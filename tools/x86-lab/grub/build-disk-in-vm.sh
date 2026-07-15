#!/usr/bin/env bash
# 在 Lima Linux VM 内把内核、BusyBox rootfs 和 GRUB2 BIOS 引导器封装成 raw 硬盘。
# 最终镜像可只用 QEMU -hda 启动，启动链为 SeaBIOS -> MBR -> core.img -> GRUB -> Linux。
# 学习重点：EXIT trap、函数、loop 设备、挂载、状态码和需要 sudo 的资源清理。
# 推荐 DEBUG_VARS=1 DEBUG_STEP=1；不要用 kill -9，否则 EXIT trap 没机会清理。
set -euo pipefail

# 统一调试入口；错误现场对 loop 设备、挂载和 grub-install 排错尤其有用。
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
source "$SCRIPT_DIR/../common/debug-lib.sh"
xlab_debug_init

# Mac 侧包装脚本必须传入共享仓库绝对路径。
: "${REPO_ROOT:?REPO_ROOT is required}"

# 硬盘、临时 loop 镜像、固定版本 GRUB 包及挂载点。
DISK_SIZE_MB="${DISK_SIZE_MB:-512}"
ARTIFACT_DIR="$REPO_ROOT/out/x86-lab"
WORK_ROOT="$HOME/x86-linux-lab-work"
DISK="$WORK_ROOT/grub-bios-disk.img"
ROOTFS_COPY="$WORK_ROOT/rootfs-for-grub.ext4"
GRUB_PACKAGE="$WORK_ROOT/grub-pc-bin_2.06-2ubuntu7.2_amd64.deb"
GRUB_PACKAGE_URL="https://archive.ubuntu.com/ubuntu/pool/main/g/grub2/grub-pc-bin_2.06-2ubuntu7.2_amd64.deb"
GRUB_PACKAGE_SHA256="51e3fc7d1758f9d72f09e12bfe51295d3f8a8da49b018a81e45c6d2f127d60c2"
GRUB_EXTRACT="$WORK_ROOT/grub-pc-bin-2.06"
GRUB_DIR="$GRUB_EXTRACT/usr/lib/grub/i386-pc"
SOURCE_MOUNT="$WORK_ROOT/mnt-rootfs-source"
TARGET_MOUNT="$WORK_ROOT/mnt-grub-disk"
xlab_debug_point "GRUB 镜像路径和参数已解析" REPO_ROOT DISK_SIZE_MB ARTIFACT_DIR WORK_ROOT DISK ROOTFS_COPY GRUB_PACKAGE GRUB_DIR SOURCE_MOUNT TARGET_MOUNT

# 先确认快速构建阶段已经提供了内核和基础根文件系统。
for artifact in bzImage rootfs.ext4; do
  [[ -f "$ARTIFACT_DIR/$artifact" ]] || {
    echo "缺少 $artifact，请先运行 tools/x86-lab/build/build.sh" >&2
    exit 1
  }
done
# loop、分区、格式化和 GRUB 安装所需命令必须全部存在。
for command_name in curl sha256sum dpkg-deb parted losetup mkfs.ext4 grub-install; do
  command -v "$command_name" >/dev/null || {
    echo "缺少工具：$command_name；请先运行 tools/x86-lab/environment/bootstrap-mac.sh" >&2
    exit 1
  }
done

mkdir -p "$WORK_ROOT" "$ARTIFACT_DIR" "$SOURCE_MOUNT" "$TARGET_MOUNT"

# ARM64 Ubuntu 不提供可直接使用的 i386-pc 模块，因此下载官方 amd64 grub-pc-bin 数据包。
# grub-install 本身在 ARM64 原生运行，只读取解包出的架构无关模块文件。
if [[ ! -f "$GRUB_PACKAGE" ]]; then
  xlab_debug_point "准备下载 GRUB i386-pc 模块包" GRUB_PACKAGE_URL GRUB_PACKAGE GRUB_PACKAGE_SHA256
  curl -fL "$GRUB_PACKAGE_URL" -o "$GRUB_PACKAGE"
fi
# 固定 SHA256，避免损坏或被替换的 deb 进入启动镜像。
echo "$GRUB_PACKAGE_SHA256  $GRUB_PACKAGE" | sha256sum -c -
if [[ ! -f "$GRUB_DIR/boot.img" ]]; then
  rm -rf "$GRUB_EXTRACT"
  dpkg-deb -x "$GRUB_PACKAGE" "$GRUB_EXTRACT"
fi

