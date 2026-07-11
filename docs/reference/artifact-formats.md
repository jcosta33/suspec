# Artifact formats

Every Suspec file is markdown with frontmatter.

The `type:` field identifies the artifact. Kind is read from frontmatter, never from the
filename or location — where the files live is your choice
([where files live](../03-where-files-live.md)).

## Core types

| Type | ID prefix |
| --- | --- |
| `intake` | none |
| `spec` | `SPEC-` |
| `task` | `TASK-` |
| `review` | `REVIEW-` |

## Conditional types

| Type | ID prefix |
| --- | --- |
| `inventory` | `INV-` |
| `change-plan` | `CHANGE-` |

## Advanced types

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

Sections:

- Intent
- Non-goals
- Requirements
- Open questions
- Affected areas
- Dropped from sources, when needed
- Execution — append-only run record, one dated entry per change-cycle

Each requirement has:

- `AC-NNN`
- one behavior
- `Verify with:`

`## Execution` holds the run record. An entry may be prose or a structured change-record carrying
`Scope`, `Coverage` (AC→evidence), and `Pins` (`reviewed-sha:` + `evidence-hash:`) — see
[ADR-0110](../adrs/0110-execution-change-record.md).

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

- Source
- Scope
- Do not change
- Affected areas
- Verify
- Agent instructions
- Findings
- Run summary
- Self-review, when the packet carries one

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
status: draft
```

A review reconciles against the **spec**, always passed explicitly via `--spec <path>` on
the check call ([ADR-0143](../adrs/0143-path-agnostic-check-cli-contract.md)): with
`task:`, coverage keys on the spec's ACs the task scoped (the task's `scope:` list); with
no `task:` (1:1, no task), on the whole spec. A task, when present, only
scopes and indexes evidence — it is never the review's target. The review's frontmatter
never names its own spec; only `task:` is read and validated by the checker.

Sections:

- Summary
- Review plan, for a lead-orchestrated review
- Candidate findings, for a multi-lens review (optional)
- Changed files
- Requirement coverage
- Change-plan coverage, when relevant
- Human attention
- Open decisions, when relevant
- Task status
- Suggested decision

Coverage rows use:

```text
ID | Result | Evidence | Human attention
```

Results:

- `Pass`
- `Fail`
- `Unverified`
- `Blocked`

A `Pass` needs evidence.

## Finding

Findings are not a standalone artifact — there is no `finding` type, no `FINDING-` id, no
file to write. Ephemeral findings ride the review packet's Candidate findings section
(above) and die with it. A durable finding becomes a native harness memory instead — one
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
- Risks

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
- Code can falsify a spec; it does not amend it.

## Related

- [Checks](checks.md)
- [Basic workflow](../02-basic-workflow.md)
- [Where files live](../03-where-files-live.md)
- [Reviewing output](../08-reviewing-output.md)
