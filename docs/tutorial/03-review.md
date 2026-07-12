# Review

This page produces an independent review packet reconciled against the spec. The reviewer
did not implement the change and reruns the requirement's Verify command.

## 1. Create and human-finalize the packet

Have an independent agent draft the evidence and findings, then have the human reviewer fill
the Result cells, status, waivers, and suggested decision. Place the packet beside the other
native working artifacts:

```text
~/.claude/notes/shop-api/checkout-expiry-review.md
```

````markdown
---
type: review
id: REVIEW-checkout-expiry
pr: none yet
reviewer: you
status: pass
---

# Review: Expired checkout session returns 409

## Summary

The implementation checks expiry before charging and returns
`409 SESSION_EXPIRED` without a charge side effect.

## Changed files

- `src/checkout/expiry.ts`
- `src/api/errors.ts`
- `test/integration/expired-session.test.ts`

## Requirement coverage

| ID | Result | Evidence | Human attention |
| --- | --- | --- | --- |
| AC-001 | Pass | `npm run test:integration -- expired-session` -> `Tests: 3 passed, 3 total` | yes |

```verify id=AC-001 cmd="npm run test:integration -- expired-session" result=pass
Tests: 3 passed, 3 total
```

## Human attention

1. Money path: confirm the expiry response occurs before any charge call.

## Suggested decision

Merge after the owner inspects the money-path note.
````

The reviewer records `Pass` only after rerunning the command against the code being
judged. Empty or stale evidence means `Unverified`.

## 2. Run the deterministic floor

This review names no task because no split occurred:

```bash
suspec check ~/.claude/notes/shop-api/checkout-expiry-review.md \
  --spec ~/.claude/notes/shop-api/checkout-expiry-spec.md
```

The structured `verify` command must match the spec's `Verify with:` value. The checker
reports packet facts and a severity level; it does not approve the change. Without the
CLI, apply the same checks by hand: full requirement coverage, independent evidence,
changed files, routed exceptions, and a human-owned decision.

Next: [Close](04-close.md).
