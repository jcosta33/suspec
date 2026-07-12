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
agents=$(repo_dir corpus-agents suspec-agents)
cli=$(repo_dir corpus-cli suspec-cli)

for required in disrespec bulletproof demolition revolver triple-check promote-artifact; do
  test -f "$skills/skills/$required/SKILL.md" || { echo "missing skill: $required" >&2; exit 1; }
  grep -q "^name: $required$" "$skills/skills/$required/SKILL.md" || { echo "name drift: $required" >&2; exit 1; }
done

for retired in concise-output revolver-review persona-challenger; do
  test ! -e "$skills/skills/$retired" || { echo "retired skill survives: $retired" >&2; exit 1; }
done
test ! -e "$agents/agents/suspec-challenger.md" || { echo "retired agent survives" >&2; exit 1; }
test ! -e "$agents/.codex/agents/suspec-challenger.toml" || { echo "retired projection survives" >&2; exit 1; }

if grep -RniE 'concise-output|revolver-review|persona-challenger|suspec-challenger' \
  "$skills/README.md" "$skills/skills" "$agents/README.md" "$agents/agents" "$agents/.codex/agents"; then
  echo "stale current method name" >&2
  exit 1
fi

if grep -RniE 'C005|C006|pass-needs-evidence' "$canon/checks" "$canon/docs/reference" \
  "$cli/src/modules/Core/services" "$cli/src/modules/Core/useCases/checkReviewFile.ts"; then
  echo "retired current check contract survives" >&2
  exit 1
fi

sh "$agents/hooks/check-projection-parity.sh"
echo "lint-method-topology: OK"
