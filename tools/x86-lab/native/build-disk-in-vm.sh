#!/usr/bin/env bash
# 在 Lima Ubuntu 内构建不含 GRUB 的 native BIOS 教学硬盘。
#
# 最终 raw 镜像布局固定为：
#   LBA 0          Stage 1 MBR（BIOS 加载到 0x7c00）
#   LBA 1..32      Stage 2，固定保留 32 个扇区（加载到 0x8000）
#   LBA 64..       原始 bzImage
#   LBA 65536..    ext4 rootfs，Linux 中为 /dev/sda1
#
# 固定 LBA 是教学取舍：loader 无需实现 ext4，只需理解 Linux boot protocol。
# 脚本会在写盘前验证 Stage 2 和 bzImage 没有越过各自预留边界。
#
# 脚本调试示例：
#   DEBUG_VARS=1 DEBUG_STEP=1 bash tools/x86-lab/native/build-disk-in-vm.sh
#   DEBUG_TRACE=1 DEBUG_ERRORS=1 bash tools/x86-lab/native/build-disk-in-vm.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
source "$SCRIPT_DIR/../common/debug-lib.sh"
xlab_debug_init

: "${REPO_ROOT:?REPO_ROOT is required}"

# 与 stage1.S/stage2.S 一致的不可变磁盘布局常量。
readonly SECTOR_SIZE=512
readonly STAGE2_LBA=1
readonly STAGE2_RESERVED_SECTORS=32
readonly KERNEL_LBA=64
readonly ROOTFS_LBA=65536

DISK_SIZE_MB="${DISK_SIZE_MB:-512}"
LOADER_SRC="$REPO_ROOT/tools/x86-lab/native/loader"
ARTIFACT_DIR="$REPO_ROOT/out/x86-lab"
WORK_ROOT="$HOME/x86-native-loader-work"
BUILD_DIR="$WORK_ROOT/build"
DISK="$WORK_ROOT/native-bios-disk.img"
BZIMAGE="$ARTIFACT_DIR/bzImage"
ROOTFS="$ARTIFACT_DIR/rootfs.ext4"
# 主构建若仍保留 O= 输出，就顺手导出 Linux setup/compressed 的 ELF 符号。
# 这只是可选增强：native 镜像构建和启动不依赖这些文件。
KERNEL_OUT="${KERNEL_OUT:-$HOME/x86-linux-lab-work/linux-out}"

xlab_debug_point "native VM 构建路径和布局已解析" \
  REPO_ROOT LOADER_SRC ARTIFACT_DIR WORK_ROOT BUILD_DIR DISK \
  BZIMAGE ROOTFS KERNEL_OUT DISK_SIZE_MB STAGE2_LBA STAGE2_RESERVED_SECTORS \
  KERNEL_LBA ROOTFS_LBA

# 这里只需要交叉 binutils；loader 不包含 C 代码，不依赖 libc 或编译器 runtime。
required=(
  x86_64-linux-gnu-as
  x86_64-linux-gnu-ld
  x86_64-linux-gnu-objcopy
  x86_64-linux-gnu-objdump
  parted
  truncate
  dd
  stat
  sha256sum
  e2fsck
  python3
)
for command_name in "${required[@]}"; do
  command -v "$command_name" >/dev/null || {
    echo "缺少工具：$command_name；请先运行 tools/x86-lab/environment/bootstrap-mac.sh" >&2
    exit 1
  }
done

for source_file in stage1.S stage1.ld stage2.S stage2.ld; do
  [[ -f "$LOADER_SRC/$source_file" ]] || {
    echo "缺少 native loader 源文件：$LOADER_SRC/$source_file" >&2
    exit 1
  }
done
for artifact in "$BZIMAGE" "$ROOTFS"; do
  [[ -f "$artifact" ]] || {
    echo "缺少基础产物：$artifact；请先运行 tools/x86-lab/build/build.sh" >&2
    exit 1
  }
done

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR" "$ARTIFACT_DIR"

echo "[1/6] 汇编和链接 Stage 1（运行地址 0x7c00）"
xlab_debug_point "准备构建 Stage 1" LOADER_SRC BUILD_DIR
x86_64-linux-gnu-as --32 \
  -o "$BUILD_DIR/stage1.o" \
  "$LOADER_SRC/stage1.S"
