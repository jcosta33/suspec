# Review

This page produces a review packet, reconciled against the spec (and the task, since
this tutorial cut one).

Use a reviewer that did not implement the change — the review-output skill assumes
independence.

## 1. Create the packet

Place it beside the spec and task:

```text
~/.claude/notes/shop-api/checkout-expiry-review.md
```

```markdown
---
type: review
id: REVIEW-checkout-expiry
task: TASK-checkout-expiry
pr: none yet
reviewer: you
status: draft
---

# Review: Expired checkout session returns 409

## Summary

Checkout returned a 500 for a session older than 30 minutes instead of the expected 409.
The fix checks expiry before the charge call and returns `409 SESSION_EXPIRED` with no
side effect.

## Changed files

- `src/checkout/expiry.ts`
- `src/api/errors.ts`
- `test/integration/expired-session.test.ts`
```

For a one-worker feature with no task packet, omit the `task:` line entirely — do not
add a `spec:` field; the review's frontmatter never names its own spec. The review still
reconciles against the whole spec because `--spec` is always passed explicitly on the
`suspec check` call.

## 2. Add coverage

The task scope has one requirement, so the table has one row:

```markdown
## Requirement coverage

| ID | Result | Evidence | Human attention |
| --- | --- | --- | --- |
| AC-001 | Pass | `npm run test:integration -- expired-session` -> `Tests: 3 passed, 3 total` | yes |
```

This is `Pass` because evidence is present. If evidence is empty, the result is
`Unverified` — never `Pass`.

## 3. Spot-check

Record one green-row check — the reviewer reruns the command itself, rather than taking
the pasted output on faith:

```markdown
Spot-checked: AC-001 - reran `npm run test:integration -- expired-session`; output matched the evidence row.
```

For this fictional `shop-api`, the command is illustrative. In your repo, run it.

## 4. Route human attention

Checkout is a money path. Keep one attention item:

```markdown
## Human attention

1. Risky path: checkout validates the session before charging. Confirm the 409 path runs before any charge call.
```

## 5. Decide

```markdown
## Suggested decision

Merge. AC-001 passes with evidence. Review the money-path note before merging.
```

Set frontmatter:

```yaml
status: pass
```

## 6. Check it against the spec and task

```bash
suspec check ~/.claude/notes/shop-api/checkout-expiry-review.md \
  --spec ~/.claude/notes/shop-api/checkout-expiry-spec.md \
  --task ~/.claude/notes/shop-api/checkout-expiry-task.md
```

Companions are always explicit — pass `--task` only when a task packet actually exists;
for the one-worker path, pass `--spec` alone. Naming a companion that can't be found
exits blocking (2). This check exits blocking (2) if a `Pass` row carries no evidence, or
if the review's `task:` reference resolves to nothing. A `Pass` row backed only by the
free-form Evidence cell built above — like this one — draws an advisory warning (exit 1);
add a fenced `verify` block alongside the row to machine-confirm it and exit 0 clean:

````markdown
| AC-001 | Pass | `npm run test:integration -- expired-session` -> `Tests: 3 passed, 3 total` | yes |

```verify id=AC-001 cmd="npm run test:integration -- expired-session" result=pass
Tests: 3 passed, 3 total
```
````

The `cmd=` must match the spec's `Verify with:` command exactly; `result=` is `pass` or
`fail`. Or leave the row as-is to route to human attention.

By hand, without the CLI, check:

- Summary and Changed files are present
- one row for `AC-001`
- evidence cell has output
- spot-check recorded
- human-attention item names the risk
- reviewer is independent

Next: [Close](04-close.md).
