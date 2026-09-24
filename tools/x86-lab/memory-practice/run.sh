#!/usr/bin/env bash
# Start the existing kernel/rootfs plus a read-only memory-practice data disk.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd -P)"
LIMACTL="${LIMACTL:-$HOME/.local/bin/limactl}"
INSTANCE="${LIMA_INSTANCE:-linux-x86-builder}"
ARTIFACT_DIR="$REPO_ROOT/out/x86-lab"
GDB_PORT="${GDB_PORT:-1236}"
OBSERVER_PORT="${OBSERVER_PORT:-4321}"
mode="${1:-normal}"
qemu_debug=()

case "$mode" in
  normal) ;;
  --gdb) qemu_debug=(-gdb "tcp:127.0.0.1:$GDB_PORT") ;;
  --debug) qemu_debug=(-gdb "tcp:127.0.0.1:$GDB_PORT" -S) ;;
  *) echo "usage: $0 [--gdb|--debug]" >&2; exit 2 ;;
esac

for artifact in bzImage vmlinux rootfs.ext4 memory-practice/memory-practice.ext4; do
  [[ -f "$ARTIFACT_DIR/$artifact" ]] || {
    echo "缺少 $ARTIFACT_DIR/$artifact；先运行 memory-practice/build.sh（内核产物缺失则运行 build/build.sh）" >&2
    exit 1
  }
done

echo "QEMU 主控制台：本终端"
echo "第二观察终端：guest 挂盘后运行 /mnt/mm/start-observer-console，再在 Mac 执行 connect-observer.sh"
if [[ "$mode" != normal ]]; then
  echo "GDB：Lima 中连接 127.0.0.1:${GDB_PORT}；--debug 会在第一条指令前暂停"
fi

"$LIMACTL" shell "$INSTANCE" -- qemu-system-x86_64 \
  -machine pc -accel tcg,thread=single -cpu max -m 512M -smp 1 \
  -kernel "$ARTIFACT_DIR/bzImage" \
  -drive "file=$ARTIFACT_DIR/rootfs.ext4,format=raw,if=ide,index=0,snapshot=on" \
  -drive "file=$ARTIFACT_DIR/memory-practice/memory-practice.ext4,format=raw,if=ide,index=1,snapshot=on" \
  -append 'root=/dev/sda rw console=ttyS0 init=/init nokaslr' \
  -serial mon:stdio \
  -chardev "socket,id=observer,host=127.0.0.1,port=$OBSERVER_PORT,server=on,wait=off" \
  -device isa-serial,chardev=observer,index=1 \
  ${qemu_debug[@]+"${qemu_debug[@]}"} -display none -no-reboot
