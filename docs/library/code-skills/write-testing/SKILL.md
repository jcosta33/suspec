---
name: write-testing
type: agent-guide
description: >-
  Implement a testing task — tests are the deliverable: behavior through the
  public surface, one reason to fail per test, each proven by flipping the
  assertion. ALWAYS apply when a task packet adds tests, closes a coverage gap,
  writes a regression test, or hardens a suite. Never assert internals, bundle
  unrelated behaviors, chase a coverage percentage, ship an unflipped test, or
  edit production code to ease a test. Skip tests that ride inside feature/fix
  work, and stabilizing an existing flaky test (fix-flaky-test).
---

# Implement tests

Tests fail their job in three quiet ways: the test that passes even when the code under test is
commented out (pure ceremony), the test that reaches into internals and shatters on a
behavior-preserving refactor (the test broke, not the code), and the test that bundles six
unrelated assertions so a failure says "something broke" without saying what. All three are
net-negative — they cost maintenance and catch nothing. This guide adds the testing discipline on
top of the base `implement-task` rules. These are conventions the review packet inspects — nothing
enforces them at edit time.

This guide is for tests as the deliverable in their own right. Tests written _as part of_ a feature
or fix ride inside those guides; a test that already fails non-deterministically belongs to
`fix-flaky-test`.

## Rules

1. **Name the coverage gap as a behavior before writing any test** — which module, behavior, and
   conditions a caller depends on, not which lines. "This file is 40% covered" breeds shallow tests
   that chase the percentage; "the retry path does not back off on the third failure" breeds a test
   that catches a real bug.
2. **Exercise the public surface.** Assert on what a caller observes — never on private methods or
   module-private state. An internals test breaks on a behavior-preserving refactor: a false
   failure, not a caught defect.
3. **One reason to fail per test.** Split anything bundled; a multi-assertion case says "something
   broke" without saying which behavior. Give each test a name (and assertion message, where the
   runner supports it) that tells the person who broke it what behavior broke.
4. **Flip every test to prove it means something.** After writing each test, flip its assertion
   (or comment out the production path it exercises): it must fail. Restore: it must pass. Paste a
   representative fail-then-pass transition. Without the flip, "it passes" is unfalsifiable — the
   test could be tautological, fire for an unrelated reason, or never run.
5. **When a test is the verification for a named AC, prove it fires for that AC's reason.** A green
   flip shows the test fires — not that it fires when _that requirement_ is violated rather than
   some adjacent condition. If no fail-when-violated test can be built, that goes back to the spec
   author as a blocked question (rebind the AC to a command or manual check) — never ship a
   green-but-irrelevant test.
6. **Strengthen the check where the stakes are high.** For a high-risk requirement or an invariant
   (a universal claim one example cannot establish), a single concrete test is a weak check — reach
   for property-based, metamorphic, or mutation-backed coverage and record what it exercised.
7. **Keep every test deterministic.** No ordering dependencies, timing assumptions, shared mutable
   state, unsandboxed network, or unseeded randomness. A flaky test trains developers to ignore
   failures — it disarms the whole suite.
8. **Never edit production code to make a test easier to write** unless the task's scope says so.
   That inverts the dependency — the test exists because of the code's behavior, never the reverse.
   Hard-to-test code is a finding candidate; a bug a test exposes is the highest-value finding this
   work produces — record it, don't fix it inline.
9. **Read coverage as a map, not a score**, place tests per the project's existing conventions
   (a test in the wrong place never runs — a green tick that guards nothing), run the whole suite,
   and paste real output. Resolve commands from `AGENTS.md`; ask when one — including a single-test
   or coverage runner — is undefined. And never write a review result on your own work.

## Refuses

| Temptation                                            | Do instead                                                            |
| ----------------------------------------------------- | --------------------------------------------------------------------- |
| "It's green, it's fine" — a test shipped with no flip | Flip it; paste the fail-then-pass transition                          |
| An assertion on a private method or internal state    | Re-aim at what a caller observes                                      |
| Several unrelated behaviors in one case               | Split — one test, one reason to fail                                  |
| "Get this file to 85% coverage"                       | Coverage maps untested behavior; it is never the target               |
| An AC-bound test that passes for an adjacent reason   | Confirm it fails when _that_ requirement is violated                  |
| One concrete example as the check for an invariant    | Strengthen to property/metamorphic/mutation; record what it exercised |
| Editing production code "to make the test easier"     | Finding candidate; leave the code alone                               |
| A bug the test exposed, fixed inline                  | Record it as a finding; the fix is its own task guarded by this test  |
| "It usually passes"                                   | Make it deterministic, or surface stabilization as its own task       |

## Self-review gate

Before declaring the task done:

- [ ] Every new test was flipped — failed when flipped, passed when restored — with a
      representative transition pasted.
- [ ] The whole suite ran after your final edit; output pasted.
- [ ] Each test exercises the public surface and has exactly one reason to fail.
- [ ] Each AC-bound test fails when its requirement is violated, not an adjacent condition;
      high-stakes requirements carry a strengthened check with a note of what it exercised.
- [ ] No production code changed outside the task's scope; bugs exposed and hard-to-test designs
      are recorded as finding candidates.
- [ ] No ordering, timing, shared-state, network, or randomness dependency that could flake in CI.
- [ ] You issued no review result on your own work.

## Bundled resources

- `references/task-template.md` — a working-notes scaffold for the run (coverage gap, test-case
  table keyed by behavior, placement table, flip evidence, self-review). The task packet itself
  uses the kit's task template.
