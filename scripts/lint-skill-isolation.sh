#!/bin/sh
set -eu

PARENT=${1:-$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)}
skills="$PARENT/corpus-skills"
[ -d "$skills" ] || skills="$PARENT/suspec-skills"

test -x "$skills/scripts/lint-current.sh" || {
  echo "skills current-surface gate missing: $skills/scripts/lint-current.sh" >&2
  exit 1
}

exec sh "$skills/scripts/lint-current.sh" "$skills"
