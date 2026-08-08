---
type: adr
id: adr-0171
status: accepted
created: 2026-08-08
---

# ADR-0171 - Global interaction economy

## Context

Suspec makes artifacts economical but leaves ordinary agent chat to harness defaults. Production use
shows the leak: agents narrate reads and commands, repeat artifacts after linking them, recap work that
the diff already proves, and flood chat with evidence that one excerpt could decide. Enterprise usage
makes the bill visible; the unread prose makes the waste obvious.

The external evidence is directional, not a promised effect size. OpenAI reports lower token use and
cost from leaner coding-agent prompts [[OAILEAN]](../research/sources.md#OAILEAN). Anthropic reports
removing most of Claude Code's system prompt without measured loss on its internal evaluation
[[CLAUDE5CTX]](../research/sources.md#CLAUDE5CTX). Tool definitions and intermediate results can
dominate context [[CLAUDETOOLS]](../research/sources.md#CLAUDETOOLS). Multi-agent cost follows task
topology, not enthusiasm [[MASCALE]](../research/sources.md#MASCALE).

## Decision

1. **Install one communication default.** `policy/economy.md` is the canonical harness-neutral
   economy policy. It controls narration and duplication only. It carries no Suspec method.
2. **Speak when speech changes the outcome.** Answers, required input, blockers, failed verification,
   safety, irreversible confirmation, and result handoff remain explicit. Routine progress narration
   and recap do not.
3. **Do not invoice twice.** Successful artifact authors return clickable artifact links. Later work
   does not restate the artifact, diff, commands, evidence, or completed steps unless the active method
   requires that proof or the user asks.
4. **Evidence earns its bytes.** Show the smallest untouched decisive excerpt. Full output stays in
   its native tool record or an artifact-owned receipt when that workflow requires one.
5. **Methods keep their contracts.** Structured decisions, artifact handoffs, worker results, review
   depth, and evidence receipts remain in their owning standalone skills or delegation prompts.
6. **Measure outcomes, not silence.** The useful metric is total parent, worker, coordination, retry,
   and rework cost per accepted outcome. Field use governs refinement. No synthetic prompt theater.

## Narrowed decisions

- [ADR-0109](./0109-output-economy-convention.md) and
  [ADR-0168](./0168-rendered-chat-output.md): economy now covers ordinary interaction, not only final
  rendered output.
- [ADR-0145](./0145-attention-economy-and-decision-rails.md): link-only artifact handoff stands;
  required proof and decisions remain explicit.
- [ADR-0169](./0169-minimum-sufficient-skill-control.md): minimum sufficient control stands; the
  always-on payload is a communication default, not a skill or method carrier.
- [ADR-0170](./0170-proportional-design-and-executable-oracles.md): witnessed production waste
  authorizes this bounded control; real work remains the behavior test.

## Consequences

- Suspec can govern global chat economy without turning every turn into a workflow.
- Skills stay standalone and on demand.
- Silence that causes rework is failure, not savings.

## Status

Accepted (2026-08-08). Narrows ADR-0109, ADR-0145, ADR-0168, ADR-0169, and ADR-0170.
