#!/usr/bin/env sh
# Make installed VSCodium extensions match shared/vscodium/extensions.txt:
# missing ones are installed, ones not in the list are uninstalled.
# Idempotent: re-running only acts on differences.

set -e

LIST="$(dirname "$0")/../../shared/vscodium/extensions.txt"

if ! command -v codium >/dev/null 2>&1; then
  echo "codium not found — skipping extensions sync."
  exit 0
fi

wanted="$(grep -v '^\s*\(#\|$\)' "$LIST" | tr '[:upper:]' '[:lower:]')"
installed="$(codium --list-extensions | tr '[:upper:]' '[:lower:]')"

printf '%s\n' "$wanted" | while read -r ext; do
  if printf '%s\n' "$installed" | grep -qx "$ext"; then
    continue
  fi
  echo ">> codium --install-extension $ext"
  codium --install-extension "$ext" >/dev/null \
    || echo "!! failed to install $ext — continuing"
done

printf '%s\n' "$installed" | while read -r ext; do
  [ -n "$ext" ] || continue
  if printf '%s\n' "$wanted" | grep -qx "$ext"; then
    continue
  fi
  echo ">> codium --uninstall-extension $ext"
  codium --uninstall-extension "$ext" >/dev/null \
    || echo "!! failed to uninstall $ext — continuing"
done

echo "VSCodium extensions sync complete."
