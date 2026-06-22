#!/usr/bin/env sh
# Reinstall global Claude/agent skills from the tracked lock file.
#
# The `skills` CLI's own `experimental_install` only restores *project*-level
# skills (a skills-lock.json in cwd). Our skills are global, recorded in
# ~/.agents/.skill-lock.json — so we replay each source's selected skills via
# `skills add --global` instead. Idempotent: re-running just re-verifies.

set -e

LOCK="$HOME/.agents/.skill-lock.json"

if [ ! -f "$LOCK" ]; then
  echo "No skill lock at $LOCK — skipping skills install."
  exit 0
fi

if ! command -v npx >/dev/null 2>&1; then
  echo "npx not found — skipping skills install (install Node, then re-run this script)."
  exit 0
fi

# Group skill names by source: prints one "source<TAB>name1,name2,..." line per source.
python3 - "$LOCK" <<'PY' | while IFS="$(printf '\t')" read -r source skills; do
import json, sys, collections
lock = json.load(open(sys.argv[1]))
by_source = collections.OrderedDict()
for name, meta in lock.get("skills", {}).items():
    by_source.setdefault(meta["source"], []).append(name)
for source, names in by_source.items():
    print(f"{source}\t{','.join(names)}")
PY
  echo ">> skills add $source ($skills)"
  npx --yes skills@1.5.12 add "$source" --global --skill "$skills" --yes \
    || echo "!! failed to install from $source — continuing"
done

echo "Skills install complete."
