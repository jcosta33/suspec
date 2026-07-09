# AGENTS.md — working on the Suspec framework

## What this repo is

This repo **is** the Suspec framework — _a personal methodology harness for working with
coding agents_, shipped as markdown: the docs and the checks contract. It ships **no
runtime**: anything described as checkable names its checker (the reference implementation
is `suspec-cli`, a sibling repo); everything else is convention or review checklist, and
says so.

- `docs/` — the product: a numbered happy path (`01`–`10`), `reference/` (the deep layer:
  structured requirements, checks, step bars, artifact formats, advanced lifecycle, CLI
  reference, memory), `examples/` (three flagship walkthroughs; `large-pr-review.md` is the
  demo), `ADOPTING.md`, `adrs/` (the decision ledger), `research/sources.md` (the evidence
  bibliography).
- `checks/` — the checks contract as data (`checks.yaml`) + fixtures (test data for
  `docs/reference/checks.md`; suspec-cli's oracle). `.agents/` — a small dev-skills subset
  (see `.agents/SKILLS-MANIFEST.md`).
- The repo seed is embedded in `suspec-cli`: `suspec init` writes it (config, `AGENTS.md`,
  the skills dirs) from the CLI's own built-in scaffolds — no template repo. The universal
  skill family (conditioning stances, code-depth guides) lives in `../suspec-skills` and
  installs globally.

## Working on this repo

Specs, runs, reviews, and findings for changes to this repo live in the developer's
personal store (`~/.claude/state/<repo-name>/`), per the harness itself — read the spec or
task slice you are given. Accepted framework decisions land here, in `docs/adrs/`.

## Startup

1. Read the current task/request first; load only the skill or reference it names.
2. Treat the ADRs (`docs/adrs/`) as the recorded intent for every format and vocabulary rule.
3. Map every completion claim to evidence — paste real output; a claim without it is unverified.
4. Adversarial self-review before declaring done (ADR-0056): re-read your own diff as a skeptic;
   never self-issue a review verdict.

## Universal rules

- **Fresh-product voice.** No migration framing anywhere except `docs/adrs/`.
  The framework is presented as originally designed.
- **Honesty framework (ADR-0063).** Rules carry a level: convention · checklist · toolable
  (names suspec-cli's command) · enforced (only with a shipped tool). Never
  write enforcement-sounding claims without a level.
- **Vocabulary tiers (ADR-0057).** User tier (README, `docs/01–10`, `docs/examples/`,
  kit core): step · requirement/AC · evidence · review result (Pass/Fail/Unverified/Blocked) ·
  checks · structured requirements · writing rules · store · save a finding. Reference tier
  may also use the precise internal terms (pass, obligation, proof, verdict, SOL codes);
  `docs/reference/glossary.md` maps both directions.
- **No counts ceremony.** Do not hardcode closed-set cardinalities in public/current prose.
  List values when they help the reader; keep maintainer reconciliation in the source
  contract instead of duplicate count registries.
- **Citations are contextual.** Every load-bearing empirical claim cites a verified entry
  inline — the `[[KEY]]` form linking the matching anchor in `docs/research/sources.md` — and the citation moves with the claim.
  Non-verified sources never carry a MUST-level claim; fact-shaped statements without a
  source are labeled design rationale. Web-verify before adding to `sources.md`.
- **Single-sourcing.** Formats are frozen in their ADRs; the artifact shapes are enforced
  by the checks contract (`checks/checks.yaml`) and materialized by the CLI's built-in
  scaffolds; the human-facing shape reference is `docs/reference/artifact-formats.md`
  (ADR-0138). Everything else links, never restates. A rule lands in `docs/` first; the
  CLI's scaffolds, the suspec-skills catalog, and the dev skills derive from it (a format
  change spans repos — cut it as one reviewed change).

## Pointers

- Decisions: `docs/adrs/README.md` — the complete immutable ledger
- The skill catalog (global install): `../suspec-skills` (github.com/jcosta33/suspec-skills —
  `npx skills add jcosta33/suspec-skills -g`)
- Claude Code agent catalog: `../suspec-agents` (github.com/jcosta33/suspec-agents — ADR-0092;
  Claude-Code-first worker definitions + the delegation hook; honest scope: toolable/partial)
- Dev skills (the small subset for working on this repo): `.agents/skills/` — see
  `.agents/SKILLS-MANIFEST.md`
- Evidence: `docs/research/sources.md` (verified / caveated / rejected — never cite rejected)

## Commands

| Slot | Command | Resolves                                             |
| ---- | ------- | ---------------------------------------------------- |
| —    | (none)  | markdown-only repo; coherence is checked by review |

## Workflow

Work from `main`: commit and push directly to `main` (producer convention only — adopters
follow their own branching; tasks run in worktrees per `docs/07-running-agents.md`).

## Compatibility

`CLAUDE.md` and `GEMINI.md` are symlinks to this file — one bootloader, many agent tools.

<!-- suspec:start -->

This repository is worked with the Suspec personal harness: specs, runs, and evidence live
in your personal store, outside the repo; only promoted residue is committed. Run
`suspec help` for the commands.

<!-- suspec:end -->
