# Running agents

Suspec does not run agents. It hands them the working artifact the change earned — a
spec, or a task packet when work is split — by explicit path.

Any worker can use a Suspec packet:

- Claude Code
- Codex
- Cursor
- Aider
- another agent
- a human

## Handoff

The dispatch prompt names the spec — and the task, when one exists — by full path:

```text
Read /Users/you/agent-notes/shop-api/spec-checkout.md and implement AC-001.

Read /Users/you/agent-notes/shop-api/task-checkout-expiry.md and do what it says.
```

The spec contains requirements and `Verify with:` lines. A task packet adds the split
scope, `Do not change`, affected areas, verify commands, and standing instructions for
one slice. Paths flow explicitly — the worker is handed everything it needs by path and
never discovers artifacts on its own (level: convention).

## Worker types

- **Worker**: implements a spec or task slice and leaves a run summary.
- **Scout**: reads or researches and reports back. It does not merge code.

Do not merge scout output as implementation work.

## Roles

Run authoring, implementation, and review as different sessions:

- **Spec/task author** — writes the spec, change plan, and split task packets when needed.
- **Implementer** — executes one spec or task slice; reads the spec and any task; the scoped requirements are the boundary; does not change requirements.
- **Lens reviewer** — reviews one lens (correctness, evidence, design risk, …) and returns findings only.
- **Review lead** — for a formal review, cycles a pool of distinct lens stances one reviewer at a time on the revised change, applies fixes between rounds, and writes the packet.
- **Human/owner** — owns the decision.

The reviewer is not the implementer. The spec or task author may review the implementation, as long as they did not implement it.

Escalate to a stronger model or session on unclear scope, repeated Verify failures, risky files, or a requirement that needs reinterpretation. A cheaper implementer fits clear, bounded work — but measure the saving by pass rate, rework rate, and review outcome; never assume it.

## Isolation

Isolation is your own git practice — Suspec does not create, manage, or clean up
worktrees or branches. What matters to the methodology is only this: parallel workers
need isolated file state, and the reviewer needs the working tree kept until review is
final.

If you use worktrees:

- one branch or worktree per spec, or per task when the spec is split — name them
  however your team names branches
- worktrees isolate file state; they do not isolate shared services, ports, databases,
  or credentials — configure those separately when needed
- exclude the worktree folder from your dev tools: vitest, eslint, cargo and friends do
  not read `.gitignore`, so worktree copies otherwise show up as duplicated tests or
  phantom lint errors (vitest `test.exclude`, eslint `ignores`, …)

## What the worker must return

The returned spec `## Execution` entry, or task packet when split, contains:

- every verify item checked or marked blocked
- short decisive output once, or a stable link to an adjacent evidence receipt
- changed files listed
- out-of-scope edits named
- blocked questions named
- candidate findings listed
- for delegated work, a Provenance line when it helps review: sources read, guide loaded,
  worker identity, and isolation mode. Treat it as evidence to inspect, not a trust token.

Example:

```markdown
## Verify

- [x] `npm run test:integration -- expired-session` (AC-001)

      Tests: 3 passed

## Findings

- Candidate findings: none

## Run summary

- Changed files: `src/checkout/expiry.ts`, `test/integration/expired-session.test.ts`
- Verify evidence: AC-001 → `Tests: 3 passed` above
- Out-of-scope edits: none
- Blocked questions: none
```

## Evidence rule

`Tests passed` is not evidence.

A `Supported` needs pasted output, a CI link, or a named manual observation. Without that, review records `Unverified`.

## Self-review

The worker inspects its own diff before handoff.

Self-review can produce fixes. It does not produce an independent assessment or human decision.

## Keep the working tree

Keep the branch or worktree until review is final. Review may need to:

- inspect the diff
- rerun commands
- verify changed files
- ask for follow-up work

## Related

- Next: [Reviewing output](08-reviewing-output.md)
- Previous: [Creating tasks](06-creating-tasks.md)
