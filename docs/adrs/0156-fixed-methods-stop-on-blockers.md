---
type: adr
id: adr-0156
status: accepted
created: 2026-07-13
updated: 2026-07-13
---

# ADR-0156 - Fixed methods stop on concrete blockers

## Context

The structured-choice rule was copied into command methods that do not transfer a decision. That
made deterministic procedures ask unnecessary questions and made Revolver manufacture a picker
when it should stop on an unresolved finding.

## Decision

1. **Choice mechanics follow decision ownership.** A workflow presents structured choices only when
   it transfers a material decision to the human. Discoverable facts and fixed method steps are not
   choices.
2. **Fixed methods execute.** Bulletproof, Demolition, Dissect, Disrespec, Revolver, and Triple-check
   run their declared procedure without generic ambiguity or picker instructions. A missing target,
   unavailable capability, or unresolved evidence gap is a concrete blocker: name it and stop.
3. **Revolver never creates a decision menu.** An unverified, blocked, or material finding that the
   orchestrator cannot resolve halts the run. A later human instruction may resolve or defer it;
   only then may the next stance run. Silence never counts as resolution.
4. **Artifact disposition is separate.** A method that produced or consumed transient artifacts
   still presents Delete, Leave, or Promote at true lifecycle close. That choice governs file
   disposition, not the method's findings.

## Narrowed decisions

- [ADR-0145](./0145-attention-economy-and-decision-rails.md): its choice mechanics apply only to
  workflows that genuinely transfer a material decision.
- [ADR-0155](./0155-revolver-sequential-resolution.md): Revolver stops on an unresolved blocker
  instead of presenting a structured choice inside the method.

## Consequences

- Fixed methods remain predictable and waste no tokens on artificial options.
- Human choices appear only where human authority is actually required.
- Revolver cannot move past unresolved material findings.

## Status

Accepted (2026-07-13). Narrows ADR-0145 and ADR-0155.
