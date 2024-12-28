#!/bin/bash

#File Locations
waybar="$HOME/.config/hyde/wallbash/Wall-Dcol"
hypr="$HOME/.config/hypr"

# Rename Waybar File
if [ -f "$waybar/waybar.dcol" ]; then
  mv "$waybar/waybar.dcol" "$waybar/waybar.dcol.bak"
fi

# Change Some text
if [ -f "$hypr/keybindings.conf" ]; then
  sed -i 's/$editor/codium/g' "$hypr/keybindings.conf"
fi
