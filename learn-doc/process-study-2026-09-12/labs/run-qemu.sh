#!/usr/bin/env bash
# 在装有 QEMU 的 Linux 主机运行。无硬盘挂接，initramfs 完全在内存中。
set -euo pipefail
lab_dir=$(cd "$(dirname "$0")" && pwd)
repo_dir=$(cd "$lab_dir/../.." && pwd)
extra=()
if [[ ${DEBUG:-0} == 1 ]]; then extra=(-S -gdb "tcp:127.0.0.1:${GDB_PORT:-1235}"); fi
exec qemu-system-x86_64 -machine pc -accel tcg,thread=single -cpu max \
  -m 512M -smp "${CPUS:-1}" -kernel "${KERNEL:-$repo_dir/out/x86-lab/bzImage}" \
  -initrd "${INITRD:-$lab_dir/initramfs.cpio.gz}" \
  -append 'console=ttyS0 nokaslr rdinit=/init panic=-1' \
  -nographic -no-reboot "${extra[@]}"
