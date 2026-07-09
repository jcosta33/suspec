# Where files live

Suspec uses three surfaces:

- **Your repo** — the code, one `suspec.config.json`, and everything you promote: ADRs,
  tests, plus any committed repo-specific agent guides.
- **Your store** — the per-repo working memory, outside every repo: specs, runs, reviews,
  findings, intake snapshots, evidence.
- **Global** — the universal Suspec skill family, installed once at the user level
  (`~/.claude/skills` + `~/.agents/skills`).

The split is the point. Store artifacts are relevant to *you* while the work is live;
anything worth keeping for others leaves the store by promotion — a decision becomes an
ADR, behavior becomes tests, a finding becomes a GitHub issue, the evidence becomes the PR
digest. The durable record lives in the layers that already own it, not in a parallel one.

## The store

One directory per repo, beside your agent's own scaffold:

```text
~/.claude/state/<repo-name>/
  spec-checkout-discounts.md
  run-checkout-discounts.md
  review-checkout-discounts.md
  finding-001.md
  intake-tick-4812.md
  evidence/
    checkout-discounts/
  archive/
```

- Flat files, one lifecycle subfolder (`archive/`), raw evidence under `evidence/<run>/`.
  No other tree. Split slices (`task-<slug>.md`, from `suspec new task`) and change plans
  (`change-plan-<slug>.md`) land flat in the same root.
- The root is configurable: the `SUSPEC_STATE_DIR` environment variable, or `state_root`
  in `suspec.config.json`. Two repos that share a folder name get distinct store
  directories, matched by recorded repo path — never by a name guess.
- Never committed to any repo (level: convention — the CLI never stages the store, and
  `suspec init` never touches it).
- Agents read and write the store directly, by the absolute paths given in the launch
  prompt. Only the driving spec auto-loads into an agent's context; everything else is
  read on demand.

## What lives where

| You produced        | It lives in the store as     | It becomes durable as                        |
| ------------------- | ---------------------------- | -------------------------------------------- |
| a captured ticket   | `intake-<slug>.md`           | nothing — the recorded URL makes it re-pullable |
| intended behavior   | `spec-<slug>.md`             | an ADR, when it carries a decision           |
| an agent run        | `run-<slug>.md`              | the PR and its digest comment                |
| evidence            | `evidence/<run>/`            | the digest on the PR (`suspec done`)         |
| a review            | `review-<slug>.md`           | the exceptions you act on                    |
| a lesson            | `finding-<NNN>.md`           | a GitHub issue (`suspec promote`)            |
| a split slice       | `task-<slug>.md`             | nothing — the spec stays the contract        |
| a change plan       | `change-plan-<slug>.md`      | the PRs that land it                         |

## Lifecycle

Active → archived → gone. Nothing needs a janitor.

- **Archived by truth, not by hand.** `suspec store doctor` reconciles the store against
  git and GitHub: a spec or run whose branch merged, whose worktree is gone, or whose PR
  closed moves to `archive/` — moved, never deleted (level: toolable). State is derived
  from git truth, never hand-maintained; a stale hand-written status row is worse than
  none [[PLANCOMPLY]](research/sources.md#PLANCOMPLY).
- **Findings die at the gate.** When the gate passes (or you accept explicitly),
  `suspec done` ends by triaging each finding: promote it, keep it with an expiry
  date, or discard it (the default for non-critical). A blocked gate skips triage; a
  critical finding is never silently discarded.
- **Deleted by retention.** `suspec store gc` (also `suspec clean`) deletes only archived
  items past `retention_days` — default 30. A 30–90 day window matches common CI artifact
  retention [[GHRETENTION]](research/sources.md#GHRETENTION) [[GLRETENTION]](research/sources.md#GLRETENTION).
- **Ambient pressure.** `work`, `next`, and `status` print one decay line when the store
  holds stale or expired items, pointing at `suspec store doctor`.
- **The nuclear option.** `suspec store purge` deletes a repo's whole store after typed
  confirmation.

## Staleness

Checked at read time, not by ceremony:

- **At launch** — a spec records the commit it was written against (`base_sha`) and its
  affected areas; `suspec work` refuses a drifted spec, printing what moved, unless you
  pass `--anyway`.
- **At the gate** — each evidence entry records a digest of the whole worktree state
  (git status + diff + the HEAD sha); `suspec done` re-hashes, and drifted evidence never
  satisfies the gate until re-run.
- **On demand** — `suspec check --staleness` reports which snapshotted specs drifted
  (advisory).

## Wipe-survival

The store is disposable by design. Everything that must survive it already lives
elsewhere: the ticket URL in the intake record makes it re-pullable, promoted findings
are GitHub issues, the digest is a PR comment, decisions are ADRs, behavior is tests.
`suspec fix #123` rebuilds a working launch straight from the issue — with or without the
store that produced it. Cross-machine continuity is a sync recipe (the store is plain
files), not a feature.

## The repo footprint

`suspec init` writes exactly: `suspec.config.json` (defaults + detected setup), an
`AGENTS.md` seed if absent, `.agents/skills/` with the `.claude/skills` symlink, and a
`.gitignore` line for `.worktrees/`. Nothing else lands in the repo, and no directory is
named after the tool — `suspec.config.json` is the sole tool-named file, the same
convention as `.eslintrc`.

## Drift rule

Code can prove a spec wrong. It does not silently update the spec.

When code and intent diverge, do one of three things:

- re-run the verification
- amend the spec
- fix the code

See [drift](reference/drift.md).

## Related

- Next: [Writing specs](04-writing-specs.md)
- Previous: [The basic workflow](02-basic-workflow.md)
