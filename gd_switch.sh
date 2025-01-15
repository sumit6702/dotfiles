#!/bin/bash

# Define Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

install_intel_driver() {
    echo -e "${BLUE}Installing Intel Graphics Driver...${NC}"
    sudo pacman -S --needed --noconfirm intel-gmmlib intel-media-driver intel-ucode libva-intel-driver vulkan-intel
    echo -e "${GREEN}Intel Graphics Driver installed successfully.${NC}"
}

install_nvidia_driver() {
    echo -e "${BLUE}Installing Nvidia Graphics Driver...${NC}"
    yay -S --needed --noconfirm nvidia-470xx nvidia-470xx-utils nvidia-470xx-settings
    echo -e "${GREEN}Nvidia Graphics Driver installed successfully.${NC}"
}

install_amd_driver() {
    echo -e "${BLUE}Installing AMD Graphics Driver...${NC}"
    sudo pacman -Rns xf86-video-amdgpu vulkan-radeon libva-mesa-driver mesa
    echo -e "${GREEN}AMD Graphics Driver installed successfully.${NC}"
}

uninstall_intel_driver() {
    echo -e "${BLUE}Uninstalling Intel Graphics Driver...${NC}"
    sudo pacman -Rns intel-gmmlib intel-media-driver intel-ucode libva-intel-driver vulkan-intel
    echo -e "${GREEN}Intel Graphics Driver uninstalled successfully.${NC}"
}

uninstall_nvidia_driver() {
    echo -e "${BLUE}Uninstalling Nvidia Graphics Driver...${NC}"
    yay -Rns nvidia-470xx nvidia-470xx-utils nvidia-470xx-settings
    echo -e "${GREEN}Nvidia Graphics Driver uninstalled successfully.${NC}"
}

uninstall_amd_driver() {
    echo -e "${BLUE}Uninstalling AMD Graphics Driver...${NC}"
    sudo pacman -Rns xf86-video-amdgpu vulkan-radeon libva-mesa-driver mesa
    echo -e "${GREEN}AMD Graphics Driver uninstalled successfully.${NC}"
} 

# Main Menu
echo "Driver Manager Script"
echo "----------------------"
echo "1. Switch to Intel"
echo "2. Switch to AMD"
echo "3. Switch to NVIDIA"
echo "4. Exit"

read -p "Select an option (1-4): " option

case $option in
    1)
        echo "Switching to Intel..."
        uninstall_nvidia_driver
        uninstall_amd_driver
        install_intel_driver
        ;;
    2)
        echo "Switching to AMD..."
        uninstall_intel_driver
        uninstall_nvidia_driver
        install_amd_driver
        ;;
    3)
        echo "Switching to NVIDIA..."
        uninstall_intel_driver
        uninstall_amd_driver
        install_nvidia_driver
        ;;
    4)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid option. Exiting..."
        exit 1
        ;;
esac
