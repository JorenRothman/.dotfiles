#!/bin/bash
NOTES_FILE="$HOME/.config/waybar/notes/notes.txt"

if [[ -f "$NOTES_FILE" ]]; then
    awk '{printf "%s\n", $0}' "$NOTES_FILE"
else
    echo "No notes"
fi
