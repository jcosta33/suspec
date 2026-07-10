# Examples

These examples show complete Suspec chains, each proportioned to its own risk.

Read in this order:

1. [Large PR review](large-pr-review.md) - review-first: the review packet does the work, not the worker's claim.
2. [Feature from ticket](feature-from-ticket.md) - the full spec -> optional split -> review -> check flow.
3. [Bug fix](bug-fix.md) - the trivial one-line-spec path, escalating only when the fix surprises you.

They are examples, not templates — the write-spec, split-work, implement-task,
review-output, and save-findings skills carry the actual shapes and the placement rule
(see [the tutorial](../tutorial/01-pull-and-spec.md) for that in full).

Each example places its Suspec artifacts beside the author's own working files, in a
folder named for the repo. For a one-worker feature there is no task packet: the run
records in the spec's own `## Execution` section instead
([creating tasks](../06-creating-tasks.md)).
