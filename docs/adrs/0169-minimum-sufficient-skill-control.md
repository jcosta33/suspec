---
type: adr
id: adr-0169
status: accepted
created: 2026-08-01
---

# ADR-0169 - Minimum sufficient skill control

## Context

Suspec requires standalone skills and says behavior matters more than copied wording. Its current
catalog still mandates one three-sentence description grammar, one body section order, and hundreds
of wording-sensitive assertions. Those gates prove prose shape, not activation or execution.

Industry evidence converges on a narrower rule: active context should carry relevant, non-obvious
control; conditional detail should load on demand; deterministic contracts need static checks; model
behavior needs observed scenarios. No reviewed evidence supports one universal skill anatomy or
aggressive tone as an independent reliability mechanism.

`fork-me` also activates too narrowly. An agent can ask a bare question without classifying it as a
listed ambiguity, defeating the decision rail.

## Decision

1. **Use minimum sufficient control.** A skill keeps non-obvious invariants, dangerous edges, exact
   input, output, and state contracts, explicit stop conditions, and failures supported by
   evaluation. Prompt length is evidence, never a quality score.
2. **Descriptions select by meaning.** State enough action, target, trigger, and nearest exclusions
   to route correctly. No sentence count, stock order, or universal grammar is mandatory. Keep
   procedure, evidence mechanics, and completion rules in the body.
3. **Bodies follow the method.** No universal section order or mandatory `Method` heading remains.
   Artifact authors retain sections required by their artifact contracts. Every other section must
   change execution.
4. **Load conditional detail on demand.** Move long phase-specific procedures into direct,
   one-level bundled references. Every installed skill remains complete alone.
5. **Static gates test static facts.** Enforce metadata, package integrity, ownership, links,
   artifact schemas, stale names, and forbidden dependencies. Do not treat preferred wording as
   proof of model behavior.
6. **Behavior gates test behavior.** Test activation, near misses, isolation, semantic handoffs,
   question handling, artifact behavior, evidence use, and method invariants across every supported
   harness-model pair. Record the harness, version, model, date, repetitions, trace, cost, and
   result. Keep private raw traces local; commit sanitized decisive evidence.
7. **Every agent-originated question is a fork.** First exhaust discoverable facts and reversible
   conventions. Then present any question the agent must ask through explicit options, a
   recommendation, plain tradeoffs, native selection when available, and numbered text plus
   `Other` otherwise. User-originated factual questions are answered; they do not activate a
   selection workflow.

## Narrowed decisions

- [ADR-0149](./0149-skills-state-rules-directly.md): standalone, behavior-owned skills stand;
  behavior evaluation replaces textual anatomy.
- [ADR-0157](./0157-ruthless-skills-and-closed-artifact-authorship.md): economy and one ambiguity
  method stand; every agent-originated question now enters that method.
- [ADR-0161](./0161-semantic-skill-contracts-and-evidence.md): descriptions still select, bodies
  still execute, semantic composition and maintained evidence stand; the exact three-sentence
  description and mandatory body anatomy retire.

## Consequences

- Skill source spends tokens only on control that changes outcomes.
- Progressive disclosure reduces active context without weakening standalone installation.
- Static checks stop impersonating model evaluations.
- Fork-me becomes the universal agent-to-human question interface.
- Suspec gains no runtime, registry, service, storage surface, CLI command, or MCP tool.

## Status

Accepted (2026-08-01). Narrows ADR-0149, ADR-0157, and ADR-0161.
