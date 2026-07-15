#!/usr/bin/env bash
# 不使用 GRUB 的完整硬盘启动入口。
#
# QEMU 只接收 -hda：Stage 1、Stage 2、bzImage、内核命令行和 BusyBox
# rootfs 全都来自 native-bios-disk.img。
#
# 退出 QEMU：先按 Ctrl-A，松开，再按 X。
# 脚本调试：DEBUG_VARS=1 DEBUG_ERRORS=1 tools/x86-lab/native/run.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
source "$SCRIPT_DIR/../common/debug-lib.sh"
xlab_debug_init

REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd -P)"
LIMACTL="${LIMACTL:-$HOME/.local/bin/limactl}"
INSTANCE="${LIMA_INSTANCE:-linux-x86-builder}"
DISK="$REPO_ROOT/out/x86-lab/native-bios-disk.img"

xlab_debug_point "native 硬盘启动参数已解析" \
  REPO_ROOT LIMACTL INSTANCE DISK

[[ -x "$LIMACTL" ]] || {
  echo "找不到 limactl，请先运行 tools/x86-lab/environment/bootstrap-mac.sh" >&2
  exit 1
}
[[ -f "$DISK" ]] || {
  echo "缺少 native 硬盘镜像，请先运行 tools/x86-lab/native/build-disk.sh" >&2
  exit 1
}

# 单 vCPU 让早期引导更容易观察；整个过程故意没有 -kernel/-append/-initrd。
"$LIMACTL" shell "$INSTANCE" -- qemu-system-x86_64 \
  -machine pc \
  -accel tcg,thread=single \
  -cpu max \
  -m 512M \
  -smp 1 \
  -hda "$DISK" \
  -boot c \
  -nographic \
  -no-reboot
