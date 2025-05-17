#!/bin/bash

WALLPAPER_DIR="$HOME/Nextcloud/Wallpapers/skele"

# Start swww daemon if not running
if ! pgrep -x swww-daemon > /dev/null; then
  swww-daemon &
  sleep 0.5
fi

while true; do
  # Pick a random image file
  FILE=$(find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.png' \) | shuf -n 1)
  
  # Set wallpaper with cool grow transition
  swww img "$FILE" \
    --transition-type grow \
    --transition-pos 0.5,0.5 \
    --transition-duration 1 \
    --transition-fps 60

  # Wait 10 minutes before next change
  sleep 600
done

