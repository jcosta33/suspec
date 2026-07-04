# Running agents

Suspec does not run agents. It gives them a spec by default, or a task packet when work is split.

Any worker can use a Suspec packet:

- Claude Code
- Codex
- Cursor
- Aider
- another agent
- a human

## Handoff

Point the worker at the spec, or at the task file when one exists:

```text
Read specs/checkout/spec.md and implement AC-001.

Read tasks/checkout-expiry.md and do what it says.
```

The spec contains requirements and `Verify with:` lines. A task file adds the split scope, `Do not change`,
affected areas, verify commands, and standing instructions for one slice.

## Worker types

- **Worker**: implements a task and leaves a run summary.
- **Scout**: reads or researches and reports back. It does not merge code.

Do not merge scout output as implementation work.

## Roles

Run authoring, implementation, and review as different sessions:

- **Spec/task author** — writes the spec, change plan, and split task packets when needed.
- **Implementer** — executes one spec or task slice; reads the spec and any task; the scoped requirements are the boundary; does not change requirements.
- **Lens reviewer** — reviews one lens (correctness, evidence, design risk, …) and returns findings only.
- **Review lead** — for a formal review, cycles a pool of distinct lens stances one reviewer at a time on the revised change, applies fixes between rounds, and writes the packet.
- **Human/owner** — owns the verdict.

The reviewer is not the implementer. The spec or task author may review the implementation, as long as they did not implement it.

Escalate to a stronger model or session on unclear scope, repeated Verify failures, risky files, or a requirement that needs reinterpretation. A cheaper implementer fits clear, bounded work — but measure the saving by pass rate, rework rate, and review outcome; never assume it.

## Worktree rule

Use one branch or worktree per spec, or per task when the spec is split.

Branch pattern:

```text
suspec/<spec-slug>/<task-slug>
```

For a single-implementer spec:

```text
suspec/<task-slug>
```

Worktrees isolate file state. They do not isolate shared services, ports, databases, or credentials. Configure those separately when needed.
And exclude the worktree folder from your dev tools: vitest, eslint, cargo and friends do not read
`.gitignore`, so worktree copies otherwise show up as duplicated tests or phantom lint errors
(vitest `test.exclude`, eslint `ignores`, …).

## Provenance

For delegated or worker-run specs/tasks, record:

- sources read
- guide loaded
- worker identity
- isolation mode: worktree, shared tree, or patch-only

This is evidence for review. It is not a trust token.

## What the worker must return

The returned spec `## Execution` entry, or task packet when split, contains:

- every verify item checked or marked blocked
- real output pasted under each command
- changed files listed
- out-of-scope edits named
- blocked questions named
- candidate findings listed

Example:

```markdown
## Verify

- [x] `npm run test:integration -- expired-session` (AC-001)

      Test Suites: 1 passed, 1 total
      Tests:       3 passed, 3 total

## Run summary

- Changed files: `src/checkout/expiry.ts`, `test/integration/expired-session.test.ts`
- Verify results:
  - `npm run test:integration -- expired-session` (AC-001): PASS, output above
- Out-of-scope edits: none
- Blocked questions: none
```

## Evidence rule

`Tests passed` is not evidence.

A `Pass` needs pasted output, a CI link, or a named manual observation. Without that, review records `Unverified`.

## Self-review

The worker inspects its own diff before handoff.

Self-review can produce fixes. It does not produce the review result. The result belongs to an independent reviewer.

## Keep the worktree

Keep the worktree until review is final. Review may need to:

- inspect the diff
- rerun commands
- verify changed files
- ask for follow-up work

## Related

- Next: [Reviewing output](08-reviewing-output.md)
- Previous: [Creating tasks](06-creating-tasks.md)
