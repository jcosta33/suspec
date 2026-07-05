---
type: adr
id: adr-0133
status: accepted
created: 2026-07-04
updated: 2026-07-04
---

# ADR-0133 — Examine, don't ruminate: decisions rest on examination, never speculation (refines ADR-0132)

## Context

An agent's default failure mode in a decision is **rumination**: reaching a plausible-sounding
conclusion by inference — from memory, from what *seems* right, or from a search *summary* — instead of
**examination**: checking the claim against its primary source and researching the actual question. The
two produce different answers, and the ruminated one is confidently wrong often enough to be dangerous.

The concrete pattern, observed repeatedly: asserting a file's state without running `git`/`ls`; citing a
statistic ("k=3 is optimal", "sequential edits beat batches") from a search snippet that the *primary*
document, once fetched, does not support or turns out to be from an unrelated domain; recommending a
design from adjacent evidence never checked against the real question. Each is a plausible inference
dressed as a grounded result. The framework already binds **completion** claims to evidence
([empirical-proof]; ADR-0121); the gap is that **decisions and factual assertions** — in reports, design
rationale, and choices — were not held to the same bar.

There is a further case the norm must cover: when the literature genuinely **does not settle** a
question. The honest resolution is not a confident guess dressed as research — it is a **measurement**
(the design-partner experiment pattern the family already uses), with any unmeasured choice recorded as a
**reasoned default**, labeled as such, with the measurement that would confirm it named.

## Decision

**Ground every decision and factual claim in examination; when the evidence is silent, measure — never
ruminate.** _Level: convention (ADR-0063)._

1. **Examine, don't ruminate.** A factual claim — a file exists, a number, how something behaves, whether
   a thing is stale — is checked against its **source** (the filesystem, `git`, the **primary** document,
   a re-run) before it is stated. A search summary is a pointer to verify, not evidence; a claim's
   strength is the source actually checked, not the plausibility of the inference. A plausible inference
   asserted as grounded is a **defect**. This generalizes the empirical-proof discipline from completion
   claims to **all** decisions and assertions.

2. **When evidence is silent, measure — and label the default honestly.** If research does not settle a
   choice, the resolution is a **small experiment** (the DP-experiment pattern), not a confident guess.
   Until measured, the chosen option is recorded as a **reasoned default**, distinguished from a proven
   result, with the measurement that would confirm or flip it named. A reasoned default is legitimate; a
   reasoned default *presented as* a measured optimum is the anti-pattern.

3. **First worked example — the revolver mechanism default** (refining [ADR-0132](./0132-revolver-rotating-refine-loop.md)).
   Revolver Review fires **one reviewer at a time** over a pool of **at least 6 distinct stances** (no
   fixed upper limit; distinctness, not a number, is the bound). The **coverage-evenness** of one-at-a-
   time is *proven* — it is arithmetic (each stance fires once per rotation; a one-in-one-out overlap
   provably over-weights the middle of the pool). The **one-at-a-time-vs-simultaneous-panel** choice is a
   **reasoned default the literature does not settle**: no direct study compares them for this loop; the
   adjacent evidence is mixed (a slight lean to finer feedback and interaction-catching; the panel's
   ensemble edge is *contested* — search-level, not primary-verified). An **A/B measurement** (single vs
   panel, on real changes, scored on marginal unique-accepted findings, regressions caught, and cost) is
   **queued in `suspec-experiments`** to confirm or flip it. This ADR does **not** assert one-at-a-time as
   optimal — only as the honestly-labeled reasoned default.

## Consequences

- The **Agent role** floors every agent loads gain the examine-don't-ruminate norm (an always-on
  convention, beside output-economy and the options+recommendation decision-handoff — the always-on
  norms belong in the context every agent loads, not an on-demand skill): the kit `AGENTS.md` for
  adopters and the family workspace's `AGENTS.md`. An always-on norm can't be deferred to an optional
  or absent file, so each floor carries it directly rather than cross-linking to another repo.
- `revolver-review` (suspec-skills) and ADR-0132's mechanism default are updated to one-at-a-time / min-6;
  ADR-0132 gains a forward note pointing here. No new `sources.md` entry is minted for the contested
  adjacent evidence **because it was not primary-verified** — recording it as a MUST would itself violate
  Decision 1.
- A `suspec-experiments` A/B (revolver single vs panel) is the named pending measurement; the default
  holds, labeled, until it runs.
- Convention-level: no contract change, no check, no count-bearing prose (ADR-0117) — the magnitudes live
  as reasoned defaults with their honesty caveat.

## Status

Accepted (2026-07-04). **Refines** [ADR-0132](./0132-revolver-rotating-refine-loop.md) (mechanism default
→ one reviewer at a time over a ≥6 stance pool). **Extends** [ADR-0121](./0121-evidence-gating-load-bearing-mechanic.md)
(the empirical-proof discipline, from completion claims to all decisions) and
[ADR-0131](./0131-minimum-useful-rigor.md) (match rigor — and now certainty-claims — to the evidence).
**Honors** [ADR-0063](./0063-honesty-framework-and-tooling-boundary.md)/[ADR-0117](./0117-no-count-bearing-prose.md).
