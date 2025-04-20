#!/bin/bash

# List of allowed prefixes
PREFIXES=("http://127.0.0.1:11471" "https://127.0.0.1:11471" "https://store-011.wnam.tb-cdn.io/")

# Temp file to detect changes
LAST_CLIP_FILE="/tmp/.mpv_clipboard_last"

# Make sure wl-paste exists
if ! command -v wl-paste &>/dev/null; then
  echo "Error: 'wl-paste' not found. Install it with your package manager."
  exit 1
fi

# Initialize last clipboard content
LAST_CLIPBOARD=""

while true; do
  # Get current clipboard content (non-blocking, no wait)
  CLIP=$(wl-paste --no-newline 2>/dev/null)

  # Check for changes
  if [[ "$CLIP" != "$LAST_CLIPBOARD" ]]; then
    LAST_CLIPBOARD="$CLIP"

    for PREFIX in "${PREFIXES[@]}"; do
      if [[ "$CLIP" == "$PREFIX"* ]]; then
        echo "Playing $CLIP with mpv..."
        mpv "$CLIP" &
        break
      fi
    done
  fi

  sleep 1
done
