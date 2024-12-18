#!/bin/bash

# Define color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Dynamic option generation function
generate_options() {
    local base_dir="$1"
    local working_dir="$2"

    # Clear the global options array first
    unset options
    declare -g -A options=()

    # Check if base directory exists
    if [ ! -d "$base_dir/$working_dir" ]; then
        echo -e "${RED}Directory $base_dir/$working_dir does not exist${NC}"
        return 1
    fi

    # Find all subdirectories in the base directory
    for dir in "$base_dir/$working_dir"/*; do
        dir_name=$(basename "${dir}")
        target="$HOME/$working_dir/$dir_name"
        options["$dir_name"]="$target:$dir_name"
    done
}

# Create backup if necessary
create_backup() {
    local target="$1"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        local backup="${target}.backup.$(date +%Y%m%d_%H%M%S)"
        echo -e "${YELLOW}Creating backup: $backup${NC}"
        mv "$target" "$backup"
    fi
}

# Link selected files
link_files() {
    local working_dir="$1"
    local selected_items=("$@")

    if [ ${#selected_items[@]} -eq 1 ]; then
        echo -e "${RED}No items selected.${NC}"
        return 1
    fi

    for item in "${selected_items[@]:1}"; do
        if [[ -n "${options[$item]}" ]]; then
            target="${options[$item]%%:*}"
            source_name="${options[$item]#*:}"
            source="$(pwd)/$working_dir/$source_name"

            if [ ! -e "$source" ]; then
                echo -e "${RED}Error: Source directory/file does not exist: $source${NC}"
                continue
            fi

            mkdir -p "$(dirname "$target")"
            create_backup "$target"
            [ -L "$target" ] && rm "$target"

            if ln -sf "$source" "$target"; then
                echo -e "${GREEN}Linked: $source -> $target${NC}"
            else
                echo -e "${RED}Failed to link $source${NC}"
            fi
        else
            echo -e "${RED}Invalid option: $item${NC}"
        fi
    done
}

# Unlink selected files
unlink_files() {
    local selected_items=("$@")
    if [ ${#selected_items[@]} -eq 0 ]; then
        echo -e "${RED}No items selected for unlinking.${NC}"
        return 1
    fi

    for item in "${selected_items[@]}"; do
        if [[ -n "${options[$item]}" ]]; then
            target="${options[$item]%%:*}"
            if [ -L "$target" ]; then
                echo -e "${YELLOW}Removing symlink: $target${NC}"
                rm "$target"
            elif [ -e "$target" ]; then
                echo -e "${RED}Not a symlink: $target. Skipping.${NC}"
            else
                echo -e "${YELLOW}Target does not exist: $target${NC}"
            fi
        fi
    done
}

# Parse selections using fzf
parse_selection() {
    local working_dir="$1"
    local selected
    selected=$(for dir in "$working_dir"/*; do
        basename "$dir"
    done | fzf --multi --prompt="Select options: " --header="Use TAB to select multiple options and ENTER to confirm.")

    if [ -n "$selected" ]; then
        echo "$selected"
    else
        echo "No items selected."
        return 1
    fi
}

# Configuration menu
config_menu() {
    local base_dir="$(pwd)"
    local working_dir=".config"

    generate_options "$base_dir" "$working_dir"
    mapfile -t selected_items < <(parse_selection "$base_dir/$working_dir")

    if [ "$1" == "install" ]; then
        link_files "$working_dir" "${selected_items[@]}"
    elif [ "$1" == "uninstall" ]; then
        unlink_files "${selected_items[@]}"
    fi
}

# Local menu
local_menu() {
    local base_dir="$(pwd)"
    local working_dir=".local/share"

    generate_options "$base_dir" "$working_dir"
    mapfile -t selected_items < <(parse_selection "$base_dir/$working_dir")

    if [ "$1" == "install" ]; then
        link_files "$working_dir" "${selected_items[@]}"
    elif [ "$1" == "uninstall" ]; then
        unlink_files "${selected_items[@]}"
    fi
}

# Other menu
other_menu() {
    local base_dir="$(pwd)"
    local working_dir="."

    generate_options "$base_dir" "$working_dir"
    mapfile -t selected_items < <(parse_selection "$base_dir/$working_dir")

    if [ "$1" == "install" ]; then
        link_files "$working_dir" "${selected_items[@]}"
    elif [ "$1" == "uninstall" ]; then
        unlink_files "${selected_items[@]}"
    fi
}

# Install menu
install_menu() {
    local choice
    choice=$(printf "1. Config\n2. Local\n3. Other" | fzf --prompt="Install Menu: " --header="Select an option:")

    case "$choice" in
        "1. Config")
            config_menu "install"
            ;;
        "2. Local")
            local_menu "install"
            ;;
        "3. Other")
            other_menu "install"
            ;;
        *)
            echo -e "${RED}Invalid choice!${NC}"
            ;;
    esac
}

# Uninstall menu
uninstall_menu() {
    local choice
    choice=$(printf "1. Config\n2. Local\n3. Other" | fzf --prompt="Uninstall Menu: " --header="Select an option:")

    case "$choice" in
        "1. Config")
            config_menu "uninstall"
            ;;
        "2. Local")
            local_menu "uninstall"
            ;;
        "3. Other")
            other_menu "uninstall"
            ;;
        *)
            echo -e "${RED}Invalid choice!${NC}"
            ;;
    esac
}

# Main menu
main_menu() {
    local choice
    choice=$(printf "Install\nUninstall" | fzf --prompt="Main Menu: " --header="Select an Option:")

    case "$choice" in
        "Install")
            install_menu
            ;;
        "Uninstall")
            uninstall_menu
            ;;
        *)
            echo -e "${RED}Invalid choice!${NC}"
            ;;
    esac
}

# Main function
main() {
    if ! command -v fzf &> /dev/null; then
        echo -e "${RED}Error: fzf is not installed.${NC}"
        echo -e "${YELLOW}Please install fzf using your system's package manager.${NC}"
        return 1
    fi
    main_menu
}

# Run the script
main

