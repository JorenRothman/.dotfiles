export ZELLIJ_AUTO_ATTACH=false
export ZELLIJ_AUTO_EXIT=true

# Only in a real terminal: GUI apps (VS Code, Electron) run `zsh -ilc` to read
# the env with no tty, which would otherwise spawn sessions + the desktop app.
if [[ -z "$ZELLIJ" && -t 0 && -t 1 ]]; then
    if [[ "$ZELLIJ_AUTO_ATTACH" == "true" ]]; then
        zellij attach -c
    else
        zellij
    fi

    if [[ "$ZELLIJ_AUTO_EXIT" == "true" ]]; then
        exit
    fi
fi
