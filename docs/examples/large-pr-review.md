# Example: large PR review

Goal: review a 41-file agent PR without reading it blindly top to bottom — review-first.
The reviewer trusts the review packet, not the worker's summary.

## Situation

An agent refactored checkout session handling. Its own spec (`SPEC-checkout`) and task
(`TASK-checkout-session-refactor`) already exist, from the PR's own author.

Claim:

```text
All checkout session behaviors preserved.
```

Risk:

- 41 files changed
- checkout is a money path
- CI is green
- the worker summary is broad and unsupported

## Inventory

The reviewer first records current behavior, beside their own working files:

```text
~/.claude/notes/shop-api/checkout-session-inventory.md
```

```markdown
---
type: inventory
id: INV-checkout-session
---

## Observed behavior

- active session can pay
- expired session returns `409 SESSION_EXPIRED`
- missing session returns `404`
- payment provider errors return `502`

## Tests

- `npm run test:integration -- checkout-session`
```

## Change plan

`~/.claude/notes/shop-api/checkout-session-change-plan.md`

```markdown
---
type: change-plan
id: CHANGE-checkout-session-refactor
preserves:
  - SPEC-checkout#AC-001
  - SPEC-checkout#AC-002
  - SPEC-checkout#AC-003
  - SPEC-checkout#AC-004
---

## Preservation guarantees

| ID | Behavior | Verify |
| --- | --- | --- |
| AC-001 | active session can pay | `npm run test:integration -- active-session` |
| AC-002 | expired session returns 409 | `npm run test:integration -- expired-session` |
| AC-003 | missing session returns 404 | `npm run test:integration -- missing-session` |
| AC-004 | provider failure returns 502 | `npm run test:integration -- provider-failure` |
```

## Review packet

`~/.claude/notes/shop-api/checkout-session-refactor-review.md`

```markdown
---
type: review
id: REVIEW-checkout-session-refactor
task: TASK-checkout-session-refactor
pr: none yet
status: needs-human
---

## Changed files

- 41 files changed
- risky path: checkout/payment

## Requirement coverage

| ID | Result | Evidence | Human attention |
| --- | --- | --- | --- |
| AC-001 | Pass | `active-session` -> `1 passed` | no |
| AC-002 | Fail | `expired-session` -> expected 409, got 500 | yes |
| AC-003 | Pass | `missing-session` -> `1 passed` | no |
| AC-004 | Pass | `provider-failure` -> `1 passed` | no |

## Human attention

1. AC-002 fails: expired sessions now return 500.
2. Money path changed: inspect checkout charge ordering.
3. Out-of-scope file changed: `src/retry.ts` was not in the task affected areas.

## Suggested decision

Do not merge. Fix AC-002 and explain `src/retry.ts`.
```

Check it, against the PR author's own spec and task, by explicit path:

```bash
suspec check ~/.claude/notes/shop-api/checkout-session-refactor-review.md \
  --spec ~/.claude/notes/shop-api/checkout-spec.md \
  --task ~/.claude/notes/shop-api/checkout-session-refactor-task.md
```

A `Fail` row with evidence attached isn't what the checker objects to — AC-002 is
honestly reported, so this reports clean or warning-level rows at most. What it would
block on is a `Pass` row with no evidence, or a `task:` reference that resolves to
nothing. The decision to not merge here comes from the human-attention list, not from
the check's exit code — the check keeps the packet honest, the human decides.

## Follow-up task

```markdown
---
type: task
id: TASK-checkout-expiry-regression
source:
  - REVIEW-checkout-session-refactor
scope: [AC-002]
status: review-ready
---

## Scope

- AC-002 - expired checkout session returns `409 SESSION_EXPIRED`.

## Do not change

- payment provider retry behavior

## Verify

- [x] `npm run test:integration -- expired-session` (AC-002)

      expected 409
      received 409
      1 passed
```

## Second review

`~/.claude/notes/shop-api/checkout-expiry-regression-review.md`

```markdown
---
type: review
id: REVIEW-checkout-expiry-regression
task: TASK-checkout-expiry-regression
pr: none yet
status: pass
---

## Requirement coverage

| ID | Result | Evidence | Human attention |
| --- | --- | --- | --- |
| AC-002 | Pass | `expired-session` -> `1 passed` | no |

Spot-checked: AC-002 - reran test; output matched.

## Suggested decision

Merge follow-up, then re-review original PR state.
```

Check the follow-up:

```bash
suspec check ~/.claude/notes/shop-api/checkout-expiry-regression-review.md \
  --spec ~/.claude/notes/shop-api/checkout-spec.md \
  --task ~/.claude/notes/shop-api/checkout-expiry-regression-task.md
```

Exits clean: one row, `Pass`, evidence present.

## Close

The regression is worth remembering — save it as a native memory:

```markdown
## Broad checkout CI can pass while expired-session handling regresses

Verified: checkout-session-refactor-review.md, AC-002 -> expected 409, got 500,
before the follow-up fix (checkout-expiry-regression-review.md, AC-002 -> 1 passed)

Applies to: checkout session refactors.
Does not apply to: changes that don't touch checkout session status handling.
```

## Lesson

Review by exception found three things the worker summary hid:

- one failed requirement
- one risky path
- one out-of-scope file

None of the three showed up in "All checkout session behaviors preserved," and none
showed up in a green CI run. The review packet — not the claim — is what a reviewer can
actually check.
