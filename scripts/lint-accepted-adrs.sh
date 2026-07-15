#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
EXPECTED_COUNT=161
EXPECTED_DIGEST=dfa3153308cde18893e2713359678d60a9b9d1ae362b133e494738f0231aa967
BASE=${SUSPEC_HISTORY_BASE:-}

case "$BASE" in
  ''|0000000000000000000000000000000000000000) ;;
  *)
    git -C "$ROOT" cat-file -e "$BASE^{commit}" 2>/dev/null || {
      echo "accepted ADR history base is unavailable: $BASE" >&2
      exit 1
    }
    base_files=$(git -C "$ROOT" ls-tree -r --name-only "$BASE" -- docs/adrs |
      grep -E '^docs/adrs/[0-9]{4}-[^/]+\.md$' || true)
    for file in $base_files; do
      test -f "$ROOT/$file" || {
        echo "accepted ADR removed: $file" >&2
        exit 1
      }
      git -C "$ROOT" diff --quiet "$BASE" -- "$file" || {
        echo "accepted ADR changed since $BASE: $file" >&2
        exit 1
      }
    done
    ;;
esac

files=$(git -C "$ROOT" ls-files 'docs/adrs/*.md' |
  grep -E '^docs/adrs/[0-9]{4}-[^/]+\.md$')
count=$(printf '%s\n' "$files" | wc -l | tr -d ' ')
test "$count" = "$EXPECTED_COUNT" || {
  echo "accepted ADR set drift: expected $EXPECTED_COUNT files, found $count" >&2
  exit 1
}

actual=$(printf '%s\n' "$files" |
  sed "s|^|$ROOT/|" |
  xargs shasum -a 256 |
  sed "s|  $ROOT/|  |" |
  shasum -a 256 |
  awk '{print $1}')
test "$actual" = "$EXPECTED_DIGEST" || {
  echo "accepted ADR body drift: $actual" >&2
  exit 1
}

echo "lint-accepted-adrs: OK"
