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

  flattened=$(tr '\n' ' ' < "$file")
  if grep -qiE 'picker|structured choices|human-readable choices|Delete, Leave, or Promote' "$file"; then
    printf '%s\n' "$flattened" | grep -Fqi 'Without a picker, render the same numbered options plus `Other`.' || {
      echo "structured choice lacks a no-picker fallback in $name" >&2
      exit 1
    }
  fi

  if grep -q 'After creating an artifact successfully' "$file"; then
    echo "obsolete artifact-only handoff in $name" >&2
    exit 1
  fi

  case " $artifact_writers " in
    *" $name "*)
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
      printf '%s\n' "$flattened" | grep -qiE 'lifecycle|fully actioned|no downstream step' || {
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
      printf '%s\n' "$flattened" | grep -Fqi 'non-empty transient artifact set' || {
        echo "artifact disposition does not require a transient set in $name" >&2
        exit 1
      }
      printf '%s\n' "$flattened" | grep -qiE 'durable (documents|inputs) never enter disposition' || {
        echo "artifact disposition may include durable inputs in $name" >&2
        exit 1
      }
      ;;
  esac
done

grep -Fq 'For a compact check with no inspection artifact' "$skills/skills/bulletproof/SKILL.md" || {
  echo "bulletproof compact handoff missing" >&2
  exit 1
}
remember=$(tr '\n' ' ' < "$skills/skills/remember/SKILL.md")
for phrase in 'non-empty transient artifact set created or consumed by the active work' \
  'Repository-native and other durable inputs never enter disposition' \
  'no downstream step needs any member or sidecar'; do
  printf '%s\n' "$remember" | grep -Fqi "$phrase" || {
    echo "remember lifecycle guard missing: $phrase" >&2
    exit 1
  }
done
execution=$(tr '\n' ' ' < "$skills/docs/execution.md")
for phrase in 'non-empty transient artifact-and-sidecar set created or consumed by the active work' \
  'Repository-native and other durable inputs never enter disposition' \
  'no earlier prompt and no downstream consumer'; do
  printf '%s\n' "$execution" | grep -Fqi "$phrase" || {
    echo "execution lifecycle guard missing: $phrase" >&2
    exit 1
  }
done

grep -Fq 'Never activate merely because another skill writes an artifact' \
  "$skills/skills/disrespec/SKILL.md" || {
  echo "disrespec blanket activation returned" >&2
  exit 1
}
for method in bulletproof demolition revolver triple-check; do
  grep -Fq 'target: <path-or-stable-identifier>' "$skills/skills/$method/SKILL.md" || {
    echo "inspection target frontmatter missing in $method" >&2
    exit 1
  }
done
grep -Fq 'The `SPEC-`-prefixed `id` is unique.' "$skills/skills/sus-spec/SKILL.md" || {
  echo "sus-spec id prefix missing" >&2
  exit 1
}
for phrase in '`sources` is always a list' '/absolute/path/to/source.md'; do
  grep -Fq "$phrase" "$skills/skills/sus-spec/SKILL.md" || {
    echo "sus-spec frontmatter shape missing: $phrase" >&2
    exit 1
  }
done
for phrase in '`preserves` is always a list' 'SPEC-feature#AC-001' 'PG-001'; do
  grep -Fq "$phrase" "$skills/skills/sus-change-plan/SKILL.md" || {
    echo "sus-change-plan frontmatter shape missing: $phrase" >&2
    exit 1
  }
done
grep -Fq 'waivers: [AC-002]' "$skills/skills/sus-review/SKILL.md" || {
  echo "sus-review waiver list shape missing" >&2
  exit 1
}

echo "lint-skill-isolation: OK"
