---
type: adr
id: adr-0143
status: accepted
created: 2026-07-10
updated: 2026-07-10
---

# ADR-0143 — Path-agnostic check: the entire CLI contract

## Context

1. **The check engine is already pure.** Every rule in the checks contract operates on parsed
   records with filesystem access injected as predicates; only the command plumbing resolves
   workspaces, stores, and repo roots. The purity boundary the codebase already enforces is the
   product boundary this decision draws.
2. **Every other verb lost its subject.** With the store retired
   ([ADR-0141](./0141-artifacts-beside-native-artifacts.md)) and promotion retired
   ([ADR-0142](./0142-findings-become-native-memories.md)), the launch spine, evidence capture,
   gate, scaffolds, seeding, staleness reconcile, board/status projections, and store management
   have nothing to operate on.
3. **Reinforcement posture.** [ADR-0140](./0140-skills-are-the-product-tools-reinforce.md)
   Decision 2: the CLI's one job is the deterministic honesty floor — the facts a lazy or
   dishonest reviewer cannot fake (coverage-complete, command-matches, pass-needs-evidence,
   ref-resolves) plus the single-artifact lint, at zero model cost.

## Decision

1. **The surface.** `suspec check <artifact> [--spec <path>] [--task <path>]` and
   `suspec check --contract` (the checks contract as JSON). Nothing else — no other command,
   no interactive mode, no dashboard. _Level: enforced (suspec-cli)._

2. **Path-agnostic, always.** The CLI reads exactly the files it is handed by full path. It never
   resolves a store, a config, a repo root, or a workspace tree, and never scans for siblings.
   The primary artifact's kind is read from its own frontmatter; companions are always explicit
   flags. _Level: enforced (suspec-cli)._

3. **A missing required companion blocks.** A review packet checked without the spec and task it
   reconciles against exits blocking (2) naming the missing flag — the honesty floor never
   degrades silently into a shallower check. _Level: enforced (suspec-cli)._

4. **Reference checks resolve artifact-relative.** C009 (source refs) and C015 (citation anchors)
   resolve against the passed artifact's own directory — `sources.md` is the spec's sibling —
   never against a workspace root. _Level: enforced (suspec-cli)._

5. **C017 leaves the adopter contract.** The orphaned-reference scan presumes a governed tree to
   walk; catalog hygiene is the catalog repo's own concern (narrows
   [ADR-0097](./0097-mint-c016-c017-defer-oversized.md); C016 stands untouched).
   _Level: convention._

6. **Contract 0.16.0.** `checks/checks.yaml` (canon) and the CLI's contract table move together
   in one logical change; the sibling-canon drift guard stays the enforcement.
   _Level: enforced (drift-guard test + CI)._

7. **Exit codes are the API.** 0 clean · 1 warning · 2 blocking; `--json` stays the structured
   face. Severity previously expressed as "blocks at the gate face" is expressed as blocking
   severity at check time — the human owns what blocks a merge (narrows
   [ADR-0129](./0129-c013-cmd-mismatch-blocks-at-gate.md) and
   [ADR-0128](./0128-mint-c020-unresolvable-ref.md): both checks and their hard severities stand;
   the gate face they referenced retires). _Level: enforced (suspec-cli)._

8. **Family consequences.** corpus-mcp adapts this surface only — path-explicit tools, shell-out
   posture unchanged (upholds [ADR-0085](./0085-suspec-mcp-adapts-the-json-contract.md)). The
   `agents emit` Codex emitter retires; the committed Codex projections become hand-maintained
   (narrows [ADR-0098](./0098-codex-emitter-and-universal-layer.md): the universal AGENTS.md
   discipline stands; the emitter and its sync guard retire). _Level: convention._

## Superseded and narrowed decisions

**Superseded:**
- [ADR-0136](./0136-launcher-boundary-automate-not-agent.md) — the launcher boundary loses its
  subject: there is no launcher, no worktree orchestration, no prompt generation, no run record.
- [ADR-0084](./0084-boundary-safe-prepare-verbs.md) — the prepare verbs (`pull`, `promote`,
  scaffolds) retire with their subjects.
- [ADR-0107](./0107-fast-track-staleness-detection.md) and
  [ADR-0130](./0130-review-staleness-content-drift.md) — the staleness reconcile ran inside
  `review`/`check --staleness`; both verbs retire. Staleness stays a review concern the reviewer
  owns by reading the diff.

