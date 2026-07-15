#!/usr/bin/env bash
# x86-lab 所有 Bash 脚本共用的“学习/调试辅助库”。
#
# 它默认完全静默，不改变正常流程。按需在命令前设置环境变量：
#   DEBUG_TRACE=1  打印每条实际执行的命令、脚本名、行号和函数名。
#   DEBUG_VARS=1   在脚本预设的调试点打印关键变量及其 Bash 类型。
#   DEBUG_STEP=1   在预设调试点暂停，按 Enter 后继续（必须是交互终端）。
#   DEBUG_ERRORS=1 命令失败时打印退出码、命令和调用栈。
#   DEBUG_LOG=文件  把调试输出追加到文件；Mac Bash 3.2 会同时记录 stderr。
#
# 示例：
#   DEBUG_TRACE=1 DEBUG_ERRORS=1 tools/x86-lab/build/build.sh
#   DEBUG_VARS=1 DEBUG_STEP=1 tools/x86-lab/direct/run.sh
#   DEBUG_TRACE=1 DEBUG_LOG=/tmp/build.trace tools/x86-lab/build/build.sh

# 防止同一进程重复 source 本文件时重复安装 trap 或打开日志描述符。
if [[ "${XLAB_DEBUG_LIB_LOADED:-0}" == "1" ]]; then
  return 0
fi
readonly XLAB_DEBUG_LIB_LOADED=1

# 把布尔开关限制为 0 或 1，避免拼写错误被悄悄当成“关闭”。
xlab_debug_check_boolean() {
  local name="$1"
  local value="${!name:-0}"

  if [[ "$value" != "0" && "$value" != "1" ]]; then
    printf '调试参数错误：%s=%q，只允许 0 或 1\n' "$name" "$value" >&2
    return 2
  fi
}

# ERR trap 的处理函数。这里先关闭 xtrace，防止错误报告本身产生大量跟踪行。
xlab_debug_error() {
  local status="$1"
  local line="$2"
  local command="$3"
  local frame=0
  local source="${BASH_SOURCE[2]:-${BASH_SOURCE[1]:-unknown}}"

  { set +x; } 2>/dev/null
  printf '\n[XLAB-ERROR] status=%s source=%s line=%s\n' \
    "$status" "$source" "$line" >&2
  printf '[XLAB-ERROR] command: %s\n' "$command" >&2
  printf '[XLAB-ERROR] call stack (newest first):\n' >&2
  while caller "$frame" >&2; do
    ((frame += 1)) || true
  done

  # trap 函数的返回值必须仍是原错误码，set -e 才能保持原有退出语义。
  return "$status"
}

# 打印指定变量。使用 declare -p 而不是 echo，数组、空格和特殊字符都不会丢失。
xlab_debug_dump_vars() {
  local label="$1"
  shift
  local name

  [[ "${DEBUG_VARS:-0}" == "1" ]] || return 0
  printf '\n[XLAB-VARS] %s\n' "$label" >&2
  for name in "$@"; do
    if [[ "$name" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]] && declare -p "$name" >/dev/null 2>&1; then
      declare -p "$name" >&2
    else
      printf '[XLAB-VARS] %s is unset or is not a valid variable name\n' "$name" >&2
    fi
  done
}

# 交互式学习断点。这里只在预先选择的阶段边界暂停，不会每执行一行都询问。
xlab_debug_pause() {
  local label="$1"
  local answer

  [[ "${DEBUG_STEP:-0}" == "1" ]] || return 0
  if [[ ! -t 0 ]]; then
    printf '[XLAB-STEP] %s：stdin 不是终端，跳过暂停。\n' "$label" >&2
    return 0
  fi

  printf '\n[XLAB-STEP] %s\n' "$label" >&2
  printf '[XLAB-STEP] Enter=继续，q=退出脚本：' >&2
  IFS= read -r answer
  if [[ "$answer" == "q" || "$answer" == "Q" ]]; then
    printf '[XLAB-STEP] 用户在调试点终止。\n' >&2
    return 130
  fi
}

# 脚本只需调用这一项即可同时获得变量快照和可选暂停。
xlab_debug_point() {
  local label="$1"
  shift
  xlab_debug_dump_vars "$label" "$@"
  xlab_debug_pause "$label"
}

# 每个脚本在读取本文件后调用一次，初始化全部调试开关。
xlab_debug_init() {
  local name

  for name in DEBUG_TRACE DEBUG_VARS DEBUG_STEP DEBUG_ERRORS; do
    xlab_debug_check_boolean "$name"
  done

  # PS4 只在 set -x 时使用；BASH_SOURCE/LINENO 会在每条命令执行时动态展开。
  export PS4='+ [${BASH_SOURCE##*/}:${LINENO}:${FUNCNAME[0]:-main}] '

  if [[ -n "${DEBUG_LOG:-}" ]]; then
    mkdir -p "$(dirname "$DEBUG_LOG")"
    if ((BASH_VERSINFO[0] >= 4)); then
      # Bash 4+ 支持专用 xtrace fd；VM 中只把 trace 写入日志。
      exec 9>>"$DEBUG_LOG"
      export BASH_XTRACEFD=9
    else
      # macOS 自带 Bash 3.2 没有 BASH_XTRACEFD，只能复制整个 stderr。
      # tee 一份写日志、一份送回原 stderr，所以终端错误信息不会消失。
      exec 2> >(tee -a "$DEBUG_LOG" >&2)
    fi
    printf '[XLAB-DEBUG] trace log: %s\n' "$DEBUG_LOG" >&2
  fi

  if [[ "${DEBUG_ERRORS:-0}" == "1" ]]; then
    # errtrace 让 ERR trap 在函数、子 shell 和命令替换中继续生效。
    set -E
    trap 'xlab_debug_error "$?" "$LINENO" "$BASH_COMMAND"' ERR
  fi

  if [[ "${DEBUG_TRACE:-0}" == "1" ]]; then
    set -x
  fi
}
