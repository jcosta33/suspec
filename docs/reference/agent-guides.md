# Agent guides

Suspec's disciplines ship as a skill family — the guides that condition an agent (or a
person) to write, split, implement, review, and close work the Suspec way. A capable
harness plus the skill family is a complete install (level: convention):

```bash
npx skills add jcosta33/suspec-skills -g
```

The spec is the contract; a task packet narrows it when work is split. Every guide keeps a
by-hand path — the disciplines work with no tool at all
([ADR-0134](../adrs/0134-self-contained-spine.md)).

## The core loop

`write-spec` → `implement-task` → `save-findings` cover the mandatory
**spec → run → close** triad; `review-output` is the review step, layered on whenever code
ships:

| Guide | Use |
| --- | --- |
| `write-spec` | write or amend specs (Spec) |
| `implement-task` | run a spec or split task packet (Run) |
| `review-output` | review worker output (Review — whenever code ships) |
| `save-findings` | write durable lessons as native memories (Close) |

## Authoring guides

Suspec-coupled guides for the other artifact kinds — load one when the work calls for that
kind:

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

Guides that implement Suspec work of a given kind — summoned as the work needs them:

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

## Framework-free skills

The catalog's second tier: skills with no Suspec knowledge, usable in any repo
([ADR-0112](../adrs/0112-two-tier-skills.md)) — load alongside the work:

- Market/review methods: `market-research`, `persona-challenger`, `bulletproof`,
  `revolver-review`
- Disciplines: `codebase-exploration`, `debugging`, `security-review`, `git-pr`,
  `planning-spec`, `empirical-proof`, `concise-output`, `fix-flaky-test`

Authoring disciplines live in their Suspec-coupled guides. Do not maintain duplicate
copies.

## Repo-committed guides

A project may commit its own guides in its repo — repo-specific disciplines, house verify
recipes, domain rules. Committed guides are the one Suspec-related surface that lives
inside a repo: instructions belong to the project; working artifacts never land there.
Keep repo guides thin — they narrow the global family for one codebase, they do not fork
it.

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
- decide whether it belongs to the global family or to one repo's committed guides
- give it a clear activation description
- remove duplicate rules from nearby guides

## Related

- [Review stances](review-stances.md)
- [Checks](checks.md)
- [Memory](memory.md)
