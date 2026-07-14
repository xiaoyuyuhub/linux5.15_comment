#!/usr/bin/env bash
# Lima VM 内的主构建脚本。
# 顺序：同步源码到大小写敏感 ext4 -> 交叉编译 x86_64 内核 -> 静态编译 BusyBox
# -> 组装最小 rootfs.ext4 -> 将可运行和可调试产物导回 Mac 共享目录。
# 学习重点：数组/循环、rsync、Python 管道、Kbuild、静态链接、ext4 镜像。
# 推荐在 Lima 内用 DEBUG_VARS=1 DEBUG_STEP=1 单独运行，逐阶段查看中间文件。
set -euo pipefail

# 本文件既可由 build.sh 调用，也可在 Lima 内单独执行并启用统一调试功能。
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
source "$SCRIPT_DIR/debug-lib.sh"
xlab_debug_init

# REPO_ROOT 必须由 Mac 侧 build.sh 注入；缺失时立即报错，防止写错目录。
: "${REPO_ROOT:?REPO_ROOT is required}"

# 可调参数和所有 VM 本地工作目录。编译放在 VM 原生 ext4 上，而不是共享挂载中。
BUSYBOX_VERSION="${BUSYBOX_VERSION:-1.36.1}"
IMAGE_SIZE_MB="${IMAGE_SIZE_MB:-256}"
CROSS_COMPILE="x86_64-linux-gnu-"
WORK_ROOT="$HOME/x86-linux-lab-work"
KERNEL_SRC="$WORK_ROOT/linux-src"
KERNEL_OUT="$WORK_ROOT/linux-out"
BUSYBOX_SRC="$WORK_ROOT/busybox-$BUSYBOX_VERSION"
ROOTFS="$WORK_ROOT/rootfs"
ARTIFACT_DIR="$REPO_ROOT/out/x86-lab"
IMAGE="$WORK_ROOT/rootfs.ext4"
JOBS="${JOBS:-$(nproc)}"
# 保存可选清理开关的有效默认值，调试快照中不会再显示为 unset。
CLEAN_BUILD="${CLEAN_BUILD:-0}"
xlab_debug_point "VM 构建路径和参数已解析" REPO_ROOT WORK_ROOT KERNEL_SRC KERNEL_OUT BUSYBOX_SRC ROOTFS ARTIFACT_DIR IMAGE JOBS

# 在耗时操作开始前一次性检查依赖，错误信息会指出应运行的初始化脚本。
required=(x86_64-linux-gnu-gcc make rsync curl tar mke2fs qemu-system-x86_64)
for command_name in "${required[@]}"; do
  command -v "$command_name" >/dev/null || {
    echo "缺少工具：$command_name；请先运行 bootstrap-mac.sh" >&2
    exit 1
  }
done

mkdir -p "$WORK_ROOT" "$ARTIFACT_DIR"

echo "[1/5] 同步内核源码到 Lima 本地磁盘"
xlab_debug_point "阶段 1/5：准备同步源码" REPO_ROOT KERNEL_SRC
# rsync --delete 保证删除过的源码不会残留；大产物和分析目录不参与复制。
mkdir -p "$KERNEL_SRC"
rsync -a --delete \
  --exclude=.git/ \
  --exclude=.understand-anything/ \
  --exclude=latex/ \
  --exclude=out/ \
  "$REPO_ROOT/" "$KERNEL_SRC/"

# macOS 默认文件系统大小写不敏感，而 Linux 源码包含 xt_TCPMSS.c 与
# xt_tcpmss.c 这类只在大小写上不同的文件。Git 索引仍保存了两个 blob，
# 因此在 Lima 的大小写敏感 ext4 中按索引路径恢复所有冲突成员。
git -C "$REPO_ROOT" ls-files -z | python3 -c '
import sys
paths = [path for path in sys.stdin.buffer.read().decode().split("\0") if path]
groups = {}
for path in paths:
    groups.setdefault(path.casefold(), []).append(path)
for values in groups.values():
    if len(values) > 1 and not values[0].startswith("latex/"):
        for path in values:
            print(path)
