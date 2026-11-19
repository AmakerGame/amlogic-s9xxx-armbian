#!/bin/sh
rfkill unblock all 2>/dev/null
i=0
while [ ! -e /sys/class/net/wlan0 ] && [ $i -lt 60 ]; do sleep 1; i=$((i+1)); done
sleep 5
if ! nmcli -t -f DEVICE con show --active | grep -q wlan0; then
  nmcli con up wlsvc-24 || true
fi
