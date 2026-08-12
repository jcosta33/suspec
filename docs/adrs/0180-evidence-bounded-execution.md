---
type: adr
id: adr-0180
status: accepted
created: 2026-08-12
---

# ADR-0180 - Evidence-bounded execution

## Context

ADR-0171 removed routine narration and duplicate explanation. It did not stop agents from repeating
reads, searches, commands, tests, or reviews after the relevant state stopped changing. Campaign
handoffs could also preserve results while burying the next action in process prose.

Prompt wording changes the amount and kind of work coding agents perform. Unbounded certainty and
multi-approach demands increased reasoning and verification without measured success gains in one
preregistered study [[PROMPTWASTE]](../research/sources.md#PROMPTWASTE). Experience-driven stopping
reduced cost with negligible aggregate resolution loss in its evaluated configurations
[[EET]](../research/sources.md#EET). Compact action-state-result communication improved the
performance-cost tradeoff across evaluated agent systems [[PACT]](../research/sources.md#PACT).
Raw token removal alone can still raise billed cost or destroy exact evidence
[[TOKENCOST]](../research/sources.md#TOKENCOST).

## Decision

1. **Repeat only after change.** Repeat a read, search, command, test, or review only when relevant
   state changed, the previous attempt failed, or independent repetition is required.
2. **Stop when proven.** Stop when the requested result exists and proportionate verification
   passes. Extra searching, testing, reviewing, or explanation requires a concrete unresolved risk.
3. **Keep handoffs operational.** Campaign worker and phase handoffs carry only the action, current
   state, result, decisive evidence, unresolved conditions, and next owner or action.
4. **Preserve exact evidence.** Economy never licenses lossy rewriting of code, errors, edit anchors,
   requirements, or other action-critical evidence.
5. **Add no control plane.** No execution mode, completion manifest, artifact registry, runtime
   progress protocol, CLI command, or MCP tool is added.
6. **Measure accepted outcomes.** Field cost includes execution, coordination, retries, and rework.
   Token reduction remains diagnostic, not proof of savings.

## Narrowed decisions

- [ADR-0162](./0162-campaign-orchestration.md), [ADR-0163](./0163-conventional-campaign-pull-requests.md),
  and [ADR-0167](./0167-bounded-campaign-guardrails.md): campaign handoffs become compact operational
  state, not process history.
- [ADR-0171](./0171-global-interaction-economy.md): global economy now stops unchanged repetition and
  evidence-free continuation.
- [ADR-0178](./0178-restartable-campaign-goals.md): the stable operating loop gains explicit
  repetition and stopping boundaries.

## Consequences

- Diligence must change confidence or stop.
- Campaign successors receive enough state to act without replaying the transcript.
- Exact evidence survives compression.
- Suspec gains two brakes, not another machine.

## Status

Accepted (2026-08-12). Narrows ADR-0162, ADR-0163, ADR-0167, ADR-0171, and ADR-0178.
