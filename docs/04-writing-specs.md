# Writing specs

A spec states intended behavior when structured intent will change execution or review.
For trivial work, state intent and verification inline.

## Minimum shape

```markdown
---
type: spec
id: SPEC-checkout
title: Expired checkout sessions
status: ready
owner: checkout-team
sources:
  - SHOP-4012
---

# Expired checkout sessions

## Intent

Reject expired checkout sessions without converting an expected client condition into a
server failure.

## Requirements

### AC-001 - Expired session returns 409

When a checkout session is older than 30 minutes, the API must return
`409 SESSION_EXPIRED` and must not return a 5xx.

Verify with: `npm run test:integration -- expired-session`
```

`Intent` and `Requirements` are required. Add `Non-goals`, `Open questions`, `Affected
areas`, `Dropped from sources`, or `Execution` only when each section carries information.

## Requirement rules

Each requirement has a stable `AC-NNN` ID, states one behavior, names its actor or system,
uses a binding word, and ends with `Verify with:`. Keep uncertainty out of requirements.

## Decision gate

Investigate discoverable facts before asking. Resolve reversible, convention-bound details.
For material behavior, public contracts, security tradeoffs, costly choices, conflicting
authority, or irreversible actions, use the harness picker: recommendation first, three
genuine options by default, two for binary choices, one-sentence tradeoffs, and `Other`.
Without a picker, render the same numbered choices plus `Other`. Never ask a bare question.

Batch only independent decisions. Record unresolved decisions under `Open questions`, keep
the spec `draft`, and block dependent work. `ready` means no blocking decision or unresolved
marker remains; C007 enforces that floor.

## Optional sections

- `Non-goals`: likely scope confusion, its boundary, and the stop condition.
- `Open questions`: only unresolved material decisions with choices and recommendation.
- `Affected areas`: only when file or subsystem boundaries constrain execution.
- `Dropped from sources`: source intent deliberately excluded, with reason.
- `Execution`: current run evidence when no task split exists.

## Structured SOL form

Plain Markdown is the default. Set `format: sol` for stricter EARS-like clauses. Do not mix
plain requirement headings with SOL blocks. See [structured requirements](reference/structured-requirements.md).

## Related

- Next: [Brownfield work and change plans](05-brownfield-and-change-plans.md)
- Previous: [Where files live](03-where-files-live.md)
