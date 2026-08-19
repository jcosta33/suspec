# Large PR review

A checkout refactor implements one split task backed by:

```text
~/.agents/artifacts/shop-api/checkout/spec.md
~/.agents/artifacts/shop-api/checkout/session-refactor-change-plan.md
~/.agents/artifacts/shop-api/checkout/session-refactor-task.md
```

The task scopes requirements and names the change plan for wave context. The spec remains requirement
authority. The worker claims:

```text
All checkout session behaviors preserved.
```

Treat that as a claim, because it is one. A non-implementer inspects changed files and reruns every
applicable command. No Suspec review file.

## Native judgment

Changed files:

- `src/checkout/session.ts`
- `src/checkout/payment.ts`
- `src/retry.ts`
- related tests

Command results:

```text
npm run test:integration -- active-session     -> 1 passed
npm run test:integration -- expired-session    -> expected 409, got 500
npm run test:integration -- missing-session    -> 1 passed
npm run test:integration -- provider-failure   -> 1 passed
```

AC-002 fails. Charge ordering changed on a money path. `src/retry.ts` is outside the task's affected
areas. Request changes on the PR. The implementer cannot accept.

```bash
suspec check ~/.agents/artifacts/shop-api/checkout/session-refactor-task.md \
  --spec ~/.agents/artifacts/shop-api/checkout/spec.md
```

The checker reports task and spec facts. Clean structure is not clean code.

The implementer fixes AC-002 within scope, removes the retry edit, and records fresh output. A fresh
reviewer reruns proof:

```text
npm run test:integration -- expired-session -> 1 passed
```

Earlier output is stale. Preserve the verified expired-session regression lesson through native memory
when useful, then [close the complete transient set](../03-where-files-live.md#close).
