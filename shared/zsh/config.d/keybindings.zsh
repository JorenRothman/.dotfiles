# Word-wise navigation with Ctrl+Arrow (shared across mac + linux)
# Bind the common terminal escape sequences. If a key still does nothing,
# run `cat -v`, press the key, and add the printed sequence here.

# xterm / alacritty / ghostty / kitty / iTerm2
bindkey '^[[1;5C' forward-word    # Ctrl+Right
bindkey '^[[1;5D' backward-word   # Ctrl+Left

# Alt+Arrow word movement (macOS Terminal default, also handy on Linux)
bindkey '^[[1;3C' forward-word    # Alt+Right
bindkey '^[[1;3D' backward-word   # Alt+Left
bindkey '^[^[[C'  forward-word    # Alt+Right (alt sends ESC prefix)
bindkey '^[^[[D'  backward-word   # Alt+Left