x86_64-linux-gnu-ld -m elf_i386 \
  -T "$LOADER_SRC/stage1.ld" \
  -Map "$BUILD_DIR/stage1.map" \
  -o "$BUILD_DIR/stage1.elf" \
  "$BUILD_DIR/stage1.o"
x86_64-linux-gnu-objcopy -O binary \
  "$BUILD_DIR/stage1.elf" "$BUILD_DIR/stage1.bin"

# Stage 1 必须严格为 512 字节；其中启动代码不能越过 MBR 分区表偏移 446。
stage1_size="$(stat -c %s "$BUILD_DIR/stage1.bin")"
[[ "$stage1_size" -eq "$SECTOR_SIZE" ]] || {
  echo "Stage 1 必须为 512 字节，实际为 $stage1_size" >&2
  exit 1
}

echo "[2/6] 汇编和链接 Stage 2（运行地址 0x8000）"
xlab_debug_point "准备构建 Stage 2" LOADER_SRC BUILD_DIR STAGE2_RESERVED_SECTORS
x86_64-linux-gnu-as --32 \
  -o "$BUILD_DIR/stage2.o" \
  "$LOADER_SRC/stage2.S"
x86_64-linux-gnu-ld -m elf_i386 \
  -T "$LOADER_SRC/stage2.ld" \
  -Map "$BUILD_DIR/stage2.map" \
  -o "$BUILD_DIR/stage2.elf" \
  "$BUILD_DIR/stage2.o"
x86_64-linux-gnu-objcopy -O binary \
  "$BUILD_DIR/stage2.elf" "$BUILD_DIR/stage2.bin"

stage2_size="$(stat -c %s "$BUILD_DIR/stage2.bin")"
stage2_reserved_bytes="$((STAGE2_RESERVED_SECTORS * SECTOR_SIZE))"
((stage2_size <= stage2_reserved_bytes)) || {
  echo "Stage 2 为 $stage2_size 字节，超过预留的 $stage2_reserved_bytes 字节" >&2
  exit 1
}

# Stage 1 固定读取 32 个扇区；用零填充副本可保证磁盘区域完全可复现。
cp "$BUILD_DIR/stage2.bin" "$BUILD_DIR/stage2-padded.bin"
truncate -s "$stage2_reserved_bytes" "$BUILD_DIR/stage2-padded.bin"

echo "[3/6] 验证当前 bzImage boot protocol 和固定布局边界"
xlab_debug_point "准备验证 bzImage" BZIMAGE KERNEL_LBA ROOTFS_LBA

# Python 只读 header 并输出一个 shell 可 source 的结果文件；所有偏移来自 boot.rst。
python3 - "$BZIMAGE" >"$BUILD_DIR/bzimage-layout.env" <<'PY'
from pathlib import Path
import struct
import sys

p = Path(sys.argv[1]).read_bytes()
if len(p) < 0x268:
    raise SystemExit("bzImage 太小，无法包含现代 boot header")

setup_sects = p[0x1F1] or 4
setup_total = setup_sects + 1
boot_flag = struct.unpack_from("<H", p, 0x1FE)[0]
magic = p[0x202:0x206]
version = struct.unpack_from("<H", p, 0x206)[0]
loadflags = p[0x211]
syssize = struct.unpack_from("<I", p, 0x1F4)[0]
protected_sectors = (syssize + 31) >> 5

if boot_flag != 0xAA55:
    raise SystemExit(f"boot_flag 错误：{boot_flag:#x}")
if magic != b"HdrS":
    raise SystemExit(f"缺少 HdrS：{magic!r}")
if version < 0x0202:
    raise SystemExit(f"boot protocol 太旧：{version:#x}")
if not loadflags & 0x01:
    raise SystemExit("LOAD_HIGH 未设置，当前教学 loader 只支持 bzImage")
if setup_total > 64:
    raise SystemExit(f"setup 共 {setup_total} 扇区，超过 loader 上限 64")

