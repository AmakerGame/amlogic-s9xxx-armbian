#!/bin/dash
# Power-cycle BT chip (fresh firmware download each attempt) + alias /dev/ttyS1 -> ttyS2 hw
rmmod sdio_bt 2>/dev/null
sleep 1
i=0
while [ ! -e /dev/ttyS2 ] && [ $i -lt 15 ]; do sleep 1; i=$((i+1)); done
ls -la /dev/ttyS* /dev/serial* > /dev/kmsg 2>&1
if [ -c /dev/ttyS2 ]; then
  mm=$(cat /sys/class/tty/ttyS2/dev 2>/dev/null)
  maj=${mm%:*}; min=${mm#*:}
  if [ -n "$maj" ] && [ -n "$min" ]; then
    rm -f /dev/ttyS1
    mknod /dev/ttyS1 c "$maj" "$min" 2>/dev/null
    chmod 666 /dev/ttyS1 2>/dev/null
  fi
fi
echo "w1-bt: ttyS1=$(ls -la /dev/ttyS1 2>&1)" > /dev/kmsg
exit 0
