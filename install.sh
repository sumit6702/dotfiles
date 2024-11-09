#!/bin/bash

# Define options for linking
declare -A options=(
    [1]="$HOME/.config/fish:fish"
    [2]="$HOME/.config/alacritty:alacritty"
    [3]="$HOME/.config/kitty:kitty"
    [4]="$HOME/.config/ohmyposh:ohmyposh"
    [5]="$HOME/.config/fastfetch:fastfetch"
    [6]="$HOME/.config/nvim:nvim"
    [7]="$HOME/.config/zellij:zellij"
    [8]="$HOME/.config/hypr:hypr"
    [9]="$HOME/.local/share/hyprpanel:hyprpanel"
    [10]="$HOME/.config/mpv:mpv"
    [11]="$HOME/.config/yazi:yazi"
    [12]="$HOME/.local/share/scripts:scripts"
    [13]="$HOME/.local/share/wallpapers:wallpapers"
)

# Display available options
echo "Available files to link:"
for key in "${!options[@]}"; do
    echo "$key) ${options[$key]}"
done

# Prompt for user input
echo "Select options to link (e.g., 1,2,3 or 1-3 or 'all'): "
read -r selection

# Parse input
if [[ "$selection" == "all" ]]; then
    selected_keys=("${!options[@]}")
else
    selected_keys=()
    IFS=',' read -ra ranges <<< "$selection"
    for range in "${ranges[@]}"; do
        if [[ "$range" == *-* ]]; then
            start="${range%-*}"
            end="${range#*-}"
            for ((i = start; i <= end; i++)); do
                selected_keys+=("$i")
            done
        else
            selected_keys+=("$range")
        fi
    done
fi

# Create necessary directories if they don't exist
for key in "${selected_keys[@]}"; do
    if [[ -n "${options[$key]}" ]]; then
        target="${options[$key]%%:*}"
        target_dir=$(dirname "$target")
        mkdir -p "$target_dir"
    fi
done

# Apply selected links
for key in "${selected_keys[@]}"; do
    if [[ -n "${options[$key]}" ]]; then
        # Split target path and source directory name
        target="${options[$key]%%:*}"
        source_name="${options[$key]#*:}"
        
        # Construct full source path (assuming script is run from dotfiles directory)
        source="$(pwd)/$source_name"
        
        # Remove existing link or file
        if [ -e "$target" ] || [ -L "$target" ]; then
            rm -rf "$target"
        fi
        
        echo "Linking $source -> $target"
        ln -sf "$source" "$target"
    else
        echo "Invalid option: $key"
    fi
done
