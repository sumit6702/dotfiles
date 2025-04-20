#!/bin/bash

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
GRAY='\033[0;37m'
NC='\033[0m'

# list of Pacman packages to install
PACMAN=(
    "git"
    "base-devel"
    "neovim"
    "fzf"
    "yazi"
    "thunar"
    "nwg-displays"
    "gnome-calculator"
    "loupe"
    "deno"
    "nodejs"
    "go"
    "rustup"
    "python-pip"
    "zig"
    "zed"
    "mpv"
    "qbittorrent"
    "adobe-source-han-sans-otc-fonts"
    "adobe-source-han-serif-otc-fonts"
    "noto-fonts-cjk"
)

AUR=(
    "zen-browser-bin"
    "gearlever"
    "microsoft-edge-stable-bin"
    "stremio"
    "discord_arch_electron"
    "onlyoffice-bin"
    "spotify"
    "jellyfin-media-player"
    "pnpm-bin"
    "fluent-icon-theme-git"
    "whitesur-icon-theme"
    "catppuccin-cursors"
    "capitaine-cursors"
)

check_yay() {
    if ! command -v yay &>/dev/null; then
        echo -e "${RED}[ERROR]${NC} yay not found. Installing yay..."
        git clone https://aur.archlinux.org/yay.git ~/yay && cd ~/yay
        makepkg -si --noconfirm
        cd ~
        rm -rf ~/yay
        echo -e "${GREEN}[SUCCESS]${NC} yay installed successfully."
    fi
}

install_pacman() {
    echo -e "${CYAN}[INFO]${NC} Installing Pacman packages..."
    for package in "${PACMAN[@]}"; do
        if ! pacman -Qi "$package" &>/dev/null; then
            echo -e "${GREEN}[SUCCESS]${NC} Installing $package..."
            sudo pacman -S --noconfirm "$package"
        else
            echo -e "${GRAY}[INSTALLED]${NC} $package is already installed."
        fi
    done
}
install_aur() {
    echo -e "${CYAN}[INFO]${NC} Installing AUR packages..."
    for package in "${AUR[@]}"; do
        if ! pacman -Qi "$package" &>/dev/null; then
            echo -e "${GREEN}[SUCCESS]${NC} Installing $package..."
            yay -S --noconfirm "$package"
        else
            echo -e "${GRAY}[INSTALLED]${NC} $package is already installed."
        fi
    done
}

show_menu() {
    echo -e "${CYAN}[INFO]${NC} Please select an option:"
    echo "1) Install Pacman packages"
    echo "2) Install AUR packages"
    echo "4) All of the above"
    echo "5) Exit"
}

cleanup() {
    echo -e "${CYAN}[INFO]${NC} Cleaning up..."
    sudo pacman -Rns $(pacman -firefox) --noconfirm
}

while true; do
    show_menu
    read -p "Enter your choice [1-5]: " choice
    case $choice in
    1)
        install_pacman
        ;;
    2)
        check_yay
        install_aur
        ;;
    3)
        echo -e "${GREEN}Bye!${NC}"
        exit 0
        ;;
    4)
        install_pacman
        check_yay
        install_aur
        ;;
    *)
        echo -e "${RED}[ERROR]${NC} Invalid choice. Please try again."
        ;;
    esac
    read -p "Do you want to continue? (y/n): " continue_choice
    if [[ $continue_choice != "y" ]]; then
        echo -e "${GREEN}Bye!${NC}"
        break
    fi
done
