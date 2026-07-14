#!/usr/bin/env bash
# Mac 侧 GRUB 硬盘封装入口：启动 Lima，并在 Linux VM 内操作 loop 设备和 ext4。
# 学习重点：包装器怎样检查/启动 VM，并把磁盘容量及调试开关传到 VM。
# 推荐：DEBUG_VARS=1 DEBUG_ERRORS=1 tools/x86-lab/build-grub-disk.sh。
set -euo pipefail

# 统一调试入口；可用 DEBUG_STEP=1 在进入 VM 前暂停检查参数。
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
source "$SCRIPT_DIR/debug-lib.sh"
xlab_debug_init

# 从脚本位置计算仓库根目录，避免依赖调用者当前目录。
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd -P)"
# 两个变量都可由高级用户覆盖。
LIMACTL="${LIMACTL:-$HOME/.local/bin/limactl}"
INSTANCE="${LIMA_INSTANCE:-linux-x86-builder}"
# 提前保存默认值，这样 DEBUG_VARS 能显示本次实际使用的镜像容量。
DISK_SIZE_MB="${DISK_SIZE_MB:-512}"
xlab_debug_point "GRUB 硬盘包装器参数已解析" REPO_ROOT LIMACTL INSTANCE DISK_SIZE_MB

# GRUB 镜像构建依赖 Lima 中的 Linux 块设备工具。
[[ -x "$LIMACTL" ]] || {
  echo "找不到 limactl，请先运行 tools/x86-lab/bootstrap-mac.sh" >&2
  exit 1
}
# 已创建但停止的实例在这里自动恢复运行。
if ! "$LIMACTL" list "$INSTANCE" --json 2>/dev/null | grep -q '"status":"Running"'; then
  "$LIMACTL" start "$INSTANCE"
fi

# DISK_SIZE_MB 默认 512 MiB；实际封装逻辑位于 *-in-vm.sh。
"$LIMACTL" shell "$INSTANCE" -- env REPO_ROOT="$REPO_ROOT" \
  DISK_SIZE_MB="$DISK_SIZE_MB" \
  DEBUG_TRACE="${DEBUG_TRACE:-0}" \
  DEBUG_VARS="${DEBUG_VARS:-0}" \
  DEBUG_STEP="${DEBUG_STEP:-0}" \
  DEBUG_ERRORS="${DEBUG_ERRORS:-0}" \
  DEBUG_LOG="${DEBUG_VM_LOG:-}" \
  bash "$REPO_ROOT/tools/x86-lab/build-grub-disk-in-vm.sh"
