instancevpn() {
  if nmcli -t -f NAME,DEVICE con show --active | grep -q '^WireGuard:'; then
    nmcli con down WireGuard
  else
    nmcli con up WireGuard
  fi
}

record() {
  local output
  if [[ -n "$1" ]]; then
    output="$1"
  else
    output="$(date +%Y-%m-%d_%H-%M-%S)"
  fi
  gpu-screen-recorder -w portal -o "$HOME/Videos/${output}.mp4"
}
