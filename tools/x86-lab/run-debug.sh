#!/usr/bin/env bash
# 内核源码级调试入口：QEMU 暂停，Mac 通过 SSH 隧道连接 VM 内的 GDB stub。
# 学习重点：后台命令、$!、信号 trap 和端口转发；DEBUG_TRACE=1 能看到完整生命周期。
# 注意脚本自身 DEBUG_* 调试与连接 QEMU 的内核 GDB 调试是两套独立机制。
set -euo pipefail

# 此处的“脚本调试”与后面的“内核 GDB 调试”相互独立，可同时开启。
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
source "$SCRIPT_DIR/debug-lib.sh"
xlab_debug_init

# 路径、实例和端口均可覆盖；默认端口与 CLion Remote Debug 配置一致。
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd -P)"
LIMACTL="${LIMACTL:-$HOME/.local/bin/limactl}"
INSTANCE="${LIMA_INSTANCE:-linux-x86-builder}"
ARTIFACT_DIR="$REPO_ROOT/out/x86-lab"
GDB_PORT="${GDB_PORT:-1234}"
SSH_CONFIG="$HOME/.lima/$INSTANCE/ssh.config"
xlab_debug_point "内核 GDB 启动参数已解析" REPO_ROOT LIMACTL INSTANCE ARTIFACT_DIR GDB_PORT SSH_CONFIG

# vmlinux 提供符号，bzImage 负责启动，rootfs.ext4 提供用户空间。
for artifact in bzImage vmlinux rootfs.ext4; do
  [[ -f "$ARTIFACT_DIR/$artifact" ]] || {
    echo "缺少 $artifact，请先运行 tools/x86-lab/build.sh" >&2
    exit 1
  }
done
# Lima 生成的 SSH 配置包含动态端口、密钥和用户名，不能用普通 localhost 配置代替。
[[ -f "$SSH_CONFIG" ]] || {
  echo "缺少 Lima SSH 配置，请先启动 $INSTANCE" >&2
  exit 1
}

# 把 Mac 127.0.0.1:GDB_PORT 转发到 Lima 内同端口；-N 表示只建隧道不执行命令。
# 禁用 ControlMaster，避免复用旧连接导致 tunnel_pid 无法准确管理生命周期。
ssh -F "$SSH_CONFIG" \
  -o ControlMaster=no -o ControlPath=none \
  -N -L "127.0.0.1:$GDB_PORT:127.0.0.1:$GDB_PORT" \
  "lima-$INSTANCE" &
tunnel_pid=$!
# 脚本退出或被中断时自动关闭后台 SSH 隧道。
trap 'kill "$tunnel_pid" 2>/dev/null || true' EXIT INT TERM
xlab_debug_point "SSH GDB 隧道进程已创建" tunnel_pid GDB_PORT SSH_CONFIG
sleep 1
kill -0 "$tunnel_pid" 2>/dev/null || {
  echo "无法建立 GDB 端口转发；请确认 Mac 的 $GDB_PORT 端口未被占用" >&2
  exit 1
}

# 提示信息可直接照抄到 CLion 的 Remote Debug 配置。
echo "QEMU 已在第一条指令前暂停。"
echo "CLion: Remote Debug -> 127.0.0.1:$GDB_PORT"
echo "Symbol file: $ARTIFACT_DIR/vmlinux"
echo "连接后设置断点 start_kernel 并点击 Resume；退出 QEMU 用 Ctrl-A X。"

# -S 在 CPU 执行前暂停；-gdb 只监听 VM 回环地址，借助上面的 SSH 隧道暴露给 Mac。
# nokaslr 与构建配置中的 RANDOMIZE_BASE=n 双重确保运行地址稳定。
"$LIMACTL" shell "$INSTANCE" -- qemu-system-x86_64 \
  -machine pc \
  -accel tcg,thread=single \
  -cpu max \
  -m 512M \
  -smp 2 \
  -kernel "$ARTIFACT_DIR/bzImage" \
  -hda "$ARTIFACT_DIR/rootfs.ext4" \
  -append "root=/dev/sda rw console=ttyS0 init=/init nokaslr" \
  -gdb "tcp:127.0.0.1:$GDB_PORT" \
  -S \
  -nographic \
  -no-reboot
