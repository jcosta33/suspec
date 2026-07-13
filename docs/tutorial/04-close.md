# Close

Close starts after the human accepts the review decision. It does not produce another
Suspec artifact.

## 1. Decide whether anything is durable

The review surfaced one reusable lesson: expired checkout sessions are an expected client
case, not a server outage. Use `remember` to record the lesson through a supported native memory
surface:

```markdown
## Expired checkout sessions return 409, not a 5xx

Verified by `test/integration/expired-session.test.ts` and
`npm run test:integration -- expired-session`.

Applies to: checkout session expiry.
Does not apply to: other checkout validation failures or non-checkout sessions.
```

Do not invent a memory file when the harness has no memory surface. Route a team-facing
lesson through the project's own issue, ADR, test, or maintained documentation instead.

## 2. Close the transient artifacts

The spec and review have served their live-work purpose. Present one structured choice covering
both files and any evidence sidecars:

1. **Delete** - remove the transient set.
2. **Leave** - keep it under the agent-neutral workspace.
3. **Promote** - choose a project-owned durable destination, sanitize private content, move the
   files, repair references, and validate.
4. **Other** - state another disposition for the complete set.

Recommend the choice supported by the work: delete exhausted scratch, leave files needed for a
known continuation, promote durable project truth. The user selection controls the action.
The agent selects nothing; inaction is not Leave. Do not return only links or claim Close when this
choice is due. Promotion never pushes implicitly, and no choice creates lifecycle state or cleanup
machinery.

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
