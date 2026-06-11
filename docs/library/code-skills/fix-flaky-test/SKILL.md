---
name: fix-flaky-test
type: agent-guide
description: >-
  Stabilize a flaky, non-deterministic test: reproduce it by looping, name the
  category of nondeterminism, fix the cause — never the assertion — and prove
  the fix with the same loop, every run passing. ALWAYS apply when a test
  passes sometimes and fails sometimes, CI shows occasional failures of one
  test, a test is skipped or quarantined for flakiness, or "passes locally,
  fails in CI". Never fix by re-run-to-green, a sleep, a timeout bump,
  try/catch, a widened assertion, or quarantine. Skip deterministic failures
  (an ordinary fix) and authoring new tests.
---

# Fix a flaky test

Stop the most tempting non-fix in software: re-running a test until it goes green, calling it
fixed, and shipping the bug. A flaky test fails non-deterministically — green sometimes, red
sometimes, usually worse under CI load than locally. The flake is a **real signal** about the
system: ordering, timing, shared state, or a leaking resource. The only acceptable resolution is to
reproduce it, name the nondeterminism, fix the cause, and prove the fix by looping the _same_ test
under the conditions in which it failed. This guide adds the flake discipline on top of the base
`implement-task` rules. These are conventions the review packet inspects — nothing enforces them at
edit time.

A test that fails 100% of the time after a change is an ordinary defect — load `write-fix`.
Authoring new tests is `write-testing`. This guide stabilizes a test that already exists and
already named itself flaky.

## Rules

1. **Reproduce before you claim to understand.** Loop the test until it fires — typically 100×,
   often 500–1000× for low-frequency flakes — then loop enough to trust the failure rate you
   observe. If it will not reproduce, broaden the conditions (CI-like load, sibling tests
   alongside, pinned or varied seed, advanced clock) rather than concluding it was never real: a
   flake that will not fire is _un-isolated_, not _unreal_. Paste the loop output showing both
   passes and failures — that is the reproduction evidence. Ask how the project loops a single test
   (a repeat flag, a single-test runner) if it is not in `AGENTS.md` — never guess the loop
   mechanism.
2. **Name the category of nondeterminism** — it narrows the fix: timing/ordering · shared state ·
   network/external service · randomness · time/clock · resource exhaustion · environment. A flake
   that mixes categories splits into separate fixes; one fix claiming to cover two is one of them
   masked.
3. **Find the cause in production code or test setup — never in the assertion.** The assertion is
   the messenger. The cause lives in nondeterministic production code (unseeded random, unmocked
   time, a race), un-isolated setup/teardown, the parallel-runner harness, or the environment.
   Trace from the reproduced failure to the line that introduces the nondeterminism.
4. **Fix the cause; never mask it.** Inject the clock or seed instead of reading the real one;
   isolate the shared state (fresh fixture, scoped teardown); wait on the actual contract (a
   settled state, an emitted event) instead of a sleep; reserve and release the contended resource
   correctly.
5. **Prove the fix with the same test, looped.** Loop it under the conditions in which the flake
   reproduced, enough runs to trust the result — every run passing. Paste the output. One green run
   proves only that the failure rate is below 100%; the loop is the only evidence it is now zero,
   not merely low.
6. **Leave a one-liner at the cause site** naming the failure mode (e.g. "session id is seeded; do
   not draw it from a global RNG here") so the next reader recognizes it before reintroducing it.
7. **Hand a production cause downstream.** If the root cause is a real production bug (a race, an
   unhandled rejection, a leak), this task delivers the diagnosis and the now-stable test as its
   regression guard; the production fix is its own task — record it as a finding candidate, do not
   bundle it. And never write a review result on your own work.

## Refuses

| Temptation                                           | Do instead                                                                                  |
| ---------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| "It passed when I re-ran it, so it's fixed"          | One pass proves the failure rate is below 100%; loop it and prove it                        |
| "I added a small sleep and it stopped failing"       | The race is still there; wait on the contract or fix the cause                              |
| "I can't reproduce it, so there's nothing to fix"    | Un-isolated, not unreal — broaden load, siblings, seed, clock                               |
| "I loosened the assertion so it tolerates the drift" | A check too weak to fire guards nothing; fix what makes the value drift                     |
| "I wrapped the flaky call in try/catch"              | Swallowing the signal is widening the assertion by another route                            |
| "I marked it skipped to keep CI green"               | Containment with an owner and a date, never the fix — the cause is live                     |
| "It only flakes in CI and I can't run CI locally"    | Reproduce the CI conditions (load, parallelism, seed) or report Blocked — not a silent pass |
| "The fix is obvious from the diff"                   | A diff does not loop the test; paste the loop output                                        |

## Self-review gate

Before declaring the task done:

- [ ] The reproduction loop output is pasted — failures visible, failure rate measured, under
      conditions no easier than where it originally failed.
- [ ] Exactly one category of nondeterminism is named; a mixed flake was split.
- [ ] The fix is at the cause in production code or test setup — not the assertion, not a sleep,
      not a timeout bump, not try/catch, not quarantine.
- [ ] The fix loop output is pasted — the same test, same conditions, every run passing.
- [ ] A one-line note marks the cause site; a production-side cause is recorded as a finding
      candidate with this test as its regression guard.
- [ ] You issued no review result on your own work.

## Bundled resources

- `references/task-template.md` — a working-notes scaffold for the run (flake category, reproduction
  protocol and evidence, hypothesis tracker where each rejected attempt teaches the next, fix
  evidence, self-review). The task packet itself uses the kit's task template.
