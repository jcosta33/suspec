# Close

Start only after review is `pass`, or an owner accepts a waiver.

Close does not produce a Suspec artifact. The spec, task, and review have already served
their purpose — they got you an evidenced, independently-checked decision. What close
adds is durable memory, and it costs one file write, in your own harness.

## 1. Save the finding, as a memory

Not every review teaches something worth remembering next time. This one does: the fix
reveals that expired checkout sessions are a distinct, expected case, not a server
error. Write it the way your harness records memories — a memory file, `CLAUDE.md`,
whatever your runner provides — one claim per memory, the evidence attached, under a
searchable title. Suspec adds no parallel findings store — if the lesson belongs to the
team rather than to you, raise it through the project's own channels (an issue, an ADR,
a test).

Illustrative entry, in whatever your harness's memory format is:

```markdown
## Expired checkout sessions return 409, not a 5xx

Verified: `npm run test:integration -- expired-session` -> 3 passed, 3 total
(checkout-expiry-review.md, AC-001)

Applies to: checkout session expiry.
Does not apply to: other checkout validation failures, non-checkout sessions.
```

## 2. Leave the rest where it landed

The spec, task, and review files stay wherever you placed them in step 1 — nothing
promotes, nothing moves, nothing gets deleted on a timer. If you want them gone once the
lesson is captured, delete them yourself; if you want them around as a record of how
this feature was decided, keep them. Either way, the code, the tests, and the memory you
just wrote are what other people and future sessions actually see.

## Artifact chain

| Step | Artifact |
| --- | --- |
| Spec | `checkout-expiry-spec.md` |
| Task | `checkout-expiry-task.md` |
| Implement | task `## Run summary` |
| Review | `checkout-expiry-review.md` |
| Close | a native memory entry — no new file in this scheme |

## What you skipped

No task split was strictly necessary — this is a one-worker feature, cut for the
tutorial only to show the shape. No inventory or change plan was needed because this is
one small feature, not structural work.

Use [brownfield work and change plans](../05-brownfield-and-change-plans.md) for
structural work.
