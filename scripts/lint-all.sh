#!/bin/sh
# lint-all.sh — run every current public-surface check over the Suspec family.
#
# A single entry point for the scriptable gates. Each is a RECORD/CHECK, not an executor
# (ADR-0077): it reads and reports, edits nothing. Aggregates: exits 0 only if every gate is clean,
# else non-zero (the first failing gate's findings are printed above).
#
#   lint-product-citations.sh   no ADR/AUDIT/source-URL citations in product bodies
#   lint-count-ranges.sh        no hardcoded count-bearing ADR ranges in bootstrap prose
#   lint-skill-mirrors.sh       local maintainer skill subset matches suspec-skills byte for byte
#
# Each repository decides whether to wire these checks into CI; this script is the shared entry point.
#
# Usage: scripts/lint-all.sh [REPO_PARENT_DIR]   (default: this repo's parent directory)
# REPO_PARENT_DIR feeds each cross-repository scan.
set -eu

HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DEV_DIR="${1:-$(CDPATH= cd -- "$HERE/../.." && pwd)}"

rc=0
for gate in lint-product-citations lint-count-ranges lint-skill-mirrors; do
    echo "--- $gate ---"
    if ! sh "$HERE/$gate.sh" "$DEV_DIR"; then
        rc=1
        echo "  ^ $gate FAILED" >&2
    fi
    echo ""
done

if [ "$rc" -eq 0 ]; then
    echo "lint-all: OK — every method-gate is clean."
else
    echo "lint-all: FAIL — at least one method-gate found a violation (see above)." >&2
fi
exit "$rc"
