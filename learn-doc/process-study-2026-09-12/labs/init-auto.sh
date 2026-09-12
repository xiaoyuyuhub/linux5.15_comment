#!/bin/sh
mount -t devtmpfs devtmpfs /dev
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t tmpfs tmpfs /tmp
export PATH=/bin:/sbin
printf '\nPROCESS_STUDY_BOOT\n'
uname -a
/process_lab all
result=$?
echo "PROCESS_STUDY_RESULT=$result"
echo 'PID 1 stays alive until poweroff; no accidental init exit.'
poweroff -f
while :; do sleep 3600; done
