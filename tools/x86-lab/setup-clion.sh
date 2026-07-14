#!/usr/bin/env bash
# 为 Mac 上的 CLion 生成 Linux 内核 Compilation Database。
# 它把 VM 构建命令和生成头文件同步到 Mac，并将 VM 路径改写为本地路径。
# 学习重点：命令替换、heredoc、管道、嵌入 Python、JSON 遍历和路径替换。
# DEBUG_TRACE=1 可观察 Shell 命令；Python 内部逻辑直接结合下方逐行注释阅读。
set -euo pipefail

# 统一调试入口；建议用 DEBUG_TRACE=1 学习路径查询、rsync 和 JSON 改写流程。
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
source "$SCRIPT_DIR/debug-lib.sh"
xlab_debug_init

# 数据库最终放在仓库根目录，CLion 必须“打开该 JSON 为项目”才能使用。
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd -P)"
LIMACTL="${LIMACTL:-$HOME/.local/bin/limactl}"
INSTANCE="${LIMA_INSTANCE:-linux-x86-builder}"
CLION_BUILD="$REPO_ROOT/out/x86-lab/clion-build"
VM_DATABASE="$REPO_ROOT/out/x86-lab/compile_commands.vm.json"
DATABASE="$REPO_ROOT/compile_commands.json"
xlab_debug_point "CLion 索引路径已解析" REPO_ROOT LIMACTL INSTANCE CLION_BUILD VM_DATABASE DATABASE

# 确保 Lima 可用，并自动启动已停止的构建实例。
[[ -x "$LIMACTL" ]] || {
  echo "找不到 limactl，请先运行 tools/x86-lab/bootstrap-mac.sh" >&2
  exit 1
}
if ! "$LIMACTL" list "$INSTANCE" --json 2>/dev/null | grep -q '"status":"Running"'; then
  "$LIMACTL" start "$INSTANCE"
fi

# 查询 VM 真正的 HOME；不要硬编码 /home/<name>，Lima 用户名可能变化。
vm_home="$($LIMACTL shell "$INSTANCE" -- printenv HOME | tr -d '\r')"
vm_source="$vm_home/x86-linux-lab-work/linux-src"
vm_build="$vm_home/x86-linux-lab-work/linux-out"
xlab_debug_point "已查询 Lima 内的构建路径" vm_home vm_source vm_build

# autoconf.h 是内核完成配置/构建的可靠标志；没有它就无法正确索引条件编译代码。
"$LIMACTL" shell "$INSTANCE" -- test -f "$vm_build/include/generated/autoconf.h" || {
  echo "缺少内核构建结果，请先运行 tools/x86-lab/build.sh" >&2
  exit 1
}

# 用内核自带脚本从真实 .cmd 文件生成数据库，先保留 VM 原始路径。
mkdir -p "$CLION_BUILD"
xlab_debug_point "准备生成 VM Compilation Database" CLION_BUILD VM_DATABASE vm_source vm_build
"$LIMACTL" shell "$INSTANCE" -- \
  python3 "$vm_source/scripts/clang-tools/gen_compile_commands.py" \
    -d "$vm_build" -o "$VM_DATABASE"

"$LIMACTL" shell "$INSTANCE" -- bash -s -- \
  "$vm_build" "$CLION_BUILD" "$VM_DATABASE" <<'GUEST'
set -euo pipefail
# 以下三个参数分别是 VM 输出目录、Mac 可见的索引辅助目录和原始数据库。
vm_build="$1"
clion_build="$2"
database="$3"

# 每次重建派生目录，避免旧生成头文件污染 CLion 索引。
rm -rf "$clion_build/include" "$clion_build/arch" "$clion_build/toolchain"
mkdir -p "$clion_build/arch/x86/include" "$clion_build/toolchain"
rsync -a "$vm_build/include/" "$clion_build/include/"
rsync -a "$vm_build/arch/x86/include/generated/" \
  "$clion_build/arch/x86/include/generated/"
rsync -a /usr/lib/gcc-cross/x86_64-linux-gnu/11/include/ \
  "$clion_build/toolchain/include/"
# 数据库中少数 .c 文件由构建过程生成；筛出并同步这些文件。
python3 - "$database" "$vm_build" <<'PY' | \
  rsync -a --files-from=- "$vm_build/" "$clion_build/"
import json
import os
import sys

database, build = sys.argv[1:]
for entry in json.load(open(database, encoding="utf-8")):
    path = entry["file"]
    if path.startswith(build + os.sep):
        print(os.path.relpath(path, build))
PY
GUEST

# 第二段 Python 在 Mac 可见路径中改写 JSON，避免 CLion 去查 VM 私有目录。
python3 - "$VM_DATABASE" "$DATABASE" \
  "$vm_source" "$vm_build" "$REPO_ROOT" "$CLION_BUILD" <<'PY'
import json
import sys

source_file, destination, vm_source, vm_build, local_source, local_build = sys.argv[1:]
with open(source_file, encoding="utf-8") as stream:
    database = json.load(stream)

# 生成头、GCC 内建头、源码路径各自映射到 Mac 上的真实副本。
replacements = (
    ("/usr/lib/gcc-cross/x86_64-linux-gnu/11/include", local_build + "/toolchain/include"),
    (vm_source, local_source),
    (vm_build, local_build),
)
unsupported_clang_flags = (
    "-mpreferred-stack-boundary=3",
    "-mindirect-branch=thunk-extern",
    "-mindirect-branch-register",
    "-fno-allow-store-data-races",
    "-fconserve-stack",
)

# CLion 在 Mac 上只用这些命令做解析，不会真的用 Apple Clang 重编 Linux 内核。
for entry in database:
    entry["directory"] = local_build
    for field in ("file", "output", "command"):
        if field not in entry:
            continue
        for old, new in replacements:
            entry[field] = entry[field].replace(old, new)
    # 将 Linux 交叉 GCC 替换成 CLion 能调用的本机 clang 前端。
    entry["command"] = entry["command"].replace(
        "x86_64-linux-gnu-gcc ",
        "/usr/bin/clang --target=x86_64-unknown-linux-gnu ",
        1,
    )
    # 删除 Apple Clang 不认识、但不影响语义索引的 GCC 专用选项。
    for flag in unsupported_clang_flags:
        entry["command"] = entry["command"].replace(" " + flag, "")

with open(destination, "w", encoding="utf-8") as stream:
    json.dump(database, stream, ensure_ascii=False, indent=2)
    stream.write("\n")

print(f"generated {len(database)} entries: {destination}")
PY

xlab_debug_point "本地 Compilation Database 已生成" DATABASE CLION_BUILD
# 原始 VM 数据库只是中间文件；保留根目录数据库作为唯一 CLion 项目入口。
rm -f "$VM_DATABASE"
echo "CLion 索引数据库已准备完成。"
echo "请在 CLion 中用 File | Open 选择：$DATABASE"
