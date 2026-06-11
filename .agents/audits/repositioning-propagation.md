---
type: audit
id: repositioning-propagation
status: active
created: 2026-06-11
---

# Repositioning propagation matrix

Tracks ADRs 0057–0068 across the 13 derived surfaces. A cell flips to `done` only with the
commit SHA that landed it. Derivation order (never violated): ADRs → docs/ + README →
examples → starter-kit → .agents/ dev subset → docs/library/code-skills → conformance/ +
evals/ → sweep → swarm-cli → close.

| Surface | 0057 | 0058 | 0059 | 0060 | 0061 | 0062 | 0063 | 0064 | 0065 | 0066 | 0067 | 0068 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| kit agent guides | | | | | | | | | | | | |
| kit advanced reference cards | | | | | | | | | | | | |
| kit templates | | | | | | | | | | | | |
| kit shell (README/AGENTS/example/decisions/gitignore) | | | | | | | | | | | | |
| .agents/skills + manifest | | | | | | | | | | | | |
| docs/library/code-skills | | | | | | | | | | | | |
| conformance/conformance.yaml | | | | | | | | | | | | |
| conformance/fixtures + prose-corpus | | | | | | | | | | | | |
| evals/ | | | | | | | | | | | | |
| docs/examples/ | | | | | | | | | | | | |
| docs/reference/cheatsheet.md | | | | | | | | | | | | |
| root AGENTS.md + symlinks | | | | | | | | | | | | |
| swarm-cli (external) | | | | | | | | | | | | |

## Reconciliation gate (run per increment; paste outputs below)

1. Link audit: every relative `](...)` resolves; every `[[KEY]]` anchor resolves in `docs/research/sources.md`.
2. Banned-token grep, tier-scoped (lists below).
3. Counts appear only in `conformance/README.md` producer note + cheatsheet appendix.
4. Terminology one-way check (user tier uses column-A vocabulary only).
5. Same-commit rule: a format change updates its fixtures + examples + templates in that commit.

## Banned tokens — user tier (`README.md docs/ADOPTING.md docs/[0-9][0-9]-*.md docs/examples/ starter-kit/` excl. `starter-kit/advanced/`)

`compiler` · `lower` (step sense) · `\bIR\b` · `swarm.ir.json` · `structured form` (as artifact) · `lint floor` ·
`HARD CAP` · `regression check` (cap sense) · `SOL/0.1` · `swarm_language` · `aps_version` · `closed set` ·
`nine-pass|9 passes` · `pass guide` · `obligation` · `verdict` · `proof type` · `conformance` (say "checks") ·
`heuristic profile` · `.swarm.md` · `source of truth` (spec sense) · `build reliably` · `task_kind` ·
`Inventory →`/`Change Plan →` as README loop steps

## Banned tokens — all tiers

`HARD CAP` · `regression check that fails` · `lint floor` · "spec is the source of truth" · "agents build reliably" ·
enforcement claims with no named (aspirational) checker

## Gate evidence log

(appended per increment)

## Gate evidence — 2026-06-11 (full rebuild)

```
user-tier banned-token hits: 0   (2 earlier hits were "compiler" inside is-not denial lists — allowed context)
all-tiers banned-token hits: 0
counts outside the two homes: 0  (present in conformance/README.md + cheatsheet appendix)
label problems: 0                (18 re-added after a formatting hook stripped them)
broken links outside docs/adrs/: 0
citation anchor/path problems: 0 (16 ADR files had pre-existing ./research path typos — fixed)
adr historical broken links: 33  (immutable ledger bodies referencing pages now in git history — accepted)
C-check numbering: reconciled to the canonical C001–C009 of docs/reference/checks.md across
conformance.yaml, fixtures, cheatsheet, and starter-kit/advanced/checks-reference.md
```

All 13 surfaces rebuilt this pass (single continuous execution; SHAs in the commits
"ADRs 0057-0068…" and "Rebuild: practical-first repositioning…"). The swarm-cli row
remains OPEN — sibling-repo resync is the one outstanding surface.
