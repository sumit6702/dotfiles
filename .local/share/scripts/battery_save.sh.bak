#!/bin/bash

if [[ $(cat /sys/class/power_supply/ACAD/online) -eq 0 ]]; then
  notify-send "Battery Save Mode Enabled"
  hyde power save on
else
  notify-send "Battery Save Mode Disabled"
  hyde power save off
fi
