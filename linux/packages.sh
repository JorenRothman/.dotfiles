#!/usr/bin/env bash
set -euo pipefail

# CachyOS Hyprland extra packages
# Base Hyprland environment (hyprland, waybar, hyprlock, hyprpaper, swayidle, etc.)
# is provided by CachyOS. Only extras are listed here.

PACMAN_PACKAGES=(
    # Wayland bar
    waybar

    # Terminal & shell
    ghostty
    zoxide
    starship
    btop

    # Audio
    pamixer
    playerctl
    easyeffects
    pavucontrol

    # Clipboard & screenshots
    wl-clipboard
    swappy

    # Notifications
    mako

    # Display & brightness
    brightnessctl

    # Wayland overlay bar (volume indicator)
    wob

    # Input method
    fcitx5
    fcitx5-im
    fcitx5-gtk
    fcitx5-qt

    # Network manager tray
    network-manager-applet

    # Qt theming
    qt6ct

    # Polkit agent
    polkit-kde-agent

    # Fonts
    ttf-firacode-nerd
)

YAY_PACKAGES=(
    # App launcher
    vicinae-bin

    # Screenshot tool
    hyprshot

    # Shader/filter overlay
    hyprshade

    # Browser
    brave-bin

    # Editor
    vscodium-bin

    # Screen recorder
    gpu-screen-recorder

    # LS_COLORS generator
    vivid

    # Lock screen (config present)
    betterlockscreen
)

install_pacman() {
    echo "==> Installing pacman packages..."
    sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}"
}

install_yay() {
    if ! command -v yay &>/dev/null; then
        echo "==> yay not found, skipping AUR packages"
        return
    fi
    echo "==> Installing AUR packages..."
    yay -S --needed --noconfirm "${YAY_PACKAGES[@]}"
}

install_pacman
install_yay

echo "==> Done"
