# Checks

Checks catch common Suspec mistakes.

Use this page as a review checklist.

`suspec check` implements the deterministic subset. It is an explicit-path checker: it discovers no
other primary artifacts or companions. C009 and C015 resolve references named by the checked spec;
C010 performs its documented bounded sibling-spec lookup for change-plan references.

```
suspec check <path>                                             # spec, task, or change plan
suspec check <review-path> --spec <spec-path>                  # review packet
suspec check <review-path> --spec <spec-path> --task <task-path> # split-task review
suspec check --contract                                         # the contract as JSON
```

Exit codes are the API: `0` clean · `1` warning · `2` blocking. A review packet always
needs `--spec`; `--task` is required iff the review names a `task:` (the task is a
split slice; a task-less 1:1 review reconciles spec-keyed, against the spec's
full requirement set). A missing required companion exits blocking naming the flag — the
strongest checks never silently degrade — and a `--task` the review never references is
refused as a wiring mistake. The human owns what blocks a merge.

## Honesty levels

| Level | Meaning |
| --- | --- |
| convention | expected practice; not checked |
| checklist | reviewer inspects it |
| toolable | a tool can check it |
| enforced | a shipped tool rejects it (blocking exit) |

This docs repo enforces nothing by itself.

## Artifact recognition

`type:` is required. `spec`, `task`, `review`, and `change-plan` have deterministic checker
faces. `inventory`, `audit`, `research`, and `inspection` are recognized and return
`checked: false`. A missing or unknown type is a blocking usage error.

Frontmatter accepts one strict subset: an optional UTF-8 BOM; required opening and closing `---`;
top-level keys matching `[A-Za-z0-9_-]+`; string scalars; flat inline or block string lists; and
comments outside quotes. Strings are never coerced to booleans, numbers, or null. Duplicate keys,
malformed quotes or brackets, nesting, maps, multiline scalars, anchors, aliases, tags, empty list
heads, and scalar/list field-shape mismatches are blocking parse errors. Unknown extra keys are
allowed when they obey the subset.

Field shapes are exact: spec `sources`; task `source` and `scope`; review `waivers`; and
change-plan `sources` and `preserves` are lists. Their other defined fields are scalars.
Declared option values are exact and case-sensitive. Spec status is `draft` or `ready`; optional
spec format is `sol`; task status, review decision, and coverage assessment use the closed sets
below. A present value outside its declared set is a blocking contract error.

## Core checks

| ID | Name | Check | Severity |
| --- | --- | --- | --- |
| C001 | `unique-ids` | Requirement IDs are unique within a file. | hard-error |
| C002 | `duplicate-id` | No other file checked in the same invocation uses the same frontmatter `id:`. Requirement IDs are spec-scoped. | hard-error |
| C003 | `verify-with` | Every requirement has a non-empty `Verify with:` or `VERIFY BY`. | hard-error |
| C004 | `one-strength-word` | Each obligation requirement uses at least one binding word; more than one flags a split candidate (advice, ADR-0126). SOL `INTERFACE` (IF-) is exempt — a signature declaration has no strength-word slot (ADR-0127). | warning |
| C007 | `no-tbd-at-ready` | `status: ready` has no `TBD`, `TODO`, `???`, or blocking open question. | hard-error |
| C008 | `sources-named` | Frontmatter `sources:` names at least one origin. | warning |
| C009 | `broken-source-link` | Path-shaped source refs resolve against the spec's own directory (artifact-relative). Bare tracker IDs are exempt. | hard-error |
| C010 | `preserves-refs-resolve` | Change-plan `preserves:` entries resolve to requirements or `PG-NNN`; `SPEC-id#AC-NNN` refs resolve against the plan's sibling specs. | hard-error |
| C011 | `waves-present` | Migration, rewrite, and schema-change plans have waves with verify steps. | warning |
| C012 | `coverage` | Requirement coverage rows match the task scope and ready source spec. Change-plan coverage is outside C012. | warning |
| C013 | `verify-evidence-binding` | Structured `verify` blocks in Requirement coverage match the requirement command and row assessment — a **consistency** check (nothing re-runs the command). Change-plan coverage is outside C013. A cmd-mismatch is **blocking** at check time (ADR-0129); the other faces stay advisory. | warning (cmd-mismatch: hard-error) |
| C015 | `citation-resolves` | `[[KEY]]` citations resolve to anchors in the named `sources.md`, itself resolved against the spec's own directory. | warning |
| C016 | `supported-needs-evidence` | A `Supported` row with empty evidence is invalid. | hard-error |
| C019 | `malformed-requirement-heading` | A `###` heading shaped like a requirement id but with a lowercase split-suffix (`AC-004a`) — it parses as prose and silently vanishes from scope and coverage. | warning |
| C020 | `unresolvable-ref` | The review's `task:` ref does not resolve to the task packet handed via `--task` (the packet identifies as a different task, or none) — coverage and evidence would key on the wrong slice, so a typo'd task ref must not silently pass. | hard-error |
| C021 | `intent-present` | A spec has a non-empty `## Intent`. | hard-error |
| C022 | `task-shape` | Task type, non-empty ID/source/scope, field shapes, status, and exactly-once required H2 sections match the contract. | hard-error |
| C023 | `task-evidence` | No evidence check runs at `ready` or `running`. At `review-ready` or `closed`, `## Verify` contains a numeric exit plus non-empty fenced raw output, a visible `CI:` or `CI link:` URL, or justified `n/a`; a claim-only fence and placeholders fail. | hard-error |
| C024 | `closed-task-resolved` | A closed task contains no `TBD`, `TODO`, `???`, or non-empty canonical blocker labeled `Blocked questions:`, `Blocking:`, or `Open question (blocking):` after an unordered or ordered list marker; `none` and `n/a` are resolved. | hard-error |

