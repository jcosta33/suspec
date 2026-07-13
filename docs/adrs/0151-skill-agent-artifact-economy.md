---
type: adr
id: adr-0151
status: accepted
created: 2026-07-13
updated: 2026-07-13
---

# ADR-0151 - Skill, agent, and artifact economy

## Context

The product accumulated overlapping workflow skills, commodity implementation procedures,
custom agent definitions, and artifact types that did not improve the core contract. Every extra
surface increased activation ambiguity, maintenance cost, and user ceremony.

## Decision

1. **The skill catalog is deliberately small.** Universal methods are `bulletproof`,
   `demolition`, `dissect`, `disrespec`, `revolver`, `triple-check`, `promote`, and `remember`.
   Canonical artifact authors are `sus-spec`, `sus-task`, `sus-review`, `sus-inventory`,
   `sus-change-plan`, `sus-audit`, and `sus-research`.
2. **Each skill stands alone.** No alias ships. No skill requires another skill, names catalog
   internals, or relies on a repository-local mirror. `bulletproof` owns active evidence
   generation. `sus-spec` owns planning, authoring, and checking a spec. `sus-research` covers
   technical and market questions without weakening source discipline.
3. **Implementation stays native.** Suspec ships no implementation, debugging, testing,
   security-review, Git, documentation, PRD, RFC, or bug-report skill. The harness and project
   tools execute work from the artifact or request.
4. **Fresh subagents replace a custom catalog.** Suspec ships no agent definitions, projections,
   delegation hooks, or role catalog. A harness may create a fresh native subagent when isolation
   or independence matters; the standalone skill carries the method.
5. **Suspec owns these artifact types.** They are `spec`, `task`, `review`, `inventory`,
   `change-plan`, `audit`, `research`, and `inspection`. Evidence receipts and run notes are
   untyped sidecars. Other durable records belong to the project or harness that owns them.
6. **Artifacts serve action.** Ordinary conversation and direct action create no Suspec artifact.
   A requested or workflow-required artifact lives in the neutral workspace until its work ends;
   the user then chooses Delete, Leave, or Promote for the complete transient set.

## Narrowed decisions

- [ADR-0114](./0114-retired-artifact-registry.md) is superseded. Suspec keeps no exhaustive
  active/retired/relocated status registry. Exact topology and stale-name gates inspect current
  repository surfaces directly; `docs/artifact-registry.md` remains only a surface-ownership index.
- [ADR-0030](./0030-unified-artifact-set.md), [ADR-0061](./0061-intake-artifact.md), and
  [ADR-0144](./0144-keys-and-scaffold.md): the current owned artifact set is the list above.
- [ADR-0092](./0092-suspec-agents-member.md), [ADR-0098](./0098-codex-emitter-and-universal-layer.md),
  and [ADR-0099](./0099-review-orchestration-and-role-routing.md): the custom agent catalog and
  projections retire; native fresh subagents provide isolation.
- [ADR-0140](./0140-skills-are-the-product-tools-reinforce.md),
  [ADR-0146](./0146-inspection-portfolio.md), and
  [ADR-0149](./0149-skills-state-rules-directly.md): skills remain the product, narrowed to the
  standalone catalog above.

## Consequences

- Skill selection is smaller and non-overlapping.
- Users can install any skill independently.
- Suspec conditions work without replacing native implementation or delegation.
- Current documentation and checks recognize only the owned artifact set.

## Status

Accepted (2026-07-13).
