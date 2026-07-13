---
type: adr
id: adr-0155
status: accepted
created: 2026-07-13
updated: 2026-07-13
---

# ADR-0155 - Revolver is an artifact-free sequential resolution loop

## Context

ADR-0133 defined Revolver as one reviewer at a time over at least six target-derived stances, with
the orchestrator addressing each round before the next reviewer sees the target. ADR-0146 preserved
the name but replaced that mechanism with a fixed-snapshot inspection by default, removed the stance
floor, and required an inspection artifact. Those changes erased the method's coverage floor and its
finest-grained regression feedback.

Revolver is orchestration. Its value is the order in which independent scrutiny and resolution alter
the target, not a report file.

## Decision

1. **Revolver creates no artifact or sidecar.** It works on the target and returns a compact chat
   outcome. A separately requested audit or review remains its own artifact workflow.
2. **The cylinder contains at least six distinct stances.** The orchestrator derives every stance
   from the target and sets no fixed upper limit. It uses no canned menu, default stance, or
   human-supplied pool. Six is a behavioral coverage floor, not an inventory count.
3. **The pool is fixed before firing.** Each stance names one falsification question and the target
   evidence that makes it relevant. Duplicates are rejected. Order follows consequence and
   uncertainty.
4. **One fresh reviewer fires at a time.** Reviewers are read-only and receive no peer prose. Each
   receives the current target, one stance, scope, and evidence rules.
5. **Every stance is addressed before the next fires.** The orchestrator verifies each finding,
   applies and checks supported fixes when mutation is allowed, rejects refuted claims with evidence,
   and stops for a structured human choice on unverified, blocked, or material findings it cannot
   resolve. An explicit human deferral counts as addressed; silence does not. The next reviewer sees
   the addressed target, including every prior fix.
6. **One full rotation is mandatory.** A rotation ends only after every stance fires once. Another
   rotation runs only when the completed rotation produced a new supported finding. Revolver stops
   after a quiet rotation or three cycles, whichever comes first.
7. **Revolver has no fixed-snapshot mode.** It is purpose-agnostic across code, diffs, artifacts,
   plans, and systems, but its invariant is sequential examination and resolution.

The stance floor and cycle cap are execution semantics. They must be visible wherever an agent needs
them; the no-counts rule continues to prohibit decorative totals and changing inventory counts.

## Narrowed decisions

- [ADR-0146](./0146-inspection-portfolio.md): Revolver no longer writes an inspection artifact, has
  no inspect/refine split, and regains its stance floor and sequential resolution invariant.
- [ADR-0132](./0132-revolver-rotating-refine-loop.md) and
  [ADR-0133](./0133-examine-dont-ruminate.md): the purpose-agnostic name remains; their rotating,
  one-at-a-time mechanism governs again.
- [ADR-0117](./0117-no-count-bearing-prose.md): behavior-defining floors and caps remain explicit;
  changing inventory totals remain absent from public prose.

## Consequences

- A Revolver run cannot silently degrade into a single-frame audit or a report-writing exercise.
- Each reviewer checks the consequences of every prior accepted fix.
- Read-only constraints and unresolved findings surface as human decisions instead of being carried
  into later stances.
- Inspection artifacts remain available to the methods that own document output.

## Status

Accepted (2026-07-13). Narrows ADR-0146 and ADR-0117; restores the operative Revolver mechanism from
ADR-0132 and ADR-0133.
