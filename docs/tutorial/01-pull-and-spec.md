# Write the spec

Source request:

```text
SHOP-4012 - Stale checkout sessions return 500s
Reporter: Priya N. (Support)
Priority: High
Labels: checkout, api

When a customer leaves checkout open for a while and then tries to pay,
the API sometimes throws a 500 instead of reporting session expiry.

A checkout session older than 30 minutes must return
409 SESSION_EXPIRED, never a 5xx.
```

Use `sus-spec` or write the format directly. This tutorial places it at:

```text
~/.agents/artifacts/shop-api/checkout-expiry-spec.md
```

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
- When: a request acts on a checkout session older than 30 minutes
- Then: the API MUST respond `409 SESSION_EXPIRED`, never a 5xx
- Verify with: `npm run test:integration -- expired-session`

## Affected areas

- `src/checkout/`
```

Check it:

```bash
suspec check ~/.agents/artifacts/shop-api/checkout-expiry-spec.md
```

Without the CLI, verify `status: ready`, unique `AC-001`, the three requirement items, exactly one
binding word in `Then`, and only useful optional sections. Empty ceremony still counts as empty.

Next: [implement](02-task-and-run.md).
