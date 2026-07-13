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
mcp=$(repo_dir corpus-mcp suspec-mcp)

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

expected_agents='.gitignore
AGENTS.md
LICENSE
README.md'
actual_agents=$(find "$agents" -mindepth 1 ! -path "$agents/.git" ! -path "$agents/.git/*" -type f -exec basename {} \; | sort)
test "$actual_agents" = "$expected_agents" || {
  echo "agent tombstone file drift" >&2
  printf 'expected:\n%s\nactual:\n%s\n' "$expected_agents" "$actual_agents" >&2
  exit 1
}
if find "$agents" -mindepth 1 ! -path "$agents/.git" ! -path "$agents/.git/*" -type d | grep -q .; then
  echo "agent tombstone contains a directory" >&2
  exit 1
fi

for required in $expected; do
  test -f "$skills/skills/$required/SKILL.md" || { echo "missing skill: $required" >&2; exit 1; }
  grep -q "^name: $required$" "$skills/skills/$required/SKILL.md" || { echo "name drift: $required" >&2; exit 1; }
done

stale_methods='concise-output|revolver-review|codebase-exploration|promote-artifact|save-findings|empirical-proof|implement-task|market-research|planning-spec|write-spec|spec-check|split-work|review-output|security-review|fix-flaky-test|git-pr|write-audit|write-bug-report|write-change-plan|write-documentation|write-feature|write-fix|write-inventory|write-migration|write-performance|write-prd|write-refactor|write-research|write-rewrite|write-rfc|write-testing'
if grep -RniE --exclude-dir=adrs "(^|[^[:alnum:]-])($stale_methods)([^[:alnum:]-]|$)" \
  "$canon/README.md" "$canon/AGENTS.md" "$canon/docs" "$canon/checks" \
  "$skills/README.md" "$skills/skills" "$agents/README.md" "$agents/AGENTS.md" \
  "$cli/README.md" "$cli/AGENTS.md" "$cli/docs" "$cli/src" "$mcp/README.md" "$mcp/src" "$mcp/test"; then
  echo "stale current method name" >&2
  exit 1
fi

unreleased=$(sed -n '/^## \[Unreleased\]/,/^## \[/p' "$skills/CHANGELOG.md" | sed '$d')
if printf '%s\n' "$unreleased" | grep -Ei "(^|[^[:alnum:]-])($stale_methods)([^[:alnum:]-]|$)"; then
  echo "stale method name in current changelog" >&2
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
expected_checks='C001 unique-ids hard-error
C002 duplicate-id hard-error
C003 verify-with hard-error
C004 one-strength-word warning
C007 no-tbd-at-ready hard-error
C008 sources-named warning
C009 broken-source-link hard-error
C010 preserves-refs-resolve hard-error
C011 waves-present warning
C012 coverage warning
C013 verify-evidence-binding warning
C015 citation-resolves warning
C016 supported-needs-evidence hard-error
C019 malformed-requirement-heading warning
C020 unresolvable-ref hard-error
C021 intent-present hard-error
C022 task-shape hard-error
C023 task-evidence hard-error
C024 closed-task-resolved hard-error'
actual_checks=$(sed -nE 's/^  - \{ id: (C[0-9]{3}), name: ([^,]+), severity: ([^ }]+) \}.*/\1 \2 \3/p' "$canon/checks/checks.yaml")
test "$actual_checks" = "$expected_checks" || {
  echo "active checks table drift" >&2
  printf 'expected:\n%s\nactual:\n%s\n' "$expected_checks" "$actual_checks" >&2
  exit 1
}
grep -Fq '  checked: [spec, task, review, change-plan]' "$canon/checks/checks.yaml" || {
  echo "checked artifact matrix drift" >&2
  exit 1
}
grep -Fq '  recognized_unchecked: [inventory, audit, research, inspection]' "$canon/checks/checks.yaml" || {
  echo "unchecked artifact matrix drift" >&2
  exit 1
}
grep -q '^  missing_type: hard-error$' "$canon/checks/checks.yaml" || { echo "missing-type policy drift" >&2; exit 1; }
grep -q '^  unknown_type: hard-error$' "$canon/checks/checks.yaml" || { echo "unknown-type policy drift" >&2; exit 1; }
grep -q '^  source_spec_status: ready' "$canon/checks/checks.yaml" || {
  echo "ready source-spec review gate missing" >&2
  exit 1
}
grep -Fq 'Require exactly `status: ready`' "$skills/skills/sus-review/SKILL.md" || {
  echo "sus-review ready-spec gate missing" >&2
  exit 1
}
grep -Fq 'require the governing spec frontmatter to contain exactly `status: ready`' \
  "$skills/skills/sus-task/SKILL.md" || {
  echo "sus-task ready-spec gate missing" >&2
  exit 1
}
grep -Fq 'Skip multi-stance inspections and decision-informing comparisons or option research.' \
  "$skills/skills/sus-audit/SKILL.md" || {
  echo "sus-audit activation boundary missing" >&2
  exit 1
}
grep -Fq 'Return only the clickable durable absolute path or the' "$skills/skills/promote/SKILL.md" || {
  echo "promote clickable handoff missing" >&2
  exit 1
}
grep -q '^    sections: \[Requirement coverage, Change-plan coverage\]' "$canon/checks/checks.yaml" || {
  echo "change-plan coverage parser contract missing" >&2
  exit 1
}
grep -q 'duplicate waiver' "$canon/checks/checks.yaml" || {
  echo "duplicate waiver rejection missing" >&2
  exit 1
}
grep -Fq '^(all )?(tests?|checks?) (pass(ed)?|succeeded)\.?$' "$canon/checks/checks.yaml" || {
  echo "C023 claim-only predicate drift" >&2
  exit 1
}
grep -q 'C005 and C006 are RETIRED' "$canon/checks/checks.yaml" || { echo "C005/C006 retirement missing" >&2; exit 1; }
grep -q 'C014 is RETIRED' "$canon/checks/checks.yaml" || { echo "C014 retirement missing" >&2; exit 1; }
grep -q 'C017 is RETIRED' "$canon/checks/checks.yaml" || { echo "C017 retirement missing" >&2; exit 1; }
grep -q 'C018 is RESERVED' "$canon/checks/checks.yaml" || { echo "C018 reservation missing" >&2; exit 1; }
for id in C005 C006 C014 C017 C018; do
  if grep -qE "^  - \{ id: $id," "$canon/checks/checks.yaml"; then
    echo "$id must not be active" >&2
    exit 1
  fi
done
echo "lint-method-topology: OK"
