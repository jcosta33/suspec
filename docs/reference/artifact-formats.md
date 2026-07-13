# Artifact formats

Every Suspec artifact is Markdown with frontmatter. Evidence receipts and run notes are untyped
Markdown sidecars.

The `type:` field identifies the artifact. Kind is read from frontmatter, never from the
filename or location. Ordinary artifacts live under the agent-neutral
`~/.agents/artifacts/<workspace>/` root and move into a project only through explicit promotion
([where files live](../03-where-files-live.md)).

Ordinary conversation and direct action create no Suspec artifact. Create one when the user requests
it or the applicable Suspec workflow requires it as a live input. When no downstream step needs the
transient set, the final consumer asks whether to delete, leave, promote, or choose `Other` for
every artifact and sidecar. Disposition is a human action, not frontmatter or lifecycle state, and
its picker replaces path-only handoff. The agent selects no option; inaction is not Leave.

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
| `inspection` | inspection method | one method applied to one target | none required |

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

- `AC-NNN`
- one behavior
- `Verify with:`

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

- Source — full spec path, source commit, and a verbatim snapshot of every scoped requirement plus
  its `Verify with:` line; when a change plan supplies wave or preservation context, name it here
  after the spec
- Scope
- Do not change
- Affected areas
- Verify
- Agent instructions
- Findings
- Run summary

Add `Self-review` when it carries useful pre-handoff checks.

Every verify item names a requirement id.

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
task: TASK-checkout-expiry   # omit for a 1:1 review with no task
pr: https://example.test/pull/123
reviewer: name-or-session
decision: pending
# waivers: [AC-002]          # required when an accepted review waives unsupported/unverified rows
```

A task is always spec-backed: `source` names the ready spec that owns every scoped requirement.
A change plan can add wave and preservation context, but it never replaces the source spec.

A review reconciles against the **spec**, always passed explicitly via `--spec <path>` on
the check call: with
`task:`, coverage keys on the spec's ACs the task scoped (the task's `scope:` list); with
no `task:` (1:1, no task), on the whole spec. A task, when present, only
scopes and indexes evidence — it is never the review's target. The review's frontmatter
never names its own spec; only `task:` is read and validated by the checker.

The source spec must still be exactly `ready` when review begins. The review ID and
`Requirement coverage` section are required and non-empty. Add `Changed files`, `Findings`, `Open decisions`,
`Change-plan coverage`, or method notes only when they carry information.

Coverage rows use:

```text
ID | Assessment | Evidence
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
coverage. Resolve the dependency or defer the review.

C012 coverage reconciliation, C013 structured command binding, and waivers read Requirement
coverage only. C016 evidence and the accepted-review `Blocked` rule read both Requirement coverage
and Change-plan coverage.

## Inspection

Compact implementation proof does not create an inspection artifact. It records the command,
numeric exit, and decisive raw output in the implementation handoff. Substantive Bulletproof,
Demolition, Revolver, and Triple-check runs use this artifact:

Frontmatter:

```yaml
type: inspection
method: bulletproof # bulletproof | demolition | revolver | triple-check
target: path-or-stable-identifier
mode: inspect       # optional; inspect | refine
```

An inspection records method output, not a ship verdict or lifecycle status. Substantive
runs always write one. Large evidence and round logs use adjacent sidecars. A Demolition
artifact opens with `Advocacy exercise, not evidence.`

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

The governing artifact links the anchor and includes only the decisive verbatim excerpt.
One receipt may support several claims when each claim names its evidence anchor.

## Run note

A run note is an untyped sidecar for raw round logs or execution detail that would dominate its
governing artifact. Name it for the run, keep raw records untouched, and link it from the artifact.
It carries no lifecycle status or independent verdict.

## Finding

Findings are not a standalone artifact — there is no `finding` type, no `FINDING-` id, no
file to write. Ephemeral findings ride the review packet's `Findings` section and die with
it. A durable finding becomes a native harness memory instead — one
claim, its evidence, a searchable title, no id assigned ([memory](memory.md),
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
