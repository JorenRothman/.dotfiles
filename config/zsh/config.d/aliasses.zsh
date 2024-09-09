# Open configs with vscode
alias dotfiles="code ~/.dotfiles ~/.zshrc"

# Brew
alias brewup='brew update; brew upgrade; brew cleanup; brew doctor'
alias brewdump='brew bundle dump --file ~/.dotfiles/BrewFile --force'
alias brewbundle='brew bundle install --file ~/.dotfiles/BrewFile'

# Git Flow Aliases
alias gf='git flow'
alias gff='git flow feature'
alias gfr='git flow release'
alias gfh='git flow hotfix'
alias gfb='git flow bugfix'

# Brew Services
alias bsl='brew services list'
alias bss='brew services start'
alias bsp='brew services stop'

# Git
alias git-latest-tag='git describe --tags --abbrev=0'
alias git-remove-local-branches='git branch -D `git branch | grep -v \* | xargs`'

# SSH
alias copy-ssh-key='pbcopy < ~/.ssh/id_ed25519.pub'

# Utils
alias localip='ipconfig getifaddr en0'
alias diskspace="ncdu -x /"
alias speedtest="open https://fast.com/"

# Function to create pbcopy alias based on the OS
setup_pbcopy_alias() {
    case "$(uname)" in
    "Darwin")
        # macOS uses pbcopy by default
        alias pbcopy='pbcopy'
        alias pbpaste='pbpaste'
        ;;
    "Linux")
        # Check if xclip or xsel is installed and create pbcopy alias
        if command -v xclip >/dev/null 2>&1; then
            alias pbcopy='xclip -selection clipboard'
            alias pbpaste='xclip -selection clipboard -o'
        elif command -v xsel >/dev/null 2>&1; then
            alias pbcopy='xsel --clipboard --input'
            alias pbpaste='xsel --clipboard --output'
        else
            echo "Please install xclip or xsel to use pbcopy on Linux."
        fi
        ;;
    *)
        echo "Unsupported OS: $(uname)"
        ;;
    esac
}

# Call the function to set up the alias
setup_pbcopy_alias

# WordPress
alias acf-env="echo ACF_PRO_KEY=$ACF_PRO_KEY > .env"

# Docker
alias docker-clean="docker system prune -a"

# Secrets
alias create-secret-base-64="openssl rand -base64 32"
alias create-secret-hex="openssl rand -hex 32"
