# AGENTS.md — working on the Suspec framework

## What this repo is

This repo **is** the Suspec framework — _an opinionated methodology for working with
coding agents, shipped as a globally installed skill family_ — in its canonical written
form: the docs and the checks contract. It ships **no runtime**: anything described as
checkable names its checker (the reference implementation is `suspec check`, from
`suspec-cli`, a sibling repo); everything else is convention or review checklist, and
says so.

- `docs/` — the product: a numbered guide, `reference/` (the deep layer:
  structured requirements, checks, artifact formats, CLI reference, memory, glossary),
  `examples/` (flagship walkthroughs; `large-pr-review.md` is the demo),
  `ADOPTING.md`, `adrs/` (the decision ledger), `research/sources.md` (the evidence
  bibliography).
- `checks/` — the checks contract as data (`checks.yaml`) + fixtures (test data for
  `docs/reference/checks.md`; suspec-cli's oracle).
- The methodology itself — standalone methods and canonical artifact authors — lives in the
  `suspec-skills` repository and installs
  globally. Adopter repos take nothing; the CLI seeds nothing.

## Working on this repo

Working artifacts for changes to this repo live under
`~/.agents/artifacts/<workspace>/` — read the spec or task packet at the explicit
absolute path you are given. Durable
lessons go to native harness memory or the project's normal channels. Accepted framework
decisions land in `docs/adrs/`.

## Startup

1. Read the current task/request first; load only the skill or reference it names.
2. Treat the ADRs (`docs/adrs/`) as the recorded intent for every format and vocabulary rule.
3. Map every completion claim to evidence — paste real output; a claim without it is unverified.
4. Self-review before declaring done: re-read your own diff against the request and evidence;
   never self-issue a review verdict.

## Universal rules

- **Fresh-product voice.** No migration framing anywhere except `docs/adrs/`.
  The framework is presented as originally designed.
- **Honesty framework (ADR-0063).** Rules carry a level: convention · checklist · toolable
  (names suspec-cli's command) · enforced (only with a shipped tool). Never
  write enforcement-sounding claims without a level.
- **Current vocabulary.** Suspec owns specs, tasks, reviews, inventories, change plans, audits,
  research, and inspections. Evidence receipts and run notes are untyped sidecars. Artifacts are
  scaffold pulled in only when work earns them.
  The checker reports facts and severity levels; only a human owns a review result.
- **No counts ceremony.** Do not hardcode closed-set cardinalities in public/current prose.
  List values when they help the reader; keep maintainer reconciliation in the source
  contract instead of duplicate count registries.
- **Citations are contextual.** Every load-bearing empirical claim cites a verified entry
  inline — the `[[KEY]]` form linking the matching anchor in `docs/research/sources.md` — and the citation moves with the claim.
  Non-verified sources never carry a MUST-level claim; fact-shaped statements without a
  source are labeled design rationale. Web-verify before adding to `sources.md`.
- **Single-sourcing.** Formats are frozen in their ADRs; the machine-readable artifact
  shape is the checks contract (`checks/checks.yaml`); the human-facing shape reference
  is `docs/reference/artifact-formats.md` (ADR-0138); the skills carry the authoring
  guidance. Everything else links, never restates. A rule lands in `docs/` first; the
  suspec-skills catalog and the dev skills derive from it (a format change spans repos —
  cut it as one reviewed change).

## Pointers

- Decisions: `docs/adrs/README.md` — the complete immutable ledger
- The standalone skill catalog (global install): github.com/jcosta33/suspec-skills —
  `npx skills add jcosta33/suspec-skills -g -a codex`
- Subagents: use fresh harness-native workers when isolation or independence matters; each skill
  carries its complete method
- Evidence: `docs/research/sources.md` (verified / caveated / rejected — never cite rejected)

## Commands

| Slot     | Command                       | Resolves                                                |
| -------- | ----------------------------- | ------------------------------------------------------- |
| cmdCheck | `sh scripts/lint-all.sh`      | product prose, checks contract, and skill topology |

## Workflow

Work from `main`: commit and push directly to `main` (producer convention only — adopters
follow their own branching; isolation for parallel work is ordinary git practice, per
`docs/07-running-agents.md`).

## Compatibility

`CLAUDE.md` and `GEMINI.md` are symlinks to this file — one bootloader, many agent tools.

<!-- suspec:start -->

This repository is worked with the Suspec methodology: ordinary working artifacts live under
`~/.agents/artifacts/<workspace>/`, outside the repo, and flow by explicit absolute path. Durable
lessons use native harness memory or the project's normal channels. The deterministic
checker is `suspec check <path>`.

<!-- suspec:end -->
