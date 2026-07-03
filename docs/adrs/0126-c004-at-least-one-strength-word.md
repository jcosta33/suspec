---
type: adr
id: adr-0126
status: accepted
created: 2026-07-03
updated: 2026-07-03
---

# ADR-0126 — C004 softens to at-least-one strength word (contract 0.11.0 → 0.12.0)

## Context

C004 (`one-strength-word`) required **exactly one** binding word per requirement. The five-project
DX stress test (suspec-works #87) measured it as the single most common authoring loop — natural
prose writes zero or two, and rephrasing to exactly one was the dominant friction — while no
evidence anywhere distinguishes exactly-one from at-least-one on outcomes (the DX interrogation's
Q-02: theater candidate until measured). The check's two real functions are distinct: a
requirement with **zero** binding words is unverifiable-as-written (the defect), and a requirement
with **several** is a split candidate (advice, not a defect).

## Decision

C004 becomes **at-least-one-strength-word**, severity unchanged (warning), with two framings:

- **Zero** binding words — the C004 warning: the requirement binds on nothing; add the one word
  it binds on.
- **More than one** — a split-candidate advisory under the same C004 id: several bindings often
  mean several requirements; split or justify. Advice-framed, never "expected exactly one."

Contract version bumps **0.11.0 → 0.12.0**. The check's name stays `one-strength-word` (the id
and name are the stable contract surface; the semantics line is the row's comment).

## Consequences

- suspec-cli pins 0.12.0 and reframes the two messages; the drift guard reconciles.
- The kit's `spec-check` guide row and canon `checks.md` row reword to match.
- The friction #87 measured drops to zero mechanical rephrasing for the ≥1 case; the bundling
  signal survives as advice. If a measurement ever shows exactly-one earns its cost, this
  supersedes cleanly.

## Status

Accepted (2026-07-03).
