---
type: adr
id: adr-0132
status: accepted
created: 2026-07-04
updated: 2026-07-04
---

# ADR-0132 — Revolver Review is a rotating adversarial refine-loop (supersedes ADR-0122; refines ADR-0124; removes the adversarial-review skill)

## Context

[ADR-0122](./0122-revolver-review-bounded-panel-strategy.md) named Revolver Review a **bounded parallel
panel**: pick a few lenses, run them blind at once over one frozen diff, reconcile once, hand a human the
findings. That is a review *gate*. It does not match the mechanism the name implies — a revolver's
cylinder **rotates**, chambers fire a few at a time, and each shot lands on the **current** target. Two
gaps followed from the panel framing: it reviews the original diff and is therefore **structurally blind
to the defects a fix introduces**, and it never converges the work — it only reports.

A July 2026 evidence pass (inline; a few web searches, not a fan-out) grounded the corrected mechanism.
The **moves are well-supported**; the **specific numbers are evidence-consistent defaults, not proven
optima** — recorded honestly so no reader mistakes a tuned default for a measured constant.

- **Re-review the revised state.** Iterative fixing routinely introduces new defects; only re-reviewing
  the post-fix code catches them — a one-shot panel cannot. (Iterative-repair evidence; the regression
  hazard is the load-bearing point.)
- **External feedback, not self-correction.** Intrinsic self-correction fails and can *degrade* output
  ([[SELFCORRECT]], ICLR 2024); fresh, independent reviewers on the revised state are the external signal
  ([[CCR]]) — so the party that applied a fix is never a reviewer of it.
- **Blind within a round, adjudicated between rounds.** Reading peers' raw drafts induces sycophancy
  ([[CONSENSUSCOST]], [[FLIPFLOP]]); a later round receives the orchestrator's reconciled/fixed state,
  never another reviewer's raw draft.
- **Distinct perspectives, cheap and varied models.** Coverage comes from perspective diversity, not
  reviewer count ([[PBR]]); correlated reviewers ≈ one reviewer, and **diverse signals beat more compute**
  ([[ENSEMBLEDIV]], [[DIVSCALE]]) — so cheaper varied models are the default, not a compromise.
- **Union, never vote.** Consensus aggregation drags a panel below its best member ([[EXPERTSBACK]]).
- **Cap the loop.** Iterative gains plateau fast and extra rounds add noise/over-edit risk; more review
  volume dilutes ([[REVBOTPR]]); a single agent can match a panel under matched compute ([[SINGLEBEATSMAS]]).

## Decision

**Revolver Review is a rotating, self-converging adversarial refine-loop.** _Level: convention._

1. **The mechanism** (superseding ADR-0122's bounded-panel form): a pool of **6–9 distinct stances**;
   fire **3 reviewer subagents per round**, blind and isolated; the **orchestrator applies the legitimate
   fixes between rounds**; the next round **rotates one stance in and one out** and reviews the **revised
   state**; continue to a **full rotation** (every stance fired once), then repeat for **up to 3 cycles**,
   stopping when a cycle surfaces no new accepted finding.
2. **The numbers are evidence-consistent defaults, to measure and tune — not constants.** The *moves*
   (revised-state, fresh-blind reviewers, fix-between, union, cheap-varied, capped cycles) are
   well-grounded above. The *magnitudes* — pool of 6–9, trio of 3, one-in-one-out, ≤3 cycles — sit in the
   direction the evidence points (small diverse batches capture most of the gain; ~10 review dimensions
   give coverage; iteration plateaus fast) but are **not** pinned to a verified optimum. Treat them as
   defaults a team measures against marginal unique-accepted yield, per [ADR-0124](./0124-opt-in-per-lens-cost-tier-routing.md).
   *(Honesty marker: a widely-summarized "k=3 optimum" figure did not survive primary verification and is
   deliberately not asserted — see [[ENSEMBLEDIV]].)*
3. **Cost-tiering defaults to cheap; the strong tier is the opt-in** (refines ADR-0124's opt-in framing):
   reviewer chambers run on **lower-end, varied** models by default so the loop is affordable to run
   across cycles; escalating a specific stance (security, architecture) or the reconciling orchestrator to
   a stronger model is the deliberate opt-in — never the whole panel by default, never a silent inherit of
   an expensive session model. _Level: convention._
4. **The `adversarial-review` skill is removed; its discipline is consumed into `revolver-review`.** A
   solo refute-by-default review with no rotating loop adds nothing a harness lacks out of the box; its
   value — refute-by-default, re-run/reconcile the evidence, cite `file:line`, keep effective false
   positives low, the adversarial questions — is inlined into `revolver-review` and **injected into each
   reviewer subagent's prompt alongside its stance**, so the skill is self-contained and installs alone
   (no skill depends on another). The **adversarial self-review *discipline*** ([ADR-0056](./0056-adversarial-self-review-completion-discipline.md))
   is unaffected — it remains canon and is carried in the kit `AGENTS.md` floor and the `suspec-reviewer`
   agent, which already self-contain it.

## Consequences

- `revolver-review` (suspec-skills) is rewritten to this mechanism, self-contained. `adversarial-review`
  is deleted; the catalog's dozen references repoint to `revolver-review`; `suspec-reviewer` drops its
  optional see-also. No contract change, no check; convention-level (ADR-0063), no count-bearing prose in
  product tiers (ADR-0117 — the magnitudes live here as defaults, with their honesty caveat).
- Independence and the evidence gate are untouched: reviewers read-only, the orchestrator fixes, a human
  owns the ship call ([ADR-0119](./0119-independent-review-invariant.md), [ADR-0121](./0121-evidence-gating-load-bearing-mechanic.md)).
- The DP-8 panel measurement (suspec-works) was taken on the bounded-panel form; a fresh measurement of
  the rotating loop (marginal unique-accepted yield per cycle, cost per cycle) is the honest follow-up —
  the numbers in Decision 2 are defaults until it lands.

## Status

Accepted (2026-07-04). **Supersedes** [ADR-0122](./0122-revolver-review-bounded-panel-strategy.md) (the
bounded-panel form → the rotating refine-loop). **Refines** [ADR-0124](./0124-opt-in-per-lens-cost-tier-routing.md)
(cost-tiering defaults to cheap; strong is the opt-in). **Removes** the `adversarial-review` skill,
consuming its discipline. **Honors** [ADR-0056](./0056-adversarial-self-review-completion-discipline.md)/[ADR-0119](./0119-independent-review-invariant.md)/[ADR-0121](./0121-evidence-gating-load-bearing-mechanic.md)/[ADR-0063](./0063-honesty-framework-and-tooling-boundary.md)/[ADR-0117](./0117-no-count-bearing-prose.md). Grounded by [[SELFCORRECT]], [[CCR]], [[PBR]], [[ENSEMBLEDIV]], [[DIVSCALE]], [[CONSENSUS]], [[EXPERTSBACK]], [[BIGGERNOTBETTER]], [[SINGLEBEATSMAS]], [[REVBOTPR]], [[CONSENSUSCOST]], [[FLIPFLOP]], [[SELFREVIEW-MOD]].
