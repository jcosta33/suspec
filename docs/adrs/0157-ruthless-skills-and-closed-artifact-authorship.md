---
type: adr
id: adr-0157
status: accepted
created: 2026-07-13
updated: 2026-07-13
---

# ADR-0157 - Ruthless skills and closed artifact authorship

## Context

Universal methods inherited artifact machinery, ambiguity boilerplate, and defensive instructions
whose absence produced identical behavior. Triple-check recorded findings instead of destroying
them. The `inspection` type persisted after its writers stopped needing documents.

## Decision

1. **Every skill is ruthless and economical.** Keep only instructions that change execution. Use
   hard imperatives. Delete filler, soft framing, default behavior, announcement labels, inert
   negatives, and duplicated mechanics.
2. **Fork every ambiguity.** `fork-me` activates whenever ambiguity survives factual investigation.
   It stops dependent work and presents at least three genuine options through the native picker,
   recommendation first, with each reason and cost stated plainly. Other skills expose ambiguity;
   they do not copy picker mechanics or name a sibling dependency.
3. **Artifact authorship is closed.** Only `sus-spec`, `sus-task`, `sus-review`, `sus-inventory`,
   `sus-change-plan`, `sus-audit`, and `sus-research` create Suspec artifacts. Evidence receipts and
   run notes remain untyped sidecars owned by those workflows. The `inspection` artifact type
   retires.
4. **Inspection methods resolve work in place.** Bulletproof and Demolition return compact chat.
   Revolver runs at least six sequential stances. Triple-check runs exactly three fresh top-tier
   passes. For both loops, supported findings are fixed and verified, refuted findings carry
   decisive evidence, genuine human decisions stop for selection, and unresolved defects block the
   next reviewer.
5. **The deterministic contract rejects the retired type.** Checks contract `0.19.0` recognizes
   `inventory`, `audit`, and `research` as unchecked. `inspection` becomes an unknown type. No check
   ID changes.
6. **Lifecycle close stays with artifact workflows.** After an artifact is fully actioned and no
   downstream step needs it, its workflow requires one human disposition for the artifact and its
   sidecars: Delete, Leave, or Promote.

## Narrowed decisions

- [ADR-0145](./0145-attention-economy-and-decision-rails.md): economy now governs skill source as
  well as generated Markdown; one ambiguity method owns picker mechanics.
- [ADR-0146](./0146-inspection-portfolio.md): inspection methods no longer produce inspection
  artifacts; Triple-check resolves sequentially instead of splitting inspect and refine modes.
- [ADR-0149](./0149-skills-state-rules-directly.md): self-containment requires local method
  contracts, not duplicated cross-cutting mechanics.
- [ADR-0150](./0150-action-first-artifact-disposition.md): lifecycle disposition remains on artifact
  workflows.
- [ADR-0151](./0151-skill-agent-artifact-economy.md): the catalog adds `fork-me`; the owned artifact
  set drops `inspection`.
- [ADR-0152](./0152-deterministic-contract-tightening.md): the recognized type set narrows and the
  checks contract advances to `0.19.0`.
- [ADR-0155](./0155-revolver-sequential-resolution.md): Revolver's sequential resolution stands.
- [ADR-0156](./0156-fixed-methods-stop-on-blockers.md): fixed procedures carry no generic picker
  boilerplate; genuine ambiguity still activates the dedicated selection method.

## Consequences

- Universal methods leave no transient documents behind.
- Every ambiguity reaches a human as an actionable fork, not a guess or essay question.
- Revolver and Triple-check improve the target instead of compiling defect reports.
- Installed skill payloads spend tokens only on behavior-changing instructions.

## Status

Accepted (2026-07-13). Narrows ADR-0145, ADR-0146, ADR-0149 through ADR-0152, ADR-0155, and
ADR-0156.
