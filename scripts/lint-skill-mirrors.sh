#!/bin/sh
# Verify that this repo's maintainer-only skill subset is byte-identical to suspec-skills.
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SUSPEC_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
PARENT=${1:-$(CDPATH= cd -- "$SUSPEC_ROOT/.." && pwd)}
MIRROR_ROOT="$SUSPEC_ROOT/.agents/skills"

repo_dir() {
    name=$1
    if [ -d "$PARENT/$name" ]; then
        printf '%s\n' "$PARENT/$name"
        return
    fi
    for candidate in "$PARENT"/*; do
        [ -d "$candidate" ] || continue
        url=$(git -C "$candidate" remote get-url origin 2>/dev/null || true)
        case "$url" in
            */"$name"|*/"$name".git)
                printf '%s\n' "$candidate"
                return
                ;;
        esac
    done
}

SKILLS_ROOT=$(repo_dir suspec-skills)
if [ -z "$SKILLS_ROOT" ] || [ ! -d "$SKILLS_ROOT/skills" ]; then
    echo "lint-skill-mirrors: suspec-skills checkout not found under $PARENT" >&2
    exit 2
fi

files=$(find "$MIRROR_ROOT" -type f | sort)
if [ -z "$files" ]; then
    echo "lint-skill-mirrors: no local mirror files found" >&2
    exit 2
fi

failures=0
count=0
printf '%s\n' "$files" | while IFS= read -r mirror; do
    relative=${mirror#"$MIRROR_ROOT/"}
    source="$SKILLS_ROOT/skills/$relative"
    if [ ! -f "$source" ]; then
        echo "lint-skill-mirrors: missing source for $relative" >&2
        exit 1
    fi
    if ! cmp -s "$mirror" "$source"; then
        echo "lint-skill-mirrors: drift: $relative" >&2
        exit 1
    fi
done || failures=1

if [ "$failures" -ne 0 ]; then
    exit 1
fi

count=$(printf '%s\n' "$files" | grep -c .)
echo "lint-skill-mirrors: OK — $count local mirror file(s) match suspec-skills."
