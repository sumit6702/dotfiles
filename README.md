# 🌟 My Cozy Arch Linux KittyDOTS

Welcome to my personal dotfiles collection! These configurations have been carefully crafted to create a comfortable and efficient Arch Linux environment, built on top of the amazing [HyprDots](https://github.com/prasanthrangan/hyprdots) foundation. Feel free to explore and use anything that catches your eye! ✨

## 🎨 Base Configuration - HyprDots

This configuration uses [HyprDots](https://github.com/prasanthrangan/hyprdots) as its foundation, which provides:

- **Hyprland** - A dynamic tiling Wayland compositor
- **Waybar** - Highly customizable status bar
- **Rofi** - Application launcher and menu system
- **Dunst** - Lightweight notification daemon
- **Swaylock** - Screen locker for Wayland
- **Wlogout** - Logout menu for Wayland

## 🐱 KittyDOTS Customizations

On top of HyprDots, I've added my personal configurations for:

- **Hyprland** - Custom keybindings and window rules
- **Kitty** - The snappiest terminal emulator around
- **Neovim** - Because life's too short for nano
- **Yazi** - Modern terminal-based file manager
- **Fish** - Modern and user-friendly shell
- **MPV** - High-performance media player
- **Custom Scripts** - Quality of life improvements

## 🚀 Installation

1. First, install HyprDots following their [official installation guide](https://github.com/prasanthrangan/hyprdots#installation)

2. Then, clone and install KittyDOTS:

```bash
git clone https://github.com/yourusername/dotfiles.git ~/.KittyDOTS
cd ~/.KittyDOTS
./install.sh
```

The install script will symlink everything to its proper location, carefully merging with HyprDots configurations. Don't worry - it'll backup your existing configs first!

## 📦 Additional Dependencies

Beyond HyprDots requirements, you'll need:

```bash
yay -S kitty fish neovim yazi mpv fzf nerd-fonts-complete
```

## ⚙️ Post-Install Setup

1. Switch to Fish shell: `chsh -s /usr/bin/fish`
2. Set up Neovim plugins: `nvim +PackerSync`
3. Log out and back in
4. Enjoy your new setup!

## 🎵 Key Bindings

### System Controls

- **Super + T** - Open Kitty terminal
- **Super + Space** - Launch Rofi
- **Super + Shift + Q** - Close window
- **Super + [1-9]** - Switch workspaces

### Custom KittyDOTS Bindings

- **Super + Y** - Launch Yazi file manager
- **Super + V** - Launch Neovim
- **Super + M** - Launch MPV
- **Super + Shift + S** - Quick screenshot

## 🌈 Color Scheme

Building on HyprDots' theming system, I use a custom night-inspired palette:

```
background: #1a1b26
foreground: #c0caf5
accent:     #bb9af7
urgent:     #f7768e
```

## 📸 Screenshots

Place your screenshots here to show off your setup!

## 💝 Credits

Special thanks to:

- [HyprDots](https://github.com/prasanthrangan/hyprdots) team for the amazing base configuration
- The Arch Linux community
- r/unixporn for inspiration
- All the awesome tool maintainers

## 🔧 Troubleshooting

Having issues? Check these common fixes:

1. Ensure HyprDots is properly installed
2. Make sure all additional dependencies are installed
3. Verify KittyDOTS symlinks are correct
4. Check Hyprland logs: `~/.local/share/hyprland/hyprland.log`

---

Made with 💜 and too much coffee
