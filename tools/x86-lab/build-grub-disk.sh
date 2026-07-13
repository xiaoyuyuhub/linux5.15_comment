#!/usr/bin/env bash
# Mac 侧 GRUB 硬盘封装入口：启动 Lima，并在 Linux VM 内操作 loop 设备和 ext4。
set -euo pipefail

# 从脚本位置计算仓库根目录，避免依赖调用者当前目录。
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd -P)"
# 两个变量都可由高级用户覆盖。
LIMACTL="${LIMACTL:-$HOME/.local/bin/limactl}"
INSTANCE="${LIMA_INSTANCE:-linux-x86-builder}"

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
  DISK_SIZE_MB="${DISK_SIZE_MB:-512}" \
  bash "$REPO_ROOT/tools/x86-lab/build-grub-disk-in-vm.sh"
