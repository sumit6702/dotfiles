#!/bin/bash
echo "Welcome to KittyDots!"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_PATH="$SCRIPT_DIR/scripts"

selected_script=$(ls "$SCRIPTS_PATH" | fzf --prompt="Select a script to run: " --height=40% --layout=reverse --border)

if [-n "$selected_script"]; then
  "$SCRIPTS_PATH/$selected_script"
else
    echo "No script selected. Exiting..."
    exit 1
fi