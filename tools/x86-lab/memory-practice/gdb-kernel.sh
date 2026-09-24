#!/usr/bin/env bash
# Run gdb-multiarch inside Lima, using the matching kernel symbols.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd -P)"
LIMACTL="${LIMACTL:-$HOME/.local/bin/limactl}"
INSTANCE="${LIMA_INSTANCE:-linux-x86-builder}"
GDB_PORT="${GDB_PORT:-1236}"

[[ -f "$REPO_ROOT/out/x86-lab/vmlinux" ]] || {
  echo "缺少 out/x86-lab/vmlinux" >&2
  exit 1
}

"$LIMACTL" shell "$INSTANCE" -- env \
  REPO_ROOT="$REPO_ROOT" GDB_PORT="$GDB_PORT" \
  gdb-multiarch -q -nx \
  -ex "set pagination off" \
  -ex "set architecture i386:x86-64" \
  -ex "set substitute-path /home/xuyu.guest/x86-linux-lab-work/linux-src $REPO_ROOT" \
  -ex "source $REPO_ROOT/tools/x86-lab/memory-practice/gdb/mm-commands.gdb" \
  -ex "target remote 127.0.0.1:$GDB_PORT" \
  "$REPO_ROOT/out/x86-lab/vmlinux"
