# Bug fix

```text
PAY-88

Retrying a payment after a timeout can double charge the customer.
```

## Inline path

> Fix: a payment retry after a timeout, with the same idempotency key, must not create a second
> charge. Verify with `npm run test:integration -- payment-timeout-retry`.

Reproduce before and after:

```text
npm run test:integration -- payment-timeout-retry
1 failed before the fix
1 passed after the fix
```

This local fix needs no artifact. The bug is enough paperwork.

## Escalation

The idempotency lookup is also shared by settlement reconciliation. That wider blast radius earns a
working spec at `~/.agents/artifacts/payments-api/payments-spec.md`:

```markdown
### AC-003 - Retry is idempotent after timeout

When a payment request times out and the client retries with the same idempotency key,
the payment service must not create a second charge.

Verify with: `npm run test:integration -- payment-timeout-retry`

## Non-goals

- No change to idempotency-key format.
```

One requirement and one worker still need no task. Record changed files, red-before-green output, and
blockers under the spec's `## Execution`.

## Review

`~/.agents/artifacts/payments-api/payment-timeout-retry-review.md`:

````markdown
---
type: review
id: REVIEW-payment-timeout-retry
pr: none yet
decision: pending
---

## Requirement coverage

| ID     | Assessment | Evidence                                                                                   |
| ------ | ---------- | ------------------------------------------------------------------------------------------ |
| AC-003 | Supported  | `npm run test:integration -- payment-timeout-retry` -> failed before fix, passed after fix |

```verify id=AC-003 cmd="npm run test:integration -- payment-timeout-retry" result=pass
1 passed
```

## Findings

1. Money path: inspect retry path and idempotency lookup before merge.
````

```bash
suspec check ~/.agents/artifacts/payments-api/payment-timeout-retry-review.md \
  --spec ~/.agents/artifacts/payments-api/payments-spec.md
```

The checker validates coverage, evidence, and command consistency. It does not decide whether a
money-path finding is acceptable. The human does.

Preserve the verified shared-lookup lesson through native memory when useful. Then
[close the transient set](../03-where-files-live.md#close).
