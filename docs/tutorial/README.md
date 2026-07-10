# Tutorial: first loop

Walk one small feature through Suspec:

```text
capture intent -> spec -> (task split) -> implement -> review -> close
```

This flow is proportioned to feature-sized work. A trivial fix earns a one-line inline
spec and no files at all — see [the bug-fix example](../examples/bug-fix.md) for that
shorter path.

You will produce:

- a spec, placed beside your own working files
- an optional task packet, so you can see the split-work artifact
- pasted verify evidence
- a review packet, checked against the spec (and the task, when one exists)
- a native memory, if the work taught something durable

This tutorial cuts a task packet on purpose, to show the split-work shape. For a
one-worker feature, skip that split and implement straight from the spec — record the
run under the spec's own `## Execution` section instead.

## Scenario

Requirement:

> A checkout session older than 30 minutes must return `409 SESSION_EXPIRED`, never a 5xx.

This uses the fictional `shop-api`. The Suspec artifacts are real; the code and test
command are illustrative.

Run the same loop on your own repo for executable proof.

## Pages

1. [Spec](01-pull-and-spec.md)
2. [Task and implement](02-task-and-run.md)
3. [Review](03-review.md)
4. [Close](04-close.md)

## Prerequisites

- the Suspec skill family installed in your harness — [Adopting Suspec](../ADOPTING.md)
- an agent or human worker
- a code repo for your real run

The `suspec` CLI sharpens the checks in steps 1 and 3, but every check keeps a by-hand
path — nothing here requires the tool.
