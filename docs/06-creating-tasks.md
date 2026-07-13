# Creating tasks

A task packet is the **split slice** — cut only when a spec has multiple independently
dispatchable parallel/context slices, including separately dispatchable sequenced waves in a
change plan. Size alone does not create a task. For the common 1:1 case there is no
packet: the implementer works from the source and fills its `## Execution` section.

A task does not add requirements. It always copies a scope subset from a source spec. A change
plan may add wave and preservation context, but it never replaces that spec.

Task packets are files like any other Suspec artifact: written by `sus-task`,
placed in the agent-neutral workspace per the [placement rule](03-where-files-live.md),
and dispatched by explicit path — the packet names its spec by absolute path, and the
dispatch prompt names the packet by absolute path. `suspec check <task-path>` validates its
frontmatter, required sections, Verify evidence, and closed-state blockers
(level: enforced — suspec-cli).

## Task shape

```markdown
---
type: task
id: TASK-checkout-expiry
source:
  - SPEC-checkout
scope: [AC-001]
status: ready
---

# Task: Expired checkout session returns 409

## Source

- Spec: `/Users/you/.agents/artifacts/shop-api/spec-checkout.md`
- Source commit: `3f2c9ab`
- Change plan: `/Users/you/.agents/artifacts/shop-api/change-checkout.md` (when this task executes a wave)

### Requirement snapshot

#### AC-001 - Expired sessions return `409 SESSION_EXPIRED`

Expired checkout sessions must return `409 SESSION_EXPIRED` before any charge call.

Verify with: `npm run test:integration -- expired-session`

## Scope

- AC-001 - Expired sessions return `409 SESSION_EXPIRED`.

## Do not change

- `sessions` table schema

## Affected areas

- `src/checkout/`
- `test/integration/`

## Verify

- [ ] `npm run test:integration -- expired-session` (AC-001)

## Agent instructions

One slice's standing instructions — scope, evidence rules, when to stop and ask.

## Findings

- None yet.

## Run summary

- Status: not started
- Changed files: none
- Verify evidence: not run
- Scope drift: none
- Blocked questions: none

## Self-review

- [ ] Every changed file is in Affected areas or listed as an exception.
- [ ] AC-001 has fresh Verify evidence after the final edit.
- [ ] Findings and blocked questions are recorded; no review decision was issued.
```

The full shape is documented in [artifact formats](reference/artifact-formats.md).

## Scope

Keep scope small.

Good tasks:

- cover one behavior or one wave
- name exact requirement ids
- have a clear write surface
- have runnable verification
- can be reviewed without reading a huge diff

Use separate slices when the source already defines independently dispatchable work:

- a change plan has waves with distinct checkpoints and rollback boundaries
- a prerequisite refactor must land before a behavior change
- parallel or per-context work has disjoint write surfaces
- one behavior must be implemented and verified independently in several repositories or platforms

## Do not change

`Do not change` is the scope wall.

Name tempting adjacent areas:

- schemas
- public APIs
- payment code
- auth rules
- generated files
- unrelated modules

A changed `Do not change` path is a review exception, even if the change looks harmless.
And give the wall its escape hatch: a worker blocked by a frozen path stops and asks — never
edits past it. A preliminary study found the wall-plus-hatch form cuts violations far more
than a bare prohibition alone ([[IMPOSSIBLE]](research/sources.md#IMPOSSIBLE)).

## Verify

Every scoped requirement needs a verify item.

Each verify item:

- names the command
- names the requirement id
- is runnable by the worker or explicitly manual

Manual verification names who observed what.

## Parallel tasks

Parallel tasks need disjoint write surfaces.

If two tasks write the same file, serialize them or split differently.

## Multi-repo tasks

Prefix affected areas with the repo name:

```text
api: src/checkout/**
web: app/checkout/**
```

Each repo still needs its own verification command.

## Findings

The worker records candidate findings — surprises, risks, adjacent issues — here as they
surface during implementation, not in the run summary.

A durable lesson becomes a native memory; an ephemeral one rides the packet and dies with
it ([saving findings](09-saving-findings.md)).

## Run summary

The worker fills the run summary after implementation.

It records:

- changed files
- Verify evidence cited from the `## Verify` section without duplicating its output
- out-of-scope edits
- blocked questions

The summary points to evidence. It does not replace evidence.

## Related

- Next: [Running agents](07-running-agents.md)
- Previous: [Brownfield work and change plans](05-brownfield-and-change-plans.md)
