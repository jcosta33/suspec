# Artifact formats

Every Suspec artifact is Markdown with frontmatter. Evidence receipts and run notes are untyped
Markdown sidecars.

Sidecars live beside their governing artifact, link from it, and travel through handoff and close as
one absolute path set. A collision follows the same stop rule as the primary artifact.

The `type:` field identifies the artifact. Kind is read from frontmatter, never from the
filename or location. Ordinary artifacts live under the agent-neutral
`~/.agents/artifacts/<workspace>/` root and move into a project only through explicit promotion
([where files live](../03-where-files-live.md)).

Only the artifact authors below create Suspec artifacts. When no downstream step needs the
transient set, the workflow requires one human disposition for every artifact and sidecar: Delete,
Leave, or Promote. Disposition is not frontmatter or lifecycle state.

## Types

| Type | Writer | Carries | ID prefix |
| --- | --- | --- | --- |
| `spec` | `sus-spec` | intent and verifiable requirements | `SPEC-` |
| `task` | `sus-task` | one dispatched source slice | `TASK-` |
| `review` | `sus-review` | requirement assessments and evidence | `REVIEW-` |
| `inventory` | `sus-inventory` | observed present-state structure | `INV-` |
| `change-plan` | `sus-change-plan` | a staged structural transformation | `CHANGE-` |
| `audit` | `sus-audit` | evidenced present-state risks | `AUDIT-` |
| `research` | `sus-research` | evidence for one decision-informing question | `RESEARCH-` |

No other `type:` value is a Suspec artifact. Project records such as issues, decision records,
product documents, and release documentation keep their project-native formats.

## Spec

Frontmatter:

```yaml
type: spec
id: SPEC-checkout
title: Expired checkout sessions
status: draft
owner: checkout-team
sources:
  - SHOP-4012
```

Required sections:

- Intent
- Requirements

Add `Non-goals`, `Open questions`, `Affected areas`, `Dropped from sources`, or `Execution`
only when the section carries information. A deferred decision keeps the spec `draft` and
blocks dependent execution.
Only a spec whose status is exactly `ready` can be dispatched or reviewed. A missing status,
`draft`, or any other value blocks both transitions.

Each requirement has:

- one `### AC-NNN` heading;
- one non-empty `- When:` condition;
- one non-empty `- Then:` observable obligation with exactly one binding word; and
- one `- Verify with:` method.

Use those three items once, in that order, with no other requirement-body line. Use `When: always`
only for an unconditional invariant.

`## Execution` holds changed files, verify output, scope drift, and blocked questions for
the live run. When work is split, those notes live in each task packet instead. Execution
notes are review input, not a durable append-only history.

## Task

Frontmatter:

```yaml
type: task
id: TASK-checkout-expiry
source:
  - SPEC-checkout
scope: [AC-001]
status: ready
```

Sections:

- Source — full spec path, source commit, and a verbatim snapshot of every scoped requirement block;
  when a change plan supplies wave or preservation context, name it here after the spec
- Scope
- Do not change
- Affected areas
- Verify
- Agent instructions
- Run order — dependency sequence plus non-empty `Starts after:` and `May run with:` values; use
  `None` explicitly
- Findings
- Run summary

Add `Self-review` when it carries useful pre-handoff checks.

Every verify item names a requirement id.

Checking a task requires its ready source spec through `--spec <spec-path>`. The task's `source:`
must name that spec. Several task paths may share one companion only when they share that source.

`status` is one of:

- `ready`
- `running`
- `review-ready`
- `closed`

## Review

Frontmatter:

```yaml
type: review
id: REVIEW-checkout-expiry
spec: SPEC-checkout
task: TASK-checkout-expiry   # omit for a 1:1 review with no task
pr: https://example.test/pull/123
reviewer: name-or-session
decision: pending
# waivers: [AC-002]          # required when an accepted review waives unsupported/unverified rows
```

A task is always spec-backed: `source` names the ready spec that owns every scoped requirement.
A change plan can add wave and preservation context, but it never replaces the source spec.

A review names the source spec in `spec:` and reconciles against that **spec**, always passed
explicitly via `--spec <path>` on
the check call: with
`task:`, coverage keys on the spec's ACs the task scoped (the task's `scope:` list); with
no `task:` (1:1, no task), on the whole spec. The checker rejects a `spec:` value that does not
match the handed spec's `id:`. A task, when present, only
scopes and indexes evidence — it is never the review's target. The review's frontmatter
names the source slice; it does not replace `spec:`.

