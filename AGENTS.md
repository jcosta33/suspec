# AGENTS.md — Suspec canon

Canon lives here. Runtime does not. This repository owns Suspec's human-readable method and
machine-readable checks contract; sibling repositories own the skill catalog, CLI, and MCP adapter.

## Authority

- Accepted decisions: `docs/adrs/`. Never rewrite historical ADR bodies.
- Human artifact shapes: `docs/reference/artifact-formats.md`.
- Machine checks contract: `checks/checks.yaml`.
- Check explanations: `docs/reference/checks.md`.
- Empirical sources: `docs/research/sources.md`.
- Global agent policy and predecessor provenance: `policy/agent.md` and
  `policy/agent-policy-predecessors.txt`.
- Executable procedures: `suspec-skills`.

A contract change travels as a unit. Half-updated truth is still wrong.

## Writing

- Present current behavior in fresh-product language. Keep migration history inside ADRs.
- State delivery control honestly: `advisory`, `deterministic local`, or `isolated authority`.
  Otherwise name the enforcing command or owner.
- Use current artifact types only: spec, task, inventory, change plan, audit, research,
  campaign, and panel.
  Evidence receipts and run notes are untyped sidecars.
- Publish no changing catalog, repository, artifact, or ADR totals. Decorative counts rot. Keep
  execution-defining floors, caps, versions, IDs, and exit codes exact.
- Cite every load-bearing empirical claim with `[[KEY]]` linked to
  `docs/research/sources.md#KEY`. Verify new sources before adding them.
- Put each rule in one authoritative document. Link from every secondary surface.

## Layout

- `docs/`: guide, reference, adoption, examples, tutorial, decisions, and evidence.
- `checks/checks.yaml`: contract data.
- `checks/fixtures/`: checker oracle data.

## Command

| Slot       | Command                  |
| ---------- | ------------------------ |
| `cmdCheck` | `sh scripts/lint-all.sh` |

Work from `main`; commit and push directly. `CLAUDE.md` and `GEMINI.md` point here.
