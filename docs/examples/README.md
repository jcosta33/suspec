# Examples

> **Superseded model — [ADR-0137](../adrs/0137-personal-harness-transient-artifacts.md).** This page still describes the committed
> workspace / board / `.suspec/` layout. Suspec artifacts are now transient personal working
> files under `~/.claude/state/<repo-name>/`, never committed to any repo; durable value is
> promoted to ADRs, tests, issues, and PR digests. Where this page conflicts with
> [ADR-0137](../adrs/0137-personal-harness-transient-artifacts.md), the ADR wins. Rewrite pending.


These examples show complete Suspec chains.

Read in this order:

1. [Large PR review](large-pr-review.md) - best example of review by exception.
2. [Feature from ticket](feature-from-ticket.md) - feature flow with a task packet.
3. [Bug fix](bug-fix.md) - spec amendment and regression evidence.

They are examples, not templates. Use the starter-kit templates for real files.

Each example cuts a task packet so you can see the split-work artifact — for the common 1:1 case
(one spec, one worker) there is no task file: the run records in the spec's `## Execution` section
instead ([creating tasks](../06-creating-tasks.md)).
