#!/bin/bash

# Arch Linux NVIDIA Driver Installation Script for GT 710

echo "Starting NVIDIA driver installation script for Arch Linux (GT 710)."

# Step 1: Installing required packages and enabling multilib
echo "Updating system..."
sudo pacman -Syu --noconfirm

echo "Installing required packages..."
sudo pacman -S base-devel linux-headers git nano --needed --noconfirm

echo "Installing AUR helper (yay)..."
cd ~
if [ ! -d "yay" ]; then
  git clone https://aur.archlinux.org/yay.git
fi
cd yay
makepkg -si --noconfirm

echo "Enabling multilib repository..."
sudo sed -i '/multilib/,/^$/s/^#//' /etc/pacman.conf
yay -Syu --noconfirm

# Step 2: Installing driver packages
DRIVER_BASE="nvidia-470xx-dkms"
OPENGL="nvidia-470xx-utils"
OPENGL_MULTILIB="lib32-nvidia-470xx-utils"

echo "Installing NVIDIA driver packages..."
yay -S --noconfirm $DRIVER_BASE $OPENGL $OPENGL_MULTILIB

echo "Installing NVIDIA settings..."
yay -S --noconfirm nvidia-settings

# Step 3: Enabling DRM kernel mode setting
echo "Configuring DRM kernel mode setting..."

# Detect if GRUB is installed
if [ -f /etc/default/grub ]; then
  echo "Editing GRUB configuration..."
  sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=".*"/\1 nvidia-drm.modeset=1"/' /etc/default/grub
  sudo grub-mkconfig -o /boot/grub/grub.cfg
else
  echo "GRUB not detected. Skipping GRUB configuration. Please configure your bootloader manually."
fi

echo "Adding early loading of NVIDIA modules..."
sudo sed -i 's/MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
sudo sed -i '/kms/d' /etc/mkinitcpio.conf
sudo mkinitcpio -P

echo "Adding pacman hook for NVIDIA driver updates..."
HOOK_PATH="/etc/pacman.d/hooks/"
HOOK_FILE="$HOOK_PATH/nvidia.hook"
sudo mkdir -p $HOOK_PATH

cat <<EOL | sudo tee $HOOK_FILE
[Trigger]
Operation = Install
Operation = Upgrade
Operation = Remove
Type = Package
Target = $DRIVER_BASE

[Action]
Description = Update NVIDIA module in initramfs
Depends = mkinitcpio
When = PostTransaction
Exec = /usr/bin/mkinitcpio -P
EOL

# Step 4: Reboot suggestion
echo "NVIDIA driver installation for GT 710 completed successfully."
echo "Please reboot your system to apply the changes."
