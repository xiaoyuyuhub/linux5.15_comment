#!/usr/bin/env bash
# 不使用 GRUB 的 native BIOS/GDB 调试入口。
#
# QEMU 使用 -S 在 reset vector 前暂停，Mac 通过 SSH 隧道连接 Lima 中的
# QEMU gdbstub。连接后推荐按顺序设置硬件断点：
#   hbreak *0x7c00    Stage 1
#   hbreak *0x8000    Stage 2
#   hbreak *0x90200   Linux 16-bit start_of_setup
#   hbreak *0x100000  compressed startup_32
#   hbreak *0x100200  compressed startup_64
#   hbreak *0x1000000 final kernel startup_64
#
# 注意：CLion Remote Debug 连接后是否自动 continue 由其启动命令和 .gdbinit
# 决定。QEMU 本身在收到明确 continue 前保持暂停。
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
source "$SCRIPT_DIR/../common/debug-lib.sh"
xlab_debug_init

REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd -P)"
LIMACTL="${LIMACTL:-$HOME/.local/bin/limactl}"
INSTANCE="${LIMA_INSTANCE:-linux-x86-builder}"
DISK="$REPO_ROOT/out/x86-lab/native-bios-disk.img"
GDB_PORT="${GDB_PORT:-1234}"
SSH_CONFIG="$HOME/.lima/$INSTANCE/ssh.config"

xlab_debug_point "native GDB 启动参数已解析" \
  REPO_ROOT LIMACTL INSTANCE DISK GDB_PORT SSH_CONFIG

[[ -f "$DISK" ]] || {
  echo "缺少 native 硬盘镜像，请先运行 tools/x86-lab/native/build-disk.sh" >&2
  exit 1
}
[[ -f "$SSH_CONFIG" ]] || {
  echo "缺少 Lima SSH 配置，请先启动 $INSTANCE" >&2
  exit 1
}

# Mac 本地 1234 -> Lima 127.0.0.1:1234。后台 PID 由 EXIT trap 清理。
ssh -F "$SSH_CONFIG" \
  -o ControlMaster=no -o ControlPath=none \
  -N -L "127.0.0.1:$GDB_PORT:127.0.0.1:$GDB_PORT" \
  "lima-$INSTANCE" &
tunnel_pid=$!
trap 'kill "$tunnel_pid" 2>/dev/null || true' EXIT INT TERM

xlab_debug_point "native GDB SSH 隧道已创建" tunnel_pid GDB_PORT

# 给 ssh 一小段初始化时间，并显式验证它没有立即退出。
sleep 1
kill -0 "$tunnel_pid" 2>/dev/null || {
  echo "无法建立 GDB 隧道；请检查 Mac 的 $GDB_PORT 端口是否已占用" >&2
  exit 1
}

echo "QEMU 将在 CPU reset vector 前暂停。"
echo "CLion/GDB target remote: 127.0.0.1:$GDB_PORT"
echo "建议先设 hbreak *0x7c00，再执行 continue。"

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
