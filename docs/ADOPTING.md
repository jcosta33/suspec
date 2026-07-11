# Adopting Suspec

Adopting is one install. Nothing lands in your repo.

## Setup

1. Install the skill family, once, globally:

   ```bash
   npx skills add jcosta33/suspec-skills -g
   ```

   That is a complete install: the skills carry the methodology — authoring specs,
   splitting work, implementing, reviewing, saving findings — and the artifact shapes
   (level: convention). Universal skills live at the user level; repo-specific guides
   (your commands, your conventions) stay committed in the repo they describe, and the
   two tiers never overlap (level: convention).

2. Optional: install the reference CLI,
   [suspec-cli](https://github.com/jcosta33/suspec-cli), for the deterministic checks.
   One command:

   ```bash
   suspec check <path>
   ```

   It reads exactly the files you hand it, by full path, and resolves nothing else — the
   exceptions are three reference checks: source refs and citation anchors resolve
   against the artifact's own directory (`sources.md` is the spec's sibling file), and
   a change plan's `SPEC-id#AC-NNN` refs resolve one level beside the plan — one level
   above the plan's own directory, scanning that parent's sibling directories for a
   `spec.md` file — no setup, no config, no
   footprint, though the plan must live in its own directory with each referenced spec
   in a sibling directory (a flat layout fails the check) (level: enforced —
   suspec-cli).

Use symlinks only when your platform handles them reliably; on Windows, copying the
skills folder is safer.

## First useful change

Start small and run the whole loop once. The loop is proportioned to feature-sized work —
a trivial fix earns a one-line inline spec and no files at all; see
[the bug-fix example](examples/bug-fix.md) for that shorter path.

1. Author a spec through the skill: requirements with `AC-NNN` ids, each with a
   `Verify with:` line, non-goals, acceptance criteria. Place the file next to your own
   native artifacts — the same place you keep your plans, notes, and memories for this
   work, in a folder named after the repo you are working on (or wherever fits your
   harness best). You choose the exact spot; keep it out of the repo unless the
   project's own governance says otherwise, and carry the file's full path forward —
   every later step names artifacts by explicit path.
2. Lint it: `suspec check <path>`.
3. Implement — your agent works from the spec by path, runs every verify command, and
   pastes real output.
4. Review — an independent reviewer builds the review packet against the spec, then runs
   the floor: `suspec check <review-path> --spec <spec-path>`.
   Exit codes: `0` clean, `1` warning, `2` blocking.
5. Keep what mattered: a durable lesson becomes a native harness memory; a decision
   becomes an ADR; a defect becomes an issue — through your project's own channels.

A hands-on walkthrough lives in [tutorial/README.md](tutorial/README.md).

## By hand — no CLI

Every step keeps a by-hand path (level: convention); the CLI accelerates the checking,
nothing else.

1. Write the spec yourself — the shape is documented in
   [artifact formats](reference/artifact-formats.md): status, requirements with IDs, a
   `Verify with:` line each. Place it beside your native artifacts as above.
2. Work in isolation if you run parallel workers — a branch or worktree is ordinary git
   practice, yours to manage.
3. Run each `Verify with:` command yourself and paste the real output into the spec's
   `## Execution` section.
4. Review by checklist: one coverage row per requirement, empty evidence is
   `Unverified` never `Pass`, exceptions routed to a human. Without the CLI the floor is
   yours to hold (level: checklist; `suspec check` is the enforced form).

## What gets committed

Nothing, by Suspec's hand. Your repo takes the code, the tests, and whatever your
project's own governance already commits — ADRs, agent guides, the PRs themselves.
Specs, task packets, and review packets stay outside the repo, beside your native
artifacts, unless the project's own governance says otherwise.

## Teams

The checks contract is data — `checks/checks.yaml` in this repo. A team that wants its
own standards reshapes the contract to match: tighten a severity, drop a check, add a
convention. The CLI checks whatever contract it ships; the honesty floor's value is that
it is deterministic, not that it is universal.

## Updating

Re-run `npx skills add jcosta33/suspec-skills -g` — the skill family updates in one
place, for every repo at once.
