# Check if the Java plugin set-java-home file exists before sourcing
if [[ -f "${ASDF_DATA_DIR:-$HOME/.asdf}/plugins/java/set-java-home.zsh" ]]; then
  source "${ASDF_DATA_DIR:-$HOME/.asdf}/plugins/java/set-java-home.zsh"
fi

# Add asdf shims to PATH
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# Add asdf completions to fpath
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
