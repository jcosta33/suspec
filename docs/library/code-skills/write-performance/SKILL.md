---
name: write-performance
type: agent-guide
description: >-
  Implement a performance task: optimize a measured bottleneck to a numeric
  target — baseline before any edit, identical measurement protocol on both
  sides, one benchmarked change at a time, full suite green after each. ALWAYS
  apply when a task packet optimizes, profiles, or cuts latency / memory / CPU
  / allocations against a metric — or gates a model-quality metric (an
  eval-gated requirement). Never edit before a baseline, mix protocols,
  batch unattributable changes, or accept "make X faster" as the target. Skip
  correctness fixes, refactors, rewrites, migrations, and net-new features.
---

# Implement a performance change

Performance work fails two ways, both producing a diff that looks like a win: **a number that moved
on the benchmark but not in production** (measured under conditions that don't match where the
system is slow, or against a baseline taken under a different protocol), and **a speedup that
quietly broke correctness** — a faster wrong answer is still a defect. This guide adds the
performance discipline on top of the base `implement-task` rules. These are conventions the review
packet inspects — nothing enforces them at edit time.

Plan the transformation first — the workspace's change plan covers baseline, waves, and rollback;
this guide is the execution half. Numbers, not vibes: nothing is faster until a baseline and a
final figure, under the identical protocol, say so. No number and no protocol is tinkering, not
optimizing — get the target before you start.

## Rules

1. **Measure the baseline before you change any code.** Run the benchmark in your worktree and
   paste the output before touching the implementation. "Improvement" is meaningless without a
   fixed reference point; a baseline reconstructed after the change is unfalsifiable.
2. **The target is a number under named conditions** — "p95 latency of `getQuote()` under 1k RPS
   drops from 240 ms to ≤ 80 ms", not "make X faster". If the task gives only a direction, surface
   a blocked question and get the number first: an unquantified goal is declarable met by any
   change in the right direction, which is how a rounding-error gain ships as done.
3. **State a falsifiable hypothesis and profile to confirm it before optimizing.** "Allocations in
   the hot loop dominate; cutting them 50% should drop latency ≥ 30%" can be disproven; "I think
   this is slow" cannot. Optimizing a path you never profiled is the most common way perf effort
   produces no production gain.
4. **Identical protocol before and after — or the comparison is void.** Warmup, sample count,
   statistical aggregate, hardware, environment, input shape, cache state: record the protocol
   once, reuse it verbatim. A cold baseline against a warm final "proves" a speedup that does not
   exist. If the figure is noisy, run more samples until it is stable — noise is not evidence.
5. **One benchmarked change at a time.** Per iteration: change → re-run the benchmark under the
   protocol → compare → run the full suite. Batched optimizations are unattributable — you cannot
   tell which moved the number, which regressed it, which is dead weight. A second bottleneck found
   mid-task is a finding candidate, not a second edit.
6. **The full suite runs after every change, output pasted.** Performance work does not get to
   skip the suite: the benchmark proves the number moved; only the suite proves you did not break
   what it was measuring. Behavior changed under a "perf" label is a rewrite in disguise — surface
   it.
7. **Document the conditions and honor the ceiling.** Record the input shape, load, hardware, and
   cache state under which the gain holds — the next reader otherwise assumes it is universal. The
   change plan's rollback criteria set the regression ceiling on other metrics; a change that
   breaches it rolls back regardless of the primary gain.
8. **Annotate the clever parts.** If the optimization cost readability, justify the trade against
   the measured gain and leave a call-site comment saying what the unusual structure is for —
   otherwise the next refactor unwinds it and the gain is lost silently.
9. **Paste real output; resolve commands (including the benchmark command) from `AGENTS.md`; ask
   when one is undefined** — a guessed benchmark invocation produces a baseline the final figure
   cannot honestly be compared against. And never write a review result on your own work.

## Refuses

| Temptation                                                    | Do instead                                                       |
| ------------------------------------------------------------- | ---------------------------------------------------------------- |
| "It feels faster" / "this should be faster"                   | Measure under the protocol; paste before and after               |
| Optimizing before a baseline exists                           | Baseline first, before any code change                           |
| Baseline cold, final warm (or different samples, host, input) | Identical protocol on both sides, recorded once                  |
| Several optimizations bundled into one change                 | One benchmarked change at a time                                 |
| "I'll skip the suite; it's just a perf change"                | Full suite after every change; paste it                          |
| "Make X faster" accepted as the target                        | Get a number under named conditions, or raise a blocked question |
| "The variance is high but my speedup is real"                 | More samples until stable; noise is not evidence                 |
| Shipping the gain while another metric breached the ceiling   | Roll back; the ceiling is the agreed trade boundary              |
| Behavior changed under a perf label                           | Surface it — that is a rewrite in different scope                |

## Self-review gate

Before declaring the task done:

- [ ] The baseline output is pasted and was captured before any code change.
- [ ] The final benchmark is pasted, under the provably identical protocol, against a numeric
      target.
- [ ] Each change was benchmarked individually — you can point at which change moved the number.
- [ ] The full suite ran after every change and after your final edit; output pasted.
- [ ] The conditions under which the gain holds are recorded; no other metric breached the
      ceiling.
- [ ] Readability costs are annotated at the call site; second bottlenecks are finding candidates.
- [ ] You issued no review result on your own work.

## Model-quality metrics — the stochastic delta

An eval-gated requirement (NDCG, accuracy, win rate) runs the same discipline with one delta:
the measurement is stochastic, so pin the protocol — seed or fixed dataset/holdout, metric,
threshold (docs/04's protocol rule) — and state a variance budget (N runs, the aggregate).
Evidence is the eval-run link or output under the same pinned protocol on both sides. The
rules above apply unchanged; the Skip list still excludes net-new feature work.

## Bundled resources

- `references/task-template.md` — a working-notes scaffold for the run (baseline block, target and
  ceiling, hypothesis, measurement protocol, per-change ledger, pasted evidence, self-review). The
  task packet itself uses the kit's task template.
