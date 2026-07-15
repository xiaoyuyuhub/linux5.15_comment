#!/usr/bin/env bash
# Mac 侧 native BIOS 硬盘构建入口。
#
# 本脚本不在 macOS 上直接运行 GNU binutils 或磁盘工具，而是：
#   1. 定位当前仓库和 Lima 实例；
#   2. 必要时启动 ARM64 Ubuntu 构建机；
#   3. 把参数和统一调试开关传给 VM 内构建脚本。
#
# 普通构建：
#   tools/x86-lab/native/build-disk.sh
#
# 学习脚本执行顺序：
#   DEBUG_VARS=1 DEBUG_STEP=1 tools/x86-lab/native/build-disk.sh
#
# 逐行记录 Mac 包装器和 VM 构建脚本：
#   DEBUG_TRACE=1 DEBUG_ERRORS=1 \
#   DEBUG_VM_LOG=out/x86-lab/native-build-vm.trace \
#   tools/x86-lab/native/build-disk.sh
set -euo pipefail

# 载入与现有 x86-lab 脚本相同的 trace、变量快照、学习断点和 ERR trap。
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
source "$SCRIPT_DIR/../common/debug-lib.sh"
xlab_debug_init

# 从脚本自身位置推导仓库根目录，不依赖调用者当前工作目录。
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd -P)"
LIMACTL="${LIMACTL:-$HOME/.local/bin/limactl}"
INSTANCE="${LIMA_INSTANCE:-linux-x86-builder}"
DISK_SIZE_MB="${DISK_SIZE_MB:-512}"

xlab_debug_point "native 硬盘 Mac 包装器参数已解析" \
  REPO_ROOT LIMACTL INSTANCE DISK_SIZE_MB

[[ -x "$LIMACTL" ]] || {
  echo "找不到 limactl，请先运行 tools/x86-lab/environment/bootstrap-mac.sh" >&2
  exit 1
}

# 实例已创建但停止时自动启动；首次环境仍应先运行 environment/bootstrap-mac.sh。
if ! "$LIMACTL" list "$INSTANCE" --json 2>/dev/null | grep -q '"status":"Running"'; then
  "$LIMACTL" start "$INSTANCE"
fi

# VM 可以通过 Lima 共享挂载看到同一个 REPO_ROOT 绝对路径。
"$LIMACTL" shell "$INSTANCE" -- env \
  REPO_ROOT="$REPO_ROOT" \
  DISK_SIZE_MB="$DISK_SIZE_MB" \
  DEBUG_TRACE="${DEBUG_TRACE:-0}" \
  DEBUG_VARS="${DEBUG_VARS:-0}" \
  DEBUG_STEP="${DEBUG_STEP:-0}" \
  DEBUG_ERRORS="${DEBUG_ERRORS:-0}" \
  DEBUG_LOG="${DEBUG_VM_LOG:-}" \
  bash "$REPO_ROOT/tools/x86-lab/native/build-disk-in-vm.sh"
