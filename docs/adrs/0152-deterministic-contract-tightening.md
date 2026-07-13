---
type: adr
id: adr-0152
status: accepted
created: 2026-07-13
updated: 2026-07-13
---

# ADR-0152 - Deterministic contract tightening

## Context

The checker inferred missing types, accepted frontmatter through several partial parsers, left task
shape as prose-only rules, and published C014 even though no deterministic checker could compute it.
Those gaps made malformed artifacts look valid and made the machine contract overstate its reach.

## Decision

1. **The checks contract is version 0.18.0.** Artifact checking requires an explicit recognized
   `type:`. Missing and unknown types are blocking usage errors.
2. **The recognized types are closed.** `spec`, `task`, `review`, and `change-plan` have
   deterministic checker faces. `inventory`, `audit`, `research`, and `inspection` are recognized
   and return `checked: false` until a deterministic contract exists for them.
3. **Frontmatter uses one strict subset.** It accepts an optional UTF-8 BOM, top-level keys, plain
   or balanced quoted string scalars, flat inline string lists, flat block string lists, and
   comments outside quotes. It preserves scalar text without boolean, number, or null coercion.
   Duplicate keys, malformed delimiters, nesting, maps, multiline scalars, anchors, aliases, tags,
   empty list heads, and field-shape mismatches are blocking parse errors.
4. **C014 retires.** Its identifier is never reused. Comparing a live diff with `Do not change`
   remains reviewer work, not a deterministic contract claim.
5. **New checks are stable.** C021 `intent-present` requires a non-empty spec `## Intent`. C022
   `task-shape` validates task type, non-empty ID/source/scope, field shapes, status, and
   exactly-once required sections. C023 `task-evidence` does not run at `ready` or `running`; at
   `review-ready` or `closed`, it requires a numeric exit plus non-empty fenced raw output, a CI
   link, or justified `n/a`. Bare claims and visible placeholders fail. C024
   `closed-task-resolved` rejects unresolved markers and non-empty canonical blocker labels in a
   closed task; `none` and `n/a` are resolved values.

## Narrowed decisions

- [ADR-0059](./0059-frontmatter-type-is-the-discriminator.md): `type:` is mandatory and unknown
  values are rejected.
- [ADR-0066](./0066-checks-redefinition.md) and
  [ADR-0086](./0086-deterministic-review-scanning-decision.md): the deterministic catalog contains
  only checks the reference implementation computes.
- [ADR-0097](./0097-mint-c016-c017-defer-oversized.md): retired and reserved identifiers remain
  unavailable for reuse.

## Consequences

- One parser owns every frontmatter read.
- Task files can be checked directly.
- Unsupported syntax fails visibly instead of being guessed or coerced.
- The checks contract states exactly what the CLI can enforce.

## Status

Accepted (2026-07-13).
