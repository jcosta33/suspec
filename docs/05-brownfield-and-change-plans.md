# Brownfield work and change plans

Use extra structure only when the work needs it.

The expanded loop:

```text
inventory -> spec -> change plan -> task split when needed -> implement -> review
```

`sus-inventory` writes the observed map; `sus-change-plan` writes the transformation contract.
Both are artifacts,
placed in the agent-neutral workspace per the
[placement rule](03-where-files-live.md), named by absolute path from then on. Lint the
change plan with `suspec check <path>` (level: enforced — suspec-cli); inventory has
no CLI check today — review it by hand (level: checklist).

## Inventory

Inventory maps current code. It does not prescribe changes.

Use it when:

- ownership is unclear
- behavior is undocumented
- tests are missing or misleading
- changes cross modules or repos
- the work touches risky code

Include:

- relevant files and modules
- observed behavior
- public interfaces
- existing tests
- unknowns
- observed constraints

Every structural claim needs a file or line reference.

## Change Plan

A change plan explains how to change code without losing behavior.

It adds transformation order, preservation guarantees, and rollback context to a source spec.
It does not own product requirements and cannot replace the spec behind a task packet or review.

Use it for:

- migrations
- rewrites
- schema changes
- broad refactors
- dependency upgrades
- performance work with staged rollout

Include:

- baseline state
- target state
- preservation guarantees
- waves
- verification per wave
- cutover and rollback notes

## Preservation guarantees

A preservation guarantee says what must not change.

Prefer existing requirement ids:

```yaml
preserves:
  - SPEC-checkout#AC-001
```

Use `PG-NNN` only for plan-local guarantees. If the guarantee describes lasting behavior,
encode it in the durable layer that owns it — usually a test, public contract, or ADR.

## Waves

Each wave must leave the codebase usable and verifiable.

When a wave becomes a task packet, the packet still names the source spec and scopes its
requirement IDs. The change plan is optional context for the wave and preservation guarantees.

Good waves:

- have a small write surface
- name commands to run
- avoid mixing refactor and behavior change
- make rollback understandable

## Review level

Review effort follows risk, not labels like greenfield or brownfield.

Increase review depth when work has:

- high diffusion across files or modules
- high churn areas
- security, data, payment, or public API impact
- migrations or destructive operations
- weak or missing tests

## Reconcile live drift

Suspec does not maintain a repository-wide spec baseline. During live work, if code or new
evidence contradicts the working spec, stop and decide which is wrong. Update the active
spec when intent changed; update the code when implementation drifted; record a project
decision through the project's normal channel when the choice must outlive the work.

After close, code and its durable project records are authoritative. A later change starts
from those current sources rather than reviving old working artifacts.

## When not to use this

Do not write inventory or a change plan for a small, local feature with clear code and
clear tests. Use the keys at the weight the work earns.

## Related

- Next: [Creating tasks](06-creating-tasks.md)
- Previous: [Writing specs](04-writing-specs.md)
