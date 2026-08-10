# Execution

Suspec ships no custom agents. Give a native worker or human a spec, or a task when the spec was split,
by explicit absolute path.

```text
Read ~/.agents/artifacts/shop-api/spec-checkout.md and implement AC-001.

Read ~/.agents/artifacts/shop-api/task-checkout-expiry.md and do what it says.
```

A task adds slice scope, excluded areas, verification, and standing instructions. A change plan may
add wave or preservation context. Neither replaces the spec.

Before changing behavior, define the strongest available observable check. A bug fix starts by
reproducing the original failure. Trust a new regression test only when it fails for the expected
reason on the original state, passes on the repair, exercises production behavior, and invents no
requirement.

## Separation

- The author defines intent and decomposition.
- The implementer changes code without changing requirements.
- An independent reviewer assesses the result without editing the target.
- The orchestrator dispatches methods and applies supported fixes.
- The human owns material decisions and acceptance.

The author may review only when they did not implement. Read-only subagent or research output is
evidence to inspect, not implementation to merge.

## Isolation

Parallel workers need isolated file state. Review needs the judged state preserved until final.
Branches and worktrees remain project-owned Git practice; Suspec does not create or clean them.

Inspect the current worktree before allocating another. Reuse project-native lanes when ownership,
branch, state, and dependency identity are proven. Implementation on `main` requires project or
human authority. Never clean a dirty, unknown, or externally owned worktree.

Worktrees are not force fields. They do not isolate services, ports, databases, or credentials.
Configure those separately.
Exclude worktree directories from tools that ignore `.gitignore`, including test runners and linters,
to prevent duplicate tests and phantom errors.

## Campaign controls

`sus-campaign` writes a stable goal contract and points to one project-native progress ledger. The
ledger owns tasks, dependencies, assignments, pull requests, and status. The campaign artifact owns
the objective, authorities, restart loop, blockers, and completion contract. Never copy mutable
progress into both.

Every pickup rereads the campaign and its authorities, reconciles live state, repairs ledger drift,
and continues the highest-priority dependency-ready work. Counts, branch SHAs, current pull-request
state, and lane occupancy belong in the live systems that own them, not the goal.

Suspec's campaign contract is advisory. Project commands provide deterministic local enforcement.
Harness permissions provide isolated authority by keeping protected state, resources, and credentials
outside worker reach.

Before allocating lanes or dispatching implementation, prove project-native control of lane
ownership, proportionate verification, machine-wide heavyweight admission, pull-request shape and
size, bounded review, exact-state proof, merge admission, and cleanup. Record each owner, class,
mechanism, and negative check in the native campaign ledger. Instructions and worker self-attestation
do not qualify.

Hosted status checks are optional. Exact-state local command evidence is valid when the project gate
accepts it. If a required capability is absent, stop dependent autonomy; let a human supply the
control, execute the affected transition, or cancel.

## Return

Record under the source spec's `## Execution`, or in the task when split:

- every verification as passed or blocked;
- decisive output once, or a stable evidence-receipt link;
- changed and out-of-scope files;
- blocked questions;
- findings;
- useful delegation provenance: sources, loaded guide, worker identity, and isolation mode.

A claim such as `Tests passed` is still a claim. Use pasted output, a labeled CI URL, or a named manual
observation. Task CI evidence starts with `CI:` or `CI link:`. Missing evidence becomes
`Unverified`.

The implementer may fix defects found during self-review. Self-review cannot manufacture
independence or a human decision. Keep the judged tree available until review and follow-up finish.

Next: [review](08-reviewing-output.md). Previous: [tasks](06-creating-tasks.md).
