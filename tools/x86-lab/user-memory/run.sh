#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT=$(cd "$(dirname "$0")/../../.." && pwd)
LIMACTL=${LIMACTL:-$HOME/.local/bin/limactl}
INSTANCE=${INSTANCE:-linux-x86-builder}
GDB_PORT=${GDB_PORT:-1235}
if [[ ${1:-} == --debug && $# == 1 ]]; then
  set -- -gdb "tcp:127.0.0.1:$GDB_PORT" -S
elif [[ $# != 0 ]]; then
  echo 'usage: bash run.sh [--debug]' >&2; exit 1
fi
art="$REPO_ROOT/out/x86-lab"
for f in bzImage rootfs.ext4 user-memory/lab.ext4; do
  [[ -f "$art/$f" ]] || { echo "Missing: $art/$f" >&2; exit 1; }
done
"$LIMACTL" shell "$INSTANCE" qemu-system-x86_64 \
  -machine pc -accel tcg,thread=single -cpu max -m 512M -smp 1 \
  -kernel "$art/bzImage" \
  -drive "file=$art/rootfs.ext4,format=raw,if=ide,index=0,snapshot=on" \
  -drive "file=$art/user-memory/lab.ext4,format=raw,if=ide,index=1,snapshot=on" \
  -append 'root=/dev/sda rw console=ttyS0 init=/init nokaslr' \
  "$@" -nographic -no-reboot
