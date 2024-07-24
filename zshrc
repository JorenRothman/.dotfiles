if [[ "$(uname)" == "Linux" ]]; then
    source ~/.dotfiles/zshrc-linux
fi

if [[ "$(uname)" == "Darwin" ]]; then
    source ~/.dotfiles/zshrc-mac
fi

# Created by `pipx` on 2024-07-22 12:38:39
export PATH="$PATH:/Users/joren/.local/bin"
