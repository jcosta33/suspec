---
type: adr
id: adr-0149
status: accepted
created: 2026-07-12
updated: 2026-07-12
---

# ADR-0149 - Skills state rules directly

## Context

Skills install independently. ADR-0145 required artifact writers to copy a named, byte-identical
Disrespec spine. That kept one sentence synchronized but exposed catalog machinery to the model,
made a local instruction look dependent on another skill, and tested textual identity instead of
behavior.

## Decision

1. **Every skill is complete alone.** A skill may use only its own body, bundled files, the target,
   and project-native instructions. It does not require, invoke, or assume another skill.
2. **Instructions state the rule, not its implementation.** Skill bodies contain no spine names,
   marker comments, parity labels, gate names, catalog topology, or internal ADR references.
3. **Economy remains local.** A skill that writes Markdown states its own concise writing and
   file-only handoff rule in ordinary command language. Disrespec remains a separate, deeper editing
   procedure and must earn its activation through output quality.
4. **Isolation replaces textual parity.** Maintainer checks reject missing bundled files and
   external skill dependencies. Behavior evaluations install one skill at a time and judge its
   output. No byte-identical instruction marker is required.

## Narrowed decisions

- [ADR-0145](./0145-attention-economy-and-decision-rails.md): attention economy and file-only
  handoff stand; the named byte-identical spine and its drift gate retire.
- [ADR-0016](./0016-skills-are-self-contained.md) and
  [ADR-0134](./0134-self-contained-spine.md): standalone operation stands and now forbids even
  optional sibling-skill dependencies.

## Consequences

- Installing one skill never leaves a missing method dependency.
- Models see direct commands instead of repository maintenance vocabulary.
- Similar local rules may differ in wording when their jobs differ; behavior, not copied bytes, is
  the invariant.

## Status

Accepted (2026-07-12).
