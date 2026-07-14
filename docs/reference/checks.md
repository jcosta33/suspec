# Checks

Checks catch common Suspec mistakes.

Use this page as a review checklist.

`suspec check` implements the deterministic subset. See the [CLI contract](cli.md) for commands,
companions, path resolution, and exits.

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
faces. `inventory`, `audit`, and `research` are recognized and return
`checked: false`. A missing or unknown type is a blocking usage error.

Each checked JSON report repeats its checked artifact `type` with `level`, `path`, and
`diagnostics`. An unchecked report repeats its type and carries `checked: false`. Only the optional
`(file set)` C002 report has no artifact type.

Frontmatter accepts one strict subset: an optional UTF-8 BOM; required opening and closing `---`;
top-level keys matching `[A-Za-z0-9_-]+`; string scalars; flat inline or block string lists; and
comments outside quotes. Strings are never coerced to booleans, numbers, or null. Duplicate keys,
malformed quotes or brackets, nesting, maps, multiline scalars, anchors, aliases, tags, empty list
heads, and scalar/list field-shape mismatches are blocking parse errors. Unknown extra keys are
allowed when they obey the subset.

Field shapes are exact: `type` and `id` are scalars on every recognized artifact; spec `sources`;
task `source` and `scope`; review `waivers`; and change-plan `sources` and `preserves` are lists.
Their other defined fields are scalars.
Declared option values are exact and case-sensitive. Spec status is `draft` or `ready`; optional
spec format is `sol`; task status, review decision, and coverage assessment use the closed sets
below. A present value outside its declared set is a blocking contract error.

## Core checks

