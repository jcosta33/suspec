# Surface index

This index answers one question: which repository owns each current Suspec surface?
Decision history lives in the [ADR ledger](adrs/README.md).

| Surface | Owner | Authority |
| --- | --- | --- |
| Methodology and artifact-authoring procedures | [suspec-skills](https://github.com/jcosta33/suspec-skills) | each skill's `SKILL.md` |
| Worker isolation and role adapters | [suspec-agents](https://github.com/jcosta33/suspec-agents) | `agents/*.md`; hand-maintained Codex projections mirror them |
| Deterministic checker | [suspec-cli](https://github.com/jcosta33/suspec-cli) | `suspec check` and its JSON/exit-code contract |
| Shell-less checker adapter | [suspec-mcp](https://github.com/jcosta33/suspec-mcp) | `suspec_check_file` and `suspec_get_checks` |
| Human-readable method, formats, and check reference | this repository | `docs/` and `docs/reference/` |
| Machine-readable checks contract | this repository | `checks/checks.yaml` |

## Working artifacts

The current shapes for specs, task packets, reviews, inventories, change plans, and
captured intake are defined in [artifact formats](reference/artifact-formats.md). Skills
place them beside the agent's native working artifacts and carry their full paths through
each handoff.

Findings are a key in the work, not a standalone artifact type. Ephemeral observations
stay in run or review notes; durable lessons go to native harness memory or the project's
normal channels.

## Installation

Install the methodology from the skill catalog for your runner (Codex shown):

```bash
npx skills add jcosta33/suspec-skills -g -a codex
```

The checker and agent catalog are reinforcement surfaces. Each repository documents its
own installation and runtime requirements.
