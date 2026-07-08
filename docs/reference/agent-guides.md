# Agent guides

> **Superseded model — [ADR-0137](../adrs/0137-personal-harness-transient-artifacts.md).** This page still describes the committed
> workspace / board / `.suspec/` layout. Suspec artifacts are now transient personal working
> files under `~/.claude/state/<repo-name>/`, never committed to any repo; durable value is
> promoted to ADRs, tests, issues, and PR digests. Where this page conflicts with
> [ADR-0137](../adrs/0137-personal-harness-transient-artifacts.md), the ADR wins. Rewrite pending.


Agent guides are optional instruction packs.

The spec is the contract; a task packet narrows it when work is split.

## Kit core

The starter kit's core loop guides. `write-spec` → `implement-task` → `save-findings` cover the
mandatory **spec → run → close** triad; `review-output` is the review step, layered on whenever code
ships ([ADR-0134](../adrs/0134-self-contained-spine.md)):

| Guide | Use |
| --- | --- |
| `write-spec` | write or amend specs (Spec) |
| `implement-task` | run a spec or split task packet (Run) |
| `review-output` | review worker output (Review — whenever code ships) |
| `save-findings` | record findings, update the board (Close) |

## Kit authoring guides

Also kit-shipped (Suspec-coupled → the kit, [ADR-0112](../adrs/0112-two-tier-skills.md)) — install only what the workspace uses:

| Guide | Use |
| --- | --- |
| `write-audit` | present-state audit |
| `write-inventory` | brownfield inventory |
| `write-change-plan` | structural change plan |
| `write-research` | source-backed inquiry |
| `write-bug-report` | defect diagnosis |
| `write-prd` | product requirements |
| `write-rfc` | proposal |
| `spec-check` | spec review |
| `split-work` | task decomposition |

## Implementation depth (opt-in)

Kit skills that implement Suspec work of a given kind — Suspec-coupled, summoned as the work needs them:

| Guide | Use |
| --- | --- |
| `write-feature` | net-new behavior |
| `write-fix` | a reproduced defect, root cause |
| `write-refactor` | restructure, behavior held |
| `write-rewrite` | deliberate behavior change |
| `write-migration` | API A → B, green per wave |
| `write-performance` | a measured bottleneck |
| `write-testing` | tests as the deliverable |
| `write-documentation` | human-facing docs |

## Universal catalog (suspec-skills)

Framework-free skills, installable in any repo with no Suspec knowledge ([ADR-0112](../adrs/0112-two-tier-skills.md)) — load alongside the work:

- Market/review methods: `market-research`, `persona-challenger`, `bulletproof`, `revolver-review`
- Disciplines: `codebase-exploration`, `debugging`, `security-review`, `git-pr`, `planning-spec`, `empirical-proof`, `concise-output`, `fix-flaky-test`

Authoring disciplines live in their kit guides. Do not maintain duplicate copies.

## Guide rules

A guide:

- states when it applies
- states when it does not apply
- loads only needed references
- is self-contained enough to run
- points to templates instead of copying long templates
- avoids hidden sibling dependencies

## Progressive disclosure

Keep the main guide small.

Put detail in referenced files only when:

- not every task needs it
- the guide names when to load it
- the reference is directly linked

An unreferenced file is dead weight.

## Authoring checklist

Before adding a guide:

- name the user task it serves
- prove no existing guide owns it
- decide if it is kit, workspace, or catalog material
- give it a clear activation description
- remove duplicate rules from nearby guides

## Related

- [Review stances](review-stances.md)
- [Checks](checks.md)
- [Memory](memory.md)
