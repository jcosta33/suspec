# Tutorial

Walk one fictional feature through spec, implementation, review, and cleanup. No grand tour, just the
whole loop:

> A checkout session older than 30 minutes must return `409 SESSION_EXPIRED`, never a 5xx.

The artifacts are valid; `shop-api` code and commands are illustrative. Use a real repository for
executable evidence.

1. [Write the spec](01-pull-and-spec.md)
2. [Implement](02-task-and-run.md)
3. [Review](03-review.md)
4. [Close](04-close.md)

This case earns a spec and deterministic check, but no task. One requirement going to one worker is
not a decomposition problem.

Prerequisites: [install Suspec](../ADOPTING.md), choose a repository, and use an agent or human worker.
