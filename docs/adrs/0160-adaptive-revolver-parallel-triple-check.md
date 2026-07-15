---
type: adr
id: adr-0160
status: accepted
created: 2026-07-15
---

# ADR-0160 - Adaptive Revolver and parallel Triple-check

## Context

ADR-0155 restored a six-stance floor for Revolver. ADR-0157 described both inspection loops as
sequential repair. The floor can force filler on a narrow target, while sequential Triple-check
turns a fast independent panel into a slower rotating review.

Breadth and speed are different jobs. Revolver must exhaust every justified angle and repair between
angles. Triple-check must collect three independent whole-target attacks quickly, then repair once.

## Decision

1. **Both methods remain artifact-free.** They improve the target and return compact chat evidence.
2. **Revolver derives its own complete stance pool.** Every materially distinct target-justified
   stance runs. There is no numeric floor or ceiling. Explicit human constraints apply; otherwise
   the orchestrator chooses without asking.
3. **Revolver stays sequential.** One fresh reviewer receives the current target and one stance.
   Every finding is verified and addressed before the next stance sees the updated target. Full
   rotations continue until one is quiet or three cycles complete.
4. **Triple-check is one parallel wave.** Exactly three fresh top-tier reviewers receive the same
   frozen snapshot, no peer prose, and the whole target. Each derives its own attack. The
   orchestrator waits for all three, reconciles and verifies their findings, applies supported fixes
   once, and runs final proof.
5. **Selection follows the job.** Revolver owns exhaustive sequential breadth. Triple-check owns
   rapid independent scrutiny. Single-claim verification belongs elsewhere.

## Narrowed decisions

- [ADR-0146](./0146-inspection-portfolio.md): the two review methods retain distinct purposes but
  use the execution contracts above.
- [ADR-0155](./0155-revolver-sequential-resolution.md): sequential resolution and cycle bounds
  stand; the six-stance floor retires.
- [ADR-0157](./0157-ruthless-skills-and-closed-artifact-authorship.md): artifact-free repair stands;
  Triple-check reviews concurrently and repairs after reconciliation.

## Consequences

- Revolver spends no reviewer on a filler stance and skips no material stance.
- Triple-check gets three independent attacks at the latency of one review wave.
- Reviewers remain read-only; orchestrators own verified repair.
- Current references must describe the adaptive pool and parallel snapshot exactly.

## Status

Accepted (2026-07-15). Narrows ADR-0146, ADR-0155, and ADR-0157.
