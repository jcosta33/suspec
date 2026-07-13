# Examples

These examples show complete Suspec chains, each proportioned to its own risk.

Read in this order:

1. [Large PR review](large-pr-review.md) - review by exception: the review packet does the work, not the worker's claim.
2. [Feature from ticket](feature-from-ticket.md) - spec -> implementation -> review -> check, without an unearned task split.
3. [Bug fix](bug-fix.md) - the trivial one-line-spec path, escalating only when the fix surprises you.

They are examples, not templates — `sus-spec`, `sus-task`, `sus-review`, and `remember`
carry the actual workflows, while native harness workers implement the change
(see [the tutorial](../tutorial/01-pull-and-spec.md) for that in full).

Each example places ordinary Suspec artifacts in the agent-neutral workspace, under a
folder named for the repo. For a one-worker feature there is no task packet: the run
records in the spec's own `## Execution` section instead
([creating tasks](../06-creating-tasks.md)).
