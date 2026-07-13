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

declaration_values() {
  root=$1
  key=$2
  find "$root" -type f -name '*.md' -exec awk -v key="$key" '
    {
      rest = $0
      pattern = "(^|[`[:space:]])" key ":[[:space:]]+"
      while (match(rest, pattern)) {
        value = substr(rest, RSTART + RLENGTH)
        first = substr(value, 1, 1)
        if (first == "\"" || first == "\047") value = substr(value, 2)
        if (match(value, /^[[:alnum:]-]+/)) print substr(value, RSTART, RLENGTH)
        rest = substr(rest, RSTART + RLENGTH)
      }
    }
  ' {} + | sort -u
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

  find "$folder" -type f -name '*.md' -print | sort | while IFS= read -r document; do
    if grep -nE 'DISRESPEC-SPINE|SPINE-(START|END)|ADR-[0-9]+|lint-[a-z-]+|this catalog|sibling skill|if installed|catalog topology' "$document"; then
      echo "internal implementation vocabulary in $name: $document" >&2
      exit 1
    fi

    if grep -nE '\.\./[^/]+/SKILL\.md' "$document"; then
      echo "external skill dependency in $name: $document" >&2
      exit 1
    fi

    for sibling in "$skills"/skills/*; do
      sibling_name=$(basename "$sibling")
      [ "$sibling_name" = "$name" ] && continue
      if grep -nE "(^|[^[:alnum:]-])$sibling_name([^[:alnum:]-]|$)" "$document"; then
        echo "sibling skill named in $name: $sibling_name ($document)" >&2
        exit 1
      fi
    done

    document_dir=$(dirname "$document")
    relative_markdown_links < "$document" | while IFS= read -r ref; do
      test -e "$document_dir/$ref" || {
        echo "missing bundled reference in $name: $document -> $ref" >&2
        exit 1
      }
    done
  done

  flattened=$(tr '\n' ' ' < "$file")
  if grep -qiE 'picker|structured choices|human-readable choices|Delete, Leave, or Promote' "$file"; then
    protocol='Investigate discoverable facts before asking. Every material choice uses the native picker: recommendation first, three genuine options by default or two when binary, one-sentence tradeoffs, and automatic `Other`. Without a native picker, render the same numbered options plus `Other`. Never ask a bare question. Batch only independent choices; ask dependent choices sequentially.'
    printf '%s\n' "$flattened" | grep -Fq "$protocol" || {
      echo "global choice protocol missing in $name" >&2
      exit 1
    }
    for phrase in 'Investigate discoverable facts before asking. Every material choice uses the native picker:' \
      'recommendation first' 'three genuine options by default or two when binary' \
      'one-sentence tradeoffs' 'automatic `Other`' 'Without a native picker' \
      'Batch only independent choices; ask dependent choices sequentially.'; do
      test "$(grep -Fc "$phrase" "$file")" = 1 || {
        echo "choice protocol must own generic mechanics exactly once in $name: $phrase" >&2
        exit 1
      }
    done
  fi
  if grep -nE 'Without a picker|three real options|Use three options by default|rely on automatic `Other`|include `Other`|explain (each|both) (option|options).*one sentence' "$file"; then
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
      printf '%s\n' "$flattened" | grep -Fqi 'At true lifecycle close, skip the path-only handoff and issue the disposition choice instead.' || {
        echo "artifact handoff does not distinguish downstream use from lifecycle close in $name" >&2
        exit 1
      }
      printf '%s\n' "$flattened" | grep -qiE 'downstream consumer.*return only|while .* still needs .*return only' || {
        echo "artifact path-only handoff lacks a downstream-consumer guard in $name" >&2
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
  actual_types=$(declaration_values "$skills/skills/$writer" type)
  test "$actual_types" = "$expected_type" || {
    echo "artifact type ownership drift in $writer: $actual_types" >&2
    exit 1
  }
done

for method in bulletproof demolition revolver triple-check; do
  actual_methods=$(declaration_values "$skills/skills/$method" method)
  test "$actual_methods" = "$method" || {
    echo "inspection method ownership drift in $method: $actual_methods" >&2
    exit 1
  }
done
for method in revolver triple-check; do
  method_text=$(tr '\n' ' ' < "$skills/skills/$method/SKILL.md" | tr -s ' ')
  for phrase in 'A substantive run requires that artifact.' \
    'An explicit no-write or chat-only request conflicts with this method.' \
    'Never write against the refusal'; do
    printf '%s\n' "$method_text" | grep -Fq "$phrase" || {
      echo "$method does not honor an explicit no-write conflict: $phrase" >&2
      exit 1
    }
  done
done
grep -Fq 'Skip targeted code-path tracing without an explicit three-pass request.' \
  "$skills/skills/triple-check/SKILL.md" || {
  echo "triple-check overlaps targeted dissection" >&2
  exit 1
}
for phrase in 'is already the independent reviewer: execute here and do not dispatch again.' \
  'Any Blocked row: Request changes or Defer. Never offer either acceptance option.' \
  'Never offer plain Accept.' 'Keep this as one contiguous GFM table:'; do
  grep -Fq "$phrase" "$skills/skills/sus-review/SKILL.md" || {
    echo "sus-review state or fallback contract missing: $phrase" >&2
    exit 1
  }
done
grep -Fq 'Make the first body line exactly: `Advocacy exercise, not evidence.`' \
  "$skills/skills/demolition/SKILL.md" || {
  echo "demolition quarantine banner missing" >&2
  exit 1
}

for phrase in '**Verification:**' '**Implementation proof:**' \
  'No claim set or assessment is required.' 'Create no artifact solely for this mode.' \
  'Verification stops when every claim is assessed.' \
  'Implementation proof stops when every required run has one complete command record.'; do
  grep -Fq "$phrase" "$skills/skills/bulletproof/SKILL.md" || {
    echo "bulletproof mode boundary missing: $phrase" >&2
    exit 1
  }
done
grep -Fq 'Never create a sidecar.' "$skills/skills/disrespec/SKILL.md" || {
  echo "disrespec may author an evidence receipt" >&2
  exit 1
}
if grep -Fq 'Move dominating raw output' "$skills/skills/disrespec/SKILL.md"; then
  echo "disrespec still owns evidence receipt creation" >&2
  exit 1
fi
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