' | while IFS= read -r tracked_path; do
  # 对每个冲突路径直接读取 Git index 中的 blob，避免从大小写折叠的工作树取错文件。
  mkdir -p "$KERNEL_SRC/$(dirname "$tracked_path")"
  git -C "$REPO_ROOT" show ":$tracked_path" > "$KERNEL_SRC/$tracked_path"
done

echo "[2/5] 配置并交叉编译 Linux 5.15 x86_64 bzImage"
xlab_debug_point "阶段 2/5：准备配置和编译内核" KERNEL_SRC KERNEL_OUT CROSS_COMPILE JOBS CLEAN_BUILD
# 清理源码树，输出文件统一写到独立的 KERNEL_OUT（O=）目录。
make -C "$KERNEL_SRC" ARCH=x86_64 CROSS_COMPILE="$CROSS_COMPILE" mrproper
# CLEAN_BUILD=1 用于彻底丢弃历史输出；默认保留目录但重新生成配置。
if [[ "$CLEAN_BUILD" == "1" ]]; then
  rm -rf "$KERNEL_OUT"
fi
mkdir -p "$KERNEL_OUT"
make -C "$KERNEL_SRC" O="$KERNEL_OUT" ARCH=x86_64 \
  CROSS_COMPILE="$CROSS_COMPILE" x86_64_defconfig

# 在发行版默认配置之上加入 IDE 硬盘、ext4、串口、DWARF4 和 GDB 所需选项。
# 关闭 KASLR 让内核链接地址与运行地址稳定对应，便于断点和源码映射。
"$KERNEL_SRC/scripts/config" --file "$KERNEL_OUT/.config" \
  --disable WERROR \
  --enable BLOCK \
  --enable PCI \
  --enable SCSI \
  --enable BLK_DEV_SD \
  --enable ATA \
  --enable ATA_PIIX \
  --enable DEVTMPFS \
  --enable DEVTMPFS_MOUNT \
  --enable EXT4_FS \
  --enable TTY \
  --enable SERIAL_8250 \
  --enable SERIAL_8250_CONSOLE \
  --enable PROC_FS \
  --enable SYSFS \
  --enable TMPFS \
  --enable UNIX \
  --enable INET \
  --enable DEBUG_INFO \
  --disable DEBUG_INFO_REDUCED \
  --disable DEBUG_INFO_SPLIT \
  --disable DEBUG_INFO_BTF \
  --disable DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT \
  --enable DEBUG_INFO_DWARF4 \
  --enable GDB_SCRIPTS \
  --disable RANDOMIZE_BASE

# olddefconfig 解析选项依赖并补齐新问题，然后并行生成 bzImage 和 vmlinux。
make -C "$KERNEL_SRC" O="$KERNEL_OUT" ARCH=x86_64 \
  CROSS_COMPILE="$CROSS_COMPILE" olddefconfig
make -C "$KERNEL_SRC" O="$KERNEL_OUT" ARCH=x86_64 \
  CROSS_COMPILE="$CROSS_COMPILE" -j"$JOBS" bzImage

echo "[3/5] 下载并静态交叉编译 BusyBox $BUSYBOX_VERSION"
xlab_debug_point "阶段 3/5：准备编译 BusyBox" BUSYBOX_VERSION BUSYBOX_SRC CROSS_COMPILE JOBS
# 修复 Ubuntu 22.04 cross-glibc 静态 libm 归档中写死的绝对路径。
sudo mkdir -p /usr/lib/x86_64-linux-gnu
for archive in /usr/x86_64-linux-gnu/lib/libm-*.a /usr/x86_64-linux-gnu/lib/libmvec.a; do
  sudo ln -sf "$archive" "/usr/lib/x86_64-linux-gnu/$(basename "$archive")"
done

