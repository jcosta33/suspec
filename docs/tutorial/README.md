# Tutorial: first loop

Walk one small feature through Suspec:

```text
intent -> spec -> implement -> review -> findings
```

The keys are intent, review, and findings. This feature earns a spec and a
deterministic check as scaffold. It does not earn a task split because one requirement
goes to one worker.

You will produce:

- a working spec in the agent-neutral artifact workspace
- pasted implementation evidence under the spec's `## Execution` section
- an independent review packet checked against the spec
- a native memory only when the work teaches a durable lesson and the harness supports it

## Scenario

Requirement:

> A checkout session older than 30 minutes must return `409 SESSION_EXPIRED`, never a 5xx.

This uses the fictional `shop-api`. The Suspec artifacts are real; the code and test
command are illustrative. Run the same loop on your own repo for executable evidence.

## Pages

1. [Spec](01-pull-and-spec.md)
2. [Implement](02-task-and-run.md)
3. [Review](03-review.md)
4. [Close](04-close.md)

## Prerequisites

- the Suspec skill family installed in your harness — [Adopting Suspec](../ADOPTING.md)
- an agent or human worker
- a code repository for a real run

The CLI sharpens the spec and review checks, but both keep a by-hand path.
