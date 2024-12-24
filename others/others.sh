#!/bin/bash

# Set the current working directory
P="$PWD"

# Define the array
declare -a files=(
  [1]="$HOME/.config/hyde/wallbash/Wall-Ways/:hyde"
  [2]="$HOME/.config/hypr:hypr"
  [3]="$HOME/.local/share/bin/:hyde_scripts"
)

# List available options
for i in "${!files[@]}"; do
  echo "$i: ${files[$i]#*:}"
done

# Prompt user for a choice
echo "Choose a file to link:"
read choice

# Check if the chosen file is valid
if [[ -n "${files[$choice]}" ]]; then
  target_file="${files[$choice]}"
  
  # Extract target location and file name
  target_loc="${target_file%%:*}"
  file_name="${target_file#*:}"
  
  # Link the file
  for f in "$P/$file_name/"* ; do
    filename=$(basename "$f")
     echo "linking $f -> $target_loc/$filename"
    ln -sf "$P/$file_name/$filename"  "$target_loc/$filename"
  done

else
  echo "Invalid choice or file not found!"
fi
