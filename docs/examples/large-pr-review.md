# Example: large PR review

Goal: review a broad agent-authored checkout refactor by requirement and exception,
without trusting either the worker summary or a green aggregate CI run.

## Situation

The PR implements one slice of a larger checkout spec. The working inputs already exist:

```text
~/.claude/notes/shop-api/checkout/spec.md
~/.claude/notes/shop-api/checkout/session-refactor-task.md
```

The task names its source spec, scoped requirements, affected areas, and `Do not change`
paths. The worker claims:

```text
All checkout session behaviors preserved.
```

The reviewer treats that sentence as a claim. They read the spec and task by full path,
inspect the actual changed files, and rerun every applicable Verify command against the
PR state.

## Review packet

Place the packet beside the reviewer's native working artifacts:

```text
~/.claude/notes/shop-api/checkout/session-refactor-review.md
```

````markdown
---
type: review
id: REVIEW-checkout-session-refactor
task: TASK-checkout-session-refactor
pr: none yet
decision: changes-requested
---

# Review: Checkout session refactor

## Summary

Active, missing, and provider-failure paths remain consistent with the spec. Expired
sessions now return 500 instead of `409 SESSION_EXPIRED`. The diff also touches
`src/retry.ts`, which lies outside the task's affected areas.

## Changed files

- `src/checkout/session.ts`
- `src/checkout/payment.ts`
- `src/retry.ts`
- related tests

## Requirement coverage

| ID | Assessment | Evidence |
| --- | --- | --- |
| AC-001 | Supported | `npm run test:integration -- active-session` -> `1 passed` |
| AC-002 | Unsupported | `npm run test:integration -- expired-session` -> expected 409, got 500 |
| AC-003 | Supported | `npm run test:integration -- missing-session` -> `1 passed` |
| AC-004 | Supported | `npm run test:integration -- provider-failure` -> `1 passed` |

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

1. AC-002 fails: expired sessions now return 500.
2. Checkout charge ordering changed on a money path.
3. `src/retry.ts` is outside the task's affected areas.

````

## Deterministic check

Pass both companions explicitly because this review covers a split task:

```bash
suspec check ~/.claude/notes/shop-api/checkout/session-refactor-review.md \
  --spec ~/.claude/notes/shop-api/checkout/spec.md \
  --task ~/.claude/notes/shop-api/checkout/session-refactor-task.md
```

The checker reconciles identities, coverage, evidence presence, and structured command
bindings. It does not convert the unsupported row into acceptance. A structurally clean
packet can still say "do not merge" because the human review decision and the check's
severity level answer different questions.

## Revise and review again

The implementer fixes the expired-session regression inside the same task scope, removes
the unrelated retry edit, and pastes the new output. The next reviewer reads the revised
state and replaces claims only when their own evidence supports them:

```markdown
| ID | Assessment | Evidence |
| --- | --- | --- |
| AC-002 | Supported | `npm run test:integration -- expired-session` -> `1 passed` |

Reran: AC-002 - expired-session integration test returned `1 passed`.
```

Run the same explicit check again after the final review edit. Earlier output is stale.

## Close

The regression is worth remembering because broad checkout CI did not expose it. Save a
native memory only if the harness provides one, and cite durable evidence:

```markdown
## Checkout refactors require the expired-session integration case

Verified by `test/integration/expired-session.test.ts` and
`npm run test:integration -- expired-session`.

Applies to: checkout session state refactors.
Does not apply to: changes outside checkout session handling.
```

## Lesson

The packet was an index, not proof. Independent reruns exposed a failed requirement, a
risky path, and an out-of-scope edit that the worker summary and aggregate CI did not
make reviewable.
