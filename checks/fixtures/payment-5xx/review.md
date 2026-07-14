---
type: review
id: REVIEW-payment-5xx
spec: SPEC-payment-5xx
task: TASK-payment-5xx
pr: https://example.test/pr/641
reviewer: fixture-reviewer
decision: deferred
---

# Payment provider 5xx handling

## Changed files

- `server/src/payments/charge.ts`

## Requirement coverage

| ID | Assessment | Evidence |
|---|---|---|
| AC-001 | Supported | `at-most-one-capture ✓` — PR run #209 |
| AC-002 | Supported | `retries-once ✓` — PR run #209 |
| AC-003 | Unsupported | The implementation retries on the trigger AC-003 forbids. |

## Findings

- AC-002 and AC-003 require opposite behavior for the same trigger.

## Open decisions

- Resolve the requirement contradiction before acceptance.
