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

# Rows of the "Retired and relocated" table, with status. Section scan is BOUNDED — it stops at
# the next `## ` header, so a table appended after this section can never leak into the row set.
# The header itself is load-bearing: absent → exit 2 (a renamed anchor must not read as clean).
section=$(awk '/^## Retired and relocated/{f=1; next} f && /^## /{exit} f{print}' "$REGISTRY")
if ! grep -q '^## Retired and relocated' "$REGISTRY"; then
    echo "lint-artifact-refs: registry section '## Retired and relocated' not found in $REGISTRY — renamed or removed? (setup error)" >&2
    exit 2
fi

# Parse each table row (skip separators/headers) into "status name". A name cell parses from its
# backticked token, or a bare single token; anything else is a loud exit 2 — a raw row must never
# become a grep pattern. Status matches case-insensitively; only retired/relocated rows are kept.
rows=$(printf '%s\n' "$section" | grep -E '^\|' | grep -viE '^\|[-[:space:]|]*$|^\| *Name *\|' || true)
pairs=""
while IFS= read -r row; do
    [ -n "$row" ] || continue
    cell=$(printf '%s' "$row" | sed -E 's/^\| *([^|]*)\|.*/\1/' | sed -E 's/[[:space:]]+$//')
    status=$(printf '%s' "$row" | sed -E 's/^\|[^|]*\| *([^|]*)\|.*/\1/' | tr '[:upper:]' '[:lower:]' | sed -E 's/[[:space:]]+//g')
    case "$status" in
        retired|relocated) ;;
        *) continue ;;
    esac
    qualified=0
    case "$cell" in *'('*')'*) qualified=1 ;; esac
    case "$cell" in
        *'`'*) name=$(printf '%s' "$cell" | sed -E 's/[^`]*`([^`]+)`.*/\1/') ;;
        *)
            # bare cell: must be one plain token (optionally with a parenthesized qualifier after)
            name=$(printf '%s' "$cell" | sed -E 's/ *\(.*\)$//')
            case "$name" in
                *' '*|''|*'|'*|*'['*|*']'*)
                    echo "lint-artifact-refs: cannot parse registry row (name cell '$cell') — backtick the name or fix the row (setup error)" >&2
                    exit 2 ;;
            esac ;;
    esac
    # A parenthesized qualifier scopes the status to one CONTEXT (e.g. relocated "(catalog)" while
    # fully active in the kit) — a bare-name grep cannot judge context. Relocated+qualified rows
    # are skipped with a note; retired+qualified is unjudgeable-in-v1 and refuses loudly.
    if [ "$qualified" -eq 1 ]; then
        if [ "$status" = "retired" ]; then
            echo "lint-artifact-refs: cannot judge a context-qualified RETIRED name ('$cell') with a bare-name scan — unqualify or split the row (setup error)" >&2
            exit 2
        fi
        echo "lint-artifact-refs: note — relocated row '$cell' is context-qualified; bare-name scan skipped (context-bound)."
        continue
    fi
    pairs="$pairs$status $name
"
done <<EOF_ROWS
$rows
EOF_ROWS

if [ -z "$pairs" ]; then
    echo "lint-artifact-refs: no retired/relocated rows in the registry — nothing to lint (0 names)."
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

# Match names as FIXED STRINGS on IDENTIFIER BOUNDARIES: metacharacters are escaped (no regex
# interpretation), and the neighbor class forbids [A-Za-z0-9_-] on either side — so a hyphenated
# longer identifier (persona-skeptic-alike) never matches, which plain grep -w cannot express. Exemptions are anchored: history by PATH component
# (archive/, CHANGELOG, docs/adrs/ in any scanned repo); redirect stubs by an explicit
# retirement PHRASE on the line — never the bare letters "retired"/"redirect" anywhere.
# A grep read error is a setup error (exit 2), never a silent pass.
STUB_PHRASE='\b([Rr]etired|[Dd]eprecated|[Ss]uperseded|[Mm]erged into|[Rr]eplaced by|[Rr]edirects? to)\b'
rc=0
count=0
warned=0
old_IFS=$IFS; IFS='
'
for pair in $pairs; do
    IFS=$old_IFS
    status=${pair%% *}
    name=${pair#* }
    [ -n "$name" ] || continue
    # escape ERE metacharacters so the name stays a fixed string
    escaped=$(printf '%s' "$name" | sed -e 's/[][\.^$*+?(){}|]/\\&/g')
    hits=""
    while IFS= read -r f; do
        [ -f "$f" ] || continue
        grc=0
        out=$(grep -HnE -- "(^|[^A-Za-z0-9_-])$escaped([^A-Za-z0-9_-]|\$)" "$f") || grc=$?
        if [ "$grc" -ge 2 ]; then
            echo "lint-artifact-refs: grep failed reading $f (setup error)" >&2
            exit 2
        fi
        [ -n "$out" ] && hits="$hits$out
"
    done <<EOF_FILES
$files
EOF_FILES
    hits=$(printf '%s' "$hits" \
        | grep -vE '^[^:]*(/archive/|CHANGELOG|/docs/adrs/)[^:]*:' \
        | grep -vE ":[0-9]+:.*$STUB_PHRASE" || true)
    if [ -n "$hits" ]; then
        if [ "$status" = "retired" ]; then
            [ "$rc" -eq 0 ] && echo "lint-artifact-refs: FAIL — retired artifact names in live prose (registry: docs/artifact-registry.md):"
            echo "  [$name] (retired)"
            printf '%s\n' "$hits" | sed 's/^/    /'
            rc=1
        else
            echo "lint-artifact-refs: warning — relocated name \"$name\" mentioned in live prose (still active at its new home; surfacing only):"
            printf '%s\n' "$hits" | sed 's/^/    /'
            warned=$((warned + 1))
        fi
    fi
    count=$((count + 1))
    IFS='
'
done
IFS=$old_IFS

if [ "$rc" -eq 0 ]; then
    suffix=""
    [ "$warned" -gt 0 ] && suffix=" ($warned relocated-name warning(s) above)"
    echo "lint-artifact-refs: OK — $count retired/relocated name(s) checked; no retired name in live product/reference prose.$suffix"
fi
exit "$rc"
