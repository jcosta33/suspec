#!/bin/sh
set -eu

PARENT=${1:-$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)}
skills="$PARENT/corpus-skills"
[ -d "$skills" ] || skills="$PARENT/suspec-skills"

seen=""
for file in "$skills"/skills/*/SKILL.md; do
  folder=$(basename "$(dirname "$file")")
  name=$(sed -n 's/^name: //p' "$file" | head -1)
  test -n "$name" || { echo "missing skill name: $file" >&2; exit 1; }
  test "$name" = "$folder" || { echo "folder/name drift: $folder != $name" >&2; exit 1; }
  case " $seen " in *" $name "*) echo "duplicate skill name: $name" >&2; exit 1;; esac
  seen="$seen $name"
  grep -q '^description:' "$file" || { echo "missing description: $name" >&2; exit 1; }
  grep -Fq "\`$name\`" "$skills/README.md" || { echo "catalog omits skill: $name" >&2; exit 1; }
done

echo "lint-skill-catalog: OK"
