#!/usr/bin/env bash
# Flameshot on Wayland can't capture the active monitor itself; it shows a
# monitor picker instead. Answer the picker with the focused monitor's number.
set -euo pipefail

key=$(( $(hyprctl monitors -j | jq '.[] | select(.focused) | .id') + 1 ))

flameshot gui "$@" &

for _ in $(seq 50); do
    if hyprctl clients -j | jq -e '.[] | select(.class == "flameshot")' >/dev/null; then
        hyprctl dispatch "hl.dsp.send_shortcut({ mods = \"\", key = \"$key\", window = \"class:flameshot\" })" >/dev/null
        break
    fi
    sleep 0.05
done

wait
