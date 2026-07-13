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

Treat that as a claim. Inspect changed files and rerun every applicable command.

## Review

`~/.agents/artifacts/shop-api/checkout/session-refactor-review.md`:

````markdown
---
type: review
id: REVIEW-checkout-session-refactor
task: TASK-checkout-session-refactor
pr: none yet
decision: changes-requested
---

## Changed files

- `src/checkout/session.ts`
- `src/checkout/payment.ts`
- `src/retry.ts`
- related tests

## Requirement coverage

| ID     | Assessment  | Evidence                                                               |
| ------ | ----------- | ---------------------------------------------------------------------- |
| AC-001 | Supported   | `npm run test:integration -- active-session` -> `1 passed`             |
| AC-002 | Unsupported | `npm run test:integration -- expired-session` -> expected 409, got 500 |
| AC-003 | Supported   | `npm run test:integration -- missing-session` -> `1 passed`            |
| AC-004 | Supported   | `npm run test:integration -- provider-failure` -> `1 passed`           |

## Change-plan coverage

| ID     | Assessment | Evidence                                                   |
| ------ | ---------- | ---------------------------------------------------------- |
| PG-001 | Supported  | `npm run test:integration -- active-session` -> `1 passed` |

```verify id=AC-001 cmd="npm run test:integration -- active-session" result=pass
1 passed
```

```verify id=AC-002 cmd="npm run test:integration -- expired-session" result=fail
expected 409
received 500
```

```verify id=AC-003 cmd="npm run test:integration -- missing-session" result=pass
1 passed
```

```verify id=AC-004 cmd="npm run test:integration -- provider-failure" result=pass
1 passed
```

## Findings

1. AC-002 fails: expired sessions return 500.
2. Charge ordering changed on a money path.
3. `src/retry.ts` is outside the task's affected areas.
````

Check both companions:

```bash
suspec check ~/.agents/artifacts/shop-api/checkout/session-refactor-review.md \
  --spec ~/.agents/artifacts/shop-api/checkout/spec.md \
  --task ~/.agents/artifacts/shop-api/checkout/session-refactor-task.md
```

The packet may be structurally clean while correctly requesting changes. The checker reports facts;
the human decision answers a different question.

The implementer fixes AC-002 within scope, removes the retry edit, and records fresh output. A fresh
reviewer replaces AC-002 only after rerunning proof:

```markdown
| ID     | Assessment | Evidence                                                    |
| ------ | ---------- | ----------------------------------------------------------- |
| AC-002 | Supported  | `npm run test:integration -- expired-session` -> `1 passed` |
```

Rerun the explicit check after the final review edit. Earlier output is stale. Preserve the verified
expired-session regression lesson through native memory when useful, then
[close the complete transient set](../03-where-files-live.md#close).
