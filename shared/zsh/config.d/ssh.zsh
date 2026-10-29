# zsh's _ssh_hosts only falls back to ~/.ssh/config when nothing in known_hosts
# or /etc/hosts matched the prefix first, so config aliases stay hidden most of
# the time. Feed them to the completion system explicitly instead.
# Setting the hosts style replaces zsh's default list entirely, so known_hosts
# entries are added back here too.
_ssh_config_hosts() {
    emulate -L zsh
    setopt extendedglob

    local f line pat
    local -a files hosts
    local -A seen

    # Walk ~/.ssh/config and every file it pulls in via Include
    files=( $HOME/.ssh/config )
    while (( $#files )); do
        f=$files[1]
        shift files
        [[ -r $f && -z $seen[$f] ]] || continue
        seen[$f]=1

        for line in ${(f)"$(<$f)"}; do
            if [[ $line == [[:space:]]#(#i)include[[:space:]]* ]]; then
                for pat in ${=${line##[[:space:]]#(#i)include[[:space:]]#}}; do
                    pat=${pat/#\~/$HOME}
                    [[ $pat == /* ]] || pat=$HOME/.ssh/$pat
                    files+=( ${~pat}(N-.) )
                done
            elif [[ $line == [[:space:]]#(#i)host[[:space:]]* ]]; then
                hosts+=( ${=${line##[[:space:]]#(#i)host[[:space:]]#}} )
            fi
        done
    done

    # Unhashed known_hosts entries; "[host]:port" becomes "host"
    if [[ -r $HOME/.ssh/known_hosts ]]; then
        for line in ${(f)"$(<$HOME/.ssh/known_hosts)"}; do
            [[ $line == ('#'|'@'|'|')* ]] && continue
            hosts+=( ${(s:,:)${line%% *}} )
        done
        hosts=( ${hosts/(#b)\[(*)\]:<->/$match[1]} )
    fi

    reply=( ${(u)${hosts:#*[*?!]*}} )
}
zstyle -e ':completion:*:(ssh|scp|sftp|rsync):*' hosts '_ssh_config_hosts'
