#!/bin/sh
set -eu

PARENT=${1:-$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)}

repo_dir() {
  for name in "$@"; do
    [ -d "$PARENT/$name" ] && { printf '%s\n' "$PARENT/$name"; return; }
  done
  return 1
}

canon=$(repo_dir corpus suspec)
skills=$(repo_dir corpus-skills suspec-skills)

expected='bulletproof
demolition
disrespec
dissect
promote
remember
revolver
sus-audit
sus-change-plan
sus-inventory
sus-research
sus-review
sus-spec
sus-task
triple-check'

actual=$(find "$skills/skills" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort)
test "$actual" = "$expected" || {
  echo "skill topology drift" >&2
  printf 'expected:\n%s\nactual:\n%s\n' "$expected" "$actual" >&2
  exit 1
}

for required in $expected; do
  test -f "$skills/skills/$required/SKILL.md" || { echo "missing skill: $required" >&2; exit 1; }
  grep -q "^name: $required$" "$skills/skills/$required/SKILL.md" || { echo "name drift: $required" >&2; exit 1; }
done

if grep -RniE --exclude-dir=adrs '(^|[^[:alnum:]-])(concise-output|revolver-review|codebase-exploration|promote-artifact|save-findings|empirical-proof|implement-task|planning-spec|write-spec|spec-check|split-work|review-output|security-review|fix-flaky-test|git-pr)([^[:alnum:]-]|$)' \
  "$canon/README.md" "$canon/AGENTS.md" "$canon/docs" "$canon/checks" "$skills/README.md" "$skills/skills"; then
  echo "stale current method name" >&2
  exit 1
fi

if grep -RniE --exclude-dir=adrs 'suspec-agents|canonical agent|Codex projection|agents/suspec-' \
  "$canon/README.md" "$canon/AGENTS.md" "$canon/docs" "$skills/README.md" "$skills/skills"; then
  echo "custom agent catalog survives on a current surface" >&2
  exit 1
fi

grep -q '^version: 0\.18\.0' "$canon/checks/checks.yaml" || {
  echo "checks contract version drift" >&2
  exit 1
}
for id in C021 C022 C023 C024; do
  grep -q "id: $id" "$canon/checks/checks.yaml" || { echo "missing check: $id" >&2; exit 1; }
done
grep -q 'C014 is RETIRED' "$canon/checks/checks.yaml" || { echo "C014 retirement missing" >&2; exit 1; }
if grep -qE '^  - \{ id: C014,' "$canon/checks/checks.yaml"; then
  echo "C014 still active" >&2
  exit 1
fi
echo "lint-method-topology: OK"
