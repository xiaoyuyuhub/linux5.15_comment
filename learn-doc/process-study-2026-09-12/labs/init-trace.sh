#!/bin/sh
mount -t devtmpfs devtmpfs /dev
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t tmpfs tmpfs /tmp
export PATH=/bin:/sbin
mkdir -p /sys/kernel/tracing
mount -t tracefs tracefs /sys/kernel/tracing
T=/sys/kernel/tracing/instances/process-study
if mkdir "$T"; then
  echo 0 > "$T/tracing_on"
  echo 2048 > "$T/buffer_size_kb"
  for e in sched_process_fork sched_process_exec sched_process_exit sched_switch sched_waking sched_wakeup; do
    echo 1 > "$T/events/sched/$e/enable"
  done
  echo 1 > "$T/tracing_on"
  /process_lab pipe
  r=$?
  echo 0 > "$T/tracing_on"
  echo TRACE_BEGIN
  cat "$T/trace"
  echo TRACE_STATS
  cat "$T/per_cpu/cpu0/stats"
  echo "TRACE_RESULT=$r"
  rmdir "$T"
else
  echo TRACE_INSTANCE_FAILED
fi
poweroff -f
while :; do sleep 3600; done
