---
type: adr
id: adr-0147
status: accepted
created: 2026-07-12
updated: 2026-07-12
---

# ADR-0147 — User-directed artifact promotion

## Context

Transient native artifacts sometimes become durable truth. Preserving a whole document differs from
extracting one lesson, but a Suspec store, registry, lifecycle state, or imposed destination would
recreate retired infrastructure.

## Decision

1. **Promotion is explicit and stateless.** `promote` discovers project-native durable
   destinations, presents structured choices, sanitizes transient or private content, moves by
   default, repairs references, and validates. An already-durable artifact returns unchanged.
2. **The project owns durability.** Promotion creates no registry, state field, CLI verb, MCP tool,
   Suspec directory, or lifecycle record. The human selects a project-native destination.
3. **Git actions are separate choices.** Promotion may commit when selected. It never pushes
   implicitly. Sensitive content blocks promotion until the human selects sanitization or cancellation.
4. **Promotion and findings remain distinct.** `remember` extracts durable lessons;
   `promote` preserves a whole document.

## Narrowed decisions

- [ADR-0137](./0137-personal-harness-transient-artifacts.md): transient placement stands; this is
  the explicit whole-document escape hatch.
- [ADR-0141](./0141-artifacts-beside-native-artifacts.md): native placement stands.
- [ADR-0142](./0142-findings-become-native-memories.md): finding promotion remains retired; whole
  artifact promotion is a distinct stateless action.

## Consequences

- Useful artifacts become durable without a second storage system.
- Moving prevents transient and durable copies from drifting.
- Promotion cannot silently publish or push private material.

## Status

Accepted (2026-07-12).
