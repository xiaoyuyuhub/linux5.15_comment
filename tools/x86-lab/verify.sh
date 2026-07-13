#!/usr/bin/env bash
# 自动验收快速启动路径：启动 QEMU、向串口注入命令、核对架构/命令行并检查 ext4。
set -euo pipefail

# 日志保存在产物目录，失败时可直接搜索 panic、mount 或 QEMU 错误。
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd -P)"
LIMACTL="${LIMACTL:-$HOME/.local/bin/limactl}"
INSTANCE="${LIMA_INSTANCE:-linux-x86-builder}"
ARTIFACT_DIR="$REPO_ROOT/out/x86-lab"
LOG="$ARTIFACT_DIR/qemu-boot.log"

mkdir -p "$ARTIFACT_DIR"

# QEMU 正常 poweroff 与 timeout 的退出方式不同，先暂时关闭 errexit 手工判断。
set +e
"$LIMACTL" shell "$INSTANCE" -- bash -lc '
  set -o pipefail
  artifact_dir="$1"
  # 后台输入流先等待系统启动，再执行三个可机器验证的命令，最后关机。
  {
    sleep 18
    echo "echo QEMU_X86_BOOT_OK"
    echo "uname -m"
    echo "cat /proc/cmdline"
    sleep 2
    echo "poweroff -f"
  } | timeout 60s qemu-system-x86_64 \
      -machine pc -accel tcg,thread=single \
      -cpu max -m 512M -smp 2 \
      -kernel "$artifact_dir/bzImage" \
      -hda "$artifact_dir/rootfs.ext4" \
      -append "root=/dev/sda rw console=ttyS0 init=/init" \
      -display none -serial stdio -monitor none -no-reboot
' bash "$ARTIFACT_DIR" 2>&1 | tee "$LOG"
# PIPESTATUS[0] 是 limactl/QEMU 管道状态，不是 tee 的状态。
qemu_status=${PIPESTATUS[0]}
set -e

if [[ "$qemu_status" -ne 0 && "$qemu_status" -ne 124 ]]; then
  echo "QEMU 异常退出，status=$qemu_status" >&2
  exit "$qemu_status"
fi

# 三个 grep 分别证明 shell 可用、客体是 x86_64、根设备参数正确。
grep -q "QEMU_X86_BOOT_OK" "$LOG"
grep -q '^x86_64' "$LOG"
grep -q 'root=/dev/sda' "$LOG"

# 客体曾以 rw 挂载镜像；关机后运行 e2fsck，0/1 均视为成功。
set +e
"$LIMACTL" shell "$INSTANCE" -- e2fsck -fy "$ARTIFACT_DIR/rootfs.ext4"
fsck_status=$?
set -e
if ((fsck_status > 1)); then
  echo "e2fsck 失败（status: $fsck_status）" >&2
  exit "$fsck_status"
fi
# rootfs 可能因验证启动发生变化，因此重新生成全部产物的 SHA256。
"$LIMACTL" shell "$INSTANCE" -- bash -lc '
  set -e
  cd "$1"
  sha256sum bzImage vmlinux rootfs.ext4 busybox kernel.config busybox.config > SHA256SUMS
' bash "$ARTIFACT_DIR"

echo "QEMU 启动验证通过（qemu status: ${qemu_status}）：$LOG"
