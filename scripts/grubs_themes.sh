deps=(fzf git curl)
for dep in "${deps[@]}"; do
  if ! command -v $dep &> /dev/null; then
    echo "Error: $dep is not installed"
    exit 1
  fi
done

TEMP_DIR="/tmp/grubs_themes_preview"
mkdir -p $TEMP_DIR

declare -A theme_data=(
    ["minegrub-theme"]="A Minecraft-inspired GRUB theme|https://raw.githubusercontent.com/Lxtharia/minegrub-theme/master/screenshot.png|https://github.com/Lxtharia/minegrub-theme.git"
    ["sekiro_grub_theme"]="Sekiro-inspired GRUB theme|https://raw.githubusercontent.com/semimqmo/sekiro_grub_theme/master/preview.png|https://github.com/semimqmo/sekiro_grub_theme.git"
    ["patato-grub"]="Minimalist GRUB theme|https://raw.githubusercontent.com/Patato777/dotfiles/main/grub/preview.png|https://github.com/Patato777/dotfiles/tree/main/grub"
    ["Elegant-grub2-themes"]="Elegant GRUB2 themes collection|https://raw.githubusercontent.com/vinceliuice/Elegant-grub2-themes/master/preview.png|https://github.com/vinceliuice/Elegant-grub2-themes.git"
    ["Cyberpunk-GRUB-Theme"]="Cyberpunk-styled GRUB theme|https://raw.githubusercontent.com/NayamAmarshe/Cyberpunk-GRUB-Theme/master/preview.png|https://github.com/NayamAmarshe/Cyberpunk-GRUB-Theme.git"
    ["catppuccin-grub"]="Catppuccin color scheme GRUB theme|https://raw.githubusercontent.com/catppuccin/grub/main/assets/preview.png|https://github.com/catppuccin/grub.git"
    ["rose-pine-grub"]="Rosé Pine GRUB theme|https://raw.githubusercontent.com/rose-pine/grub/main/assets/preview.png|https://github.com/rose-pine/grub.git"
)

download_preview() {
    local theme_name=$1
    IFS='|' read -r -a theme_data <<< "${theme_data[$theme_name]}"
    echo "Downloading preview image for $theme_name..."

    sudo cp -r /etc/default/grub /etc/default/grub.bak

    git clone ${theme_data[2]} $TEMP_DIR/$theme_name
    cd $TEMP_DIR/$theme_name
    sudo cp -r * /boot/grub/themes/

    echo "Theme installed successfully!"
    echo "Don't forget to update your GRUB configuration file and run 'sudo grub-mkconfig -o /boot/grub/grub.cfg'"
}

download_preview

theme_list=""
for theme_name in "${!theme_data[@]}"; do
    IFS='|' read -r description preview_url repo_url <<< "${theme_data[$theme_name]}"
    theme_list+="$theme_name - $description\n"
done

selected=$(echo -e "$theme_list" | fzf \
    --preview "kitty +kitten icat --clear --transfer-mode=file --place=50x50@100x0 $TEMP_DIR/\$(echo {} | cut -d' ' -f1).png" \
    --preview-window=right:50%:wrap \
    --bind 'ctrl-p:toggle-preview' \
    --header 'Choose a GRUB theme (Ctrl+P to toggle preview)')

if [ -z "$selected" ]; then
    theme_name=$(echo $selected | cut -d' ' -f1)
    install_theme $theme_name
fi

rm -rf $TEMP_DIR