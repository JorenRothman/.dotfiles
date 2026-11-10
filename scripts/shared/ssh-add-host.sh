#!/usr/bin/env bash
# Add an SSH host to one of the categories in shared/ssh/config.d/,
# or create a new category (file + symlink into ~/.ssh/config.d).
#
# Usage:
#   ssh-add-host                                      # fully interactive
#   ssh-add-host <alias> <hostname> [user] [port]  # prompts only for category
#   ssh-add-host -c <category> <alias> <hostname> [user] [port]
#
# <category> matches a file by name with or without number prefix
# (e.g. "clients" or "20-clients"). Unknown names create a new category.

set -euo pipefail

SELF="$(readlink -f "$0" 2>/dev/null || echo "$0")"  # follow ~/.local/bin symlink
DIR="$(cd "$(dirname "$SELF")/../../shared/ssh/config.d" && pwd)"
LINK_DIR="$HOME/.ssh/config.d"

die() { echo "error: $*" >&2; exit 1; }
ask() { local v; read -rp "$1" v; printf '%s' "${v:-${2:-}}"; }

category=""
if [[ "${1:-}" == "-c" ]]; then
  category="${2:-}"; shift 2 || die "-c needs a value"
fi

alias_="${1:-}";  [[ -n "$alias_" ]] || alias_="$(ask 'Host alias: ')"
hostname="${2:-}"; [[ -n "$hostname" ]] || hostname="$(ask 'HostName (ip/domain): ')"
user="${3:-}";     [[ -n "$user" || -n "${2:-}" ]] || user="$(ask 'User [none]: ')"
port="${4:-}";     [[ -n "$port" || -n "${2:-}" ]] || port="$(ask 'Port [22]: ')"

[[ -n "$alias_" && -n "$hostname" ]] || die "alias and hostname are required"
[[ -z "$port" || "$port" =~ ^[0-9]+$ ]] || die "port must be numeric"

# Refuse duplicate aliases across all categories.
for f in "$DIR"/*; do
  if awk -v a="$alias_" 'tolower($1)=="host"{for(i=2;i<=NF;i++) if($i==a) found=1} END{exit !found}' "$f"; then
    die "host '$alias_' already exists in $(basename "$f")"
  fi
done

mapfile -t files < <(cd "$DIR" && ls -1)

# Resolve the category to a file.
resolve() {
  local want="$1" f
  for f in "${files[@]}"; do
    [[ "$f" == "$want" || "${f#*-}" == "$want" ]] && { echo "$f"; return; }
  done
  return 0
}

if [[ -z "$category" ]]; then
  echo "Category:"
  i=1
  for f in "${files[@]}"; do echo "  $i) ${f#*-}"; i=$((i+1)); done
  echo "  n) new category"
  choice="$(ask 'Choose: ')"
  if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#files[@]} )); then
    category="${files[$((choice-1))]}"
  elif [[ "$choice" == "n" ]]; then
    category="$(ask 'New category name: ')"
  else
    category="$choice"
  fi
fi

[[ -n "$category" ]] || die "no category given"
file="$(resolve "$category")"

if [[ -z "$file" ]]; then
  name="${category#[0-9]*-}"
  [[ "$name" =~ ^[a-z0-9_-]+$ ]] || die "category name must be lowercase [a-z0-9_-]"
  if [[ "$category" =~ ^[0-9]+- ]]; then
    file="$category"
  else
    # Next free tens slot below 90 (90+ is reserved for personal/catch-all).
    n=10
    while ls "$DIR"/"$n"-* >/dev/null 2>&1; do n=$((n+10)); done
    (( n < 90 )) || n=80
    file="$n-$name"
  fi
  desc="$(ask "Description for '$name' [${name^} hosts]: " "${name^} hosts")"
  printf '# %s. Encrypted in the repo via git-crypt.\n' "$desc" > "$DIR/$file"
  mkdir -p "$LINK_DIR"
  ln -sfn "$DIR/$file" "$LINK_DIR/$file"
  echo "Created category $file (linked into $LINK_DIR)"
fi

{
  # Ensure exactly one blank line before the new block.
  [[ -s "$DIR/$file" && -n "$(tail -c1 "$DIR/$file")" ]] && echo
  [[ "$(tail -n1 "$DIR/$file")" != "" ]] && echo
  echo "Host $alias_"
  echo "    HostName $hostname"
  [[ -n "$user" ]] && echo "    User $user"
  [[ -n "$port" && "$port" != 22 ]] && echo "    Port $port"
  true
} >> "$DIR/$file"

echo "Added '$alias_' to $file"
