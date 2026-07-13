#!/usr/bin/env bash
# 快速启动路径：QEMU 直接装入 bzImage，ext4 镜像仅作为根硬盘。
# 这种方式适合内核开发，但会跳过 BIOS -> MBR -> GRUB 的引导链。
set -euo pipefail

# 定位仓库、Lima 和构建产物。
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd -P)"
LIMACTL="${LIMACTL:-$HOME/.local/bin/limactl}"
INSTANCE="${LIMA_INSTANCE:-linux-x86-builder}"
ARTIFACT_DIR="$REPO_ROOT/out/x86-lab"

# 两项缺一都无法完成快速启动。
[[ -f "$ARTIFACT_DIR/bzImage" && -f "$ARTIFACT_DIR/rootfs.ext4" ]] || {
  echo "缺少构建产物，请先运行 tools/x86-lab/build.sh" >&2
  exit 1
}

# QEMU 运行在 ARM64 Lima 内；TCG 将 x86_64 客体指令翻译成 ARM64 主机指令。
# 参数依次表示：传统 PC 机器、单线程 TCG、完整模拟 CPU、512 MiB/2 vCPU、
# 直接加载内核、挂接 IDE 根硬盘、传入内核命令行、使用串口、禁止自动重启。
"$LIMACTL" shell "$INSTANCE" -- qemu-system-x86_64 \
  -machine pc \
  -accel tcg,thread=single \
  -cpu max \
  -m 512M \
  -smp 2 \
  -kernel "$ARTIFACT_DIR/bzImage" \
  -hda "$ARTIFACT_DIR/rootfs.ext4" \
  -append "root=/dev/sda rw console=ttyS0 init=/init" \
  -nographic \
  -no-reboot
