#!/usr/bin/env bash
# Apple Silicon Mac 首次初始化脚本。
# 作用：下载并校验 Lima，创建 ARM64 Ubuntu VM，安装 x86_64 交叉工具链、
# QEMU、GRUB、GDB 和镜像工具。重复执行是安全的：已有组件会被复用。
set -euo pipefail

# 所有配置均允许用同名环境变量覆盖；默认值是本项目验证过的组合。
LIMA_VERSION="${LIMA_VERSION:-2.1.4}"
INSTANCE="${LIMA_INSTANCE:-linux-x86-builder}"
LIMA_HOME="${LIMA_INSTALL_DIR:-$HOME/.local}"
LIMACTL="$LIMA_HOME/bin/limactl"
APT_MIRROR="${APT_MIRROR:-https://mirrors.ustc.edu.cn/ubuntu-ports}"

# 防止脚本误在 Intel Mac 或 Linux 主机上创建不符合预期的环境。
if [[ "$(uname -s)" != "Darwin" || "$(uname -m)" != "arm64" ]]; then
  echo "此脚本只用于 Apple Silicon macOS。" >&2
  exit 1
fi

# 仅在 limactl 不存在时下载；同时从官方发布页下载 SHA256SUMS 做完整性校验。
if [[ ! -x "$LIMACTL" ]]; then
  asset="lima-${LIMA_VERSION}-Darwin-arm64.tar.gz"
  base_url="https://github.com/lima-vm/lima/releases/download/v${LIMA_VERSION}"
  # 临时目录会在脚本退出时自动删除。
  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' EXIT

  curl -fL "$base_url/$asset" -o "$tmpdir/$asset"
  curl -fL "$base_url/SHA256SUMS" -o "$tmpdir/SHA256SUMS"
  expected="$(awk -v name="$asset" '$2 == name { print $1 }' "$tmpdir/SHA256SUMS")"
  actual="$(shasum -a 256 "$tmpdir/$asset" | awk '{ print $1 }')"
  # 校验不匹配时，由 set -e 立即终止，绝不解压未知文件。
  [[ -n "$expected" && "$expected" == "$actual" ]]

  mkdir -p "$LIMA_HOME"
  tar -xzf "$tmpdir/$asset" -C "$LIMA_HOME"
fi

# 首次创建：VZ 提供 Apple 原生虚拟化，客体仍是 ARM64；x86 由客体 QEMU TCG 模拟。
# --mount-writable 让 Mac 仓库以相同绝对路径可写地共享进 VM。
if ! "$LIMACTL" list --json 2>/dev/null | grep -q "\"name\":\"$INSTANCE\""; then
  "$LIMACTL" start --yes \
    --name="$INSTANCE" \
    --vm-type=vz \
    --arch=aarch64 \
    --cpus=6 \
    --memory=10 \
    --disk=35 \
    --containerd=none \
    --mount-writable \
    --timeout=20m \
    template:ubuntu-22.04
elif ! "$LIMACTL" list "$INSTANCE" --json | grep -q '"status":"Running"'; then
  # 实例存在但已停止时直接启动，不重建磁盘。
  "$LIMACTL" start "$INSTANCE"
fi

# heredoc 中的命令在 Ubuntu VM 内执行；单引号标记可避免 Mac 侧提前展开变量。
"$LIMACTL" shell "$INSTANCE" -- bash -s -- "$APT_MIRROR" <<'GUEST'
set -euo pipefail
mirror="$1"

# 可通过 APT_MIRROR='' 禁用镜像站替换并使用 Ubuntu 官方 ports 源。
if [[ -n "$mirror" ]]; then
  sudo sed -i -E "s#https?://ports\.ubuntu\.com/ubuntu-ports#$mirror#g" /etc/apt/sources.list
fi

# 减少语言索引下载，并固定 IPv4，降低首次初始化时的网络不确定性。
apt_opts=(-o Acquire::Languages=none -o Acquire::ForceIPv4=true)
sudo apt-get "${apt_opts[@]}" update
sudo DEBIAN_FRONTEND=noninteractive apt-get "${apt_opts[@]}" install -y \
  build-essential gcc-x86-64-linux-gnu binutils-x86-64-linux-gnu \
  libc6-dev-amd64-cross bc bison flex libssl-dev libelf-dev dwarves \
  cpio rsync kmod fakeroot qemu-system-x86 qemu-utils e2fsprogs \
  parted dosfstools util-linux grub2-common gdb-multiarch \
  wget curl xz-utils file git perl python3

# Ubuntu 22.04 的 amd64 cross-glibc libm.a 使用 /usr/lib/x86_64-linux-gnu
# 绝对路径，但归档实际安装在 /usr/x86_64-linux-gnu/lib。
sudo mkdir -p /usr/lib/x86_64-linux-gnu
for archive in /usr/x86_64-linux-gnu/lib/libm-*.a /usr/x86_64-linux-gnu/lib/libmvec.a; do
  sudo ln -sf "$archive" "/usr/lib/x86_64-linux-gnu/$(basename "$archive")"
done

# 打印关键版本，既是安装结果摘要，也是排错时的第一组证据。
echo "host_arch=$(uname -m)"
x86_64-linux-gnu-gcc --version | head -1
qemu-system-x86_64 --version | head -1
GUEST

echo "Lima 构建环境已准备好：$INSTANCE"
