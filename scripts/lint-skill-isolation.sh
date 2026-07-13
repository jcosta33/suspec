#!/bin/sh
set -eu

PARENT=${1:-$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)}
skills="$PARENT/corpus-skills"
[ -d "$skills" ] || skills="$PARENT/suspec-skills"

artifact_handlers='bulletproof demolition disrespec revolver sus-audit sus-change-plan sus-inventory sus-research sus-review sus-spec sus-task triple-check'
artifact_creators='bulletproof demolition revolver sus-audit sus-change-plan sus-inventory sus-research sus-review sus-spec sus-task triple-check'

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
    protocol='Every choice uses the native picker with automatic `Other`. Without one, render the same numbered options plus `Other`. Never ask a bare question.'
    printf '%s\n' "$flattened" | grep -Fq "$protocol" || {
      echo "global choice protocol missing in $name" >&2
      exit 1
    }
    test "$(grep -Fc 'Every choice uses the native picker with automatic `Other`.' "$file")" = 1 || {
      echo "choice protocol must appear exactly once in $name" >&2
      exit 1
    }
  fi
  if grep -Fq 'Without a picker' "$file"; then
    echo "choice-local fallback duplicates the global protocol in $name" >&2
    exit 1
  fi

  if grep -q 'After creating an artifact successfully' "$file"; then
    echo "obsolete artifact-only handoff in $name" >&2
    exit 1
  fi

  case " $artifact_creators " in
    *" $name "*)
      grep -Fq '~/.agents/artifacts/<workspace>/' "$file" || {
        echo "neutral artifact root missing in $name" >&2
        exit 1
      }
      for term in absolute repository vendor temporary; do
        grep -qi "$term" "$file" || { echo "incomplete placement rule in $name: $term" >&2; exit 1; }
      done
      ;;
  esac

  case " $artifact_handlers " in
    *" $name "*)
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

grep -Fq 'Never author or place a new artifact' "$skills/skills/disrespec/SKILL.md" || {
  echo "disrespec may create an unplaced artifact" >&2
  exit 1
}
grep -Fq 'requested or required by the active workflow' "$skills/skills/dissect/SKILL.md" || {
  echo "dissect overlaps workflow-required inventory" >&2
  exit 1
}
for phrase in '**Sanitize and retry**' '**Cancel**' 'Change nothing until the human selects.'; do
  grep -Fq "$phrase" "$skills/skills/promote/SKILL.md" || {
    echo "promote sensitive-content decision missing: $phrase" >&2
    exit 1
  }
done

writer_types='bulletproof:inspection demolition:inspection revolver:inspection triple-check:inspection sus-spec:spec sus-task:task sus-review:review sus-inventory:inventory sus-change-plan:change-plan sus-audit:audit sus-research:research'
for pair in $writer_types; do
  writer=${pair%%:*}
  expected_type=${pair#*:}
  actual_types=$(grep -RohE 'type: (spec|task|review|inventory|change-plan|audit|research|inspection)' \
    "$skills/skills/$writer" | sort -u)
  test "$actual_types" = "type: $expected_type" || {
    echo "artifact type ownership drift in $writer: $actual_types" >&2
    exit 1
  }
done

for method in bulletproof demolition revolver triple-check; do
  actual_methods=$(grep -ohE 'method: (bulletproof|demolition|revolver|triple-check)' \
    "$skills/skills/$method/SKILL.md" | sort -u)
  test "$actual_methods" = "method: $method" || {
    echo "inspection method ownership drift in $method: $actual_methods" >&2
    exit 1
  }
done
grep -Fq 'Make the first body line exactly: `Advocacy exercise, not evidence.`' \
  "$skills/skills/demolition/SKILL.md" || {
  echo "demolition quarantine banner missing" >&2
  exit 1
}

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

grep -Fq 'activate merely because another skill writes one' \
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
