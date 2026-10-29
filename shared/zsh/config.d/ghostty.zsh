# Ghostty only injects its shell integration into shells it spawns directly,
# so load it here too for shells inside zellij (enables the ssh terminfo wrapper).
if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
  source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
fi
