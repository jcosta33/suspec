# Docs

> **Superseded model — [ADR-0137](adrs/0137-personal-harness-transient-artifacts.md).** This page still describes the committed
> workspace / board / `.suspec/` layout. Suspec artifacts are now transient personal working
> files under `~/.claude/state/<repo-name>/`, never committed to any repo; durable value is
> promoted to ADRs, tests, issues, and PR digests. Where this page conflicts with
> [ADR-0137](adrs/0137-personal-harness-transient-artifacts.md), the ADR wins. Rewrite pending.


The numbered happy path, in order:

1. [What is Suspec?](01-what-is-suspec.md) - the workflow and its artifacts.
2. [The basic workflow](02-basic-workflow.md) - the loop, step by step.
3. [Where files live](03-where-files-live.md) - the workspace, the code repo, retention.
4. [Writing specs](04-writing-specs.md) - intent, requirements, and `Verify with:`.
5. [Brownfield work and change plans](05-brownfield-and-change-plans.md) - inventory and change plans, when needed.
6. [Creating tasks](06-creating-tasks.md) - the split slice, cut only for parallel work.
7. [Running agents](07-running-agents.md) - worktrees, run summaries, evidence.
8. [Reviewing output](08-reviewing-output.md) - coverage, exceptions, the merge gate.
9. [Saving findings](09-saving-findings.md) - Close, promotion, retrieval.
10. [Integrations](10-integrations.md) - tools, CLI/MCP, boundaries.

Then go deeper:

- [Tutorial](tutorial/README.md) - walk one small change end to end.
- [Examples](examples/README.md) - complete Suspec chains.
- [Reference](reference/) - the deep layer: checks, step bars, artifact formats, glossary.
- [Adopting Suspec](ADOPTING.md) - set up a workspace.
