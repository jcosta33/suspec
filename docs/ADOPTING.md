# Adopting Suspec

Adopting begins with the global skill install. Nothing lands in your repo.

## Setup

1. Install the skill family, once, globally for your runner (Codex shown):

   ```bash
   npx skills add jcosta33/suspec-skills -g -a codex
   ```

   That is a complete install: the skills carry the methodology — authoring specs,
   splitting work, implementing, reviewing, saving findings — and the artifact shapes
   (level: convention). Repo-specific guides — your commands, architecture, and
   conventions — stay committed in the repository they describe; they do not fork the
   globally installed methodology.

2. Add the reference CLI,
   [suspec-cli](https://github.com/jcosta33/suspec-cli), when deterministic checks will
   improve review. It is not published; install it from source with Node.js 22.6 or newer:

   ```bash
   git clone https://github.com/jcosta33/suspec-cli
   cd suspec-cli
   npm install
   npm run build
   npm link
   ```

   Then run:

   ```bash
   suspec check <path>
   ```

   It reads exactly the files you hand it, accepting full paths or paths relative to the
   process's current working directory. Source paths and citation files resolve from the
   spec's own directory using the paths its frontmatter names. C010
   scans `spec.md` in each immediate child directory of the change plan directory's
   parent, including the plan's own directory; it never walks deeper. No setup, config,
   or repository footprint is required (level: enforced — suspec-cli).

## First useful change

Start small and run the whole loop once. The loop is proportioned to feature-sized work —
a trivial fix earns one-line inline intent and no files at all; see
[the bug-fix example](examples/bug-fix.md) for that shorter path.

1. Author a spec through the skill: requirements with `AC-NNN` ids, each with a
   `Verify with:` line, non-goals, acceptance criteria. Place the file under
   `~/.agents/artifacts/<workspace>/`, resolve `~` to the absolute home path, and
   derive `<workspace>` from the repository or working-directory basename. Keep it
   out of the repository and carry its absolute path forward.
2. When using the checker, lint it: `suspec check <path>`.
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
   `Verify with:` line each. Place it in the agent-neutral workspace as above.
2. Work in isolation if you run parallel workers — a branch or worktree is ordinary git
   practice, yours to manage.
3. Run each `Verify with:` command yourself and paste the real output into the spec's
   `## Execution` section.
4. Review by checklist: one coverage row per requirement, empty evidence is
   `Unverified` never `Supported`, exceptions routed to a human. Without the CLI the floor is
   yours to hold (level: checklist; `suspec check` is the enforced form).

## What gets committed

Nothing, by Suspec's hand. Your repo takes the code, the tests, and whatever your
project's own governance already commits — ADRs, agent guides, the PRs themselves.
Specs, task packets, and review packets stay outside the repository under
`~/.agents/artifacts/<workspace>/` until explicitly promoted.

## Teams

The checks contract is data — `checks/checks.yaml` in this repo — and the CLI ships its
own matching implementation. A team can decide which reported levels block CI and can
layer project-specific checks beside it. Changing Suspec's check definitions requires a
corresponding CLI change; editing a local copy of `checks.yaml` does not reconfigure the
installed checker.

## Updating

Re-run `npx skills add jcosta33/suspec-skills -g -a codex` (substituting your runner's
agent ID) — the skill family updates in one
place, for every repo at once.