print(f"setup_total_sectors={setup_total}")
print(f"protected_sectors={protected_sectors}")
print(f"bzimage_bytes={len(p)}")
print(f"protocol_version={version}")
PY

# 文件内容由上面的受控 Python 生成，变量名和值均为十进制整数。
source "$BUILD_DIR/bzimage-layout.env"
kernel_file_sectors="$(((bzimage_bytes + SECTOR_SIZE - 1) / SECTOR_SIZE))"
kernel_end_lba="$((KERNEL_LBA + kernel_file_sectors))"
((kernel_end_lba < ROOTFS_LBA)) || {
  echo "bzImage 到 LBA $kernel_end_lba，已碰到 rootfs 起点 $ROOTFS_LBA" >&2
  exit 1
}

xlab_debug_point "bzImage 布局验证通过" \
  setup_total_sectors protected_sectors bzimage_bytes protocol_version \
  kernel_file_sectors kernel_end_lba

echo "[4/6] 创建 MBR 分区表并写入 Stage 1、Stage 2、bzImage 和 rootfs"
rootfs_bytes="$(stat -c %s "$ROOTFS")"
rootfs_sectors="$(((rootfs_bytes + SECTOR_SIZE - 1) / SECTOR_SIZE))"
rootfs_end_lba="$((ROOTFS_LBA + rootfs_sectors - 1))"
disk_sectors="$((DISK_SIZE_MB * 1024 * 1024 / SECTOR_SIZE))"
((rootfs_end_lba < disk_sectors)) || {
  echo "${DISK_SIZE_MB} MiB 磁盘容不下 rootfs；至少需要 LBA $rootfs_end_lba" >&2
  exit 1
}

xlab_debug_point "准备写入 raw 硬盘" \
  DISK rootfs_bytes rootfs_sectors rootfs_end_lba disk_sectors

rm -f "$DISK"
truncate -s "${DISK_SIZE_MB}M" "$DISK"

# 先让 parted 创建合法分区表；后面只替换 boot code 和 55aa，保留分区项。
parted -s "$DISK" mklabel msdos
parted -s "$DISK" unit s mkpart primary ext4 \
  "${ROOTFS_LBA}s" "${rootfs_end_lba}s"
parted -s "$DISK" set 1 boot on

# 写 Stage 1 的前 446 字节，保留 0x1be..0x1fd 的 parted 分区表。
dd if="$BUILD_DIR/stage1.bin" of="$DISK" \
  bs=1 count=446 conv=notrunc status=none
# 单独写 MBR 末尾 55aa。
dd if="$BUILD_DIR/stage1.bin" of="$DISK" \
  bs=1 skip=510 seek=510 count=2 conv=notrunc status=none
# Stage 2 和 bzImage 位于分区前的原始固定区域。
dd if="$BUILD_DIR/stage2-padded.bin" of="$DISK" \
  bs="$SECTOR_SIZE" seek="$STAGE2_LBA" conv=notrunc status=none
dd if="$BZIMAGE" of="$DISK" \
  bs="$SECTOR_SIZE" seek="$KERNEL_LBA" conv=notrunc status=none
# 基础 rootfs.ext4 原样放到 MBR 分区起点；文件系统大小与分区大小一致。
dd if="$ROOTFS" of="$DISK" \
  bs="$SECTOR_SIZE" seek="$ROOTFS_LBA" conv=notrunc status=none

echo "[5/6] 对最终镜像执行结构和字节级校验"

# 对源 ext4 做只读检查；它被逐字节复制到最终分区，所以内容等价。
e2fsck -fn "$ROOTFS"

# 校验最终 MBR 签名、Stage 2、bzImage header 和 rootfs ext4 magic。
python3 - "$DISK" "$BUILD_DIR/stage2-padded.bin" "$BZIMAGE" \
  "$STAGE2_LBA" "$KERNEL_LBA" "$ROOTFS_LBA" <<'PY'
from pathlib import Path
import sys

disk = Path(sys.argv[1]).read_bytes()
stage2 = Path(sys.argv[2]).read_bytes()
bzimage = Path(sys.argv[3]).read_bytes()
stage2_lba, kernel_lba, rootfs_lba = map(int, sys.argv[4:])
sector = 512