C005, C006, C014, and C017 are retired and never reused. C018 is reserved.

Notes:

- `AC-NNN` IDs are unique within a spec, not across files. Cross-spec references use `SPEC-id#AC-NNN`.
- A `Verify with:` command that does not exist yet is not a spec defect. The requirement is `Unverified` until evidence exists.
- The oversized-packet size band is specified-not-shipped (ADR-0097). Diff size is a reviewer judgment; no band is asserted.
- The review-packet checks run against the companions the reviewer hands the checker — the
  review is never checked shallowly by accident, because a missing required companion is a
  blocking usage error, not a silent skip. C012 keys on the task's declared `scope` when the
  review names a task, and on the spec's full requirement set when it doesn't; C020 applies
  only to task-referencing reviews. Comparing changed files with `Do not change` needs the live
  diff and remains a reviewer checklist item.
- References resolve artifact-relative everywhere. A spec citing a file two folders up writes
  the relative path from its own directory (`../../sources/sup-204.md`); no root is ever inferred.
- A task is dispatched, and any review begins, only when its source spec's status is exactly
  `ready`. Draft, missing, and unknown statuses are blocking; C012 and C013 therefore never use a
  draft exemption.

## Task and review packet checks

| Check | Rule |
| --- | --- |
| C022 `task-shape` | Required task frontmatter and sections have valid shapes. |
| C023 `task-evidence` | No evidence check at `ready`/`running`; at `review-ready`/`closed`, require numeric exit plus non-empty fenced raw output, a visible `CI:` or `CI link:` URL, or justified `n/a`. A fence is claim-only only when its entire trimmed body matches `^(all )?(tests?|checks?) (pass(ed)?|succeeded)\.?$` case-insensitively; claim-only fences and placeholders fail. |
| C024 `closed-task-resolved` | A closed task has no non-empty canonical blocker after an unordered or ordered list marker; `none` and `n/a` are resolved values. |
| Review structure (unnumbered) | The source spec is exactly `ready`; review ID and `Requirement coverage` are non-empty; decision and assessment values use their declared enums. `Change-plan coverage`, when present, is parsed with the same columns and assessment enum. |
| `no-open-critical` | An accepted review has no non-empty `Open decisions` section. |
| `accepted-no-blocked` | An accepted review has no `Blocked` assessment in requirement or change-plan coverage; Blocked cannot be waived. |
| `accepted-waivers` | Requirement coverage only: `waivers` appears only at acceptance and, when needed, exactly equals the Unsupported and Unverified requirement IDs without duplicates; it is absent when there are no such rows. Supported and Blocked rows are not waivable. |
| `verify-evidence-binding` | Requirement coverage only: structured evidence matches its requirement row and command. |

## Writing watchlist

These words are allowed only when the same line makes them checkable.

| Family | Examples | Better form |
| --- | --- | --- |
| subjective | robust, clean, simple, intuitive | state observable behavior |
| quality without measure | fast, secure, reliable | give threshold or named test |
| vague verbs | handle, support, improve | name actor, action, object |
| loopholes | where feasible, if practical | make it required or remove it |
| ambiguous qualifiers | significant, minimal | quantify |
| comparatives | better, faster | name baseline and margin |
| broad quantifiers | all, any, every, some | name the exact set |
| bundling | and, or, and/or | split requirements |
| vague references | it, this, above | name the thing |

