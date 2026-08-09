---
type: adr
id: adr-0176
status: accepted
created: 2026-08-09
---

# ADR-0176 - Native delivery control contract

## Context

Campaign instructions can coordinate willing agents. They cannot constrain a worker that can bypass
the prescribed command, spend shared host resources, attest its own proof, review its own work, and
merge with the same credentials.

Observed Sourdaw campaigns exposed that boundary: review and pull-request ceremony expanded without
control, governing artifacts drifted, heavyweight tests competed for one host, merge authority
collapsed into self-attestation, and cleanup targeted state whose ownership was unproven. Paid hosted
CI is deliberately absent there; exact-state local proof must remain first class.

Suspec must define what safe autonomous delivery requires without becoming the service that enforces
it.

## Decision

1. **Split ownership.** Skills define methods. Projects enforce delivery transitions. Harnesses own
   worker isolation and authority. Humans own consequential decisions, waivers, irreversible acts,
   acceptance, and merge authority.
2. **Name control strength.** An `advisory` control is instruction only. `deterministic local`
   enforcement rejects an invalid transition through a project-owned command. `isolated authority`
   keeps the protected state, resource, or credential outside the worker's reach.
3. **Prove capability before dispatch.** Before allocating lanes or starting implementation, a
   campaign must identify the owner, class, mechanism, and negative proof for lane ownership,
   proportionate verification, machine-wide heavyweight admission, pull-request shape and size,
   bounded review, exact-state proof, merge admission, and cleanup.
4. **Keep local proof first class.** Project-declared local commands may satisfy verification when
   their evidence binds the exact state, command, working directory, environment when material, exit
   status, and decisive output. Hosted status checks are optional.
5. **Reject self-authorized merge.** A worker that chooses proof scope, attests the result, reviews
   the change, and can merge has no independent gate. Unattended merge remains blocked until a
   project-owned or human authority validates the transition.
6. **Give the machine one resource owner.** Concurrent workers may not launch heavyweight commands
   outside one machine-wide admission boundary with bounded commands, workers, failures, CPU,
   memory, and concurrency. Without that boundary, heavyweight execution is human-only or the
   campaign runs sequentially without it.
7. **Bound pull requests and review.** Projects own reviewable-scope limits, review breadth, comment
   placement, exact reviewed state, repair closure, and merge admission. Supported findings resolve
   before the next review stance.
8. **Reconcile authority before merge.** Behavior-changing work updates its governing artifact.
   Durable lessons enter project records or native memory only when they do not duplicate policy.
9. **Clean only proven property.** Cleanup may remove only campaign-owned, clean, terminal lanes and
   branches. Dirty, foreign, unknown, or nonterminal state survives.
10. **Fail closed.** A missing capability stops dependent autonomy. The human may supply the
    capability, execute the affected transitions under supervision, or cancel. Suspec never falls
    back silently.
11. **Stay runtime-free.** Suspec gains no scheduler, broker, daemon, hook runtime, credential store,
    resource governor, delivery-state store, GitHub mutation, merge authority, project-control
    command, CLI checker change, or MCP write surface.
12. **Route globally, enforce locally.** The installed agent policy tells workers to use
    project-native delivery controls and never bypass them. It states no security claim; prose
    cannot isolate a same-user process.
13. **Keep project regressions in the project.** The witnessed Sourdaw incidents map to Sourdaw's
    `SPEC-autonomous-delivery-control`, change-plan waves, and named fixtures:

| Audit ID | Requirements | Wave | Fixture |
| --- | --- | --- | --- |
| B-001 | AC-001, AC-002, AC-004, AC-012, AC-019 | 1, 5 | `local-proof-bypass` |
| B-002 | AC-013, AC-022 | 4 | `authority-conflict` |
| B-003 | AC-009, AC-018 | 3 | `review-pool-bounds` |
| M-001 | AC-007, AC-010 | 3 | `publication-shape` |
| M-002 | AC-008 | 3 | `pull-request-size` |
| M-003 | AC-012, AC-013, AC-020, AC-022 | 1, 4 | `authority-drift` |
| M-004 | AC-003, AC-005, AC-006, AC-018 | 2 | `heavyweight-admission` |
| M-005 | AC-011, AC-012, AC-019 | 3, 5 | `reviewed-head-authority` |
| M-006 | AC-006, AC-016, AC-017 | 4 | `stacked-lane-transaction` |
| M-007 | AC-015, AC-019 | 4, 5 | `memory-admission` |
| M-008 | AC-013, AC-014, AC-020 | 4 | `artifact-disposition` |

14. **Separate references from handoff.** Local source references inside artifacts are relative to
    the artifact. Absolute paths are reserved for runtime handoff.

## Narrowed decisions

- [ADR-0143](./0143-path-agnostic-check-cli-contract.md): artifact-relative local references stand;
  author instructions now match the checker.
- [ADR-0162](./0162-campaign-orchestration.md) and
  [ADR-0167](./0167-bounded-campaign-guardrails.md): native state, reusable lanes, bounded review,
  and human merge authority stand; capability proof now precedes dispatch.
- [ADR-0170](./0170-proportional-design-and-executable-oracles.md): executable oracles and proven
  worktree authority stand; project controls must make their absence visible.
- [ADR-0172](./0172-reversible-harness-economy-setup.md) through
  [ADR-0175](./0175-single-context-gateway.md): setup remains reversible and narrow; its payload gains
  one advisory routing rule.

## Consequences

- Campaign refuses unsupported autonomy instead of mistaking instructions for enforcement.
- Local verification remains valid without paid hosted CI.
- Adopting projects own every executable control and regression.
- Suspec remains portable Markdown plus read-only checking and reversible policy setup.

## Status

Accepted (2026-08-09). Narrows ADR-0143, ADR-0162, ADR-0167, and ADR-0170 through ADR-0175.
