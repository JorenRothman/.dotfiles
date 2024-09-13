# Function to check TERM and SSH with appropriate TERM value
ssh_dynamic_term() {
    local host="$1"
    shift

    local term_to_use="wezterm"

    # Check if wezterm terminfo exists on the remote host
    if ! /usr/bin/ssh -q "$host" 'infocmp wezterm > /dev/null 2>&1'; then
        term_to_use="xterm-256color"
    fi

    # Use the determined TERM
    env TERM="$term_to_use" /usr/bin/ssh "$host" "$@"
}

# Alias to use the function
alias ssh='ssh_dynamic_term'

# Enable autocompletion for the ssh_dynamic_term function
compdef ssh_dynamic_term=ssh
