---
type: adr
id: adr-0146
status: accepted
created: 2026-07-12
updated: 2026-07-12
---

# ADR-0146 — Inspection portfolio

## Context

Claim verification, hostile advocacy, broad risk discovery, and deep checking differ in evidence,
cost, and mutation authority. Persona-shaped tools blur those command contracts.

## Decision

1. **Inspection is an artifact type.** Substantive runs write one artifact with `type: inspection`,
   `method: bulletproof | demolition | revolver | triple-check`, `target`, and optional
   `mode: inspect | refine`. It has no ship verdict or lifecycle status. Large evidence and round
   logs use sidecars.
2. **Bulletproof verifies claims.** It checks every explicit and load-bearing implied claim through
   code inspection, primary sources, and non-mutating checks. It may generate evidence, never edit
   the target, and reports claim assessments rather than an accept/ship decision.
3. **Demolition is quarantined advocacy.** Explicit invocation permits speculative, one-sided
   persuasive destruction of an idea, design, claim, or concept. It may not fabricate sources,
   quotations, incidents, or test output. Its artifact opens with exactly one banner:
   `Advocacy exercise, not evidence.` Nothing becomes a finding until independently verified.
4. **Revolver is breadth inspection.** It accepts code, diffs, artifacts, plans, or systems; derives
   every distinct target-justified stance with no numeric floor; completes rotations; stops after a
   quiet rotation; and retains the hard three-cycle cap. Stances are risk-derived, never defaulted.
5. **Triple-check is depth inspection.** It runs exactly three fresh, target-derived, top-tier
   passes. Inspect mode fixes the snapshot and hides peer reports. Refine mode applies
   evidence-backed fixes between fresh passes.
6. **Mutation belongs to the orchestrator.** Revolver and Triple-check default to inspect mode;
   refine requires explicit request. Reviewers never edit. Generic fresh subagents execute these
   commands; `persona-challenger` and `suspec-challenger` retire.
7. **Every skill earns its place.** A skill needs distinct intent, trigger, procedure, output, and
   prevented failure. `implement-task` is fallback-only; specialized implementation skills carry
   the packet contract without co-activating it. `review-output`, `spec-check`, and `write-audit`
   retain their distinct purposes. Further removal requires structured human choice.

## Narrowed decisions

- [ADR-0093](./0093-collapse-1to1-personas.md): the remaining challenger persona retires.
- [ADR-0122](./0122-revolver-review-bounded-panel-strategy.md) and
  [ADR-0132](./0132-revolver-rotating-refine-loop.md): Revolver becomes purpose-agnostic; the stance
  floor retires; rotation and the hard cycle cap stand.
- [ADR-0124](./0124-opt-in-per-lens-cost-tier-routing.md): model routing follows method depth.

## Consequences

- Breadth, depth, fact-checking, and advocacy have non-overlapping contracts.
- Advocacy cannot masquerade as evidence.
- No replacement persona agent is added.

## Status

Accepted (2026-07-12).
