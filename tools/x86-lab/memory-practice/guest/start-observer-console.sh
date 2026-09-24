#!/bin/sh
# Attach an interactive shell to the QEMU second serial device.
if [ ! -c /dev/ttyS1 ]; then
  echo "missing /dev/ttyS1; memory-practice/run.sh must add the second serial port" >&2
  exit 1
fi

echo "Starting observer shell on /dev/ttyS1"
setsid sh -c 'exec /bin/sh -i </dev/ttyS1 >/dev/ttyS1 2>&1' &
echo "Now run connect-observer.sh in another Mac terminal"
