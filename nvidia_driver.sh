#!/bin/bash

# Exit on any error
set -e

echo "Starting NVIDIA driver installation for GT 710..."

# Function to check for sudo privileges
check_sudo() {
    if [ "$EUID" -eq 0 ]; then
        echo "Please don't run this script as root directly. Use: sudo ./install-nvidia.sh"
        exit 1
    fi
    
    if ! sudo -v; then
        echo "This script requires sudo privileges"
        exit 1
    fi
}

# Function to backup configuration files
backup_config() {
    local file=$1
    if [ -f "$file" ]; then
        sudo cp "$file" "$file.backup.$(date +%Y%m%d_%H%M%S)"
        echo "Created backup of $file"
    fi
}

# Step 1: System Update and Prerequisites
step1() {
    echo "Step 1: Installing prerequisites..."
    sudo pacman -Syu --noconfirm
    sudo pacman -S --needed --noconfirm base-devel linux-headers git nano
    
    # Install yay if not present
    if ! command -v yay &> /dev/null; then
        echo "Installing yay..."
        cd /tmp
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd ..
        rm -rf yay
    fi
    
    # Enable multilib repository
    if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
        echo "Enabling multilib repository..."
        echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf > /dev/null
        sudo pacman -Sy
    fi
}

# Step 2: Install NVIDIA Drivers
step2() {
    echo "Step 2: Installing NVIDIA drivers..."
    yay -S --noconfirm nvidia-470xx-dkms nvidia-470xx-utils lib32-nvidia-470xx-utils nvidia-settings
}

# Step 3: Configure DRM kernel mode setting
step3() {
    echo "Step 3: Configuring DRM kernel mode setting..."
    
    # Configure GRUB
    if [ -f "/etc/default/grub" ]; then
        backup_config "/etc/default/grub"
        if grep -q "^GRUB_CMDLINE_LINUX_DEFAULT=" /etc/default/grub; then
            # Check kernel version for fbdev parameter requirement
            if uname -r | grep -q "^6.11"; then
                sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="\([^"]*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 nvidia-drm.modeset=1 nvidia-drm.fbdev=1"/' /etc/default/grub
            else
                sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="\([^"]*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 nvidia-drm.modeset=1"/' /etc/default/grub
            fi
            sudo grub-mkconfig -o /boot/grub/grub.cfg
        fi
    fi
    
    # Configure mkinitcpio
    backup_config "/etc/mkinitcpio.conf"
    
    # Update MODULES line
    sudo sed -i 's/^MODULES=.*/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
    
    # Carefully handle the HOOKS line - preserve existing hooks while removing kms if present
    if grep -q '^HOOKS=' /etc/mkinitcpio.conf; then
        # Get current HOOKS line
        CURRENT_HOOKS=$(grep '^HOOKS=' /etc/mkinitcpio.conf)
        # Remove 'kms' from hooks if present, maintaining the rest of the configuration
        NEW_HOOKS=$(echo "$CURRENT_HOOKS" | sed 's/\(HOOKS=([^)]*\)kms\([^)]*)\)/\1\2/' | sed 's/  / /g')
        if [ "$CURRENT_HOOKS" != "$NEW_HOOKS" ]; then
            sudo sed -i "s|^HOOKS=.*|$NEW_HOOKS|" /etc/mkinitcpio.conf
        fi
    else
        # If no HOOKS line exists, add a default one
        echo 'HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)' | sudo tee -a /etc/mkinitcpio.conf
    fi
    
    # Create and configure nvidia hook
    sudo mkdir -p /etc/pacman.d/hooks
    sudo tee /etc/pacman.d/hooks/nvidia.hook > /dev/null << 'EOL'
[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
Target=nvidia-470xx-dkms
Target=linux

[Action]
Description=Update NVIDIA module in initcpio
Depends=mkinitcpio
When=PostTransaction
NeedsTargets
Exec=/bin/sh -c 'while read -r trg; do case $trg in linux) exit 0; esac; done; /usr/bin/mkinitcpio -P'
EOL
    
    # Regenerate initramfs
    sudo mkinitcpio -P
}

# Main installation process
main() {
    check_sudo
    step1
    step2
    step3
    echo "Installation complete! Please reboot your system."
}

# Run the installation
main
