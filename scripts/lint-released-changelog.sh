#!/bin/sh
set -eu

PARENT=${1:-$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)}
skills="$PARENT/corpus-skills"
[ -d "$skills" ] || skills="$PARENT/suspec-skills"
file="$skills/CHANGELOG.md"
expected=bb28151be77b84872076b94b7c9f47470b5f66be47e1d1db749650c3a468c1cd

grep -q '^## \[[0-9]' "$file" || {
  echo "released changelog sections missing" >&2
  exit 1
}

actual=$(sed -n '/^## \[[0-9]/,$p' "$file" | shasum -a 256 | awk '{print $1}')
test "$actual" = "$expected" || {
  echo "released changelog history drift" >&2
  exit 1
}

echo "lint-released-changelog: OK"
