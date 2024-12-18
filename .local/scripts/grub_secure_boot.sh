#!/bin/bash

# Secure Boot Setup Script for GRUB
# WARNING: Run this script with caution and understand each step
# Note: This script is designed primarily for Arch Linux systems

# Color codes for formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Error handling function
error_exit() {
    echo -e "${RED}Error: $1${NC}" >&2
    exit 1
}

# Warn function
warn() {
    echo -e "${YELLOW}Warning: $1${NC}" >&2
}

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
   error_exit "This script must be run as root. Use sudo."
fi

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Prerequisite checks
prereq_check() {
    echo "Checking prerequisites..."
    
    # Check for required tools
    local required_tools=("grub-install" "grub-mkconfig" "sbctl")
    for tool in "${required_tools[@]}"; do
        if ! command_exists "$tool"; then
            error_exit "$tool is not installed. Please install it first."
        fi
    done
}

# Get EFI system partition
get_efi_partition() {
    local efi_partitions
    efi_partitions=$(lsblk -f | grep 'vfat' | grep 'FAT32' | awk '{print $1}')
    
    if [[ -z "$efi_partitions" ]]; then
        error_exit "No EFI system partition found. Please check your disk configuration."
    fi
    
    if [[ $(echo "$efi_partitions" | wc -l) -gt 1 ]]; then
        echo "Multiple EFI partitions found:"
        echo "$efi_partitions"
        read -rp "Enter the EFI partition you want to use (e.g., nvme0n1p1): " chosen_partition
        EFI_PARTITION="/dev/$chosen_partition"
    else
        EFI_PARTITION="/dev/$(echo "$efi_partitions" | head -n1)"
    fi
    
    # Ensure EFI partition is mounted
    mkdir -p /boot/efi
    mount "$EFI_PARTITION" /boot/efi 2>/dev/null
}

# Main secure boot setup function
secure_boot_setup() {
    # Prerequisite check
    prereq_check
    
    # Get EFI partition
    get_efi_partition
    
    # Reinstall GRUB with TPM and without shim
    echo "Reinstalling GRUB..."
    grub-install --target=x86_64-efi \
                 --efi-directory=/boot/efi \
                 --bootloader-id=GRUB \
                 --modules="tpm" \
                 --disable-shim-lock || error_exit "GRUB installation failed"
    
    # Regenerate GRUB configuration
    echo "Regenerating GRUB configuration..."
    grub-mkconfig -o /boot/grub/grub.cfg || warn "GRUB configuration regeneration failed"
    
    # Check Secure Boot status
    echo "Checking Secure Boot status..."
    local sb_status
    sb_status=$(sbctl status)
    echo "$sb_status"
    
    if [[ "$sb_status" != *"Setup Mode"* ]]; then
        warn "Your system is not in Setup Mode. Please reboot and enter UEFI settings to set up Setup Mode."
        read -rp "Do you want to continue anyway? (y/n): " continue_anyway
        [[ "$continue_anyway" != "y" ]] && exit 1
    fi
    
    # Create custom Secure Boot keys
    echo "Creating custom Secure Boot keys..."
    sbctl create-keys || error_exit "Failed to create Secure Boot keys"
    
    # Enroll keys (including Microsoft CA certificates)
    echo "Enrolling keys..."
    sbctl enroll-keys -m || error_exit "Failed to enroll keys"
    
    # Verify which files need signing
    echo "Checking files that need signing..."
    local unsigned_files
    unsigned_files=$(sbctl verify)
    echo "$unsigned_files"
    
    # Signing files
    echo "Signing required files..."
    # Customize this section based on your specific unsigned files
    sign_files() {
        local files_to_sign=(
            "/boot/efi/EFI/GRUB/grubx64.efi"
            # Add other files that need signing
        )
        
        for file in "${files_to_sign[@]}"; do
            if [[ -f "$file" ]]; then
                # Remove immutable attribute if present
                chattr -i "$file" 2>/dev/null
                
                # Sign the file
                sbctl sign -s "$file" || warn "Failed to sign $file"
            fi
        done
    }
    sign_files
    
    # Final verification
    echo "Final verification:"
    sbctl verify
    
    echo -e "${GREEN}Secure Boot setup completed successfully!${NC}"
    echo "Next steps:"
    echo "1. Reboot your system"
    echo "2. Enable Secure Boot in UEFI settings"
    echo "3. Verify Secure Boot status after reboot"
}

# Run the main function
secure_boot_setup
