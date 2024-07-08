if [[ "$(uname)" == "Linux" ]]; then
    source ~/.dotfiles/zshrc-linux
fi

if [[ "$(uname)" == "Darwin" ]]; then
    source ~/.dotfiles/zshrc-mac
fi
