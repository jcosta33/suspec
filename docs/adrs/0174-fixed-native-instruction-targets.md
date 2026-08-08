---
type: adr
id: adr-0174
status: accepted
created: 2026-08-09
---

# ADR-0174 - Fixed native instruction targets

## Context

ADR-0173 allowed setup to follow an existing Codex override. That makes installation depend on
incidental user scaffolding and lets setup occupy a file whose purpose is exceptional precedence.
The ordinary global instruction files are the stable integration surface
[[CODEXGLOBAL]](../research/sources.md#CODEXGLOBAL)
[[CLAUDEDIR]](../research/sources.md#CLAUDEDIR)
[[OPENCODERULES]](../research/sources.md#OPENCODERULES).

## Decision

1. **Use the ordinary native file.** Each explicit harness identifier maps to its documented normal
   global instruction file. Existing content is preserved around the neutral owned block.
2. **Never chase precedence.** Setup does not redirect installation into overrides, alternate
   instruction files, or discovered scaffolding.
3. **Report shadowing.** When another configuration would prevent the normal file from loading, setup
   stops. The user resolves that harness configuration outside Suspec.

## Narrowed decisions

- [ADR-0173](./0173-native-harness-instruction-installation.md): native inline installation survives;
  targeting a non-empty Codex override retires.
- [ADR-0172](./0172-reversible-harness-economy-setup.md): fixed documented targets and fail-closed
  precedence survive unchanged.

## Consequences

- Setup behaves the same on clean and customized machines.
- Exceptional harness configuration remains owned by the user.

## Status

Accepted (2026-08-09). Narrows ADR-0172 and ADR-0173.
