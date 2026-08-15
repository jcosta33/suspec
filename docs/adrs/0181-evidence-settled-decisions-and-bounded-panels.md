---
type: adr
id: adr-0181
status: accepted
created: 2026-08-15
---

# ADR-0181 - Evidence-settled decisions and bounded panels

## Context

Agents should not send technical homework to the user when inspection, project precedent, official
documentation, or empirical evidence can settle it. One agent can still miss a viable alternative;
blind agreement among several agents can preserve the same error.

Distinct perspectives improve review coverage [[PBR]](../research/sources.md#PBR), while raw peer
rationales can induce conformity and waste tokens [[CONSENSUSCOST]](../research/sources.md#CONSENSUSCOST).
Consensus is not verification [[CONSENSUS]](../research/sources.md#CONSENSUS), and multi-agent
fan-out can lose to one agent under an equal token budget [[SINGLEBEATSMAS]](../research/sources.md#SINGLEBEATSMAS).
The useful pattern is bounded independence, not a meeting with no exit.

## Decision

1. **Settle technical ambiguity with evidence.** A standalone universal method resolves technical
   and procedural choices through direct inspection, current authoritative sources, safe exercise,
   project conventions, and empirical data. It returns the decision and decisive evidence in chat.
2. **Do not create a decision artifact by default.** Routine technical resolution remains working
   conduct. Product intent, public behavior, material security or cost tradeoffs, waivers,
   irreversible actions, and acceptance remain human-owned.
3. **Persist deliberation only when deliberation is the job.** `sus-panel` authors a `panel`
   artifact when a consequential choice needs several independent perspectives and a durable
   recommendation.
4. **Use an adaptive panel.** A user-specified participant count wins. Otherwise the orchestrator
   chooses the smallest panel that covers every material perspective. No numeric floor or cap is
   canonical.
5. **Buy diversity cheaply.** Use the cheapest capable models by default. Give fresh participants
   one fixed question and evidence packet. Hide peer analyses until every initial response lands.
6. **Synthesize; do not transcribe.** Persist the question, constraints, options, recommendation,
   material dissent, and unknowns. Omit identities, votes, transcripts, and repeated rationale.
7. **Verify claims outside the vote.** Agreement never proves a fact. The orchestrator verifies
   load-bearing claims against direct evidence and may run one targeted follow-up when evidence can
   resolve a decisive conflict.
8. **Keep neighboring methods distinct.** Research collects and qualifies evidence. A panel
   compares viable alternatives. The panel recommends; it does not seize human intent.
9. **Recognize the new artifact explicitly.** Checks contract `0.25.0` adds `panel` as a recognized
   unchecked type. No check ID or MCP surface changes.

## Narrowed decisions

- [ADR-0151](./0151-skill-agent-artifact-economy.md) and
  [ADR-0157](./0157-ruthless-skills-and-closed-artifact-authorship.md): the catalog adds `settle` and
  `sus-panel`; closed artifact authorship adds `panel`.
- [ADR-0169](./0169-minimum-sufficient-skill-control.md): the new skills carry only control that
  changes execution.
- [ADR-0170](./0170-proportional-design-and-executable-oracles.md): technical ambiguity is resolved
  by evidence; durable multi-perspective deliberation is explicit and proportional.

## Consequences

- Solvable technical questions stop reaching the user.
- Important alternatives receive independent scrutiny without a fixed headcount or open-ended
  debate.
- Cheap fan-out stays optional and evidence-bounded.
- Durable panel output is short enough to use.

## Status

Accepted (2026-08-15). Narrows ADR-0151, ADR-0157, ADR-0169, and ADR-0170.
