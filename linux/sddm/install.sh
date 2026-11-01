#!/usr/bin/env bash
# Builds the SDDM theme from the lock screen's files. Run with sudo to install it, or
# pass a directory to build there instead. Doesn't change which theme SDDM uses.
set -euo pipefail

dest=${1:-/usr/share/sddm/themes/quickshell-login}
here=$(cd "$(dirname "$0")" && pwd)
login=$here/../quickshell-login

rm -rf "$dest"
mkdir -p "$dest"
cp "$here/Main.qml" "$here/metadata.desktop" "$here/qmldir" "$login/LoginScreen.qml" "$dest/"
cp -L "$login/wallpaper.jpg" "$dest/"
# SDDM has no Quickshell, so the bar's theme becomes a plain singleton
sed -e '/^import Quickshell$/d' -e 's/^Singleton {/QtObject {/' "$here/../quickshell/Theme.qml" > "$dest/Theme.qml"
chmod -R a+rX "$dest"

cat <<EOF
Built $dest
Switch to it:  sudo sed -i 's/^Current=.*/Current=quickshell-login/' /etc/sddm.conf
Switch back:   sudo sed -i 's/^Current=.*/Current=catppuccin-macchiato/' /etc/sddm.conf
EOF