## SOL checks

SOL-specific checks apply only to specs with `format: sol`.

The core C checks apply to both plain and SOL specs.

SOL-specific codes are the reference contract. Use `suspec check --contract` to confirm
which core checks are implemented in your installed version.

### Structure

| Code | Check |
| --- | --- |
| SOL-S001 | trigger without actor line |
| SOL-S002 | unknown block type or clause |
| SOL-S003 | actor line missing strength word |
| SOL-S004 | duplicate block ID |
| SOL-S005 | ID prefix does not match block type |
| SOL-S006 | `SHOULD` or `SHOULD NOT` lacks `BECAUSE` or `EXCEPT` |
| SOL-S007 | malformed header, including a `QUESTION` marker other than exact lowercase `[blocking]` or `[non-blocking]` |
| SOL-S008 | metadata or prose before first control line |
| SOL-S010 | unknown metadata field |
| SOL-S011 | recognized block type with no ID |
| SOL-S012 | required spec section missing or out of order |
| SOL-S013 | hidden control or homoglyph characters |
| SOL-S014 | required clause missing |

### Prose

| Code | Check |
| --- | --- |
| SOL-P001 | condition has no consequence |
| SOL-P002 | actor missing |
| SOL-P003 | strength word missing or lowercase |
| SOL-P004 | multiple behaviors in one clause |
| SOL-P005 | watchlist word without same-line criterion |
| SOL-P006 | undefined term |
| SOL-P007 | bare `MUST NOT` with no affirmative behavior |
| SOL-P008 | uncertainty left in requirement prose |
| SOL-P050 | pronoun has no unique antecedent |
| SOL-P051 | passive voice hides actor |
| SOL-P052 | sentence is too long |
| SOL-P053 | not present tense / active voice |
| SOL-P054 | decorative phrase adds no constraint |
| SOL-P055 | repeated context adds nothing |
| SOL-P056 | comparative has no baseline |
| SOL-P057 | term drifts from glossary |
| SOL-P058 | `SHALL` used as a strength word |

### Cross-reference

| Code | Check |
| --- | --- |
| SOL-M001 | actor, object, surface, or ID resolves nowhere |
| SOL-M002 | direct contradiction |
| SOL-M003 | `DEPENDS ON`, `IMPLEMENTS`, or `PRESERVES` reference missing |
| SOL-M004 | lower-authority file weakens higher-authority requirement |

### Verification

| Code | Check |
| --- | --- |
| SOL-V001 | requirement, constraint, invariant, or interface lacks `VERIFY BY` |
| SOL-V002 | `VERIFY BY` target does not resolve |
| SOL-V003 | evidence cannot observe the claim |
| SOL-V004 | support recorded against changed text or code |
| SOL-V005 | invalid result or lifecycle marker |
| SOL-V006 | interface not verified by contract check |
| SOL-V007 | lifecycle marker on wrong result |
| SOL-V008 | required binding has no result |
| SOL-V009 | unknown evidence type |
| SOL-V010 | manual or waived result lacks named human |
| SOL-V011 | evidence does not state what it exercised |

### Splitting

| Code | Check |
| --- | --- |
| SOL-O001 | parallel tasks write same files |
| SOL-O002 | dependency cycle |
| SOL-O003 | blocking question reaches task split |
| SOL-O004 | requirement lacks write/read scope |
| SOL-O005 | task writes outside scope |
| SOL-O006 | imported file duplicates policy requirement |
| SOL-O007 | requirement assigned to no task |
| SOL-O008 | requirement assigned to two implementing tasks |

## Severity split

Hard:

- C001, C002, C003, C007, C009, C010, C016, C020, C021, C022, C023, C024
- all SOL-S
- SOL-P001-SOL-P008
- all SOL-M
- SOL-V001, SOL-V002, SOL-V004-SOL-V010
- SOL-O001, SOL-O002, SOL-O003, SOL-O005, SOL-O007, SOL-O008

Warning:

- C004, C008, C011, C012, C013, C015, C019
- SOL-P050-SOL-P058
- SOL-V003, SOL-V011
- SOL-O004, SOL-O006

Teams may treat any warning as blocking by policy.

## Related

- [Structured requirements](structured-requirements.md)
- [Writing specs](../04-writing-specs.md)
- [Reviewing output](../08-reviewing-output.md)
- [Artifact formats](artifact-formats.md)
