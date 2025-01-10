#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root"
    exit 1
fi

echo "Starting driver switch process..."

# Remove NVIDIA packages including 470xx drivers
echo "Removing NVIDIA packages..."
pacman -Rns --noconfirm \
    nvidia nvidia-utils nvidia-settings nvidia-prime \
    nvidia-dkms nvidia-hook libvdpau nvidia-open nvidia-open-dkms \
    nvidia-470xx-utils nvidia-470xx nvidia-470xx-dkms 2>/dev/null || true

# Check and remove from AUR if installed
if command -v yay &>/dev/null; then
    echo "Removing AUR NVIDIA packages..."
    yay -Rns --noconfirm nvidia-470xx-utils-beta nvidia-470xx-beta 2>/dev/null || true
elif command -v paru &>/dev/null; then
    echo "Removing AUR NVIDIA packages..."
    paru -Rns --noconfirm nvidia-470xx-utils-beta nvidia-470xx-beta 2>/dev/null || true
fi

# Clean any remaining NVIDIA configuration
echo "Cleaning NVIDIA configurations..."
rm -f /etc/X11/xorg.conf
rm -f /etc/X11/xorg.conf.d/*nvidia*
rm -f /etc/modprobe.d/*nvidia*

# Install Intel drivers and utilities
echo "Installing Intel drivers and utilities..."
pacman -S --needed --noconfirm \
    xf86-video-intel \
    intel-ucode \
    mesa \
    lib32-mesa \
    vulkan-intel \
    lib32-vulkan-intel \
    libva-intel-driver \
    libvdpau-va-gl

# Update initramfs
echo "Updating initramfs..."
mkinitcpio -P

# Create Intel configuration
echo "Creating Intel graphics configuration..."
cat > /etc/X11/xorg.conf.d/20-intel.conf << EOF
Section "Device"
    Identifier  "Intel Graphics"
    Driver      "intel"
    Option      "TearFree" "true"
    Option      "DRI" "3"
EndSection
EOF

# Check for and blacklist NVIDIA modules if needed
echo "Checking for and blacklisting NVIDIA modules..."
if [ ! -f /etc/modprobe.d/blacklist-nvidia.conf ]; then
    cat > /etc/modprobe.d/blacklist-nvidia.conf << EOF
blacklist nvidia
blacklist nvidia_drm
blacklist nvidia_uvm
blacklist nvidia_modeset
blacklist nvidia_470xx
blacklist nvidia_470xx_drm
blacklist nvidia_470xx_modeset
EOF
fi

echo "Driver switch completed. Please reboot your system."
echo "After reboot, verify the driver with: lspci -k | grep -A 2 'VGA'"
