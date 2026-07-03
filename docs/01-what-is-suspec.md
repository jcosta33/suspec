# What is Suspec?

Suspec is a markdown workflow for agent-assisted code changes.

It gives you:

- specs with acceptance criteria
- optional task packets when one spec splits into parallel work
- review packets with evidence per requirement
- findings for lessons worth keeping
- a workspace layout for those files

It does not replace your agent, issue tracker, PRs, CI, or docs site.

## Why use it

Agent output is easy to generate and hard to review. Suspec puts a small record between each step:

| Problem | Suspec record |
| --- | --- |
| Vague ticket | `intake/` snapshot plus a spec |
| Repeated prompt context | workspace files the agent can read |
| Scope drift | spec or task scope with explicit non-goals and `Do not change` |
| Large PR | review packet with coverage and exceptions |
| Lost lesson | finding saved at Close |

## Who should not use it

If you work alone, in a codebase you know, on changes small enough to read whole — plan mode,
an `AGENTS.md`, and your test suite already cover most of this, at zero ceremony. Suspec starts
paying when the diff outgrows your attention, when more than one person or agent touches the
work, or when someone must later reconstruct what was intended and what was proven. Until one of
those is true, don't adopt it.

## The loop

```text
Pull -> Spec -> (Task) -> Run -> Review -> Close
```

Three steps are conditional:

- **Inventory**: map existing code before brownfield work.
- **Change Plan**: plan migrations, rewrites, schema changes, or high-risk refactors.
- **Task**: split one spec into bounded packets only when the work needs parallel slices.

See [the basic workflow](02-basic-workflow.md).

## What the files do

- **Intake** captures the upstream ask without interpretation.
- **Spec** states intended behavior, non-goals, open questions, and `Verify with:` lines.
- **Task** gives one bounded split unit of work to an agent or person.
- **Run summary** records changed files, commands run, output, blocked questions, and findings.
- **Review** records requirement results and what needs human attention.
- **Finding** saves durable knowledge for future work.
- **Status board** shows the current state and links closed work to review packets.

## Tooling

The markdown workflow works without tooling.

`suspec-cli` is optional. It scaffolds, checks, launches, and reconciles files.
It does not write code or decide whether work is correct.

See [the CLI reference](reference/cli.md).

Suspec keeps the *functions* of heavyweight engineering (explicit intent, verification, review,
traceability, change control) while dropping the document stack — see [lineage](reference/lineage.md).

## Start here

1. Read [the basic workflow](02-basic-workflow.md).
2. Check [where files live](03-where-files-live.md).
3. Walk [the tutorial](tutorial/README.md).

## Related

Next: [The basic workflow](02-basic-workflow.md)
