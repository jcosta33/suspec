#!/bin/sh
# lint-artifact-refs.sh — the ADR-0114 retired-name gate (method-gate 0114-artifact-refs).
#
# docs/artifact-registry.md is the single source for which public artifact names are active. A
# RETIRED name that survives in product or reference prose sends a reader to something that no
# longer exists. This gate reads the registry's "Retired and relocated" table, takes every row whose
# Status is `retired`, and greps the family's product + reference doc surfaces for those names.
# It is a RECORD/CHECK, not an executor (ADR-0077): it reads and reports, it edits nothing.
#
# ALLOWLIST (ADR-0114's own requirement — without it the gate becomes noise an author mutes):
#   - docs/adrs/**            (immutable history legitimately names retired things)
#   - docs/artifact-registry.md (the registry names them on purpose)
#   - archive/**, CHANGELOG*   (history)
#   - any LINE that itself contains "retired"/"Retired"/"redirect" (a redirect stub or a note
#     recording the retirement is the correct way to mention a retired name)
#
# Scope per repo (sibling repos under the family parent; markdown prose only — code files are
# human-reviewed, not linted, same stance as lint-product-citations.sh):
#   suspec:              README.md docs/ (minus adrs/ + artifact-registry.md)
#   suspec-skills:       README.md docs/ skills/
#   suspec-starter-kit:  README.md AGENTS.md templates/ .agents/skills/ hooks/
#   suspec-agents:       README.md AGENTS.md docs/ agents/ hooks/
#   suspec-cli / -mcp:   README.md docs/
#
# Exit: 0 clean · 1 hits found · 2 usage/setup error.
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
CANON_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
DEV_DIR="${1:-$(CDPATH= cd -- "$CANON_ROOT/.." && pwd)}"
REGISTRY="$CANON_ROOT/docs/artifact-registry.md"

[ -f "$REGISTRY" ] || { echo "lint-artifact-refs: registry not found: $REGISTRY" >&2; exit 2; }

# Retired names: rows of the "Retired and relocated" table whose Status cell is `retired`.
# Row shape: | `name` | retired | replacement |  (a parenthesized qualifier after the name is legal)
names=$(awk '/^## Retired and relocated/{f=1} f && /^\|/{print}' "$REGISTRY" \
    | grep -E '\|[[:space:]]*retired[[:space:]]*\|' \
    | sed -E 's/^\| *`([^`]+)`.*/\1/')

if [ -z "$names" ]; then
    echo "lint-artifact-refs: no retired rows in the registry — nothing to lint (0 names)."
    exit 0
fi

# Resolve a family repo dir by remote-or-folder name (folders may be corpus-*, remotes suspec-*).
# A missing sibling is warned, never silently skipped — a shrinking scan surface must be visible.
repo_dir() {
    for cand in "$DEV_DIR/$1" "$DEV_DIR/$(printf '%s' "$1" | sed 's/^suspec/corpus/')"; do
        [ -d "$cand" ] && { printf '%s\n' "$cand"; return 0; }
    done
    echo "lint-artifact-refs: warning — sibling repo not found under $DEV_DIR: $1 (skipped)" >&2
    return 1
}

# Collect the in-scope files (markdown only), newline-delimited.
collect() {
    dir="$1"; shift
    for sub in "$@"; do
        target="$dir/$sub"
        if [ -f "$target" ]; then
            printf '%s\n' "$target"
        elif [ -d "$target" ]; then
            find "$target" -name '*.md' -type f
        fi
    done
}

collect_sibling() {
    repo="$1"; shift
    dir=$(repo_dir "$repo") || return 0
    collect "$dir" "$@"
}

# The canon scope always comes from the repo this script lives in — never from the argument.
files=$(
    {
        collect "$CANON_ROOT" README.md docs | { grep -v '/docs/adrs/' || true; } \
            | { grep -v 'artifact-registry\.md' || true; }
        collect_sibling suspec-skills README.md docs skills
        collect_sibling suspec-starter-kit README.md AGENTS.md templates .agents/skills hooks
        collect_sibling suspec-agents README.md AGENTS.md docs agents hooks
        collect_sibling suspec-cli README.md docs
        collect_sibling suspec-mcp README.md docs
    } | sort -u
)

# An empty scan list is a setup error, not a pass — the exit-2 contract above.
if [ -z "$files" ]; then
    echo "lint-artifact-refs: no in-scope files found (DEV_DIR=$DEV_DIR) — refusing a vacuous pass." >&2
    exit 2
fi

rc=0
count=0
for name in $names; do
    hits=$(printf '%s\n' "$files" | while IFS= read -r f; do
        [ -f "$f" ] || continue
        grep -Hn -- "$name" "$f" 2>/dev/null || true
    done | grep -viE 'retired|redirect|CHANGELOG|/archive/' || true)
    if [ -n "$hits" ]; then
        [ "$rc" -eq 0 ] && echo "lint-artifact-refs: FAIL — retired artifact names in live prose (registry: docs/artifact-registry.md):"
        echo "  [$name]"
        printf '%s\n' "$hits" | sed 's/^/    /'
        rc=1
    fi
    count=$((count + 1))
done

if [ "$rc" -eq 0 ]; then
    echo "lint-artifact-refs: OK — $count retired name(s) absent from live product/reference prose."
fi
exit "$rc"
