# Where files live

> **Superseded model — [ADR-0137](adrs/0137-personal-harness-transient-artifacts.md).** This page still describes the committed
> workspace / board / `.suspec/` layout. Suspec artifacts are now transient personal working
> files under `~/.claude/state/<repo-name>/`, never committed to any repo; durable value is
> promoted to ADRs, tests, issues, and PR digests. Where this page conflicts with
> [ADR-0137](adrs/0137-personal-harness-transient-artifacts.md), the ADR wins. Rewrite pending.


Suspec uses three surfaces:

- **Framework repo**: the docs and decisions for Suspec itself.
- **Workspace repo or folder**: specs, tasks, reviews, findings, and board for a project.
- **Code repo**: the application code.

Keep durable work records in the workspace, not scattered across chat or PR comments.

## Workspace layout

```text
your-workspace/
  AGENTS.md
  specs/
    checkout/
      spec.md
      research.md
  intake/
  tasks/
  reviews/
  findings/
  inventory/
  change-plans/
  decisions/
  templates/
  status.md
```

Core homes:

- `intake/`: upstream asks captured verbatim.
- `specs/<feature>/`: intended behavior and related support docs.
- `tasks/`: bounded split packets when one spec becomes parallel work.
- `reviews/`: review packets kept while they are active records.
- `findings/`: durable lessons saved at Close.
- `inventory/`: present-state maps for brownfield work.
- `change-plans/`: wave plans for structural work.
- `decisions/`: project ADRs.
- `status.md`: the hand-edited Human-attention list and closed-work links. Live spec/task/review
  STATE is derived — `suspec status` is the canonical view where the CLI is installed; a stale
  hand-written state row is worse than none ([[PLANCOMPLY]](research/sources.md#PLANCOMPLY)).

## Co-located or dedicated

Both layouts are valid.

- **Co-located**: put the workspace inside one code repo, often under `suspec/`.
- **Dedicated**: use a separate repo for one or more code repos.

Default name for a dedicated workspace repo:

```text
<project>-works
```

Use a dedicated workspace when features span repos or when spec owners differ from code owners.

In dedicated mode, keep the implementer single-root. See [ADOPTING](ADOPTING.md#spec-external-single-root-implementer).

## Code repo footprint

A code repo needs little or nothing.

Allowed footprint:

- a short `AGENTS.md` pointer:

  ```text
  Suspec workspace: ../<project>-works. Read the spec or task packet before coding.
  ```

- `.gitignore` lines for local Suspec state
- optional agent guide copies if the repo needs them

Specs, tasks, reviews, and findings belong in the workspace.

## Retention

(The working set — `intake/`, `tasks/`, `reviews/` — is gitignored by default per the
ephemeral-by-default decision; retention below concerns what is committed.)

Keep for the life of the project:

- accepted specs
- ADRs
- saved findings

Let transitory output age out once the durable record has what matters:

- closed split task packets
- review packets
- `suspec check` output
- run logs
- temporary agent scratch

Use git history or `archive/`.

A 30-90 day window matches common CI artifact retention
[[GHRETENTION]](research/sources.md#GHRETENTION) [[GLRETENTION]](research/sources.md#GLRETENTION).
A task or review packet is live while open, kept for reference once closed, then moved to `archive/` or left to git history; the closed board row keeps the link. Promote a closed task's durable lesson to its home before the scratch ages out.

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
