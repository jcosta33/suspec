# Drift

Drift matters while work is live: the implementation, evidence, or scope no longer agrees
with the intent being reviewed.

## Common forms

- requirement text changed after evidence was captured
- the named Verify command changed
- code under review changed after the reviewer reran it
- changed files moved outside the declared scope
- a task no longer matches its source spec
- a hand-maintained agent projection or generated fixture no longer matches its canonical source

## Reconcile live work

1. Stop using stale evidence.
2. Identify which source changed: intent, code, task scope, or canonical agent definition.
3. Update the live working artifact when intent changed, or fix the implementation when
   code drifted.
4. Rerun affected verification against the final state.
5. Review the revised state; do not carry forward an earlier result.

Suspec does not maintain a repository-wide spec baseline after close. Later work starts
from current code, tests, project decisions, and the new request. Old working artifacts do
not require review-on-touch maintenance.

Agent projections are different because they are shipped product output. Their canonical source
remains durable; a projection that no longer matches it is live drift and must be reconciled before
handoff.

Related: [lineage](lineage.md) · [reviewing output](../08-reviewing-output.md)
