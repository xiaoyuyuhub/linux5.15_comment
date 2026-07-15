#!/usr/bin/env bash
# BIOS/MBR/GRUB 调试入口：从 CPU reset vector 暂停，可在 0x7c00 截获 MBR。
# 学习重点：Shell 管理 SSH/QEMU 进程，GDB 调试客体 CPU；两层调试可同时开启。
# 推荐 DEBUG_TRACE=1 DEBUG_ERRORS=1，并在 GDB 中使用 hbreak *0x7c00。
set -euo pipefail

# 统一脚本调试入口；可与 BIOS/MBR 的 GDB 调试同时使用。
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
source "$SCRIPT_DIR/../common/debug-lib.sh"
xlab_debug_init

# 公共路径、硬盘镜像、GDB 端口和 Lima SSH 连接描述。
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd -P)"
LIMACTL="${LIMACTL:-$HOME/.local/bin/limactl}"
INSTANCE="${LIMA_INSTANCE:-linux-x86-builder}"
DISK="$REPO_ROOT/out/x86-lab/grub-bios-disk.img"
GDB_PORT="${GDB_PORT:-1234}"
SSH_CONFIG="$HOME/.lima/$INSTANCE/ssh.config"
xlab_debug_point "GRUB GDB 启动参数已解析" REPO_ROOT LIMACTL INSTANCE DISK GDB_PORT SSH_CONFIG

# 完整硬盘和正在运行的 Lima 实例都是前置条件。
[[ -f "$DISK" ]] || {
  echo "缺少 GRUB 硬盘镜像，请先运行 tools/x86-lab/grub/build-disk.sh" >&2
  exit 1
}
[[ -f "$SSH_CONFIG" ]] || {
  echo "缺少 Lima SSH 配置，请先启动 $INSTANCE" >&2
  exit 1
}

# 建立 Mac -> Lima 的本地端口转发，使 CLion/GDB 无需理解 Lima 私网地址。
ssh -F "$SSH_CONFIG" \
  -o ControlMaster=no -o ControlPath=none \
  -N -L "127.0.0.1:$GDB_PORT:127.0.0.1:$GDB_PORT" \
  "lima-$INSTANCE" &
tunnel_pid=$!
# 保证退出调试时不遗留 ssh 后台进程。
trap 'kill "$tunnel_pid" 2>/dev/null || true' EXIT INT TERM
xlab_debug_point "SSH GDB 隧道进程已创建" tunnel_pid GDB_PORT SSH_CONFIG
sleep 1
kill -0 "$tunnel_pid" 2>/dev/null || {
  echo "无法建立 GDB 端口转发；请确认 Mac 的 $GDB_PORT 端口未被占用" >&2
  exit 1
}

# 注意：BIOS 阶段没有 vmlinux 符号，主要按物理地址、寄存器和原始机器码调试。
echo "QEMU 已在 CPU reset vector 执行前暂停。"
echo "GDB target remote: 127.0.0.1:$GDB_PORT"
echo "连接后可设置硬件断点：hbreak *0x7c00，然后 continue。"

# 单 vCPU 让早期引导跟踪更直观；此处故意没有 -kernel/-append/-initrd。
"$LIMACTL" shell "$INSTANCE" -- qemu-system-x86_64 \
  -machine pc \
  -accel tcg,thread=single \
  -cpu max \
  -m 512M \
  -smp 1 \
  -hda "$DISK" \
  -boot c \
  -gdb "tcp:127.0.0.1:$GDB_PORT" \
  -S \
  -nographic \
  -no-reboot
