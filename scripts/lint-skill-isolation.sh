#!/bin/sh
set -eu

PARENT=${1:-$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)}
skills="$PARENT/corpus-skills"
[ -d "$skills" ] || skills="$PARENT/suspec-skills"

artifact_writers='bulletproof demolition disrespec revolver sus-audit sus-change-plan sus-inventory sus-research sus-review sus-spec sus-task triple-check'

relative_markdown_links() {
  grep -oE ']\((\.\.?/)[^)]*\)' | sed -E 's/^]\((.*)\)$/\1/'
}

probe=$(printf '%s\n' '[one](./references/one.md) and [two](../two.md)' | relative_markdown_links)
expected=$(printf '%s\n' './references/one.md' '../two.md')
[ "$probe" = "$expected" ] || {
  echo "relative Markdown link extractor missed a same-line link" >&2
  exit 1
}

for file in "$skills"/skills/*/SKILL.md; do
  folder=$(dirname "$file")
  name=$(basename "$folder")

  if grep -nE 'DISRESPEC-SPINE|SPINE-(START|END)|ADR-[0-9]+|lint-[a-z-]+|this catalog|sibling skill|if installed|catalog topology' "$file"; then
    echo "internal implementation vocabulary in $name" >&2
    exit 1
  fi

  if grep -nE '\.\./[^/]+/SKILL\.md' "$file"; then
    echo "external skill dependency in $name" >&2
    exit 1
  fi

  for sibling in "$skills"/skills/*; do
    sibling_name=$(basename "$sibling")
    [ "$sibling_name" = "$name" ] && continue
    if grep -nE "(^|[^[:alnum:]-])$sibling_name([^[:alnum:]-]|$)" "$file"; then
      echo "sibling skill named in $name: $sibling_name" >&2
      exit 1
    fi
  done

  relative_markdown_links < "$file" | while IFS= read -r ref; do
    test -e "$folder/$ref" || {
      echo "missing bundled reference in $name: $ref" >&2
      exit 1
    }
  done

  if grep -q 'After creating an artifact successfully' "$file"; then
    echo "obsolete artifact-only handoff in $name" >&2
    exit 1
  fi

  case " $artifact_writers " in
    *" $name "*)
      flattened=$(tr '\n' ' ' < "$file")
      if [ "$name" != disrespec ]; then
        grep -Fq '~/.agents/artifacts/<workspace>/' "$file" || {
          echo "neutral artifact root missing in $name" >&2
          exit 1
        }
        for term in absolute repository vendor temporary; do
          grep -qi "$term" "$file" || { echo "incomplete placement rule in $name: $term" >&2; exit 1; }
        done
      fi
      for term in delete leave promote sidecar; do
        grep -qi "$term" "$file" || { echo "incomplete artifact disposition in $name: $term" >&2; exit 1; }
      done
      grep -qiE 'lifecycle|fully actioned|no downstream step' "$file" || {
        echo "artifact close occurs at the wrong time in $name" >&2
        exit 1
      }
      printf '%s\n' "$flattened" | grep -qiE 'inaction is not Leave|never choose|do not choose|human chooses' || {
        echo "agent may choose artifact disposition in $name" >&2
        exit 1
      }
      grep -qiE 'ordinary conversation|direct action|user spoke|merely because|explicit invocation only|explicit request' "$file" || {
        echo "ordinary interaction may create an artifact in $name" >&2
        exit 1
      }
      grep -qiE 'workflow requires|workflow needs|workflow input|substantive|user requests|explicit invocation|explicit.*request' "$file" || {
        echo "required artifact may be skipped in $name" >&2
        exit 1
      }
      for phrase in 'final consumer' 'no earlier disposition prompt occurred' 'created or consumed by the active work'; do
        printf '%s\n' "$flattened" | grep -Fqi "$phrase" || {
          echo "artifact disposition is not composition-safe in $name: $phrase" >&2
          exit 1
        }
      done
      ;;
  esac
done

grep -Fq 'Never activate merely because another skill writes an artifact' \
  "$skills/skills/disrespec/SKILL.md" || {
  echo "disrespec blanket activation returned" >&2
  exit 1
}
for phrase in 'non-empty transient artifact set' 'durable documents never enter disposition'; do
  grep -Fq "$phrase" "$skills/skills/disrespec/SKILL.md" || {
    echo "disrespec may dispose of durable documents: $phrase" >&2
    exit 1
  }
done
for method in bulletproof demolition revolver triple-check; do
  grep -Fq 'target: <path-or-stable-identifier>' "$skills/skills/$method/SKILL.md" || {
    echo "inspection target frontmatter missing in $method" >&2
    exit 1
  }
done
grep -Fq 'unique `SPEC-`-prefixed `id`' "$skills/skills/sus-spec/SKILL.md" || {
  echo "sus-spec id prefix missing" >&2
  exit 1
}

echo "lint-skill-isolation: OK"
