---
type: adr
id: adr-0183
status: accepted
created: 2026-08-16
---

# ADR-0183 - Single-file skills and role-routed models

## Context

ADR-0169 moved conditional procedure into bundled references. Current surviving references carry
mandatory campaign controls, research methods, and the task packet contract. Their extra read saves
no useful context after activation and creates one more place for execution to fail.

Campaign model routing also lacks role-specific inputs. Implementation difficulty differs from
review stance criticality. The user selects the campaign's controlling model outside Suspec.

## Decision

1. Every skill ships as one complete `SKILL.md`. Appendix payloads retire.
2. Condense mandatory procedure and templates into the owning skill body. Preserve behavior, not
   file boundaries.
3. Select implementation models from task complexity and ambiguity.
4. Select reviewers from the criticality of their assigned stance.
5. Use vendor-neutral economy, standard, and strongest classes. Escalate only the blocked or
   disputed step.
6. State no model tier for the campaign's controlling agent.
7. Reject any skill payload outside `SKILL.md`.

## Consequences

- One activation supplies the whole method.
- No control depends on a second discretionary read.
- Campaign routing follows work risk without naming vendor models.
- Suspec gains no CLI, MCP, runtime, registry, or configuration surface.

## Status

Accepted (2026-08-16). Narrows ADR-0162 and ADR-0169.
