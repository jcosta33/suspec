# Saving findings

Findings come in two lifetimes. Ephemeral findings — surprises, candidate issues,
things the reviewer should see — ride the review packet's Candidate findings section
when the review is multi-lens, or its Human attention section otherwise, and die with
it. Durable lessons outlive the work, and they go where your harness will actually read
them again:

A durable lesson becomes a native memory: write it the way your harness records memories
(a memory file, CLAUDE.md, whatever your runner provides), one claim per memory, the
evidence attached, under a searchable title. Suspec adds no parallel findings store — if
the lesson belongs to the team rather than to you, raise it through the project's own
channels (an issue, an ADR, a test).

Save a lesson when it will matter again. Do not save task-local scratch.

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

- intended behavior -> spec amendment
- a decision with tradeoffs -> an ADR, through the project's own process
- a defect or team-facing lesson -> an issue
- behavior worth locking in -> a test
- a term definition -> the project's glossary

A finding does not weaken a requirement. If the finding contradicts the spec, reconcile
the spec.

## Retrieval

Retrieval is your harness's job — its memory surface is indexed and loaded by the
runner itself, which is exactly why the lesson goes there. Help it: name memories for
the words a future reader will search.

## Related

- Next: [Integrations](10-integrations.md)
- Previous: [Reviewing output](08-reviewing-output.md)
