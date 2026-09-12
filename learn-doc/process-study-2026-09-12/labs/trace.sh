#!/usr/bin/env bash
# 只在实验 guest/Linux 实验机以 root 运行；独立 instance 不改全局 tracer。
set -euo pipefail
trace_root=${TRACE_ROOT:-/sys/kernel/tracing}
[[ -d "$trace_root/events/sched" ]] || { echo '请先挂载 tracefs 并确认调度事件存在' >&2; exit 1; }
[[ $# -gt 0 ]] || { echo 'usage: bash trace.sh /path/process_lab pipe' >&2; exit 2; }
instance="$trace_root/instances/process-study-$$"
mkdir "$instance"
cleanup() {
  echo 0 > "$instance/tracing_on" 2>/dev/null || true
  rmdir "$instance" 2>/dev/null || true
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
echo 0 > "$instance/tracing_on"
echo 2048 > "$instance/buffer_size_kb"
for event in sched_process_fork sched_process_exec sched_process_exit sched_switch sched_waking sched_wakeup; do
  [[ -f "$instance/events/sched/$event/enable" ]] || { echo "缺少事件 $event" >&2; exit 1; }
  echo 1 > "$instance/events/sched/$event/enable"
done
echo 1 > "$instance/tracing_on"
result=0
"$@" || result=$?
echo 0 > "$instance/tracing_on"
cat "$instance/trace"
for stats in "$instance"/per_cpu/cpu*/stats; do
  echo "BUFFER_STATS $stats" >&2
  cat "$stats" >&2
done
exit "$result"
