---
type: task
id: TASK-{{slug}}
source:
  - SPEC-{{slug}}
  # - CHANGE-{{slug}}   (when the work executes a change-plan wave)
scope: [AC-001, AC-002]
status: ready
---

# Task: {{title}}

## Source

- Spec: `specs/{{feature}}/spec.md` (SPEC-{{slug}})
- {{Change plan: `change-plans/{{slug}}.md` (CHANGE-{{slug}}) — if any}}

## Scope

Implement or preserve:

- AC-001 — {{one line}}
- AC-002 — {{one line}}

## Do not change

- {{areas explicitly out of bounds}}

## Affected areas

- `{{path}}`

## Verify

- [ ] `{{test-or-command}}` (AC-001)
- [ ] `{{test-or-command}}` (AC-002)

## Agent instructions

1. Read the source spec (and change plan, if any) first.
2. Stay inside this task's scope. If a requirement can't be met as written,
   stop and say why instead of improvising.
3. Run every Verify item and paste the real output — a claim without output
   counts as unverified.
4. Before finishing, re-read your own diff as a skeptic: what would a
   reviewer flag?
5. Leave a summary: changed files, commands run with output, and anything
   learned worth saving as a finding.

## Findings

<!-- Anything durable discovered during the task — moved to findings/ at Close. -->
