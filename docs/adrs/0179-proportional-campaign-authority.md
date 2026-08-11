---
type: adr
id: adr-0179
status: accepted
created: 2026-08-11
---

# ADR-0179 - Proportional campaign authority

## Context

ADR-0176 required every campaign to prove the same delivery capabilities at fixed enforcement
strengths. ADR-0178 then made that universal preflight a condition of campaign readiness. A campaign
created to add missing project controls therefore could not become ready until those controls already
existed. Advisory delivery, deterministic rejection, and hostile-worker containment also collapsed
into one oversized contract.

Suspec needs honest authority, not maximum machinery everywhere.

## Decision

1. **Preflight follows operations.** A campaign names only the lane, verification, resource,
   publication, review, merge, and cleanup operations it will use. Unused operations require no
   mechanism.
2. **Strength follows the claim.** Advisory guidance may coordinate willing agents. Deterministic
   local commands must reject invalid transitions they claim to enforce. Isolated authority is
   required only when protected state, resources, or credentials must remain unreachable to a
   worker.
3. **Block the transition, not the campaign.** Missing authority stops only dependent operations.
   Independent work continues when its ownership and verification remain valid.
4. **Permit bootstrap.** One named trusted owner may implement a missing control without dispatching
   the operation that control will later govern. The campaign states the temporary limit and claims
   no unavailable protection.
5. **Allow delegated execution.** Humans retain intent, material decisions, waivers, irreversible
   authority, and acceptance. They may authorize a named orchestrator, project command, or protected
   queue to execute merge and cleanup. Hard containment still requires a boundary the worker cannot
   bypass.
6. **Derive review and size bounds.** Repository policy, change risk, reviewer capacity, and witnessed
   failure determine pull-request and review limits. Suspec supplies no universal line, file,
   reviewer, stance, or time threshold.
7. **Bind only material evidence.** Review and merge bind to current head and base. Commands carry
   their working directory, state, exit, and decisive output. Inputs, configuration, toolchain, and
   environment join the proof only when they can change the result. No receipt store is required.
8. **Keep state native.** Git and project systems own mutable delivery state. Campaigns add no lane
   registry, review state machine, duplicate ledger, or controller.
9. **Make readiness honest.** A campaign is ready when its authorities are reachable, its blocking
   choices are resolved, and every intended operation names a truthful owner, strength, mechanism,
   and failure behavior. A named stop may guard a later unavailable transition without blocking
   earlier independent work.
10. **Add no runtime.** The CLI and MCP contracts do not change. Projects and harnesses still own
    enforcement.

## Narrowed decisions

- [ADR-0162](./0162-campaign-orchestration.md): native coordination and independent repair stand;
  merge execution may be delegated by the owner.
- [ADR-0167](./0167-bounded-campaign-guardrails.md): reviewability remains project-derived; numeric
  defaults retire.
- [ADR-0170](./0170-proportional-design-and-executable-oracles.md): witnessed-failure control now
  governs campaign capability selection.
- [ADR-0176](./0176-native-delivery-control-contract.md): control classes stand; their universal
  capability matrix, fixed strengths, and all-or-nothing preflight retire.
- [ADR-0178](./0178-restartable-campaign-goals.md): stable goals and native progress stand;
  readiness becomes operation-scoped.

## Consequences

- Small campaigns stay small.
- Campaigns can bootstrap project controls without lying about protection.
- Drift resistance no longer pays for hostile-worker containment.
- Missing authority fails at the boundary it governs.

## Status

Accepted (2026-08-11). Narrows ADR-0162, ADR-0167, ADR-0170, ADR-0176, and ADR-0178.
