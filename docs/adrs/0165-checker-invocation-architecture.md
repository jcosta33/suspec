---
type: adr
id: adr-0165
status: accepted
created: 2026-07-19
---

# ADR-0165 - Checker invocation architecture

## Context

The deterministic checker is optional reinforcement. Naming it inside artifact-authoring skills made
two methods orchestrate one optional tool while the rest remained standalone. Leaving invocation
entirely to users made the MCP tool discoverable in name but not in purpose.

The boundaries are distinct. Skills define methods. The CLI computes deterministic integrity facts.
MCP exposes that engine to tool-aware harnesses.

## Decision

1. **The CLI is the deterministic engine.** `suspec check` remains a zero-token, read-only floor for
   artifact shape, references, coverage, and evidence consistency. It never judges correctness,
   reads implementation source to find defects, executes verification, or proves that recorded
   evidence is true. It rejects malformed integrity; a well-formed lie remains possible.
2. **MCP is the ambient bridge.** `suspec_check` tells an agent when checking is useful: after
   authoring or before finalizing a spec, task, review, or change plan. It forwards explicit paths to
   one CLI process and validates the result. It gains no storage, discovery, orchestration, or
   judgment.
3. **Skills stay checker-agnostic.** Artifact methods state the required shape and self-checking
   method. They do not name, require, discover, or invoke optional Suspec tools.
4. **Invocation stays optional.** An agent may discover the MCP tool, a user may run the CLI, or a
   user may instruct an agent to check an artifact. A harness with neither tool nor instruction
   still runs the skill. The checker reinforces; it never gates method availability.
5. **The CLI keeps one verb.** Retired store, scaffold, and execution verbs remain retired. A
   read-only structure projection is coherent only when a real consumer exists; none is established,
   so no second verb is added.

## Upheld decisions

- [ADR-0121](./0121-evidence-gating-load-bearing-mechanic.md) and
  [ADR-0140](./0140-skills-are-the-product-tools-reinforce.md): deterministic checks reinforce the
  method without becoming mandatory.
- [ADR-0143](./0143-path-agnostic-check-cli-contract.md): explicit-path, read-only checking remains
  the entire CLI surface.
- [ADR-0153](./0153-mcp-parity-and-compatibility.md): MCP remains an exact, thin CLI adapter.
- [ADR-0149](./0149-skills-state-rules-directly.md) and
  [ADR-0161](./0161-semantic-skill-contracts-and-evidence.md): each skill remains complete alone and
  free of optional sibling machinery.

## Consequences

- Tool-aware harnesses receive a useful activation cue without loading it into every skill.
- Artifact methods neither depend on the checker nor duplicate its invocation contract.
- The checker keeps an honest ceiling: deterministic integrity, never semantic truth.

## Status

Accepted (2026-07-19). Upholds ADR-0121, ADR-0140, ADR-0143, ADR-0149, ADR-0153, and ADR-0161.
