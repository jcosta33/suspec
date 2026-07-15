---
type: adr
id: adr-0161
status: accepted
created: 2026-07-15
---

# ADR-0161 - Semantic skill contracts and maintained evidence

## Context

Independent installation forbids sibling dependencies. Pure isolation, however, left adjacent
methods disconnected even when a harness could discover the next capability from loaded skill
metadata. Skill descriptions also drifted between selection metadata and body procedure, while
catalog doctrine changed faster than its design evidence.

Implicit activation is harness- and model-dependent. It may be tested and encouraged; it may not be
claimed as a portable guarantee.

## Decision

1. **Descriptions select.** Every description states the action and target, a positive `Use when`
   trigger, and genuine near misses in exactly three sentences. It contains no self-name, procedure,
   sequencing, evidence rules, or completion mechanics.
2. **Bodies execute.** `Method` is mandatory. Other standard sections appear only when they carry
   behavior. Instructions use hard imperatives and omit filler, default behavior, repeated rationale,
   and internal catalog vocabulary.
3. **Every skill remains complete alone.** No body names, requires, invokes, or assumes a sibling.
   Load-bearing behavior stays local.
4. **Adjacent methods compose semantically.** A skill may state a useful next job in language that
   matches another skill's description. The sentence must remain executable when the companion is
   absent. Intended handoffs are tested with each skill alone and together; results remain local
   evidence, not a universal activation claim.
5. **Design docs are current contracts.** The skills repository documents activation, body anatomy,
   execution, scope, self-containment, existence, and evidence. Gates bind those documents to the
   shipped catalog.
6. **Evidence changes with doctrine.** `docs/sources.md` is updated in the same change whenever an
   externally grounded skill or documentation rule changes. Primary and official sources lead.
   Secondary evidence is labeled and bounded. Dead or irrelevant sources leave with the claim.

## Narrowed decisions

- [ADR-0149](./0149-skills-state-rules-directly.md): standalone operation stands; semantic wording
  may expose an optional adjacent job without creating a dependency.
- [ADR-0157](./0157-ruthless-skills-and-closed-artifact-authorship.md): ruthless economy governs
  descriptions and maintainer documentation as well as bodies.
- [ADR-0113](./0113-product-vs-docs-boundary.md): executable skills remain self-contained; design
  docs own catalog contracts and supporting evidence.

## Consequences

- Installation order never determines correctness.
- Harnesses may discover coherent method chains without explicit sibling calls.
- Descriptions stop wasting preload context on procedure.
- Documentation drift and unsupported design folklore become gate failures.

## Status

Accepted (2026-07-15). Narrows ADR-0113, ADR-0149, and ADR-0157.
