---
type: adr
id: adr-0131
status: accepted
created: 2026-07-04
updated: 2026-07-04
---

# ADR-0131 — Minimum useful rigor: no ceremony without leverage

## Context

A refinement report ("Ceremony Does Not Improve Agent Output by Itself") argued Suspec should default
to less process and more proof. Most of its direction is already shipped doctrine — the who-should-not-
use case ([ADR-0057](./0057-practical-first-repositioning.md), `docs/01`), disposable run-scoped task
briefs, manual/cost-tiered heavy review ([ADR-0122](./0122-revolver-review-bounded-panel-strategy.md),
[ADR-0124](./0124-opt-in-per-lens-cost-tier-routing.md)), and skills paired with their counterweight
([[SWESKILLS]] with [[SKILLSBENCH26]]). What was missing is the doctrine stated **once, plainly**, with
the internal measurement that motivates it recorded honestly rather than as a slogan.

**The measurement, in its own words (suspec-works DP-9, the first controlled A/B of the whole loop —
local, unpublished, pre-registered).** A 15-task battery run through four arms (full loop / plan-then-
implement / gate-only / skills-only): **every arm hit 100% oracle-pass with zero regressions** (A 15/15,
B 15/15, D 6/6, E 3/3), at a ceremony cost of **~2.6× for the full loop**. The finding's own conclusion:
"On tractable, clearly-specified tasks the loop is correctness-neutral overhead — now with data,
matching the docs' own guidance. The loop's value for hard, ambiguous, or long-horizon work where
implementers *do* ship defects remains **plausible and unproven**." The direct gate test could not fire:
a capable model on unambiguous briefs shipped no defects, so the gate had nothing to catch — "the
framework's own 'who should not use this' guidance (small, clear, tractable work) confirmed with data,
not a refutation of the loop for hard work." Cost is model-confounded (two models mid-run); only the
**correctness parity** is robust.

Three guardrails on the way in, so the doctrine records the evidence and not more than the evidence:

1. **No "ceremony doesn't improve output" claim.** DP-9 showed *parity on tractable work* and could not
   test the hard-work regime; the slogan overstates it, and canon already forbids it —
   [ADR-0117](./0117-no-count-bearing-prose.md) (no count-bearing prose in public/current copy) and
   [ADR-0063](./0063-honesty-framework-and-tooling-boundary.md) (no data-shaped claim without a level and,
   for enforcement, a shipped tool).
2. **A non-ceremony counterweight exists.** Under the same discipline, implementers refused to fabricate
   evidence when asked (suspec-works #90) — a benefit of the honesty framing that is not process bulk.
   Cutting rigor to zero is not the lesson; cutting *unleveraged* rigor is.
3. **Targeted structure still measurably helps.** A lean plan the coder then follows buys a real gain
   ([[SELFPLAN]] +25.4% Pass@1; [[PLANCOMPLY]] plan + reminders improve compliance), and reducing detail
   can *also* help by not misleading retrieval ([[UNDERSPEC-HELPS]]). The variable is leverage and task-
   fit, not artifact count — the same split [[SWESKILLS]]/[[SKILLSBENCH26]] found for skills.

## Decision

**Default to the least rigor that still leaves enough proof; add structure only where it changes
execution quality or reviewability.** Two operational tools carry the doctrine, both introduced by this
ADR:

1. **The rigor ladder** (`docs/reference/rigor-escalation.md`): named L0–L5 rungs (prompt-only → lean
   spec → spec + task → + independent review → Revolver panel → orchestrated waves), **default L1 or
   L3, the top rung is never the default**, keyed to the existing risk axis — size / diffusion / churn /
   change-type ([ADR-0094](./0094-decomposition-and-risk-weighted-review.md)). _Level: convention._
2. **The artifact leverage test** ([ADR-0109](./0109-output-economy-convention.md), extended this pass):
   every artifact, section, and template earns its place by improving at least one of {clarity, scope,
   execution-context, verification, reviewability, durable-memory}; if it has no consumer, cut it.
   _Level: checklist (a spec-check / review item, not a shipped enforcer)._

**One convention line, reinforcing existing skip-clauses (not a new field).** Escalating to a heavy mode
— a Revolver panel, an orchestrated fan-out, a durable task brief on otherwise 1:1 work — SHOULD state
its reason (the risk that warrants the cost). This is prose, resolved by review; it adds no machine-
readable `complexity_justification` field. _Level: convention._

**What stays fixed.** The independent-review invariant ([ADR-0119](./0119-independent-review-invariant.md))
and the evidence gate ([ADR-0121](./0121-evidence-gating-load-bearing-mechanic.md)) are not "ceremony" to
trim — they are the minimum, not the surplus. Minimum useful rigor lowers the *default rung*, never the
floor that keeps a completion claim honest.

## Consequences

- A single stated doctrine the ladder and the leverage test both point at, consistent with the vocab
  tiers, the output-economy floor, and the risk-weighted-review rule already in canon.
- **Not enforced.** No hook, no `checks.yaml` rule, no contract change (ADR-0063). The ladder is a how-to
  reference; the leverage test is a review checklist item; the escalation-reason line is a convention a
  reconcile pass MAY note but does not gate.
- The DP-9 record stays private and descriptive (single operator, N=15, model-confounded cost); this ADR
  cites it as recorded rationale, not as a published result. The burden of proof for the loop's hard-work
  value moves to a harder task battery, not more easy-task replications — a future suspec-experiments run,
  out of scope here.

## Affected obligations / constraints

- **Refines:** [ADR-0057](./0057-practical-first-repositioning.md) (practical-first positioning) and
  [ADR-0094](./0094-decomposition-and-risk-weighted-review.md) (risk-weighted scrutiny — adds the named
  ladder). **Extends:** [ADR-0109](./0109-output-economy-convention.md) (the leverage test generalizes
  output-economy from agent output to all artifacts).
- **Honors:** [ADR-0117](./0117-no-count-bearing-prose.md), [ADR-0063](./0063-honesty-framework-and-tooling-boundary.md)
  (no slogan, no unlevelled claim), [ADR-0119](./0119-independent-review-invariant.md),
  [ADR-0121](./0121-evidence-gating-load-bearing-mechanic.md) (the floor is not trimmed).
- **Grounded by:** [[SELFPLAN]], [[SWESKILLS]], [[SKILLSBENCH26]], [[PLANCOMPLY]], [[UNDERSPEC-HELPS]],
  [[BUILDAGENTS]]; the [[INSTRROT]] boundary (stale artifacts are prevalent but their output-quality
  effect is unmeasured — the leverage test cuts by consumer, not by an unproven decay claim).
- **Does NOT change:** the artifact formats, the verdict model, or the checks contract; introduces no
  enforcement and no provider-specific mechanism.

## Status

Accepted (2026-07-04).
