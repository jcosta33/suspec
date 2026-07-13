# Execution

Suspec ships no custom agents. A native harness worker or human implements a spec, or a task when the
spec was split, by explicit absolute path.

```text
Read /Users/you/.agents/artifacts/shop-api/spec-checkout.md and implement AC-001.

Read /Users/you/.agents/artifacts/shop-api/task-checkout-expiry.md and do what it says.
```

A task adds slice scope, excluded areas, verification, and standing instructions. A change plan may
add wave or preservation context. Neither replaces the spec.

## Separation

- The author defines intent and decomposition.
- The implementer changes code without changing requirements.
- An independent reviewer assesses the result without editing the target.
- The orchestrator dispatches methods and applies accepted fixes.
- The human owns material decisions and acceptance.

The author may review only when they did not implement. Scout or research output is evidence to
inspect, not implementation to merge.

## Isolation

Parallel workers need isolated file state. Review needs the judged state preserved until final.
Branches and worktrees remain project-owned Git practice; Suspec does not create or clean them.

Worktrees do not isolate services, ports, databases, or credentials. Configure those separately.
Exclude worktree directories from tools that ignore `.gitignore`, including test runners and linters,
to prevent duplicate tests and phantom errors.

## Return

Record under the source spec's `## Execution`, or in the task when split:

- every verification as passed or blocked;
- decisive output once, or a stable evidence-receipt link;
- changed and out-of-scope files;
- blocked questions;
- findings;
- useful delegation provenance: sources, loaded guide, worker identity, and isolation mode.

A claim such as `Tests passed` is not evidence. Use pasted output, a labeled CI URL, or a named manual
observation. Task CI evidence starts with `CI:` or `CI link:`. Missing evidence becomes
`Unverified`.

The implementer may fix defects found during self-review but cannot produce an independent assessment
or human decision. Keep the judged tree available until review and follow-up finish.

Next: [review](08-reviewing-output.md). Previous: [tasks](06-creating-tasks.md).