The source spec must still be exactly `ready` when review begins. The review ID and
`Requirement coverage` section are required and non-empty. Add `Changed files`, `Findings`, `Open decisions`,
`Change-plan coverage`, or method notes only when they carry information.

The method requires `reviewer` to identify the fresh human or agent context. The CLI requires it as
a non-empty scalar but cannot prove independence; a name is provenance, not a force field.

Coverage is one contiguous GFM table. Use the exact header and place its delimiter immediately
after it. Keep every row together; structured `verify` blocks follow the table.

```markdown
| ID | Assessment | Evidence |
| --- | --- | --- |
| AC-001 | Supported | exact evidence |
```

Assessments:

- `Supported`
- `Unsupported`
- `Unverified`
- `Blocked`

The decision enum is `pending`, `accepted`, `changes-requested`, or `deferred`. The assessment
enum is exactly the four values above; any other option value is a blocking error. When present,
`Change-plan coverage` is parsed with the same columns and assessment enum. `Supported` needs
evidence in either table. The agent writes assessments and
leaves `decision: pending`. After a state-aware human picker, the selected decision is written as
`accepted`, `changes-requested`, or `deferred`. `waivers` is absent before acceptance. At acceptance,
when Unsupported or Unverified Requirement coverage rows exist, it lists exactly once every such
requirement ID and no others;
otherwise it is absent. `Supported` and `Blocked` rows are not waivable. An accepted review has no
non-empty `Open decisions` section and no `Blocked` assessment in requirement or change-plan
coverage. Resolve the dependency or defer the review. Every Change-plan coverage row must be
`Supported` before acceptance; requirement waivers cannot excuse a failed preservation guarantee.

C012 coverage reconciliation, C013 structured command binding, and waivers read Requirement
coverage only. C016 evidence and the accepted-review `Blocked` rule read both Requirement coverage
and Change-plan coverage.

## Evidence receipt

Evidence receipts are untyped sidecars. Name large receipts `evidence-<slug>.md`. Each record has a
stable `E-NNN` anchor and:

````markdown
<a id="E-001"></a>
## E-001

- Command: `pnpm test`
- Working directory: `/path/to/repo`
- State: `git:<commit-or-tree-id>`
- Exit: `0`

```text
untouched raw output
```
````

The governing artifact links the anchor and includes only the decisive verbatim excerpt. Review
checks resolve explicit local Markdown links with `E-NNN` fragments against the review's directory
and require the linked file to carry the matching HTML id anchor.
One receipt may support several claims when each claim names its evidence anchor.

## Run note

A run note is an untyped sidecar for raw round logs or execution detail that would dominate its
governing artifact. Name it for the run, keep raw records untouched, and link it from the artifact.
It carries no lifecycle status or independent verdict.

## Finding

Findings are not a standalone artifact — there is no `finding` type, no `FINDING-` id, no
file to write. Ephemeral findings ride the review packet's `Findings` section and die with
it. A durable personal lesson becomes native harness memory. A durable team fact enters a
human-selected project channel such as an issue, ADR, test, runbook, or maintained documentation.
Keep one claim, its evidence, a searchable title, and no assigned id ([memory](memory.md),
[saving findings](../09-saving-findings.md)).

## Inventory

Use before brownfield work.

Sections:

- Scope
- Observed structure
- Interfaces
- Tests
- Unknowns
- Observed constraints

No prescriptions.

## Audit

An audit records present-state findings, severity, and direct evidence. It does not invent intended
behavior or prescribe a change. Each finding must be independently checkable from the named source.

## Research

Research answers one decision-informing question with source-qualified findings, limitations, and
open uncertainty. It does not make the decision. Marketing claims, synthetic respondents, and
anecdotes remain labeled as such.

## Change plan

Use for structural work.

Sections:

- Baseline
- Target
- Preservation guarantees
- Transformation waves
- Cutover / rollback
- Task split

Every wave names verification.

## Reference rules

- IDs are stable.
- Accepted decisions are superseded, not rewritten.
- Requirement IDs are spec-scoped.
- Cross-spec references use `SPEC-id#AC-NNN`.
- During live work, code can falsify a working spec; reconcile the intent before close.

## Related

- [Checks](checks.md)
- [Basic workflow](../02-basic-workflow.md)
- [Where files live](../03-where-files-live.md)
- [Reviewing output](../08-reviewing-output.md)