**Narrowed:**
- [ADR-0077](./0077-suspec-cli-reconcile-only-harness.md) — reconcile-only, markdown-only,
  verdict-free, facts-not-verdicts (D8): all stand, sharpened — the harness of composable parts
  collapses to the one composable part that earned its keep. The multi-verb surface retires.
- [ADR-0097](./0097-mint-c016-c017-defer-oversized.md), [ADR-0128](./0128-mint-c020-unresolvable-ref.md),
  [ADR-0129](./0129-c013-cmd-mismatch-blocks-at-gate.md) — per Decisions 5 and 7.
- [ADR-0098](./0098-codex-emitter-and-universal-layer.md) — per Decision 8.

**Upheld:** [ADR-0085](./0085-suspec-mcp-adapts-the-json-contract.md) (shell-out, never import),
[ADR-0063](./0063-honesty-framework-and-tooling-boundary.md) (levels as stated),
[ADR-0079](./0079-c012-coverage-check.md)/[ADR-0083](./0083-verify-evidence-reconcile.md) (the
surviving checks' semantics).

## Alternatives considered

| Alternative | Why rejected |
|---|---|
| Positional multi-file with role pairing (`suspec check review.md spec.md task.md`) | Pairing inference between positionals is hidden resolution — the exact organ this decision removes; explicit flags are deterministic and self-documenting. |
| Keep a path-agnostic scaffold verb | Skills carry the artifact shapes; an agent writes files natively. A scaffold verb is surface without subject. |
| Keep `--staleness` (git-backed advisory) | It resolves a repo root and reads git — both banned by Decision 2; the reviewer reads the diff. |
| Warn (exit 1) on a review checked without companions | Silently downgrades the floor's strongest checks (C012/C013/C020 simply don't run); a floor that degrades quietly is not a floor. |

## Consequences

- Positive: the CLI becomes a pure function over files it is handed — trivially testable,
  trivially portable, no location opinions; the drift guard keeps canon and implementation
  honest; the check is runnable by hand, in CI, or through MCP identically.
- Negative: no tool lists, resumes, or manages work in flight — by design, that capability left
  with the store; anyone wanting it composes it from their own harness.
- Neutral: contract 0.16.0 is a breaking bump consumed only by the repo family (nothing external
  pins 0.15.0).

## Status

Accepted (2026-07-10). Supersedes
[ADR-0136](./0136-launcher-boundary-automate-not-agent.md),
[ADR-0084](./0084-boundary-safe-prepare-verbs.md),
[ADR-0107](./0107-fast-track-staleness-detection.md),
[ADR-0130](./0130-review-staleness-content-drift.md); narrows
[ADR-0077](./0077-suspec-cli-reconcile-only-harness.md),
[ADR-0097](./0097-mint-c016-c017-defer-oversized.md),
[ADR-0128](./0128-mint-c020-unresolvable-ref.md),
[ADR-0129](./0129-c013-cmd-mismatch-blocks-at-gate.md),
[ADR-0098](./0098-codex-emitter-and-universal-layer.md); upholds
[ADR-0085](./0085-suspec-mcp-adapts-the-json-contract.md),
[ADR-0063](./0063-honesty-framework-and-tooling-boundary.md). Part of the
[ADR-0140](./0140-skills-are-the-product-tools-reinforce.md) re-founding.

## Propagation

- `docs/adrs/README.md` — ledger row + disposition flips (0136, 0084, 0107, 0130, 0077, 0097,
  0128, 0129, 0098, 0085).
- Canon: `checks/checks.yaml` → 0.16.0 (C009/C015 re-scope wording, C017 removal);
  `docs/reference/cli.md` (two-invocation rewrite), `docs/reference/checks.md`,
  `checks/README.md`, `docs/10-integrations.md`.
- corpus-cli: the surgery — 18 command retirements, store/gate/launch/Tui/Workspace cull,
  explicit-path review checking, contract bump, test rebuild, gates green.
- corpus-mcp: path-pass-through realign + fixture regeneration against the rebuilt CLI.
- corpus-agents: drop the retired verbs from agent bodies; retire the codex-sync guard; freeze
  `.codex/` as hand-maintained.
