# Artifact formats

Every Suspec file is markdown with frontmatter.

The `type:` field identifies the artifact. Kind is read from frontmatter, never from the
filename or location — where the files live is your choice
([where files live](../03-where-files-live.md)).

## Live-work records

| Type | ID prefix |
| --- | --- |
| `intake` | none |
| `spec` | `SPEC-` |
| `task` | `TASK-` |
| `review` | `REVIEW-` |

## Structural-work records

| Type | ID prefix |
| --- | --- |
| `inventory` | `INV-` |
| `change-plan` | `CHANGE-` |

## Other skill outputs

| Type | Use |
| --- | --- |
| `audit` | present-state risk or debt |
| `bug-report` | diagnosis of one defect |
| `adr` | decision record |
| `research` | inquiry with sources, no decision |
| `prd` | product requirements |
| `rfc` | proposal for review |
| `threat-model` | security analysis |
| `release-note` | shipped-change note |

## Intake

Frontmatter:

```yaml
type: intake
source: SHOP-4012
url: https://...
captured: 2026-06-20
```

Body: verbatim source text.

No interpretation.

## Spec

Frontmatter:

```yaml
type: spec
id: SPEC-checkout
title: Expired checkout sessions
status: draft
owner: checkout-team
sources:
  - intake/SHOP-4012.md
```

Required sections:

- Intent
- Requirements

Add `Non-goals`, `Open questions`, `Affected areas`, `Dropped from sources`, or `Execution`
only when the section carries information. A deferred decision keeps the spec `draft` and
blocks dependent execution.

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
  its `Verify with:` line
- Scope
- Do not change
- Affected areas
- Verify
- Agent instructions
- Findings
- Run summary
- Self-review

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
pr: https://...
reviewer: name-or-session
decision: pending
# waivers: [AC-002]          # required when an accepted review waives unsupported/unverified rows
```

A review reconciles against the **spec**, always passed explicitly via `--spec <path>` on
the check call ([ADR-0143](../adrs/0143-path-agnostic-check-cli-contract.md)): with
`task:`, coverage keys on the spec's ACs the task scoped (the task's `scope:` list); with
no `task:` (1:1, no task), on the whole spec. A task, when present, only
scopes and indexes evidence — it is never the review's target. The review's frontmatter
never names its own spec; only `task:` is read and validated by the checker.

`Requirement coverage` is required. Add `Changed files`, `Findings`, `Open decisions`,
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

`Supported` needs evidence. The agent writes assessments and leaves `decision: pending`.
After a state-aware human picker, the selected decision is written as `accepted`,
`changes-requested`, or `deferred`. Accepted reviews list every waived `Unsupported` or
`Unverified` requirement ID under `waivers`.

## Inspection

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

Name large receipts `evidence-<slug>.md`. Each record has a stable `E-NNN` anchor and:

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