# BusyBox 源码目录存在时不重复下载；需要换版本可设置 BUSYBOX_VERSION。
if [[ ! -d "$BUSYBOX_SRC" ]]; then
  archive="$WORK_ROOT/busybox-$BUSYBOX_VERSION.tar.bz2"
  curl -fL "https://busybox.net/downloads/busybox-$BUSYBOX_VERSION.tar.bz2" -o "$archive"
  tar -xjf "$archive" -C "$WORK_ROOT"
fi

# distclean 保证配置可复现；CONFIG_STATIC=y 生成不依赖客体共享库的单文件工具箱。
make -C "$BUSYBOX_SRC" distclean
make -C "$BUSYBOX_SRC" ARCH=x86_64 CROSS_COMPILE="$CROSS_COMPILE" defconfig
sed -i 's/^# CONFIG_STATIC is not set/CONFIG_STATIC=y/' "$BUSYBOX_SRC/.config"
make -C "$BUSYBOX_SRC" ARCH=x86_64 CROSS_COMPILE="$CROSS_COMPILE" -j"$JOBS"

echo "[4/5] 生成 BusyBox rootfs 和 ext4 硬盘镜像"
xlab_debug_point "阶段 4/5：准备制作基础 rootfs" ROOTFS IMAGE IMAGE_SIZE_MB
# 重新创建 staging rootfs，防止旧文件混入镜像。
sudo rm -rf "$ROOTFS"
mkdir -p "$ROOTFS"
make -C "$BUSYBOX_SRC" ARCH=x86_64 CROSS_COMPILE="$CROSS_COMPILE" \
  CONFIG_PREFIX="$ROOTFS" install

# 准备启动时所需目录，安装自定义 PID 1，并创建最早期控制台设备节点。
mkdir -p "$ROOTFS"/{dev,proc,sys,tmp,root,mnt,etc}
install -m 0755 "$REPO_ROOT/tools/x86-lab/rootfs/init" "$ROOTFS/init"
sudo mknod -m 600 "$ROOTFS/dev/console" c 5 1
sudo mknod -m 666 "$ROOTFS/dev/null" c 1 3

# 创建“无分区表、整个文件就是 ext4”的快速启动根盘。
# ^64bit 让旧版 GRUB/e2fs 工具也能稳定读取；-d 直接灌入 staging 目录。
truncate -s "${IMAGE_SIZE_MB}M" "$IMAGE"
sudo mke2fs -q -F -t ext4 -L rootfs -O '^64bit' -d "$ROOTFS" "$IMAGE"
sudo chown "$(id -u):$(id -g)" "$IMAGE"
e2fsck -fn "$IMAGE"

echo "[5/5] 导出产物与校验信息"
xlab_debug_point "阶段 5/5：准备导出产物" KERNEL_OUT ARTIFACT_DIR IMAGE
# bzImage 用于启动，vmlinux 保留完整 ELF/DWARF 供 GDB，配置用于复现。
install -m 0644 "$KERNEL_OUT/arch/x86/boot/bzImage" "$ARTIFACT_DIR/bzImage"
install -m 0644 "$KERNEL_OUT/vmlinux" "$ARTIFACT_DIR/vmlinux"
install -m 0644 "$IMAGE" "$ARTIFACT_DIR/rootfs.ext4"
install -m 0644 "$KERNEL_OUT/.config" "$ARTIFACT_DIR/kernel.config"
install -m 0644 "$BUSYBOX_SRC/.config" "$ARTIFACT_DIR/busybox.config"
install -m 0755 "$BUSYBOX_SRC/busybox" "$ARTIFACT_DIR/busybox"

# 在子 shell 内进入产物目录，使校验文件记录简洁的相对文件名。
(
  cd "$ARTIFACT_DIR"
  sha256sum bzImage vmlinux rootfs.ext4 busybox kernel.config busybox.config > SHA256SUMS
)

# 最后打印文件类型，快速确认内核/BusyBox 的目标架构确为 x86-64。
file "$ARTIFACT_DIR/bzImage" "$ARTIFACT_DIR/vmlinux" \
  "$ARTIFACT_DIR/busybox" "$ARTIFACT_DIR/rootfs.ext4"
echo "构建完成：$ARTIFACT_DIR"
