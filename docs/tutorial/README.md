# Tutorial: first loop

> **Superseded model — [ADR-0137](../adrs/0137-personal-harness-transient-artifacts.md).** This page still describes the committed
> workspace / board / `.suspec/` layout. Suspec artifacts are now transient personal working
> files under `~/.claude/state/<repo-name>/`, never committed to any repo; durable value is
> promoted to ADRs, tests, issues, and PR digests. Where this page conflicts with
> [ADR-0137](../adrs/0137-personal-harness-transient-artifacts.md), the ADR wins. Rewrite pending.


Walk one small change through Suspec:

```text
Pull -> Spec -> (Task) -> Run -> (Review) -> Close
```

You will create:

- `intake/checkout-expiry.md`
- `specs/checkout/spec.md`
- `tasks/checkout-expiry.md`
- a task run summary
- `reviews/checkout-expiry.md`
- `findings/session-expiry-is-409.md`
- an updated `status.md`

This tutorial includes a task packet so you can see the split-work artifact. For
small 1:1 work, you can run directly from the spec and record `## Execution`
there.

## Scenario

Requirement:

> A checkout session older than 30 minutes must return `409 SESSION_EXPIRED`, never a 5xx.

This uses the fictional `shop-api` from the examples. The Suspec artifacts are real; the code and test command are illustrative.

Run the same loop on your own repo for executable proof.

## Pages

1. [Pull and Spec](01-pull-and-spec.md)
2. [Task and Run](02-task-and-run.md)
3. [Review](03-review.md)
4. [Close](04-close.md)

## Prerequisites

- a Suspec workspace from [Adopting Suspec](../ADOPTING.md)
- an agent or human worker
- a code repo for your real run
