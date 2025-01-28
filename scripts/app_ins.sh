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
)

declare -a aur_packages=(
  "onlyoffice-bin"
  "nvm"
  "zen-browser-bin"
  "materialgram-bin"
  " visual-studio-code-bin"
)


for package in "${offical_packages[@]}"
do
  sudo pacman -S $package
done

for package in "${aur_packages[@]}"
do
  yay -S $package
done