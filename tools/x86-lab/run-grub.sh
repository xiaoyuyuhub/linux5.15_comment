#!/usr/bin/env bash
# 完整硬盘启动：SeaBIOS 从 MBR 读取 GRUB，再由 GRUB 加载硬盘中的内核。
# 特意不使用 -kernel、-append 或 -initrd，方便研究 0x7c00 起始的引导过程。
set -euo pipefail

# 解析公共路径与实例设置。
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd -P)"
LIMACTL="${LIMACTL:-$HOME/.local/bin/limactl}"
INSTANCE="${LIMA_INSTANCE:-linux-x86-builder}"
DISK="$REPO_ROOT/out/x86-lab/grub-bios-disk.img"

# 镜像包含 MBR、GRUB core.img、ext4 分区、bzImage 和 BusyBox 根文件系统。
[[ -f "$DISK" ]] || {
  echo "缺少 GRUB 硬盘镜像，请先运行 tools/x86-lab/build-grub-disk.sh" >&2
  exit 1
}

# 从第一个硬盘启动；全部内核参数来自镜像内 /boot/grub/grub.cfg。
"$LIMACTL" shell "$INSTANCE" -- qemu-system-x86_64 \
  -machine pc \
  -accel tcg,thread=single \
  -cpu max \
  -m 512M \
  -smp 2 \
  -hda "$DISK" \
  -boot c \
  -nographic \
  -no-reboot
