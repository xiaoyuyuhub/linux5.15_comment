#!/bin/sh
set -eu

if [ "$#" -lt 1 ]; then
	echo "usage: $0 PROGRAM [ARGS...]" >&2
	exit 2
fi

trace_dir=/sys/kernel/tracing
if [ ! -d "$trace_dir/events/sched" ]; then
	echo "tracefs is unavailable at $trace_dir" >&2
	exit 1
fi
if [ ! -w "$trace_dir/tracing_on" ]; then
	echo "write access to tracefs is required (usually run as root)" >&2
	exit 1
fi

events="sched_process_fork sched_process_exec sched_process_exit sched_switch"
cleanup()
{
	echo 0 > "$trace_dir/tracing_on"
	for event in $events; do
		if [ -e "$trace_dir/events/sched/$event/enable" ]; then
			echo 0 > "$trace_dir/events/sched/$event/enable"
		fi
	done
}
trap cleanup EXIT INT TERM

echo 0 > "$trace_dir/tracing_on"
: > "$trace_dir/trace"
for event in $events; do
	if [ -e "$trace_dir/events/sched/$event/enable" ]; then
		echo 1 > "$trace_dir/events/sched/$event/enable"
	fi
done

echo 1 > "$trace_dir/tracing_on"
"$@"
echo 0 > "$trace_dir/tracing_on"
cat "$trace_dir/trace"
