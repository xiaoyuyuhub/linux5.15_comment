#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT=$(cd "$(dirname "$0")/../../.." && pwd)
LIMACTL=${LIMACTL:-$HOME/.local/bin/limactl}
INSTANCE=${INSTANCE:-linux-x86-builder}
"$LIMACTL" shell "$INSTANCE" env REPO_ROOT="$REPO_ROOT" bash -s <<'BUILD'
set -euo pipefail
out="$REPO_ROOT/out/x86-lab/user-memory"
mkdir -p "$out"
stage=$(mktemp -d)
trap 'rm -rf "$stage"' EXIT
x86_64-linux-gnu-gcc -static -g3 -O0 -fno-omit-frame-pointer -fno-pie -no-pie \
  -Wall -Wextra -Werror "$REPO_ROOT/tools/x86-lab/user-memory/mm-walk.c" -o "$stage/mm-walk"
file "$stage/mm-walk"
cp "$stage/mm-walk" "$out/mm-walk"
truncate -s 16M "$out/lab.ext4.new"
mke2fs -q -F -t ext4 -d "$stage" "$out/lab.ext4.new"
mv "$out/lab.ext4.new" "$out/lab.ext4"
printf 'Built: %s\n' "$out/lab.ext4"
BUILD
