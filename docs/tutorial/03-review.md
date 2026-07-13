# Review

This page produces an independent review packet reconciled against the spec. The reviewer
did not implement the change and reruns the requirement's Verify command.

## 1. Create and human-finalize the packet

Run `sus-review` in an independent context to draft evidence, findings, and assessments. Then present the human
decision picker and write the selection. Place the packet in the agent-neutral workspace:

```text
~/.agents/artifacts/shop-api/checkout-expiry-review.md
```

````markdown
---
type: review
id: REVIEW-checkout-expiry
pr: none yet
reviewer: you
decision: accepted
---

# Review: Expired checkout session returns 409

## Changed files

- `src/checkout/expiry.ts`
- `src/api/errors.ts`
- `test/integration/expired-session.test.ts`

## Requirement coverage

| ID | Assessment | Evidence |
| --- | --- | --- |
| AC-001 | Supported | `npm run test:integration -- expired-session` -> `Tests: 3 passed, 3 total` |

```verify id=AC-001 cmd="npm run test:integration -- expired-session" result=pass
Tests: 3 passed, 3 total
```

````

The reviewer records `Supported` only after rerunning the command against the code being
judged. Empty or stale evidence means `Unverified`.

## 2. Run the deterministic floor

This review names no task because no split occurred:

```bash
suspec check ~/.agents/artifacts/shop-api/checkout-expiry-review.md \
  --spec ~/.agents/artifacts/shop-api/checkout-expiry-spec.md
```

The structured `verify` command must match the spec's `Verify with:` value. The checker
reports packet facts and a severity level; it does not approve the change. Without the
CLI, apply the same checks by hand: full requirement coverage, independent evidence,
changed files, routed exceptions, and a human-owned decision.

Next: [Close](04-close.md).
