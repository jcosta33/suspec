#!/bin/sh
set -eu

PARENT=${1:-$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)}
skills="$PARENT/corpus-skills"
[ -d "$skills" ] || skills="$PARENT/suspec-skills"

spine='DISRESPEC-SPINE: One fact once. No filler, repeated source material, empty sections, or chat restatement; after successful creation return only clickable artifact links, except for blockers, failed creation, incomplete verification, or irreversible-action confirmation.'

writers='bulletproof demolition empirical-proof implement-task market-research planning-spec promote-artifact review-output revolver spec-check split-work triple-check write-audit write-bug-report write-change-plan write-documentation write-feature write-fix write-inventory write-migration write-performance write-prd write-refactor write-research write-rewrite write-rfc write-spec write-testing'

for name in $writers; do
  file="$skills/skills/$name/SKILL.md"
  test -f "$file" || { echo "missing artifact writer: $name" >&2; exit 1; }
  count=$(grep -Fxc "\`$spine\`" "$file" || true)
  test "$count" -eq 1 || { echo "Disrespec spine drift: $name ($count copies)" >&2; exit 1; }
done

echo "lint-disrespec-spine: OK"
