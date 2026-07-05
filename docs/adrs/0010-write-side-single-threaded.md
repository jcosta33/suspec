# ADR 0010: Write-side single-threading

## Status

Accepted

## Context

Parallel autonomous writers collide on merges, violating determinism and bypassing coherent review narratives.

## Decision

Parallelism is acceptable on **read paths** / research; writes that land in one branch must serialize through orchestration (**Lead Engineer** pattern) unless human explicitly forks work with merge policy.

Encoded in recursion limits and orchestration semantics (`docs/concepts/10-subagent-strategy.md`).

> **Forward note (2026-07-05).** The `docs/concepts/10-subagent-strategy.md` path referenced above has
> no live target — that doc was never created in this repo. The decision (writes serialize through
> orchestration) stands on its own; the review-orchestration semantics live in the ADR ledger
> ([ADR-0099](./0099-review-orchestration-and-role-routing.md), [ADR-0132](./0132-revolver-rotating-refine-loop.md)).

## Consequences

- Positive: merges stay reviewable; fewer conflict-induced silent behaviour changes.
- Negative: throughput cap — tackled via batching orchestration waves, not uncontrolled agents.
