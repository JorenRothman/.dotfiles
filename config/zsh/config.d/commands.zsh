alias deploy_dierenrecht_prod='ssh dierenrecht.nl -t "cd production; sh ./scripts/deploy-production.sh"'
alias deploy_dierenrecht_staging='ssh dierenrecht.instance.studio -t "cd dierenrecht; sh ./scripts/deploy-staging.sh"'
alias deploy_phion_prod='ssh phion.nl -t "cd phion; composer run-script deploy-production"'
alias secret_string='openssl rand -base64 32 | tee /dev/tty | pbcopy'

instancevpn() {
  if nmcli -t -f NAME,DEVICE con show --active | grep -q '^WireGuard:'; then
    nmcli con down WireGuard
  else
    nmcli con up WireGuard
  fi
}

gsr() {
  local output
  if [[ -n "$1" ]]; then
    output="$1"
  else
    output="$(date +%Y-%m-%d_%H-%M-%S)"
  fi
  gpu-screen-recorder -w portal -o "$HOME/Videos/${output}.mp4"
}
