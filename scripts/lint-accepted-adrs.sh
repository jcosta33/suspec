#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
EXPECTED_COUNT=152
EXPECTED_DIGEST=b25703cdfa7c9fb075aee391cd49360283fdfc5b824818afaa8839839433d9f2

files=$(git -C "$ROOT" ls-files 'docs/adrs/0*.md' |
  grep -E '^docs/adrs/(00[0-9]{2}|01[0-4][0-9]|015[0-4])-')
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
  echo "accepted ADR body drift in 0001-0154" >&2
  exit 1
}

echo "lint-accepted-adrs: OK"
