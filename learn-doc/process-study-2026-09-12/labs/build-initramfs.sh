#!/usr/bin/env bash
# 在 Linux 构建机运行；所有产物只写入本学习目录。
set -euo pipefail
lab_dir=$(cd "$(dirname "$0")" && pwd)
repo_dir=$(cd "$lab_dir/../.." && pwd)
make -C "$lab_dir" CC="${CC:-x86_64-linux-gnu-gcc}" LDFLAGS=-static
stage_dir=$(mktemp -d)
trap 'rm -rf "$stage_dir"' EXIT
mkdir -p "$stage_dir"/{bin,sbin,dev,proc,sys,tmp}
cp "${BUSYBOX:-$repo_dir/out/x86-lab/busybox}" "$stage_dir/bin/busybox"
for app in sh mount uname poweroff sleep cat mkdir rmdir ls ps; do
  ln -s busybox "$stage_dir/bin/$app"
done
cp "$lab_dir/process_lab" "$stage_dir/process_lab"
cp "${INIT_SCRIPT:-$lab_dir/init}" "$stage_dir/init"
chmod +x "$stage_dir/init"
(cd "$stage_dir" && find . -print0 | cpio --null -o --format=newc 2>/dev/null | gzip -n) > "${INITRAMFS_OUTPUT:-$lab_dir/initramfs.cpio.gz}"
echo "Built ${INITRAMFS_OUTPUT:-$lab_dir/initramfs.cpio.gz}"
