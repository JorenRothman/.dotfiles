#!/usr/bin/env bash
set -euo pipefail

# CachyOS Hyprland extra packages
# Base Hyprland environment (hyprland, hyprlock, hyprpaper, swayidle, etc.)
# is provided by CachyOS. Only extras are listed here.

PACMAN_PACKAGES=(
    # Desktop shell (bar, notifications)
    quickshell

    # Terminal & shell
    ghostty
    zoxide
    starship
    btop
    fzf
    jq
    ncdu
    duperemove

    # Dotfiles secrets (SSH keys, git-crypt)
    git-crypt
    bitwarden-cli

    # Containers
    docker

    # Audio
    pamixer
    playerctl
    easyeffects
    pavucontrol
    alsa-utils

    # Idle & lock
    swayidle

    # Clipboard & screenshots
    wl-clipboard
    swappy

    # Display & brightness
    brightnessctl

    # Wayland overlay bar (volume indicator)
    wob

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

    # XEmbed tray icons (Wine/Proton) for the quickshell tray
    xembedsniproxy

    # git flow (gf* aliases)
    gitflow-cjs
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
