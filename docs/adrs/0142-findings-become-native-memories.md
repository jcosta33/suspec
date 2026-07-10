---
type: adr
id: adr-0142
status: accepted
created: 2026-07-10
updated: 2026-07-10
---

# ADR-0142 — Durable findings become native harness memories

## Context

1. **v2 durability was a pipeline.** A durable lesson became a finding file in the store, waited
   for triage at the gate (`promote` / keep-with-expiry / discard), and left via a CLI verb to a
   GitHub issue. The pipeline exists to compensate for a parallel record nobody reads on its own —
   the machinery is the cost of having invented a second memory.
2. **Harnesses ship native memory.** Agent runtimes maintain their own durable memory surfaces —
   memory directories with an index, `CLAUDE.md`-style instruction files, equivalents per vendor —
   loaded into context by the harness itself. A lesson written there is read on every future
   session with no Suspec machinery at all; a lesson written to a parallel store is read never.
3. **The proportional default is the cheap route.** The internal trial's memory arm was never
   run — the value of any curated-memory machinery is unproven — while the native-memory route
   costs one file write the agent already knows how to do
   ([ADR-0131](./0131-minimum-useful-rigor.md)).

## Decision

1. **A durable lesson becomes a native memory.** The save-findings discipline guides the agent to
   write durable lessons the way its harness records memories — one claim per memory, the
   evidence attached, under a searchable title. Ephemeral findings ride the review packet and die
   with it. _Level: convention._

2. **No promotion machinery.** Suspec ships no finding store, no triage state, no promote verb,
   no expiry. Residue that belongs to the team leaves through the project's own channels — an
   issue, an ADR, a test — written by hand like any other contribution. _Level: convention._

3. **Memory hygiene is prose, not machinery.** The skill carries the cautions that matter — a
   memory states what was verified, not what was assumed; agent-authored claims name their
   evidence; stale memories are corrected or deleted when contradicted
   (consuming the poisoning-defense insight of
   [ADR-0123](./0123-project-memory-quarantine-and-poisoning-defense.md) without its quarantine
   states). _Level: convention._

## Superseded and narrowed decisions

**Superseded:**
- [ADR-0123](./0123-project-memory-quarantine-and-poisoning-defense.md) — the quarantine states
  and project-memory file machinery presume a Suspec-owned memory surface; the defensive insight
  (agent-authored content is a claim, not a fact) survives as Decision 3 prose.
- [ADR-0137](./0137-personal-harness-transient-artifacts.md) Decision 3 (durability by promotion)
  — recorded in 0137's ledger disposition alongside
  [ADR-0141](./0141-artifacts-beside-native-artifacts.md)'s narrowing.

**Upheld:**
- [ADR-0121](./0121-evidence-gating-load-bearing-mechanic.md)'s evidence discipline — a finding
  without evidence is an opinion; that rule moves house intact.

## Alternatives considered

| Alternative | Why rejected |
|---|---|
| Keep `suspec promote` (findings → GitHub issues) | A CLI verb for something the agent does natively in one step; the verb drags store residence and triage state behind it. |
| A Suspec-owned memory file with its own format | A second memory beside the harness's memory is the same parallel-record mistake at smaller scale; the harness already indexes, loads, and recalls its own. |
| Drop durable findings entirely | Real lessons recur; the one-file-write cost is proportional, and native memory makes the lesson actually load next session. |

## Consequences

- Positive: durable lessons land where the harness actually reads them; the finding artifact,
  triage states, expiry machinery, and promote verb all retire; the discipline (claim + evidence
  + searchable title) survives as three lines of skill prose.
- Negative: memories are per-developer and per-harness — a team never sees them unless the
  developer raises the lesson through project channels (this is the personal-harness posture,
  stated plainly).
- Neutral: what the harness does with its memory (indexing, recall quality) is the vendor's
  concern; Suspec inherits it rather than competing with it.

## Status

Accepted (2026-07-10). Supersedes
[ADR-0123](./0123-project-memory-quarantine-and-poisoning-defense.md) and (with
[ADR-0141](./0141-artifacts-beside-native-artifacts.md)) the promotion decision of
[ADR-0137](./0137-personal-harness-transient-artifacts.md); upholds
[ADR-0121](./0121-evidence-gating-load-bearing-mechanic.md)'s evidence discipline. Part of the
[ADR-0140](./0140-skills-are-the-product-tools-reinforce.md) re-founding.

## Propagation

- `docs/adrs/README.md` — ledger row + disposition flips (0123, 0137).
- Canon: `docs/09-saving-findings.md` and `docs/reference/memory.md` rewritten around this
  decision.
- corpus-skills: `save-findings` spine rewrite; the finding-triage lines in `review-output` and
  `write-audit`.
- corpus-cli: `promote`, finding store, and triage surface retire
  ([ADR-0143](./0143-path-agnostic-check-cli-contract.md)).
