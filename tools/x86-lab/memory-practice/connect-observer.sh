#!/usr/bin/env bash
# Forward QEMU's second serial port from Lima and attach the Mac terminal to it.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
LIMACTL="${LIMACTL:-$HOME/.local/bin/limactl}"
INSTANCE="${LIMA_INSTANCE:-linux-x86-builder}"
OBSERVER_PORT="${OBSERVER_PORT:-4321}"
OBSERVER_LOCAL_PORT="${OBSERVER_LOCAL_PORT:-14321}"
SSH_CONFIG="$HOME/.lima/$INSTANCE/ssh.config"

[[ -x "$LIMACTL" && -f "$SSH_CONFIG" ]] || {
  echo "Lima 实例或 SSH 配置不存在：$INSTANCE" >&2
  exit 1
}
command -v nc >/dev/null || { echo "Mac 缺少 nc" >&2; exit 1; }

# Lima may automatically forward a VM listener to the same Mac port. Reuse it
# when present; opening a second SSH listener on that port would fail.
if command -v lsof >/dev/null &&
   lsof -nP -iTCP:"$OBSERVER_PORT" -sTCP:LISTEN 2>/dev/null | grep -q limactl; then
  echo "使用 Lima 自动转发的 127.0.0.1:$OBSERVER_PORT"
  echo "若无提示符，先在主控制台运行 /mnt/mm/start-observer-console，然后按 Enter。"
  exec nc 127.0.0.1 "$OBSERVER_PORT"
fi

ssh -F "$SSH_CONFIG" -o ExitOnForwardFailure=yes \
  -o ControlMaster=no -o ControlPath=none \
  -N -L "127.0.0.1:$OBSERVER_LOCAL_PORT:127.0.0.1:$OBSERVER_PORT" \
  "lima-$INSTANCE" &
tunnel_pid=$!
trap 'kill "$tunnel_pid" 2>/dev/null || true' EXIT INT TERM
sleep 1
kill -0 "$tunnel_pid" 2>/dev/null || {
  echo "无法建立观察串口转发；检查 Mac 端口 $OBSERVER_LOCAL_PORT 是否占用" >&2
  exit 1
}

echo "已连接 guest ttyS1。若无提示符，先在主控制台运行 /mnt/mm/start-observer-console，然后按 Enter。"
nc 127.0.0.1 "$OBSERVER_LOCAL_PORT"
