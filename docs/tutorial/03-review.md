# Review

Run `sus-review` in an independent context. It reruns the requirement command, drafts assessments,
asks the human for the decision, and writes:

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

| ID     | Assessment | Evidence                                                                    |
| ------ | ---------- | --------------------------------------------------------------------------- |
| AC-001 | Supported  | `npm run test:integration -- expired-session` -> `Tests: 3 passed, 3 total` |

```verify id=AC-001 cmd="npm run test:integration -- expired-session" result=pass
Tests: 3 passed, 3 total
```
````

Check the taskless review:

```bash
suspec check ~/.agents/artifacts/shop-api/checkout-expiry-review.md \
  --spec ~/.agents/artifacts/shop-api/checkout-expiry-spec.md
```

The structured command must match the spec. Empty or stale evidence is `Unverified`. The checker
reports facts. The human gets `decision: accepted`.

Next: [close](04-close.md).
