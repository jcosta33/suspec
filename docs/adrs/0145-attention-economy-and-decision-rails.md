---
type: adr
id: adr-0145
status: accepted
created: 2026-07-12
updated: 2026-07-12
---

# ADR-0145 — Attention economy and decision rails

## Context

Agents are good at investigation, mechanical execution, and evidence collection. Humans are the
scarce authority for intent, material tradeoffs, waivers, irreversible actions, and acceptance.
Current rules spend that authority poorly: optional economy guidance permits repeated prose, bare
questions permit guesses, review rows withhold assessments agents can make, and repeated raw output
obscures the evidence it is meant to expose.

## Decision

1. **Disrespec governs Markdown artifacts.** It maximizes clarity per token: one fact once, no
   filler, repeated source material, empty section, or chat conclusion that restates a successful
   artifact. Chat returns only clickable artifact links. Blocked decisions, failed creation,
   incomplete verification, and irreversible-action confirmation remain explicit. Source code, raw
   evidence, commit messages, and repository-native PR formats are exempt. Its full method is
   single-sourced; every artifact writer carries one byte-identical spine checked for drift.
   _Level: toolable through family gates._

2. **Discover facts before asking.** Agents decide reversible, convention-bound details. Material
   behavior, public contracts, security tradeoffs, costly choices, conflicting authority, and
   irreversible actions require human selection. Prefer the native picker: three genuine options by
   default, two for binary choice, recommendation first, one-sentence tradeoffs, and `Other`. Without
   a picker, render the same numbered choices plus `Other`; never ask a bare question. Batch only
   independent decisions. Deferral leaves the artifact `draft` or `pending` and blocks dependent work.

3. **Specs contain only useful sections.** `Intent` and `Requirements` are the minimum. `Non-goals`,
   `Open questions`, `Affected areas`, and source-drop sections are conditional. C005 and C006 retire
   without ID reuse. C007 still blocks a ready spec containing a blocking unresolved decision.

4. **Agents assess; humans decide.** Review coverage is `ID | Assessment | Evidence` with
   `Supported`, `Unsupported`, `Unverified`, or `Blocked`. Frontmatter carries
   `decision: pending | accepted | changes-requested | deferred`; an agent leaves it `pending`, then
   presents a state-aware human picker. Only that selection changes the decision. Accepted reviews
   with `Unsupported` or `Unverified` rows list their IDs under `waivers`. Summary, task status,
   suggested decision, and empty attention sections retire.

5. **Evidence is written once.** Short output appears once. Dominating output moves to adjacent
   `evidence-<slug>.md`. A receipt contains stable `E-NNN` anchors, command, working directory, state
   identifier, exit status, and untouched raw output. Governing artifacts carry a decisive verbatim
   excerpt and receipt link. One command may support several claims when each maps to its anchor.
   Existing `verify` info strings remain command-result records; bodies may carry the excerpt and
   receipt link. Without an artifact, chat may carry compact command, exit status, and decisive output.

## Narrowed decisions

- [ADR-0058](./0058-two-tier-spec-format.md): fixed empty sections retire; requirement records stand.
- [ADR-0083](./0083-verify-evidence-reconcile.md): verify blocks stand; `Pass` becomes `Supported`.
- [ADR-0097](./0097-mint-c016-c017-defer-oversized.md): C016 becomes
  `supported-needs-evidence`; C005 and C006 retire.
- [ADR-0101](./0101-authoring-open-decisions.md): structured choices stand; their section is conditional.
- [ADR-0109](./0109-output-economy-convention.md): optional economy becomes Disrespec for artifact writers.
- [ADR-0119](./0119-independent-review-invariant.md): independent assessment and human acceptance coexist.
- [ADR-0121](./0121-evidence-gating-load-bearing-mechanic.md): receipts replace evidence repetition.

## Consequences

- Human attention lands on decisions, evidence gaps, waivers, and irreversible acts.
- Agent assessments become explicit without granting agents acceptance authority.
- The checks contract advances to `0.17.0`.

## Status

Accepted (2026-07-12).
