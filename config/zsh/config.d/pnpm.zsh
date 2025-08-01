if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # pnpm
    export PNPM_HOME="/home/joren/.local/share/pnpm"
    case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
    esac
# pnpm end
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    # pnpm
    export PNPM_HOME="/Users/joren/Library/pnpm"
    case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
    esac
    # pnpm end
fi

###-begin-pnpm-completion-###
if type compdef &>/dev/null; then
    _pnpm_completion() {
        local reply
        local si=$IFS

        IFS=$'\n' reply=($(COMP_CWORD="$((CURRENT - 1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" SHELL=zsh pnpm completion-server -- "${words[@]}"))
        IFS=$si

        if [ "$reply" = "__tabtab_complete_files__" ]; then
            _files
        else
            _describe 'values' reply
        fi
    }
    compdef _pnpm_completion pnpm
fi
###-end-pnpm-completion-###
