---
type: adr
id: adr-0159
status: accepted
created: 2026-07-13
---

# ADR-0159 - Companion and task binding

## Context

A task could claim any source spec and still check clean. Review companions bypassed their own hard
checks. The task method required dependency order, but C022 did not.

## Decision

1. **Task checks bind a spec.** Every checked task receives an explicit `--spec` companion. The spec
   must be ready, clear its hard checks, and match the task's `source:` list. One companion may bind
   several task paths only when they all name that spec.
2. **Review companions clear their hard checks.** A review does not reconcile against a malformed
   spec or task. Companion warnings remain advisory.
3. **C022 owns dependency handoff.** `Run order` is required exactly once. It carries non-empty
   `Starts after:` and `May run with:` values; `None` is explicit and valid.
4. **The contract advances to `0.21.0`.** No check ID is added or repurposed. C022 gains the shape it
   already claimed; companion failures remain usage errors.
5. **MCP stays thin.** `specPath` may accompany task paths or one review. `taskPath` remains valid
   only for one review. The adapter forwards; the CLI decides validity.

## Narrowed decisions

- [ADR-0143](./0143-path-agnostic-check-cli-contract.md): task source specs join explicit review
  companions.
- [ADR-0152](./0152-deterministic-contract-tightening.md): C022 includes dependency handoff.
- [ADR-0153](./0153-mcp-parity-and-compatibility.md): exact compatibility advances to `0.21.0`.
- [ADR-0154](./0154-spec-backed-tasks-and-review-closure.md): spec-backed task authority is enforced
  at check time.
- [ADR-0158](./0158-deterministic-artifact-binding.md): companions must be valid before their
  identity can bind another artifact.

## Consequences

- Missing, stale, draft, malformed, or mismatched task sources cannot dispatch cleanly.
- A review cannot launder a malformed companion into a clean reconciliation.
- Split tasks always state their dependency position.

## Status

Accepted (2026-07-13). Narrows ADR-0143 and ADR-0152 through ADR-0154 and ADR-0158.