| ID | Name | Check | Severity |
| --- | --- | --- | --- |
| C001 | `unique-ids` | Requirement IDs are unique within a file. | hard-error |
| C002 | `duplicate-id` | No other file checked in the same invocation uses the same frontmatter `id:`. Requirement IDs are spec-scoped. | hard-error |
| C003 | `verify-with` | Every requirement has a non-empty `Verify with:` or `VERIFY BY`. | hard-error |
| C004 | `one-strength-word` | Each obligation requirement uses at least one binding word; more than one flags a split candidate. SOL `INTERFACE` (`IF-`) is exempt because it is a declaration. | warning |
| C007 | `no-tbd-at-ready` | `status: ready` has no `TBD`, `TODO`, `???`, or blocking open question. | hard-error |
| C008 | `sources-named` | Frontmatter `sources:` names at least one origin. | warning |
| C009 | `broken-source-link` | Path-shaped source refs resolve against the spec's own directory (artifact-relative). Bare tracker IDs are exempt. | hard-error |
| C010 | `preserves-refs-resolve` | Change-plan `preserves:` entries resolve to requirements or `PG-NNN`; `SPEC-id#AC-NNN` refs resolve against the plan's sibling specs. | hard-error |
| C011 | `waves-present` | Migration, rewrite, and schema-change plans have waves with verify steps. | warning |
| C012 | `coverage` | Requirement coverage rows match the task scope and ready source spec. Change-plan coverage is outside C012. | warning |
| C013 | `verify-evidence-binding` | Structured `verify` blocks in Requirement coverage match the requirement command and row assessment — a **consistency** check (nothing re-runs the command). Change-plan coverage is outside C013. A command mismatch is blocking; the other faces stay advisory. | warning (command mismatch: hard-error) |
| C015 | `citation-resolves` | `[[KEY]]` citations resolve to anchors in the named `sources.md`, itself resolved against the spec's own directory. | warning |
| C016 | `supported-needs-evidence` | A `Supported` row with empty evidence is invalid. | hard-error |
| C019 | `malformed-requirement-heading` | A `###` heading shaped like a requirement id but with a lowercase split-suffix (`AC-004a`) — it parses as prose and silently vanishes from scope and coverage. | warning |
| C020 | `unresolvable-ref` | The review's `task:` ref does not resolve to the task packet handed via `--task` (the packet identifies as a different task, or none). | hard-error |
| C021 | `intent-present` | A spec has a non-empty `## Intent`. | hard-error |
| C022 | `task-shape` | Task type, non-empty ID/source/scope, field shapes, status, exactly-once required H2 sections, and non-empty dependency handoff match the contract. | hard-error |
| C023 | `task-evidence` | No evidence check runs at `ready` or `running`. At `review-ready` or `closed`, `## Verify` contains a numeric exit plus non-empty fenced raw output, a visible `CI:` or `CI link:` URL, or justified `n/a`. A fence is claim-only when its entire trimmed body matches <code>^(all )?(tests?&#124;checks?) (pass(ed)?&#124;succeeded)\.?$</code> case-insensitively. Any placeholder fence fails even beside valid output; visible placeholders fail case-insensitively. | hard-error |
| C024 | `closed-task-resolved` | A closed task contains no `TBD`, `TODO`, `???`, or non-empty canonical blocker labeled `Blocked questions:`, `Blocking:`, or `Open question (blocking):` after an unordered or ordered list marker; `none` and `n/a` are resolved. Fences and comments are excluded; inline code is live text. | hard-error |
| C025 | `spec-shape` | A spec has a non-empty ID, `draft` or `ready` status, exactly one `Intent` and `Requirements` section, and at least one parsed requirement. | hard-error |
| C026 | `evidence-receipt-resolves` | Explicit local Markdown evidence links with `E-NNN` fragments resolve artifact-relative to files carrying the matching HTML id anchor. | hard-error |
| C027 | `review-spec-ref` | The review's `spec:` ref matches the spec packet handed via `--spec`. | hard-error |

C005, C006, C014, and C017 are retired and never reused. C018 is reserved.

Notes:

- `AC-NNN` IDs are unique within a spec, not across files. Cross-spec references use `SPEC-id#AC-NNN`.
- A `Verify with:` command that does not exist yet is not a spec defect. The requirement is `Unverified` until evidence exists.
- Diff size remains reviewer judgment; no packet-size threshold is asserted.
- The review-packet checks run against the companions the reviewer hands the checker — the
  review is never checked shallowly by accident, because a missing required companion is a
  blocking usage error, not a silent skip. C012 keys on the task's declared `scope` when the
  review names a task, and on the spec's full requirement set when it doesn't. C027 always binds
  the review to the handed spec; C020 binds split reviews to the handed task. Comparing changed files with `Do not change` needs the live
  diff and remains a reviewer checklist item.
- References resolve artifact-relative everywhere. A spec citing a file two folders up writes
  the relative path from its own directory (`../../sources/sup-204.md`); no root is ever inferred.
- A task is dispatched, and any review begins, only when its source spec's status is exactly
  `ready`. Draft, missing, and unknown statuses are blocking; C012 and C013 therefore never use a
  draft exemption.

## Unnumbered review checks

The [core checks](#core-checks) above own every numbered rule. Reviews also enforce:

| Check | Rule |
| --- | --- |
| Review structure (unnumbered) | The source spec is exactly `ready`; review ID, spec ref, reviewer provenance, and `Requirement coverage` are non-empty; each coverage section uses one contiguous GFM table whose exact header is followed immediately by its three-column delimiter; decision and assessment values use their declared enums. `Change-plan coverage`, when present, uses the same shape. |
| `no-open-critical` | An accepted review has no non-empty `Open decisions` section. |
| `accepted-no-blocked` | An accepted review has no `Blocked` assessment in requirement or change-plan coverage; Blocked cannot be waived. |
| `accepted-change-plan-supported` | Every Change-plan coverage row is `Supported` before acceptance. |
| `accepted-waivers` | Requirement coverage only: `waivers` appears only at acceptance and, when needed, exactly equals the Unsupported and Unverified requirement IDs without duplicates; it is absent when there are no such rows. Supported and Blocked rows are not waivable. |

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

## SOL syntax

Specs with `format: sol` use SOL requirement openers and the same C checks listed above. The parser
also rejects malformed `QUESTION` headers. Suspec publishes no separate SOL check-code family.

See [structured requirements](structured-requirements.md) for the exact parsed syntax. Teams may
treat any warning as blocking by policy.

## Related

- [Structured requirements](structured-requirements.md)
- [Writing specs](../04-writing-specs.md)
- [Reviewing output](../08-reviewing-output.md)
- [Artifact formats](artifact-formats.md)
