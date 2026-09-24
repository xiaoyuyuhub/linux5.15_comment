#!/usr/bin/env bash
# Build only the memory-practice programs and their independent ext4 data disk.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd -P)"
LIMACTL="${LIMACTL:-$HOME/.local/bin/limactl}"
INSTANCE="${LIMA_INSTANCE:-linux-x86-builder}"

[[ -x "$LIMACTL" ]] || {
  echo "找不到 limactl，请先运行 tools/x86-lab/environment/bootstrap-mac.sh" >&2
  exit 1
}

"$LIMACTL" shell "$INSTANCE" -- env \
  REPO_ROOT="$REPO_ROOT" \
  bash -s <<'BUILD_IN_LIMA'
set -euo pipefail

lab_dir="$REPO_ROOT/tools/x86-lab/memory-practice"
output_dir="$REPO_ROOT/out/x86-lab/memory-practice"
stage_dir="$(mktemp -d)"
trap 'rm -rf "$stage_dir"' EXIT

make -C "$lab_dir" CC=x86_64-linux-gnu-gcc clean all
mkdir -p "$output_dir" "$stage_dir/bin"
for program in 00_memory_tour 01_anon_lazy 02_populate 03_malloc_brk 04_fork_cow 05_file_map; do
  install -m 0755 "$lab_dir/$program" "$stage_dir/bin/$program"
  install -m 0755 "$lab_dir/$program" "$output_dir/$program"
done
install -m 0755 "$lab_dir/guest/mm-observe.sh" "$stage_dir/mm-observe"
install -m 0755 "$lab_dir/guest/start-observer-console.sh" "$stage_dir/start-observer-console"
install -m 0644 "$lab_dir/README.md" "$stage_dir/README.md"

image_new="$output_dir/memory-practice.ext4.new"
truncate -s 32M "$image_new"
mke2fs -q -F -t ext4 -L mm-practice -O '^64bit' -d "$stage_dir" "$image_new"
mv "$image_new" "$output_dir/memory-practice.ext4"

file "$output_dir"/0* "$output_dir/memory-practice.ext4"
(cd "$output_dir" && sha256sum 0* memory-practice.ext4 > SHA256SUMS)
make -C "$lab_dir" clean
echo "Built $output_dir/memory-practice.ext4"
BUILD_IN_LIMA
