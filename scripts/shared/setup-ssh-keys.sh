#!/bin/bash

# Usage
# setup bw cli https://bitwarden.com/download/#downloads-command-line-interface
# bw login
# export BW_SESSION=$(bw unlock --raw)

# Function to fetch and set up SSH keys
fetch_and_setup_keys() {
    local private_key_note=$1
    local public_key_note=$2

    # Fetch the private key from Bitwarden
    bw get notes "$private_key_note" --session $BW_SESSION >~/.ssh/id_ed25519
    # Fetch the public key from Bitwarden
    bw get notes "$public_key_note" --session $BW_SESSION >~/.ssh/id_ed25519.pub

    # Set appropriate permissions
    chmod 600 ~/.ssh/id_ed25519
    chmod 644 ~/.ssh/id_ed25519.pub

    echo "SSH keys for $(uname) have been set up."
}

# Check if the SSH keys already exist
if [ -f "$HOME/.ssh/id_ed25519" ] && [ -f "$HOME/.ssh/id_ed25519.pub" ]; then
    echo "SSH keys already exist. Skipping setup."
    exit 0
fi

prompt_install_bw_cli() {
    echo "==============================================================================="
    echo "                           Bitwarden CLI Installation                         "
    echo "==============================================================================="
    echo "Bitwarden CLI is not installed or not found in your PATH."
    echo "Please install Bitwarden CLI to proceed with setting up the session."
    echo ""
    echo "You can install it using one of the following methods:"
    echo ""
    echo "1. Install using Homebrew (MacOS):"
    echo "   brew install bitwarden-cli"
    echo ""
    echo "3. Install manually:"
    echo "   Visit https://bitwarden.com/help/article/cli/ for installation instructions."
    echo ""
    echo "Once installed, please restart your terminal session and rerun this script."
    echo "==============================================================================="
    echo ""
}

# Check if Bitwarden CLI is installed
if ! command -v bw >/dev/null 2>&1; then
    prompt_install_bw_cli
    exit 0
fi

# Function to display a formatted message
prompt_login() {
    echo "==============================================================================="
    echo "                            Bitwarden Session Setup                            "
    echo "==============================================================================="
    echo "Please ensure you have logged in to Bitwarden and set the BW_SESSION variable."
    echo "If you haven't done so, please run the following commands:"
    echo ""
    echo "    bw login"
    echo "    export BW_SESSION=\$(bw unlock --raw)"
    echo ""
    echo "Once you have set the session, you can proceed with the script."
    echo "==============================================================================="
    echo ""
}

# Check if the Bitwarden session is set
if [ -z "$BW_SESSION" ]; then
    prompt_login
    exit 0
fi

# Ensure the SSH directory exists
if [ ! -d "$HOME/.ssh" ]; then
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
fi

# Determine the operating system and fetch the appropriate keys
case "$(uname)" in
"Linux")
    fetch_and_setup_keys "Linux Private SSH Key" "Linux Public SSH Key"
    ;;
"Darwin")
    fetch_and_setup_keys "Mac Private SSH Key" "Mac Public SSH Key"
    ;;
*)
    echo "Unsupported OS: $(uname)"
    exit 0
    ;;
esac
