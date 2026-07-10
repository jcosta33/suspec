# Spec

This page produces one file: a spec.

Scenario:

> A checkout session older than 30 minutes must return `409 SESSION_EXPIRED`, never a 5xx.

The `shop-api` command is illustrative. Use your own repo for a real run.

## 1. Capture intent

Start from whatever the ask actually says — a ticket, a Slack message, a line from a
human. Don't create an artifact for this; just keep the source text handy so the spec
can name it.

```text
SHOP-4012 - Stale checkout sessions return 500s
Reporter: Priya N. (Support)
Priority: High
Labels: checkout, api

When a customer leaves checkout open for a while and then tries to pay,
the API sometimes throws a 500 instead of telling them the session timed
out. Support can't tell these apart from real outages.

What we want: a checkout session older than 30 minutes must return
409 SESSION_EXPIRED, never a 5xx.
```

## 2. Write the spec

Use the write-spec skill (or write it by hand — the skill is the discipline, not a
requirement) to turn that ask into requirement text.

Place the file next to your own native artifacts — the same place you keep your plans,
notes, and memories for this work, in a folder named after the repo you are working on
(or wherever fits your harness best). You choose the exact spot; keep it out of the repo
unless the project's own governance says otherwise, and carry the file's full path
forward — every later step names artifacts by explicit path.

As one example of that choice, this walkthrough uses:

```text
~/.claude/notes/shop-api/checkout-expiry-spec.md
```

Your harness may put it somewhere else entirely — that's fine.

```markdown
---
type: spec
id: SPEC-checkout
title: Expired checkout sessions return 409
status: ready
owner: checkout-team
sources:
  - SHOP-4012
---

# Expired checkout sessions return 409

## Intent

Expired checkout sessions return a client-visible expiry response instead of a server error.

## Non-goals

- The 30-minute lifetime does not change.
- The `sessions` table schema does not change.
- Session creation and charging behavior do not change.

## Requirements

### AC-001 - Expired session returns 409

When a request acts on a checkout session older than 30 minutes, the API must respond
`409 SESSION_EXPIRED` and must not return a 5xx.

Verify with: `npm run test:integration -- expired-session`

## Open questions

- None.

## Affected areas

- `src/checkout/`
```

## 3. Lint it

```bash
suspec check ~/.claude/notes/shop-api/checkout-expiry-spec.md
```

This exits 0 on a clean spec. A ready spec with no requirements, a missing `Verify
with:`, or a leftover `TBD` reports a blocking row naming the gap; a thin `Non-goals` or
`Open questions` section reports a warning.

By hand, without the CLI, check the same things:

- `status: ready`
- one requirement: `AC-001`
- `Verify with:` exists
- non-goals bound scope

Next: [Task and implement](02-task-and-run.md).
