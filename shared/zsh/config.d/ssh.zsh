# Function to check TERM and SSH with appropriate TERM value
ssh_dynamic_term() {
    local host="$1"
    shift

    local term_to_use="xterm-ghostty"

    # Check if xterm-ghostty terminfo exists on the remote host
    if ! /usr/bin/ssh -q "$host" 'infocmp xterm-ghostty > /dev/null 2>&1'; then
        term_to_use="xterm-256color"
    fi

    # Use the determined TERM
    env TERM="$term_to_use" /usr/bin/ssh "$host" "$@"
}

# Alias to use the function
alias ssh='ssh_dynamic_term'

# Enable autocompletion for the ssh_dynamic_term function
compdef ssh_dynamic_term=ssh

# zsh's _ssh_hosts only falls back to ~/.ssh/config when nothing in known_hosts
# or /etc/hosts matched the prefix first, so config aliases stay hidden most of
# the time. Feed them to the completion system explicitly instead.
_ssh_config_hosts() {
    emulate -L zsh
    setopt extendedglob

    [[ -r $HOME/.ssh/config ]] || return

    local -a lines
    lines=( ${(f)"$(<$HOME/.ssh/config)"} )
    reply=( ${${=${${(M)lines:#[[:space:]]#(#i)host[[:space:]]*}##[[:space:]]#(#i)host[[:space:]]#}}:#*[*?]*} )
}
zstyle -e ':completion:*:(ssh|scp|sftp|rsync|ssh_dynamic_term):*' hosts '_ssh_config_hosts'
