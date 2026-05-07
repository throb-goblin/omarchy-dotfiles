#!/bin/bash
# Run once on your current machine to move configs into dotfiles and stow them.
set -e

DOTFILES="$HOME/dotfiles"

move() {
    local src="$1"
    local dest="$DOTFILES/$2"
    mkdir -p "$(dirname "$dest")"
    if [ -e "$src" ] && [ ! -L "$src" ]; then
        mv "$src" "$dest"
        echo "Moved: $src"
    else
        echo "Skipped (missing or already a symlink): $src"
    fi
}

# Hyprland
move ~/.config/hypr/bindings.conf         hypr/.config/hypr/bindings.conf
move ~/.config/hypr/hyprland.conf         hypr/.config/hypr/hyprland.conf
move ~/.config/hypr/hyprlock.conf         hypr/.config/hypr/hyprlock.conf
move ~/.config/hypr/hypridle.conf         hypr/.config/hypr/hypridle.conf
move ~/.config/hypr/hyprsunset.conf       hypr/.config/hypr/hyprsunset.conf
move ~/.config/hypr/monitors.conf         hypr/.config/hypr/monitors.conf
move ~/.config/hypr/input.conf            hypr/.config/hypr/input.conf
move ~/.config/hypr/autostart.conf        hypr/.config/hypr/autostart.conf
move ~/.config/hypr/envs.conf             hypr/.config/hypr/envs.conf
move ~/.config/hypr/looknfeel.conf        hypr/.config/hypr/looknfeel.conf
move ~/.config/hypr/xdph.conf             hypr/.config/hypr/xdph.conf

# Waybar
move ~/.config/waybar/config.jsonc        waybar/.config/waybar/config.jsonc
move ~/.config/waybar/style.css           waybar/.config/waybar/style.css

# Omarchy theme
move ~/.config/omarchy/themes/gooner-red   omarchy-theme/.config/omarchy/themes/gooner-red

# Mimeapps (default browser + app associations)
move ~/.config/mimeapps.list              mimeapps/.config/mimeapps.list

# Custom desktop entries
for entry in \
    "Calculator (NaSC).desktop" \
    "Claude AI.desktop" \
    "claude-terminal.desktop" \
    "ChatGPT.desktop" \
    "Copilot.desktop" \
    "GitHub.desktop" \
    "Gmail.desktop" \
    "Google Calendar.desktop" \
    "Google Contacts.desktop" \
    "Google Messages.desktop" \
    "Google Photos.desktop" \
    "WhatsApp.desktop" \
    "YouTube.desktop"; do
    move ~/.local/share/applications/"$entry" apps/.local/share/applications/"$entry"
done

# Icons
if [ -d ~/.local/share/applications/icons ]; then
    cp -r ~/.local/share/applications/icons/. "$DOTFILES/icons/.local/share/applications/icons/"
    echo "Copied icons"
fi

# Scripts
move ~/.local/bin/claude-terminal         scripts/.local/bin/claude-terminal
move ~/.local/bin/osk-toggle              scripts/.local/bin/osk-toggle

# Git
move ~/.config/git/config                 git/.config/git/config

# Cava
move ~/.config/cava/config                cava/.config/cava/config

# Mise
move ~/.config/mise/config.toml           mise/.config/mise/config.toml

# Lazygit
move ~/.config/lazygit/config.yml         lazygit/.config/lazygit/config.yml

# LibreOffice
move ~/.config/libreoffice/4/user/registrymodifications.xcu \
    libreoffice/.config/libreoffice/4/user/registrymodifications.xcu

# User font
move ~/.local/share/fonts/omarchy.ttf     fonts/.local/share/fonts/omarchy.ttf

# Plymouth theme files
echo "Copying Plymouth theme..."
sudo cp /usr/share/plymouth/themes/omarchy-red/*.png "$DOTFILES/plymouth/omarchy-red/"
sudo cp /usr/share/plymouth/themes/omarchy-red/omarchy-red.plymouth "$DOTFILES/plymouth/omarchy-red/"
sudo cp /usr/share/plymouth/themes/omarchy-red/omarchy.script "$DOTFILES/plymouth/omarchy-red/"

# Microsoft fonts
echo "Copying Microsoft fonts..."
cp /usr/share/fonts/Microsoft/* "$DOTFILES/msfonts/Microsoft/"

# Stow everything
echo ""
echo "Stowing packages..."
cd "$DOTFILES"
for pkg in hypr waybar omarchy-theme mimeapps apps icons scripts git cava mise lazygit libreoffice fonts; do
    stow "$pkg" && echo "Stowed: $pkg" || echo "Failed: $pkg"
done

echo ""
echo "Done. Push to GitHub to back up."