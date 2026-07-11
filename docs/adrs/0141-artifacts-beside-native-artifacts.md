---
type: adr
id: adr-0141
status: accepted
created: 2026-07-10
updated: 2026-07-10
---

# ADR-0141 — Artifacts live beside the agent's native artifacts; the store retires

## Context

1. **A tool still owned the location.** [ADR-0137](./0137-personal-harness-transient-artifacts.md)
   Decision 2 placed artifacts "beside the agent's own scaffold" but made the CLI resolve the
   directory; [ADR-0139](./0139-store-location-is-a-rule-cli-conforms.md) hardened that into a
   deterministic rule keyed on the repo's absolute path. Rule or service, the effect is the same:
   Suspec prescribes a filesystem location, and everything downstream (launch-prompt path
   handover, store commands, reconcilers) exists to serve the prescription.
2. **The agent already solves placement.** A harness lands its own artifacts — plans, notes,
   memories — in its own conventions without any external rule. Describing intent ("put this next
   to your own artifacts, in a folder named for the repo you're working on, or wherever fits")
   is sufficient and portable across vendors; prescribing a path re-creates the store under
   another name.
3. **The management organs exist only because a tool owned a directory.** Doctor, gc, decay,
   WIP caps, migrate, near-miss reconciliation — every one presumes Suspec is responsible for a
   location's hygiene. No owned location, no organs.

## Decision

1. **Skills describe placement; the agent chooses.** The skills instruct: place Suspec artifacts
   next to your own native artifacts — the same place you keep your plans, notes, and memories —
   in a folder named after the repo you are working on, or wherever fits your harness best; keep
   them out of the repo unless the project's own governance says otherwise. No path is prescribed,
   no directory is set in stone, and no rule needs a tool to compute
   (upholds [ADR-0134](./0134-self-contained-spine.md) Decision 3 trivially). _Level: convention._

2. **The store retires.** No state root, no repo keying or encoding, no `suspec.config.json`
   location config, no seeding or init, no doctor/gc/decay/WIP-cap/migrate, no launch-prompt
   path-handover contract, no store commands. _Level: convention._

3. **Paths flow explicitly.** Whoever needs a file names it by full path — a skill carrying a
   path forward through the work, a dispatch prompt naming its inputs, the checker receiving
   artifact paths as arguments ([ADR-0143](./0143-path-agnostic-check-cli-contract.md)). Nothing
   discovers, resolves, or infers a store, a config, a repo root, or a workspace tree; the narrow
   exception is [ADR-0143](./0143-path-agnostic-check-cli-contract.md) Decision 4's
   artifact-relative sibling lookup for three reference checks (C009, C015, C010) — one level
   beside the passed artifact, never a tree walk. _Level: convention._

## Superseded and narrowed decisions

**Superseded:**
- [ADR-0139](./0139-store-location-is-a-rule-cli-conforms.md) — the deterministic store-location
  rule loses its subject with the store; nothing computes a location anymore.
- [ADR-0106](./0106-keep-clean-tooling.md) — keep-clean tooling (promotion-or-die, gc) managed a
  record Suspec owned; zero-noise is now structural by absence — there is nothing to manage.

**Narrowed:**
- [ADR-0137](./0137-personal-harness-transient-artifacts.md) — "artifacts are transient and never
  committed to any repo" stands as the default (Decision 1 above narrows it with a governance
  exception, mirrored in [ADR-0140](./0140-skills-are-the-product-tools-reinforce.md) Decision 6);
  Decision 2's CLI-resolved store, Decision 6's structural anti-rot machinery, and Decision 7's
  `suspec.config.json` exception retire. Decision 4's repo-root worktree launch and its
  launch-prompt-as-store-pointer retire along with it — both the store it points into (Decision 2,
  above) and the CLI-generated launch prompt / worktree orchestration itself
  ([ADR-0143](./0143-path-agnostic-check-cli-contract.md), superseding
  [ADR-0136](./0136-launcher-boundary-automate-not-agent.md)). Durability by promotion (Decision 3)
  is retired by [ADR-0142](./0142-findings-become-native-memories.md).

## Alternatives considered

| Alternative | Why rejected |
|---|---|
| Keep the ADR-0139 rule (deterministic store location) | Any prescribed location — rule or service — drags the management organs back in and makes Suspec own hygiene it has no business owning. |
| Prescribe a canonical folder name only (no root) | Still a prescription; harnesses differ, and the agent knows its own conventions better than a cross-vendor rule can. |
| Keep a minimal `suspec.config.json` for overrides | Config that configures nothing: with no resolution, there is nothing to override. |

## Consequences

- Positive: zero Suspec footprint anywhere — no repo files, no owned home directory, no lifecycle
  machinery; placement guidance is one paragraph of prose that works on every harness.
- Negative: artifact locations vary by developer and harness; anything that wants a file must be
  handed its path (this is the design, but it forbids "list all my specs" tooling).
- Neutral: an agent that places artifacts beside its plans-and-memories scaffold will often
  produce something store-shaped anyway — by its choice, not Suspec's rule.

## Status

Accepted (2026-07-10). Supersedes [ADR-0139](./0139-store-location-is-a-rule-cli-conforms.md) and
[ADR-0106](./0106-keep-clean-tooling.md); narrows
[ADR-0137](./0137-personal-harness-transient-artifacts.md); upholds
[ADR-0134](./0134-self-contained-spine.md) Decision 3. Part of the
[ADR-0140](./0140-skills-are-the-product-tools-reinforce.md) re-founding.

## Propagation

- `docs/adrs/README.md` — ledger row + disposition flips (0139, 0106, 0137).
- Canon: `docs/03-where-files-live.md` (rewritten around this decision), plus every page the
  [ADR-0140](./0140-skills-are-the-product-tools-reinforce.md) sweep names.
- corpus-skills: the placement paragraph (byte-identical across the artifact-authoring skills)
  and the self-containment editing rule in `AGENTS.md`.
- corpus-cli: the store module and every command premised on it
  ([ADR-0143](./0143-path-agnostic-check-cli-contract.md) owns the surface).
