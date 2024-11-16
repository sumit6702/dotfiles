#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

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
    [14]="$HOME/.config/btop:btop"
    [15]="$HOME/.config/spicetify:spicetify"
    [16]="$HOME/.config/zed:zed"
)

# Function to display usage
usage() {
    echo -e "${YELLOW}Usage: $0 [install|uninstall]${NC}"
    echo "Commands:"
    echo "  install   - Install and link dotfiles"
    echo "  uninstall - Remove dotfiles symlinks"
    exit 1
}

# Function to parse selection using fzf
parse_selection_fzf() {
    local action="$1"
    local selections
    selections=$(for key in $(printf "%s\n" "${!options[@]}" | sort -n); do
        echo "[$key] ${options[$key]}"
    done | fzf --multi --prompt="Select options to $action > " --header="Use TAB to select multiple options and ENTER to confirm")
    
    if [[ -z "$selections" ]]; then
        echo -e "${RED}No selection made. Exiting.${NC}"
        exit 1
    fi

    # Extract selected keys
    echo "$selections" | awk -F']' '{print $1}' | tr -d '['
}


# Function to create backup
create_backup() {
    local target="$1"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        local backup="${target}.backup.$(date +%Y%m%d_%H%M%S)"
        echo -e "${YELLOW}Creating backup: $backup${NC}"
        mv "$target" "$backup"
    fi
}

# Function to install dotfiles
install_dotfiles() {
    local selections
    selections=$(parse_selection_fzf "install")
    
    while read -r line; do
        key="${line%%)*}"
        if [[ -n "${options[$key]}" ]]; then
            target="${options[$key]%%:*}"
            source_name="${options[$key]#*:}"
            source="$(pwd)/$source_name"
            
            # Check if source exists
            if [ ! -e "$source" ]; then
                echo -e "${RED}Error: Source directory/file does not exist: $source${NC}"
                continue
            fi
            
            # Create target directory if it doesn't exist
            target_dir=$(dirname "$target")
            mkdir -p "$target_dir"
            
            # Create backup if necessary and remove existing link
            create_backup "$target"
            [ -L "$target" ] && rm "$target"
            
            echo -e "${GREEN}Linking $source -> $target${NC}"
            if ln -sf "$source" "$target"; then
                echo -e "${GREEN}Successfully linked $source${NC}"
            else
                echo -e "${RED}Failed to link $source${NC}"
            fi
        else
            echo -e "${RED}Invalid option: $key${NC}"
        fi
    done <<< "$selections"
}

# Function to uninstall dotfiles
uninstall_dotfiles() {
    local selections
    selections=$(parse_selection_fzf "uninstall")
    
    while read -r line; do
        key="${line%%)*}"
        if [[ -n "${options[$key]}" ]]; then
            target="${options[$key]%%:*}"
            
            if [ -L "$target" ]; then
                echo -e "${YELLOW}Removing symlink: $target${NC}"
                rm "$target"
                echo -e "${GREEN}Successfully removed symlink${NC}"
                
                # Restore backup if it exists
                backup=$(find "$(dirname "$target")" -maxdepth 1 -name "$(basename "$target").backup.*" | sort -r | head -n1)
                if [ -n "$backup" ]; then
                    echo -e "${GREEN}Restoring backup: $backup${NC}"
                    mv "$backup" "$target"
                fi
            else
                echo -e "${YELLOW}No symlink found at $target${NC}"
            fi
        else
            echo -e "${RED}Invalid option: $key${NC}"
        fi
    done <<< "$selections"
}

# Main script
case "$1" in
    "install")
        install_dotfiles
        ;;
    "uninstall")
        uninstall_dotfiles
        ;;
    *)
        usage
        ;;
esac