# 保留基础 rootfs 原件；新建 512 MiB raw 盘、DOS/MBR 分区表和 1 MiB 对齐分区。
# 起始 LBA 2048 前的空隙用于 GRUB core.img embedding area。
cp "$ARTIFACT_DIR/rootfs.ext4" "$ROOTFS_COPY"
rm -f "$DISK"
truncate -s "${DISK_SIZE_MB}M" "$DISK"
parted -s "$DISK" mklabel msdos
parted -s "$DISK" mkpart primary ext4 1MiB 100%
parted -s "$DISK" set 1 boot on

# 两个变量同时充当资源句柄和“是否已释放”的状态标记。
disk_loop=""
source_loop=""
# 无论正常、报错还是 Ctrl-C，都尽量卸载文件系统并释放 loop 设备。
cleanup() {
  set +e
  mountpoint -q "$TARGET_MOUNT" && sudo umount "$TARGET_MOUNT"
  mountpoint -q "$SOURCE_MOUNT" && sudo umount "$SOURCE_MOUNT"
  [[ -n "$source_loop" ]] && sudo losetup -d "$source_loop"
  [[ -n "$disk_loop" ]] && sudo losetup -d "$disk_loop"
}
trap cleanup EXIT

# --partscan 为整盘 loop 自动创建 p1；基础 rootfs 以只读 loop 挂载。
disk_loop="$(sudo losetup --find --show --partscan "$DISK")"
source_loop="$(sudo losetup --find --show --read-only "$ROOTFS_COPY")"
partition="${disk_loop}p1"
xlab_debug_point "loop 设备已创建" DISK disk_loop ROOTFS_COPY source_loop partition
# udev 创建设备节点可能稍有延迟，最多等待约两秒。
for _ in {1..20}; do
  [[ -b "$partition" ]] && break
  sleep 0.1
done
[[ -b "$partition" ]]

# 格式化目标分区，复制 BusyBox 根目录，并加入内核和 GRUB 菜单配置。
sudo mkfs.ext4 -q -F -L x86root "$partition"
sudo mount -o ro "$source_loop" "$SOURCE_MOUNT"
sudo mount "$partition" "$TARGET_MOUNT"
sudo cp -a "$SOURCE_MOUNT/." "$TARGET_MOUNT/"
sudo install -m 0755 "$REPO_ROOT/tools/x86-lab/rootfs/init" "$TARGET_MOUNT/init"
sudo mkdir -p "$TARGET_MOUNT/boot/grub"
sudo install -m 0644 "$ARTIFACT_DIR/bzImage" "$TARGET_MOUNT/boot/bzImage"
sudo install -m 0644 "$REPO_ROOT/tools/x86-lab/grub/grub.cfg" \
  "$TARGET_MOUNT/boot/grub/grub.cfg"

# BIOS 安装模式将 boot.img 写入 MBR 引导代码区，将 core.img 嵌入 1 MiB 间隙。
# 指定最小模块集合：MBR 分区、ext 文件系统、串口、菜单和 Linux 加载器。
sudo grub-install \
  --target=i386-pc \
  --directory="$GRUB_DIR" \
  --boot-directory="$TARGET_MOUNT/boot" \
  --disk-module=biosdisk \
  --modules="part_msdos ext2 serial normal linux" \
  --recheck \
  "$disk_loop"
xlab_debug_point "GRUB 已写入 MBR 和 embedding area" disk_loop partition TARGET_MOUNT GRUB_DIR

# 先落盘再卸载；显式释放资源后清空变量，避免 EXIT trap 二次处理。
sync
sudo umount "$TARGET_MOUNT"
sudo umount "$SOURCE_MOUNT"
sudo losetup -d "$source_loop"
source_loop=""

# e2fsck 的 0 表示无错，1 表示已修复；两者都属于可接受结果。
sudo e2fsck -fy "$partition" || status=$?
status="${status:-0}"
((status <= 1)) || exit "$status"
sudo losetup -d "$disk_loop"
disk_loop=""
trap - EXIT

# 导出完整硬盘、单独的 512 字节 MBR、前 1 MiB 引导区及其校验值。
# 拆分文件便于 GDB/objdump 单独研究 0x7c00 代码和 core.img 区域。
install -m 0644 "$DISK" "$ARTIFACT_DIR/grub-bios-disk.img"
dd if="$DISK" of="$ARTIFACT_DIR/grub-mbr.bin" bs=512 count=1 status=none
dd if="$DISK" of="$ARTIFACT_DIR/grub-boot-region.bin" \
  bs=512 count=2048 status=none
(
  cd "$ARTIFACT_DIR"
  sha256sum grub-bios-disk.img grub-mbr.bin grub-boot-region.bin \
    > grub-bios-disk.SHA256SUMS
)

echo "GRUB2 BIOS 硬盘镜像：$ARTIFACT_DIR/grub-bios-disk.img"
# 以扇区为单位打印最终布局，作为镜像生成结果的可读校验。
parted -s "$DISK" unit s print