assert disk[510:512] == b"\x55\xaa", "最终 MBR 缺少 55aa"
assert disk[stage2_lba*sector:(stage2_lba*sector)+len(stage2)] == stage2
assert disk[kernel_lba*sector:(kernel_lba*sector)+len(bzimage)] == bzimage
# ext2/3/4 superblock 从文件系统起点 +1024 开始，magic 位于 superblock +56。
magic = disk[rootfs_lba*sector + 1024 + 56:rootfs_lba*sector + 1024 + 58]
assert magic == b"\x53\xef", f"rootfs ext magic 错误：{magic.hex()}"
print("最终镜像字节级校验通过")
PY

echo "[6/6] 导出 loader、完整硬盘、反汇编和校验文件"
install -m 0644 "$BUILD_DIR/stage1.elf" "$ARTIFACT_DIR/native-stage1.elf"
install -m 0644 "$BUILD_DIR/stage1.bin" "$ARTIFACT_DIR/native-stage1.bin"
install -m 0644 "$BUILD_DIR/stage1.map" "$ARTIFACT_DIR/native-stage1.map"
install -m 0644 "$BUILD_DIR/stage2.elf" "$ARTIFACT_DIR/native-stage2.elf"
install -m 0644 "$BUILD_DIR/stage2.bin" "$ARTIFACT_DIR/native-stage2.bin"
install -m 0644 "$BUILD_DIR/stage2.map" "$ARTIFACT_DIR/native-stage2.map"
install -m 0644 "$BUILD_DIR/bzimage-layout.env" \
  "$ARTIFACT_DIR/native-bzimage-layout.env"
install -m 0644 "$DISK" "$ARTIFACT_DIR/native-bios-disk.img"

# setup.elf 和 compressed/vmlinux 不在 bzImage 中保留符号；若主构建目录存在，
# 导出它们可在 GDB 中用 -o 加载偏移获得更友好的汇编标签和源码位置。
if [[ -f "$KERNEL_OUT/arch/x86/boot/setup.elf" ]]; then
  install -m 0644 "$KERNEL_OUT/arch/x86/boot/setup.elf" \
    "$ARTIFACT_DIR/native-linux-setup.elf"
else
  echo "提示：未找到 $KERNEL_OUT/arch/x86/boot/setup.elf；0x90200 仍可按地址调试。"
fi
if [[ -f "$KERNEL_OUT/arch/x86/boot/compressed/vmlinux" ]]; then
  install -m 0644 "$KERNEL_OUT/arch/x86/boot/compressed/vmlinux" \
    "$ARTIFACT_DIR/native-linux-compressed-vmlinux"
else
  echo "提示：未找到 compressed/vmlinux；0x100000/0x100200 仍可按地址调试。"
fi

# 从最终硬盘重新提取真实 MBR；它包含分区表，因此与模板 stage1.bin 不完全相同。
dd if="$DISK" of="$ARTIFACT_DIR/native-mbr.bin" \
  bs="$SECTOR_SIZE" count=1 status=none

x86_64-linux-gnu-objdump -D -m i8086 "$BUILD_DIR/stage1.elf" \
  >"$ARTIFACT_DIR/native-stage1.asm"
x86_64-linux-gnu-objdump -D -m i8086 "$BUILD_DIR/stage2.elf" \
  >"$ARTIFACT_DIR/native-stage2.asm"

(
  cd "$ARTIFACT_DIR"
  sha256sum \
    native-bios-disk.img native-mbr.bin \
    native-stage1.bin native-stage1.elf \
    native-stage2.bin native-stage2.elf \
    bzImage rootfs.ext4 \
    >native-bios-disk.SHA256SUMS
)

parted -s "$DISK" unit s print
printf '\n构建完成：%s\n' "$ARTIFACT_DIR/native-bios-disk.img"
printf 'Stage 1：%s 字节；Stage 2：%s 字节；bzImage：%s 字节\n' \
  "$stage1_size" "$stage2_size" "$bzimage_bytes"
printf '启动链：SeaBIOS -> 0x7c00 -> 0x8000 -> 0x90200 -> 0x100000\n'
