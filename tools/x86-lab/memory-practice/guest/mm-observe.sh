#!/bin/sh
# Snapshot one target process without requiring procps, perf, or Python.
pid="${1:-}"
case "$pid" in
  ''|*[!0-9]*) echo "usage: $0 PID" >&2; exit 2 ;;
esac
base="/proc/$pid"
[ -d "$base" ] || { echo "PID $pid does not exist" >&2; exit 1; }

echo "===== PID $pid $(date 2>/dev/null || true) ====="
echo "--- status counters ---"
sed -n '/^Name:/p;/^State:/p;/^Pid:/p;/^PPid:/p;/^VmPeak:/p;/^VmSize:/p;/^VmRSS:/p;/^RssAnon:/p;/^RssFile:/p;/^VmData:/p;/^VmStk:/p;/^VmExe:/p;/^VmPTE:/p;/^voluntary_ctxt_switches:/p;/^nonvoluntary_ctxt_switches:/p' "$base/status"
echo "--- statm: size resident shared text lib data dt (pages) ---"
cat "$base/statm"
echo "--- maps ---"
cat "$base/maps"
if [ -r "$base/smaps_rollup" ]; then
  echo "--- smaps_rollup ---"
  sed -n '/^Rss:/p;/^Pss:/p;/^Shared_Clean:/p;/^Shared_Dirty:/p;/^Private_Clean:/p;/^Private_Dirty:/p;/^Anonymous:/p;/^AnonHugePages:/p' "$base/smaps_rollup"
fi
echo "--- system ---"
sed -n '/^MemTotal:/p;/^MemFree:/p;/^MemAvailable:/p;/^Buffers:/p;/^Cached:/p;/^PageTables:/p;/^Committed_AS:/p' /proc/meminfo
