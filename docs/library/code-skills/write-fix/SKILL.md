---
name: write-fix
type: agent-guide
description: >-
  Implement a fix task: reproduce the defect, patch the root cause, bind a
  regression test that fails before the patch and passes after, run the full
  suite, paste the evidence. ALWAYS apply when asked to fix, patch, resolve, or
  close a bug, regression, or defect. Never patch the symptom, ship without the
  red-before/green-after transition, or bundle neighboring fixes. Skip writing
  the bug report (a kit guide), behavior-preserving refactors, rewrites — and a
  flaky, non-deterministic failure, which has its own fix-flaky-test guide.
---

# Implement a fix

Fixes fail two ways, both producing a green-looking diff that ships the bug. **Patching the
symptom**: suppressing the visible failure while the cause survives, so the defect recurs through a
different path. **A regression test that does not exercise the bug**: one green before the patch
proves nothing, because it stays green if the fix is deleted. This guide adds the fix discipline on
top of the base `implement-task` rules. These are conventions the review packet inspects — nothing
enforces them at edit time.

Writing the bug _report_ is a different job with its own guide in the starter kit's advanced tier
(`write-bug-report`) — this guide consumes a report and produces the fix. A test that fails
_sometimes_ is a different oracle entirely: load `fix-flaky-test`, not this.

## Rules

1. **Reproduce the bug in your worktree before you patch.** Re-run the report's reproduction and
   paste the failing output. If you cannot reproduce, do not patch — the discrepancy between your
   environment and the report's is itself a finding (versions, seeds, fixtures, clock, OS), not a
   dismissal. The reproduction is the falsification target for the whole task; without it, "fixed"
   is a claim with no possible counter-evidence.
2. **Patch the root cause, not the symptom.** Before patching, restate in your own words why this
   location is the cause and not merely where the failure became visible; if you cannot, you have
   not root-caused it (see _Hunting the cause_ below). Swallowing the error, clamping the value, or
   special-casing the one triggering input leaves the cause live under a different trigger.
3. **The regression test fails before the fix and passes after.** Patch your fix _out_ (revert it,
   or comment out the path it touches); run the test — it must fail. Restore the fix; run it — it
   must pass. Paste both transitions. A regression test that stays green when the fix is removed is
   a tautology. Assert on the behavior the bug broke — the output, the returned value, the emitted
   event — not on internal state.
4. **Run the full suite, not just the regression test**, and paste the output. A patch that passes
   its own test but breaks a neighbor trades a known bug for an unknown one.
5. **Keep the fix minimal; no bundling.** Bugs have neighbors, and a fix task is the most tempting
   place to "just also fix" the related defect or rename the confusing variable. Don't. Every
   related discovery is a finding candidate in your summary, not a second fix in the diff — a
   one-cause fix is reviewable; a bundle is not.
6. **Record why the patch addresses the cause** in your summary, in one or two sentences. The
   reviewer checks exactly this. "The patch worked" is a verification output, not a reason.
7. **Paste everything; resolve commands from `AGENTS.md`; ask when a command is undefined.** A
   guessed test command produces a false signal about whether the bug is gone. And never write a
   review result on your own work.

## Hunting the cause

Root-causing demands hostility to the first plausible explanation:

- **The first suspicious line is rarely the origin.** Trace from the observable failure back to
  the state-plus-input that produces it; a correlated symptom upstream of the cause is the classic
  false catch.
- **Anchor the cause at file:line, with the state and input that trigger it.** "Somewhere in the
  cache layer" is a symptom location. A cause you cannot anchor, you cannot prove patched.
- **State Expected vs Actual, and Expected by whose authority.** Expected comes from the spec's
  requirement, not your opinion of good behavior. If no requirement covers the broken behavior,
  say so — that coverage gap is itself a finding.
- **"Can't reproduce" is a lead, not an exit.** Vary what the report could not: load, parallel
  siblings, seed, clock, data state. Surface a blocked question if it still will not fire.

## Refuses

| Temptation                                                       | Do instead                                                       |
| ---------------------------------------------------------------- | ---------------------------------------------------------------- |
| Patching where the failure is visible instead of where it starts | Trace to the cause; restate why that location is the origin      |
| A regression test that was never seen red                        | Patch the fix out; paste the failing run, then the passing one   |
| "I can't reproduce it, must be environment-specific"             | The discrepancy is the finding; investigate or surface a blocker |
| "While I'm here, this related bug…"                              | Finding candidate in the summary; one cause per fix              |
| A test asserting internal state                                  | Assert the behavior the bug broke                                |
| "Tests passed" with no command, exit, or output                  | Paste the real, re-runnable output                               |
| Re-running a sometimes-failing test until green                  | Wrong guide — load `fix-flaky-test`                              |

## Self-review gate

Before declaring the task done:

- [ ] The pre-patch reproduction output is pasted — the bug fired in _your_ worktree.
- [ ] The regression test's red-then-green transition is pasted (fix patched out, then restored).
- [ ] The full suite ran after your final edit, output pasted.
- [ ] The summary states why the patch addresses the cause, not the symptom.
- [ ] The diff is the minimal fix; related defects are finding candidates, not edits.
- [ ] You issued no review result on your own work.

## Bundled resources

- `references/task-template.md` — a working-notes scaffold for the run: reproduction block,
  hypothesis trail (each rejected attempt teaches the next), progress checklist, pasted evidence,
  self-review. The task packet itself uses the kit's task template.
