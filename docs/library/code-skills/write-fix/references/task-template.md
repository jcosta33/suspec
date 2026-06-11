# Run notes: {{title}}

- Task packet: `tasks/{{TASK-slug}}.md`
- Bug report: `{{path}}`
- Spec defining the broken behavior (if any): `{{path}}`
- Worktree / branch: {{branch}}
- Created: {{YYYY-MM-DD}} · Status: active

> **Fix task** — reproduce the defect, patch the root cause (not the symptom), bind a regression
> test that fails before the patch and passes after, run the full suite, paste the evidence.
>
> **Commands** resolve from the code repo's `AGENTS.md` Commands table. For any command you need
> that is undefined, ask the user — do not guess; a guessed test command is a false signal about
> whether the bug is gone.
>
> **Flaky?** If the failing test is non-deterministic, this is the wrong scaffold — a flake's
> evidence is a loop run, not a single reproduction. Use the `fix-flaky-test` guide instead.

## Scope (from the task packet)

- In: the named defect and its ACs only.
- Do not change: {{areas the packet rules out}}; neighboring bugs and "while I'm here" cleanup go
  to Findings.

## Reproduction (paste actual output — the bug must fire here)

Re-run the bug report's reproduction in *this* worktree before patching. If it does not fire, do
not patch — record a blocked question and investigate the environment discrepancy (it is itself a
finding, not a dismissal).

```text
{{paste reproduction output — the bug firing}}
```

## Hypothesis trail

Each fix attempt is a row. When an attempt fails, write what that teaches the next one — the trail
is what stops the next attempt from repeating a dead end.

| # | Hypothesis | Attempt | Outcome | What it teaches |
|---|---|---|---|---|
| 1 | | | | |

## Root cause

- **Symptom:** {{what fails, where}} — `{{file}}:{{line}}`
- **Cause:** {{the mechanism — the state plus input that triggers it}} — `{{file}}:{{line}}`
- Why this is the cause and not merely where the failure became visible:

## Progress checklist

- [ ] Bug report read; reproduction re-run in this worktree, output pasted
- [ ] Cause located at file:line — traced from the symptom, not the first suspicious line
- [ ] Minimal patch at the cause
- [ ] Regression test added — fails with the fix patched out (verified, output pasted)
- [ ] Regression test passes with the fix restored (output pasted)
- [ ] Full suite + checks clean after the final edit (output pasted)
- [ ] No bundling; related defects recorded as findings
- [ ] Self-review answered with pasted evidence

## Evidence (paste actual command output — never paraphrase)

- Pre-patch reproduction (the bug fires):
- Regression test, fix patched out (goes red):
- Regression test, fix restored (goes green):
- Full test suite after the final edit (last lines + exit):
- Check command (last lines + exit):

## Decisions

Why this patch addresses the cause — the reviewer checks exactly this. ("The patch worked" is
evidence, not a decision; it goes above.)

-

## Findings

Neighboring bugs, refactor opportunities, missing tests elsewhere — candidates for the workspace's
`findings/` at Close.

-

## Blocked questions

A reproduction that will not fire, a requirement the fix cannot meet as written.

-

## Next steps

-

## Self-review

Answer in writing, evidence pasted. A symptom-patch leaves the bug latent — close as a reviewer
hostile to "looks fine".

- **Root cause:** did the patch land at the cause's file:line, or suppress a symptom elsewhere?
  Could the bug recur via a different path under the same cause?
- **Regression test:** does it fail when the fix is patched out — verified, transition pasted? Does
  it assert behavior, not internal state?
- **Side effects:** did the full suite pass after the final edit, output pasted?
- **Scope:** minimal fix only; related defects recorded as findings, not bundled; nothing outside
  the packet's areas touched.
- **Independence:** no review result issued on your own work.
