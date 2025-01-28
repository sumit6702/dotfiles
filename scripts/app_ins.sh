#!/bin/bash

declare -a offical_packages=(
  "sptotify"
  "discord"
  "telegram-desktop"
  "thunar"
  "nwg-displays"
  "qbittorrent"
  "yazi"
  "fzf"
  "starship"
  "eza"
  "neovim"
  "nodejs"
  "ttf-jetbrains-mono-nerd"
  "qbittorrent"
  "jdk21-openjdk"
)

declare -a aur_packages=(
  "onlyoffice-bin"
  "nvm"
  "zen-browser-bin"
  "materialgram-bin"
  "visual-studio-code-bin"
  "stremio"
)

# Check if packages are already installed
for package in "${offical_packages[@]}"
do
  if ! pacman -Qi $package &> /dev/null; then
    sudo pacman -S $package
  fi
done

for package in "${aur_packages[@]}"
do
  if ! pacman -Qi $package &> /dev/null; then
    yay -S $package
  fi
done
