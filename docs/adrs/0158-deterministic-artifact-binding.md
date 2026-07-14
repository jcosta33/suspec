---
type: adr
id: adr-0158
status: accepted
created: 2026-07-13
updated: 2026-07-13
---

# ADR-0158 - Deterministic artifact binding

## Context

The checker could report a spec with no status or requirements as clean. A review could be checked
against the wrong spec. Receipt links and accepted preservation failures also escaped deterministic
validation. Those are wiring defects, not judgment calls.

## Decision

1. **Specs prove their shape.** C025 requires a non-empty ID, `draft` or `ready` status, exactly one
   `Intent` and `Requirements` section, and at least one parsed requirement.
2. **Receipt links resolve.** C026 resolves explicit local Markdown evidence links carrying an
   `E-NNN` fragment against the review's directory and requires the linked file to carry the matching
   HTML id anchor. It does not judge evidence freshness or truth.
3. **Reviews bind to specs and reviewers.** Every review carries non-empty `spec:` and `reviewer:`
   fields. C027 requires `spec:` to match the packet handed through `--spec`; the unnumbered review
   shape rejects missing reviewer provenance. `task:` remains the optional split-slice binding
   checked by C020.
4. **Preservation failures cannot be waived.** Every Change-plan coverage row must be `Supported`
   before acceptance. Requirement waivers remain limited to Unsupported or Unverified Requirement
   coverage rows.
5. **The contract advances to `0.20.0`.** C025, C026, and C027 are hard errors. Existing IDs keep
   their meanings.

## Narrowed decisions

- [ADR-0079](./0079-c012-coverage-check.md) and [ADR-0128](./0128-mint-c020-unresolvable-ref.md):
  explicit review companions now bind both spec and task identity.
- [ADR-0121](./0121-evidence-gating-load-bearing-mechanic.md) and
  [ADR-0145](./0145-attention-economy-and-decision-rails.md): receipt links gain deterministic path
  and anchor validation; evidential adequacy remains human judgment.
- [ADR-0152](./0152-deterministic-contract-tightening.md): spec shape and review wiring join the
  deterministic floor.
- [ADR-0153](./0153-mcp-parity-and-compatibility.md): exact MCP compatibility advances to `0.20.0`.
- [ADR-0154](./0154-spec-backed-tasks-and-review-closure.md): accepted preservation coverage must be
  fully supported.

## Consequences

- Empty specs, wrong companions, dangling receipts, and waived preservation failures stop cleanly.
- The checker proves references and structure. Humans still judge evidence, independence, and risk.
- Existing reviews need one explicit `spec:` field.

## Status

Accepted (2026-07-13). Narrows ADR-0079, ADR-0121, ADR-0128, ADR-0145, and ADR-0152 through
ADR-0154.
