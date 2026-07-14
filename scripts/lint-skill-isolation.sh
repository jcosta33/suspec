#!/bin/sh
set -eu

PARENT=${1:-$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)}
skills=${SUSPEC_SKILLS:-}

if [ -z "$skills" ]; then
  for candidate in "$PARENT"/*; do
    [ -f "$candidate/skills/disrespec/SKILL.md" ] || continue
    [ -z "$skills" ] || { echo "multiple Suspec Skills repositories under $PARENT" >&2; exit 1; }
    skills=$candidate
  done
fi
[ -n "$skills" ] || { echo "Suspec Skills repository not found under $PARENT" >&2; exit 1; }

test -x "$skills/scripts/lint-current.sh" || {
  echo "skills current-surface gate missing: $skills/scripts/lint-current.sh" >&2
  exit 1
}

exec sh "$skills/scripts/lint-current.sh" "$skills"
