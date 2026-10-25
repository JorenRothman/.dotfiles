#!/usr/bin/env sh
# Install VSCodium extensions listed in shared/vscodium/extensions.txt.
# Idempotent: already-installed extensions are skipped.

set -e

LIST="$(dirname "$0")/../../shared/vscodium/extensions.txt"

if ! command -v codium >/dev/null 2>&1; then
  echo "codium not found — skipping extensions install."
  exit 0
fi

installed="$(codium --list-extensions | tr '[:upper:]' '[:lower:]')"

grep -v '^\s*\(#\|$\)' "$LIST" | while read -r ext; do
  lower="$(printf '%s' "$ext" | tr '[:upper:]' '[:lower:]')"
  if printf '%s\n' "$installed" | grep -qx "$lower"; then
    continue
  fi
  echo ">> codium --install-extension $ext"
  codium --install-extension "$ext" >/dev/null \
    || echo "!! failed to install $ext — continuing"
done

echo "VSCodium extensions install complete."
