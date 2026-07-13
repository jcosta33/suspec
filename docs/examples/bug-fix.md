# Example: bug fix

Goal: fix a defect with the least ceremony that still proves it, escalating only when
the fix surprises you.

## Bug

```text
PAY-88

Retrying a payment after a timeout can double charge the customer.
```

## The trivial path: one line, no file

A fix this small doesn't earn a spec file. The "spec" is one line, inline in the
task dispatch or your own working note:

> Fix: a payment retry after a timeout, with the same idempotency key, must not create a
> second charge. Verify with `npm run test:integration -- payment-timeout-retry`.

Implement it, reproduce the bug, then paste both runs — red before green, not just the
final green:

```text
npm run test:integration -- payment-timeout-retry
1 failed before the fix
1 passed after the fix
```

That's the whole loop at this size: no spec file, no task file, no review packet. The
code plus the red-then-green run is the evidence.

## When it escalates

Say the fix turns out to touch more than the ticket implied — reproducing the double
charge means changing the idempotency lookup itself, not just the retry path, and that
lookup is shared with settlement reconciliation. A blast radius wider than the ticket is
the signal to escalate, not a blanket rule that bugs always need a spec.

### Working spec

Write a working spec for the wider change, e.g.
`~/.agents/artifacts/payments-api/payments-spec.md`.

Add:

```markdown
### AC-003 - Retry is idempotent after timeout

When a payment request times out and the client retries with the same idempotency key,
the payment service must not create a second charge.

Verify with: `npm run test:integration -- payment-timeout-retry`
```

Non-goal:

```markdown
- No change to idempotency-key format.
```

One requirement and one worker do not earn a task split. The implementer works from the
spec's absolute path and records changed files, red-before-green output, and blocked questions
under `## Execution`.

### Review

`~/.agents/artifacts/payments-api/payment-timeout-retry-review.md`

````markdown
---
type: review
id: REVIEW-payment-timeout-retry
pr: none yet
decision: pending
---

## Requirement coverage

| ID | Assessment | Evidence |
| --- | --- | --- |
| AC-003 | Supported | `npm run test:integration -- payment-timeout-retry` -> failed before fix, passed after fix |

```verify id=AC-003 cmd="npm run test:integration -- payment-timeout-retry" result=pass
1 passed
```

## Findings

1. Money path: inspect retry path and idempotency lookup before merge.
````

Check it:

```bash
suspec check ~/.agents/artifacts/payments-api/payment-timeout-retry-review.md \
  --spec ~/.agents/artifacts/payments-api/payments-spec.md
```

This exits clean: the coverage row, evidence, spec command, and matching `verify` block agree. It
would exit blocking if AC-003 were marked `Supported` with an empty evidence cell. The human still
decides whether the money-path finding permits acceptance.

### Close

The idempotency-lookup sharing was worth remembering. Use `remember` to route it to native memory:

```markdown
## Payment timeout retries reuse the idempotency record, not a new charge

Verified: `test/integration/payment-timeout-retry.test.ts` and
`npm run test:integration -- payment-timeout-retry` -> failed before, passed after.

Applies to: payment timeout retry handling.
Does not apply to: retries with a different idempotency key.
```

Once the spec and review have no downstream consumer, present one disposition choice covering
both files:

1. **Delete (recommended)** — the durable lesson is already saved.
2. **Leave** — keep the transient files for near-term reuse.
3. **Promote** — move selected files into a project-owned durable destination.
4. **Other** — state another disposition for the complete set.

Execute the human selection.

## Lesson

Start at one line. Escalate only when the fix surprises you — a wider blast radius than
the ticket implied is the signal, not a policy that says every bug needs a spec.
