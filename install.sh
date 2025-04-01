#!/bin/bash

red="\033[31m"
green="\033[32m"
reset="\033[0m"

# Files Path
dotfiles=("$PWD/dots"/*)
scripts_path="./scripts"

# Welcome message
echo -e "${green}Simple Dotfile Manager - Sumitk${reset}"

install_dotfiles() {
    local c=1  # Reset counter for each run

    # Check if dotfiles exist
    if [ ${#dotfiles[@]} -eq 0 ]; then
        echo -e "${red}No dotfiles found in ./dots${reset}"
        return
    fi

    # List dotfiles
    for dot in "${dotfiles[@]}"; do
        echo -e "${red}${c}:${reset} ${green}${dot##*/}${reset}"
        ((c++))
    done

    echo -e "\n${red}Enter No. To Install Dotfile: ${reset}"
    read -r user_input

    if [[ "$user_input" =~ ^[0-9]+$ ]] && (( user_input >= 1 && user_input <= ${#dotfiles[@]} )); then
        selected_item="${dotfiles[user_input-1]}"
        echo -e "${green}Installing${reset} ${red}${selected_item##*/}${reset}"
        
        # User Destination
        echo -e "\n${red}Enter Destination (e.g., ~/.config/nvim or ~/.config/):${reset}"
        read -r user_dest
        user_dest="${user_dest/#\~/$HOME}"  # Expand ~ to $HOME

        # Ensure user_dest is an absolute path
        if [[ ! "$user_dest" = /* ]]; then
            echo -e "${red}Error: Destination must be an absolute path.${reset}"
            return
        fi

        # Determine final link path
        if [[ -d "$user_dest" ]]; then
            link_path="$user_dest/${selected_item##*/}"
        else
            link_path="$user_dest"
        fi

        # Backup if existing
        if [ -e "$link_path" ] || [ -L "$link_path" ]; then
            echo -e "${red}Backing up existing file/directory...${reset}"
            mv "$link_path" "${link_path}.bak"
        fi

        # Remove existing empty directory if mistakenly created
        if [ -d "$link_path" ] && [ -z "$(ls -A "$link_path")" ]; then
            rmdir "$link_path"
        fi

        # Create symbolic link
        ln -s "$selected_item" "$link_path"
        echo -e "${green}Symbolic link created at $link_path.${reset}"
    else 
        echo -e "${red}Invalid selection. Please choose a number between 1 and ${#dotfiles[@]}.${reset}"
    fi
}

run_scripts() {
    if [ ! -d "$scripts_path" ] || [ -z "$(ls -A "$scripts_path")" ]; then
        echo -e "${red}No scripts found in $scripts_path${reset}"
        return
    fi

    echo -e "${green}Available Scripts:${reset}"
    local scripts=("$scripts_path"/*)
    local c=1

    for script in "${scripts[@]}"; do
        echo -e "${red}${c}:${reset} ${green}${script##*/}${reset}"
        ((c++))
    done

    echo -e "\n${red}Enter No. To Run Script: ${reset}"
    read -r user_input

    if [[ "$user_input" =~ ^[0-9]+$ ]] && (( user_input >= 1 && user_input <= ${#scripts[@]} )); then
        selected_script="${scripts[user_input-1]}"
        echo -e "${green}Running Script:${reset} ${red}${selected_script##*/}${reset}"
        bash "$selected_script"
    else
        echo -e "${red}Invalid selection.${reset}"
    fi
}

uninstall() {
    echo -e "${red}Uninstalling Dotfiles${reset}"
    echo -e "\n${red}Enter the Destination of Installed Dotfile to Remove (e.g., ~/.config/nvim):${reset}"
    read -r user_dest
    user_dest="${user_dest/#\~/$HOME}"  # Expand ~ to $HOME

    if [ -L "$user_dest" ]; then
        echo -e "${red}Removing symlink:${reset} $user_dest"
        rm "$user_dest"
    elif [ -d "$user_dest" ] || [ -f "$user_dest" ]; then
        echo -e "${red}Warning: This is a real file/folder, not a symlink. Skipping.${reset}"
    else
        echo -e "${red}No such file or symlink found.${reset}"
    fi
}

# ----- MAIN MENU ----- #
echo -e "${green}Choose an option:${reset}"
echo -e "${red}1. Install Dotfiles${reset}"
echo -e "${red}2. Run Scripts${reset}"
echo -e "${red}3. Uninstall Dotfiles${reset}"
read -p "Enter your choice: " choice

case $choice in
    1) install_dotfiles ;;
    2) run_scripts ;;
    3) uninstall ;;
    *) echo -e "${red}Invalid option!${reset}" ;;
esac
