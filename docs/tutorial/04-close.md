# Close

Close starts after the human accepts the review decision. It does not produce another
Suspec artifact.

## 1. Decide whether anything is durable

The review surfaced one reusable lesson: expired checkout sessions are an expected client
case, not a server outage. If the harness provides native memory, record the lesson through
that supported surface:

```markdown
## Expired checkout sessions return 409, not a 5xx

Verified by `test/integration/expired-session.test.ts` and
`npm run test:integration -- expired-session`.

Applies to: checkout session expiry.
Does not apply to: other checkout validation failures or non-checkout sessions.
```

Do not invent a memory file when the harness has no memory surface. Route a team-facing
lesson through the project's own issue, ADR, test, or maintained documentation instead.

## 2. Let working artifacts remain transient

The spec and review stay wherever the harness placed them until they are no longer useful.
Suspec moves nothing and owns no cleanup lifecycle. Code, tests, project decisions, and a
supported native memory are the durable layers.

## What this walkthrough used

| Moment | Record |
| --- | --- |
| Intent | `checkout-expiry-spec.md` |
| Implementation evidence | spec `## Execution` |
| Review | `checkout-expiry-review.md` |
| Findings decision | native memory when supported; otherwise a project channel or nothing |

No task split, inventory, or change plan was needed. The work earned a spec and a checked
review; the remaining scaffold stayed out.

Use [brownfield work and change plans](../05-brownfield-and-change-plans.md) for structural
work.
