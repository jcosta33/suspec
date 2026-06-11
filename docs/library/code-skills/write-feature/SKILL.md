---
name: write-feature
type: agent-guide
description: >-
  Implement a feature task: build net-new behavior for a task packet's
  requirements, mapping every AC to a part of the change before coding, with
  pasted evidence per AC. ALWAYS apply when a task packet adds capability that
  did not exist, or acceptance criteria for new behavior are named — even with
  no spec. Do not code before surveying existing patterns, invent a requirement
  to resolve an ambiguity, or refactor in passing. Skip defect fixes,
  behavior-preserving refactors, deliberate rewrites, migrations, performance
  tuning, and test-only work.
---

# Implement a feature

Features fail when the builder improvises around the spec — building past it, smuggling in "while
I'm here" cleanup, or declaring done on a green suite that never exercised the new behavior. This
guide adds the feature discipline on top of the base `implement-task` rules: build exactly what the
requirements name, reuse before you invent, let nothing leave your hand unverified. These are
conventions the review packet inspects — nothing enforces them at edit time.

A feature adds capability that did not exist. Repairing a defect, restructuring without a behavior
change, deliberately changing existing behavior, moving between APIs, and tuning a bottleneck are
different kinds with their own guides in this library.

## Rules

1. **Read the packet and its sources first.** The task packet fixes your scope — the AC list, the
   do-not-change areas, the Verify checklist; the spec says why. Resolve project commands from the
   code repo's `AGENTS.md` Commands table; if a command you need is undefined, ask — never guess.
2. **Map every AC to a concrete part of the change before coding.** Each AC gets a named step in
   your plan. An AC you did not map before coding is one you discover unmet at self-review — or
   one the reviewer discovers for you.
3. **Survey existing patterns before inventing.** Before adding a helper, type, or pattern, search
   the codebase for an existing equivalent — memory is not a survey; it misses the helper added
   last week. If nothing fits, say why in your summary so the reviewer judges the choice instead of
   re-litigating it.
4. **Halt on ambiguity.** If an AC is unclear or contradictory, stop and surface it — do not invent
   the requirement. A guessed requirement commits a decision nobody made; a blocked question keeps
   it visible until someone answers.
5. **Do not refactor opportunistically.** Debt you spot while building is a finding candidate, not
   an inline fix. A feature diff that also restructures unrelated code is unreviewable — the
   reviewer cannot tell the intended change from the smuggled one.
6. **Run the checks after every batch, not only at the end**, and paste output as you go. Catching
   a violation at batch 3 is cheaper than at batch 12, and pasting as you go means the evidence
   exists before the claim that depends on it.
7. **Tests are part of the deliverable, and each must fire for the right reason.** Every AC has a
   corresponding test (or an explicitly noted follow-up task). Prove each test means something by
   **flipping its assertion** (or commenting out the production path it exercises): it must fail;
   restore it: it must pass — paste both transitions. A test that still passes when flipped
   exercises nothing; a green suite that never ran the new behavior proves nothing about it.
8. **Paste real output for every Verify item, after your final edit.** Command, exit status,
   summary lines — fenced, unmodified. "Tests passed" with no output is unverified.
9. **Close with the summary and findings.** Changed files, commands with output, anything unmet as
   written, out-of-scope edits if any, and finding candidates in the packet's `## Findings`
   section. No review result on your own work.

## Refuses

| Temptation                                                          | Do instead                                                          |
| ------------------------------------------------------------------- | ------------------------------------------------------------------- |
| "While I'm here…" — code beyond the listed ACs                      | Build only the assignment; note the rest as finding candidates      |
| An ambiguity resolved by guessing so the build can proceed          | Halt and surface the question; never invent intent                  |
| A new helper that duplicates an existing one                        | Reuse the existing one, or record why it does not fit               |
| An opportunistic refactor of a file the build merely passed through | Keep the diff to the task's areas; raise the cleanup separately     |
| An AC declared met with no evidence for its check                   | Run the bound check; paste the output — uncovered until then        |
| A green suite standing in for the new behavior                      | Flip the new tests' assertions; paste the fail-then-pass transition |
| Quietly switching to fixing or refactoring mid-build                | Surface the concern; the feature scope holds for the whole task     |

## Self-review gate

Before declaring the task done:

- [ ] Every AC maps to a part of the diff you can point at — and no part of the diff exists
      without an AC (or a listed exception) behind it.
- [ ] Every Verify item ran after your final edit, output pasted.
- [ ] Every new test was flipped — failed when flipped, passed when restored — and a
      representative transition is pasted.
- [ ] Every ambiguity you met was surfaced, not resolved by a guess.
- [ ] New helpers or patterns carry a recorded reason an existing one did not fit.
- [ ] The summary names changed files, commands with output, and finding candidates; you issued no
      review result on your own work.

## Bundled resources

- `references/task-template.md` — a working-notes scaffold for the run (plan, progress, decisions,
  pasted evidence, self-review). The task packet itself uses the kit's task template; this scaffold
  is where you keep state while working.
