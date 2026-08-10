---
type: adr
id: adr-0178
status: accepted
created: 2026-08-10
---

# ADR-0178 - Restartable campaign goals

## Context

The campaign method coordinates long, multi-pull-request delivery but leaves its goal prompt
handwritten. One observed prompt grew to 109 lines by embedding artifact counts, branch SHAs,
pull-request state, lane occupancy, and handoff facts. Those facts drifted and forced replacement.

OpenAI defines a goal as one durable objective with source pointers, checkpoint proof, and a
verifiable stopping condition; it warns against loose backlogs and accumulated one-off
instructions. [[OAIGOAL]] Anthropic observed long-running agents one-shotting work, abandoning
half-built state, and declaring completion early across fresh contexts; structured continuity and
incremental progress reduced those failures. [[LONGHARNESS]] Microsoft Research separates stable
task planning from mutable progress tracking in its Magentic-One orchestrator. [[MAGENTIC]]

Suspec needs a durable campaign contract without becoming a scheduler or duplicating project state.

## Decision

1. **Rename the author.** `campaign` becomes `sus-campaign` with no alias. It authors, revises, and
   checks one `type: campaign` artifact for a multi-pull-request delivery goal.
2. **Keep the contract stable.** A campaign carries `Objective`, `Completion contract`,
   `Authorities`, `Operating loop`, and `Stops`. `Constraints`, `Non-goals`, and `Workstreams`
   appear only when useful.
3. **Keep progress native.** One issue, epic, or equivalent project ledger owns work items,
   dependencies, assignments, pull requests, and status. The campaign points to it. The campaign
   contains no mutable task-list checkboxes or copied status.
4. **Make every pickup equivalent.** Each pickup rereads the campaign and authorities, reconciles
   live repository, ledger, pull-request, worktree, worker, and verification state, repairs ledger
   drift, selects dependency-ready work, executes project gates, records durable progress, and
   repeats.
5. **Define terminal truth.** Completion is the artifact's verifiable completion contract, not an
   agent's impression, an exhausted queue scan, or stale counts.
6. **Use native goal execution.** A local harness receives the campaign by absolute path. A harness
   without path access receives the same artifact body. Suspec does not set, schedule, resume, or
   store goal runtime state.
7. **Block unreachable authority.** Local source and ledger references are artifact-relative. A
   remote run starts only when every authority is reachable there through a durable URL or promoted
   project-owned file.
8. **Check the deterministic shell.** Checks contract `0.24.0` adds `campaign` as a checked type:
   C029 validates frontmatter and required sections, C030 validates authority references and rejects
   duplicated task-list state, and C031 rejects unresolved blocking state at `ready`.
9. **Preserve delivery control.** Existing capability preflight, worktree ownership, proportionate
   proof, bounded review, independent repair, human merge authority, and cleanup rules remain in
   force. The artifact carries their project-specific authorities; it does not replace them.
10. **Add no runtime surface.** The CLI remains a read-only checker. MCP inherits contract parity and
    gains no tool. No registry, daemon, hook, scheduler, tracker, or project-owned state enters
    Suspec.

## Narrowed decisions

- [ADR-0148](./0148-agent-neutral-artifact-workspace.md): campaign artifacts use the same transient
  neutral root and explicit handoff.
- [ADR-0151](./0151-skill-agent-artifact-economy.md) and
  [ADR-0157](./0157-ruthless-skills-and-closed-artifact-authorship.md): `campaign` joins the closed
  artifact set and its writer adopts the `sus-` prefix.
- [ADR-0162](./0162-campaign-orchestration.md): project-native campaign state stands; the stable
  campaign contract now points to it.
- [ADR-0167](./0167-bounded-campaign-guardrails.md) and
  [ADR-0176](./0176-native-delivery-control-contract.md): delivery controls stand and become
  campaign authorities rather than startup-only instructions.

## Consequences

- Goal text remains useful after any context reset because it carries invariants, not a snapshot.
- The native ledger provides the progress checklist without creating a second truth.
- Campaigns become portable Suspec artifacts while execution remains harness- and project-owned.
- Deterministic checks catch malformed, stale-by-construction campaign shells before dispatch.

## Status

Accepted (2026-08-10). Narrows ADR-0148, ADR-0151, ADR-0157, ADR-0162, ADR-0167, and ADR-0176.
