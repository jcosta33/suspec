# Task and implement

This page produces a task packet and its filled-in run evidence.

This split is optional. For a one-worker feature, skip step 1 and hand the worker the
spec directly — the worker records changed files, verify results, and blocked questions
under the spec's own `## Execution` section, and step 3 in [Review](03-review.md) checks
the review against `--spec` alone, with no `--task` flag. This tutorial cuts a task
anyway, so you can see the split-work shape.

## 1. Split the work

Use the split-work skill (or cut it by hand) to carve a scope-subset off the spec. A
task never adds a requirement — it only narrows to what one worker will do.

Place it beside the spec:

```text
~/.claude/notes/shop-api/checkout-expiry-task.md
```

```markdown
---
type: task
id: TASK-checkout-expiry
source:
  - SPEC-checkout
scope: [AC-001]
status: ready
---

# Task: Expired checkout session returns 409

## Source

- `~/.claude/notes/shop-api/checkout-expiry-spec.md`

## Scope

- AC-001 - A checkout session older than 30 minutes returns `409 SESSION_EXPIRED`, never a 5xx.

## Do not change

- the `sessions` table schema

## Affected areas

- `src/checkout/`
- `test/`

## Verify

- [ ] `npm run test:integration -- expired-session` (AC-001)

## Agent instructions

Read the source spec's Intent and Non-goals before touching code. Stay inside Affected
areas. Stop and ask before touching anything in Do not change.
```

Check, by hand:

- scope is `[AC-001]`
- `Do not change` names the schema
- verify command matches the spec
- agent instructions are concrete, not a placeholder

## 2. Dispatch and implement

Use the implement-task skill, or hand the task to a worker directly — dispatch by
explicit path so nothing has to be discovered or guessed:

```text
Read ~/.claude/notes/shop-api/checkout-expiry-task.md and do what it says.
```

Use one worktree or branch per task, e.g.:

```bash
git worktree add -b suspec/checkout-expiry ../shop-api--checkout-expiry main
```

## Expected return

The worker pastes real output under the verify item and fills the run summary:

```markdown
## Verify

- [x] `npm run test:integration -- expired-session` (AC-001)

      Test Suites: 1 passed, 1 total
      Tests:       3 passed, 3 total

## Findings

- Candidate findings: none

## Run summary

- Changed files: `src/checkout/expiry.ts`, `src/api/errors.ts`, `test/integration/expired-session.test.ts`
- Verify results:
  - `npm run test:integration -- expired-session` (AC-001): PASS, output above
- Out-of-scope edits: none
- Blocked questions: none
```

Check, by hand:

- output is pasted, not summarized
- changed files are listed
- out-of-scope edits are named, even if `none`
- blocked questions are named, even if `none`

Next: [Review](03-review.md).
