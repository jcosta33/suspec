# Adopting Suspec

Adopting is two installs and one config file. Your repo stays clean: artifacts live in
your personal store, outside the repo; only what you promote is committed.

## Setup

1. Install the reference CLI: [suspec-cli](https://github.com/jcosta33/suspec-cli).

2. Seed the repo:

   ```bash
   suspec init
   ```

   This writes `suspec.config.json` (defaults + detected setup), seeds `AGENTS.md` if
   absent, creates `.agents/skills/` with the `.claude/skills` symlink, and gitignores
   `.worktrees/`. Nothing else lands in the repo, and the store is never touched here.

3. Install the universal skill family, once, globally:

   ```bash
   npx skills add jcosta33/suspec-skills -g
   ```

   Universal skills live at the user level; repo-specific guides stay committed in the
   repo they describe. The two tiers never overlap (level: convention).

4. Make the seed yours: fill `AGENTS.md` with your commands and facts, and declare
   `setup` / `verify` (and `risk_paths`, if you want the nudges) in `suspec.config.json`
   — the [CLI reference](reference/cli.md) documents every key.

Use symlinks only when your platform handles them reliably; on Windows, copying the
skills folder is safer.

## First useful change

Start small and run the whole loop once:

1. `suspec write spec "<one-line intent>"` — then fill the requirements: one AC per id,
   each with a `Verify with:` line.
2. `suspec work <SPEC>` — worktree, setup, your agent launched against the spec.
3. `suspec evidence add <RUN> --ac AC-001 -- <verify command>` — the harness runs the
   command itself and records the evidence, per AC.
4. `suspec done <RUN>` — the gate: every AC needs captured, passing, non-stale evidence,
   or an explicit acceptance. The digest lands on the PR; findings get triaged.
5. `suspec promote <FIND>` — anything worth keeping for others becomes a GitHub issue.

A hands-on walkthrough lives in [tutorial/README.md](tutorial/README.md) — still on the
superseded layout; its banner flags what changed.

## By hand — no CLI

Every step keeps a by-hand path (level: convention); the CLI accelerates it and adds the
machine gate.

1. Make the store: `mkdir -p ~/.claude/state/<repo-name>`.
2. Write `spec-<slug>.md` there from the spec template (the
   [starter kit](https://github.com/jcosta33/suspec-starter-kit) ships the templates):
   status, requirements with IDs, a `Verify with:` line each.
3. Work in isolation: `git worktree add .worktrees/<slug> -b suspec/<slug>`, `cd` in, and
   run your agent pointed at the store spec by absolute path.
4. Run each `Verify with:` command yourself and paste the real output into the run file.
   Without the CLI there is no machine-enforced gate — the evidence discipline is yours
   (level: convention; `suspec evidence add` + `suspec done` are the toolable form).
5. Promote by hand: open the issue, write the ADR, paste the digest on the PR.

## What gets committed

Nothing but `suspec.config.json`, the seeded `AGENTS.md` and any repo-specific guides
you keep, and your own promotions — ADRs, tests, whatever you land through the normal PR.
Specs, runs, reviews, findings, and evidence stay in your store; when a reviewer wants
the evidence, the digest is already on the PR.

## Updating

- **Kit-managed templates**: `suspec update --check` reports drift against the shipped
  kit; `suspec update --write` refreshes the kit-owned files (a customized file is backed
  up to `*.suspec-bak` by default). Your own artifacts are never touched.
- **Skills**: re-run `npx skills add jcosta33/suspec-skills -g` — the family updates in
  one place, for every repo at once.
