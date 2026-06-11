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
| kit agent guides | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b |
| kit advanced reference cards | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b |
| kit templates | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b |
| kit shell (README/AGENTS/example/decisions/gitignore) | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b |
| .agents/skills + manifest | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b |
| docs/library/code-skills | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b |
| conformance/conformance.yaml | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b |
| conformance/fixtures + prose-corpus | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b |
| evals/ | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b |
| docs/examples/ | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b |
| docs/reference/cheatsheet.md | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b |
| root AGENTS.md + symlinks | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b | done@10c238b |
| swarm-cli (external) | pending | pending | pending | pending | pending | pending | pending | pending | pending | pending | pending | pending |

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

## Outstanding (open increments)

- **Increment 10 — swarm-cli resync** (sibling repo): kit re-copy, spec suite re-cut to the new
  format, `swarm lint`/`swarm spec check` pointed at the C001–C011 contract + `format: sol`
  selector + the new fixtures (incl. equivalence pairs). Gate: pasted green run on both repos.
- **Increment 11 — cold re-adoption + pilot kickoff**: fresh-workspace adoption exercise, the
  ten-question/10-minute cold read (+ "when do I need an inventory/change plan?"), keep/adjust
  calls for the three externally-unverifiable decisions (intake D6, examples D10, memory D14),
  and the spec-first pilot (protocol: `.agents/plans/spec-first-pilot-protocol.md`, pre-registered;
  moves to the swarm-cli backlog at resync). Files `.agents/audits/post-pivot-adoption-review.md`.
- **Deliberate cuts recorded:** IR fixtures are not shipped (machine-artifact schemas live only on
  `docs/reference/future-cli.md`; reserved names spelled infix-free per ADR-0059 addendum); the
  frozen template texts live verbatim in `starter-kit/templates/` with the ADRs describing them
  (embedding waived — one verbatim home beats two).

## Tracked derived pairs

- `.agents/skills/adversarial-review/` ↔ `starter-kit/advanced/adversarial-review/` — dev copy may use
  internal vocabulary; the kit copy follows kit conventions (frontmatter `type:`, cmd* slots, packet
  vocabulary). An edit to one re-checks the other.

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

## Gate evidence — 2026-06-11 (post adversarial review)

Six-dimension hostile review consolidated in `.agents/audits/post-rebuild-adversarial-review.md`.
2 BLOCKERs + ~20 MAJORs + ~30 MINORs found and fixed; re-run gates all zero (user-tier tokens,
labels 28/28, links, citations, counts). Accepted-as-is items and the two open increments are
recorded in the review file.
