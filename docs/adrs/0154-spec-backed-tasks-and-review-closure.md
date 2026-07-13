---
type: adr
id: adr-0154
status: accepted
created: 2026-07-13
updated: 2026-07-13
---

# ADR-0154 - Spec-backed tasks and review closure

## Context

Task CI evidence, blocker-list parsing, task authority, and review acceptance each had more than
one plausible representation. That ambiguity let valid packets fail and invalid terminal states
pass.

## Decision

1. **C023 CI evidence is visibly labeled.** A task's CI evidence is a URL following `CI:` or
   `CI link:`. An unlabeled URL is not C023 evidence.
2. **C024 recognizes Markdown list forms.** Canonical blocker labels are recognized after
   unordered and ordered list markers. `none` and `n/a` remain resolved values.
3. **Every task is spec-backed.** The source spec owns scoped requirements. A change plan may
   add wave and preservation context but cannot replace the spec in a task or review.
4. **Review structure stays deterministic and unnumbered.** Review ID and Requirement coverage
   are non-empty; decision and assessment values use their declared enums; waivers appear only
   on accepted reviews and exactly cover Unsupported and Unverified requirement rows; accepted
   reviews contain no non-empty Open decisions section or Blocked assessment. Blocked cannot be
   waived.
5. **The checks contract remains 0.18.0.** No C-code is added, removed, renamed, or reused.

## Narrowed decisions

- [ADR-0151](./0151-skill-agent-artifact-economy.md): task packets remain part of the small artifact
  set and now always retain one governing requirement authority.
- [ADR-0152](./0152-deterministic-contract-tightening.md): C023, C024, task source authority, and
  unnumbered review structure use the exact forms above without changing the C-code catalog or
  contract version.

## Consequences

- Task CI and blocker evidence parse consistently with their fixtures.
- Change-plan tasks and reviews retain one requirement authority.
- Accepted review state has one mechanically reconcilable waiver and decision shape.

## Status

Accepted (2026-07-13).
