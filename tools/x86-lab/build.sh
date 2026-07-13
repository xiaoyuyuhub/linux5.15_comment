#!/usr/bin/env bash
# Mac 侧构建入口：把真正的交叉编译任务交给 Lima ARM64 Linux 虚拟机。
# 本脚本不直接编译内核；它负责定位仓库、选择 Lima 实例并传递构建参数。
set -euo pipefail

# 无论从哪个目录调用脚本，都把仓库根目录解析成绝对物理路径。
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd -P)"
# 允许通过环境变量覆盖 limactl 路径和虚拟机实例名。
LIMACTL="${LIMACTL:-$HOME/.local/bin/limactl}"
INSTANCE="${LIMA_INSTANCE:-linux-x86-builder}"

# 给出比“command not found”更明确的首次使用提示。
if [[ ! -x "$LIMACTL" ]]; then
  echo "找不到 limactl，请先运行 tools/x86-lab/bootstrap-mac.sh" >&2
  exit 1
fi

# 通过 Lima 共享目录执行 VM 内脚本；REPO_ROOT 在 Mac 与 VM 中保持同一路径。
# BUSYBOX_VERSION 和 IMAGE_SIZE_MB 均可在命令前临时覆盖。
"$LIMACTL" shell "$INSTANCE" -- env \
  REPO_ROOT="$REPO_ROOT" \
  BUSYBOX_VERSION="${BUSYBOX_VERSION:-1.36.1}" \
  IMAGE_SIZE_MB="${IMAGE_SIZE_MB:-256}" \
  bash "$REPO_ROOT/tools/x86-lab/build-in-vm.sh"
