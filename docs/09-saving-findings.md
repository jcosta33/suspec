# Saving findings

Findings are either ephemeral or durable. Ephemeral findings - surprises and issues the reviewer
should see - ride the review packet's `Findings` section and die with it. Durable lessons outlive
the work, and they go where your harness will actually read
them again:

A durable lesson becomes a native memory only when the harness provides a memory surface.
Use that surface's documented API or convention; do not invent a memory file. Record one
claim with its evidence and boundaries under a searchable title. Suspec adds no parallel
findings store. If no native memory exists, or the lesson belongs to the team, use the
project's own channels — an issue, ADR, test, or maintained documentation — or leave the
task-local observation ephemeral.

Save a lesson when it will matter again. Do not save task-local scratch.

Use `remember` for this route. It stores one verified lesson through native memory when available,
or sends team-facing residue to the project's own channel. It creates no Suspec memory store.

## What counts

Good candidates for a durable memory:

- a behavior that surprised the worker or reviewer
- a project constraint not already documented
- a risky edge case
- a test or fixture fact future work needs
- a recurring implementation pattern
- a known non-goal or boundary

Poor candidates:

- routine command output
- temporary debugging notes
- one-off local setup
- speculation with no evidence

## The shape of a memory

One claim, its evidence, its boundaries:

```markdown
# Expired checkout sessions are 409

Expired checkout sessions return `409 SESSION_EXPIRED`, not a 5xx.

Evidence: `test/integration/expired-session.test.ts`; confirmed in the
checkout-expiry review, AC-001.

Applies to checkout session expiry. Does not apply to other checkout
validation failures or non-checkout sessions.
```

Write it in whatever format your harness's memory surface uses — the discipline is the
claim + evidence + searchable title, not a file format (level: convention).

## Memory hygiene

Agent-authored content is a claim, not a fact. Keep the memory surface honest
(level: convention):

- a memory states what was **verified**, not what was assumed
- an agent-authored claim names its evidence, so a future reader can re-check it
- a memory contradicted by current reality is corrected or deleted, not left to mislead

A finding without evidence is an opinion.

## What belongs somewhere else

Some discoveries have a better home than your memory:

- intended behavior that must outlive the change -> a test, public contract, ADR, or maintained documentation
- a decision with tradeoffs -> an ADR, through the project's own process
- a defect or team-facing lesson -> an issue
- behavior worth locking in -> a test
- a term definition -> the project's glossary

A finding does not weaken a requirement. During live work, reconcile a contradiction
between the finding, the working spec, and the code before review closes.

## Close the working files

After every finding and severe issue is accounted for, confirm no downstream step still needs the
working artifacts. Present one structured choice covering every artifact and sidecar: Delete,
Leave, Promote, or Other. Delete only after selection. Leave keeps the current neutral paths. Promote
sanitizes and moves the set into a selected project-owned durable destination, repairs references,
validates, and never pushes implicitly. This picker is the handoff; do not return only artifact
links or claim Close. The agent selects no option; inaction is not Leave. Create no disposition
record or lifecycle state.

## Retrieval

Retrieval behavior belongs to the harness and varies by product. Use only a supported
memory surface, and name memories for the words a future reader is likely to search.

## Related

- Next: [Integrations](10-integrations.md)
- Previous: [Reviewing output](08-reviewing-output.md)
