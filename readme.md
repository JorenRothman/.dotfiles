# Dotfiles

Some basic dot files

## Installation

```bash
./install
```

### ZSH

Install [zimfw](https://zimfw.sh/)

Add this to .zshrc

```zsh
for conf in "$HOME/.config/zsh/config.d/"*.zsh; do
  source "${conf}"
done

unset conf
```

### Oh my posh

Install [oh my posh](https://ohmyposh.dev/)

Add this to .zshrc

```zsh
eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/config.omp.json)"
```
