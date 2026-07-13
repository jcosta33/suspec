# Surface index

This index answers one question: which repository owns each current Suspec surface? It is not an
artifact status or lifecycle registry. Decision history lives in the [ADR ledger](adrs/README.md).

| Surface | Owner | Authority |
| --- | --- | --- |
| Methodology and artifact-authoring procedures | [suspec-skills](https://github.com/jcosta33/suspec-skills) | each skill's `SKILL.md` |
| Deterministic checker | [suspec-cli](https://github.com/jcosta33/suspec-cli) | `suspec check` and its JSON/exit-code contract |
| Shell-less checker adapter | [suspec-mcp](https://github.com/jcosta33/suspec-mcp) | `suspec_check`, `suspec_get_checks`, and `suspec://checks` |
| Human-readable method, formats, and check reference | this repository | `docs/` and `docs/reference/` |
| Machine-readable checks contract | this repository | `checks/checks.yaml` |

## Working artifacts

The current shapes for specs, tasks, reviews, inventories, change plans, audits, research, and
inspections are defined in [artifact formats](reference/artifact-formats.md). Skills
place them in the agent-neutral artifact workspace and carry their absolute paths through
each handoff.

An ADR decides a shape or method. The human reference explains it. Each standalone skill implements
the procedure locally. `checks/checks.yaml` owns only the deterministic subset a checker can enforce.
Changing any of those contracts starts from a new ADR, then updates every reinforcement surface.

Findings are a key in the work, not a standalone artifact type. Ephemeral observations
stay in run or review notes; durable lessons go to native harness memory or the project's
normal channels.

## Installation

Install the methodology from the skill catalog for your runner (Codex shown):

```bash
npx skills add jcosta33/suspec-skills -g -a codex
```

The checker and MCP adapter are optional reinforcement surfaces. Each repository documents its
own installation and runtime requirements. Fresh harness-native subagents provide isolation when
the work needs it.
