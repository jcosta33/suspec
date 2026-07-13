# Specs

Use `sus-spec` when structured intent will change execution or review. State trivial work inline.

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

Reject expired checkout sessions without converting an expected client condition into a server
failure.

## Requirements

### AC-001 - Expired session returns 409

When a checkout session is older than 30 minutes, the API must return
`409 SESSION_EXPIRED` and must not return a 5xx.

Verify with: `npm run test:integration -- expired-session`
```

`Intent` and `Requirements` are required. Add `Non-goals`, `Open questions`, `Affected areas`,
`Dropped from sources`, or `Execution` only when they carry information.

## Requirements

Each requirement:

- has a stable `AC-NNN` ID;
- states one observable behavior;
- names its actor or system;
- uses a binding word;
- ends with one `Verify with:` line;
- contains no unresolved uncertainty.

Resolve discoverable facts and reversible conventions. Put unresolved material decisions under
`Open questions`, keep the spec `draft`, and block dependent work. `ready` means no blocking
decision or unresolved marker remains. C007 enforces that floor; C021 rejects a missing or empty
`Intent`.

Plain Markdown is the default. Set `format: sol` only for the
[structured SOL form](reference/structured-requirements.md); do not mix SOL and plain requirement
syntax.

Exact frontmatter and optional sections: [artifact formats](reference/artifact-formats.md).

Next: [inventories and change plans](05-brownfield-and-change-plans.md). Previous:
[artifact location and close](03-where-files-live.md).
