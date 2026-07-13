#!/bin/sh
# lint-all.sh — run every current public-surface check over the Suspec family.
#
# A single read-only entry point for the scriptable gates. It exits zero only when every gate is
# clean; failures remain visible above the aggregate result.
#
#   lint-product-citations.sh   no ADR/AUDIT/source-URL citations in product bodies
#   lint-count-ranges.sh        no hardcoded count-bearing ADR ranges in bootstrap prose
#   lint-accepted-adrs.sh       every numbered accepted ADR matches the frozen digest
#   lint-released-changelog.sh  released skill-catalog history matches the frozen digest
#   lint-method-topology.sh     cross-repository ownership and contract coherence
#   lint-skill-isolation.sh     delegates to the skills repository's local structural gate
#
# Each repository decides whether to wire these checks into CI; this script is the shared entry point.
#
# Usage: scripts/lint-all.sh [REPO_PARENT_DIR]   (default: this repo's parent directory)
# REPO_PARENT_DIR feeds each cross-repository scan.
set -eu

HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DEV_DIR="${1:-$(CDPATH= cd -- "$HERE/../.." && pwd)}"

rc=0
for gate in lint-product-citations lint-count-ranges lint-accepted-adrs lint-released-changelog lint-method-topology lint-skill-isolation; do
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
