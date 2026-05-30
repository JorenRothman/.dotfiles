# Function to create pbcopy alias based on the OS
setup_pbcopy_alias() {
    # Check if xclip or xsel is installed and create pbcopy alias
    if command -v xclip >/dev/null 2>&1; then
        alias pbcopy='xclip -selection clipboard'
        alias pbpaste='xclip -selection clipboard -o'
    elif command -v wl-copy >/dev/null 2>&1; then
        alias pbcopy='wl-copy'
        alias pbpaste='wl-paste'
    else
        echo "Please install xclip or wl-copy to use pbcopy on Linux."
    fi
}

# Call the function to set up the alias
setup_pbcopy_alias
