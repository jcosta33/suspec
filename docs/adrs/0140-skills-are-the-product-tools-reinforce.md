---
type: adr
id: adr-0140
status: accepted
created: 2026-07-10
updated: 2026-07-10
---

# ADR-0140 — Suspec v3: skills are the product; tools reinforce

## Context

1. **The v2 pivot renamed the record and kept the record's organs.**
   [ADR-0137](./0137-personal-harness-transient-artifacts.md) declared "Suspec owns no record",
   then shipped a managed store with lifecycle machinery (doctor, gc, decay, WIP caps,
   triage-at-done), a ~20-command CLI, and an evidence-gate loop — a record apparatus under a
   transient name. The owner judged the composite incoherent.
2. **The internal benchmark located the cost in the apparatus, not the structuring.** The
   suspec-experiments paired trial measured the full v2 loop at correctness parity with plain
   plan-then-implement on tractable tasks, with the gate catching zero defects; its ceremony
   concentrated in the spec + board + run-record + CLI apparatus, while the gate-only arm sat at
   the null arm's artifact volume ([ADR-0131](./0131-minimum-useful-rigor.md) already frames this
   honestly).
3. **An adversarially verified external evidence sweep (2026-07-10) narrowed the durable slot.**
   The methodology-as-prose lane is crowded and machine-check-free: the leading skills framework
   gates implementation behind an approved design document as prose discipline only, at roughly
   twice the adoption of GitHub's own spec toolkit; no vendor ships a built-in, enforced, typed
   planning artifact, and vendors state plan-mode neutrality as product philosophy. Scaffolding
   that compensates for model weakness demonstrably loses value as models improve, while
   deterministic external standards (linters, type checkers) hold or gain value across model
   generations. Winning developer standards are mechanical, minimal-config, and ride an existing
   workflow; heavyweight bundled methodologies lose on ceremony regardless of intent.
4. **The owner repositioned the product.** Suspec imposes structure and consistency on the
   agent's working artifacts — the prettier/eslint register, not an intelligence claim. Its
   posture: describe, don't impose; flex according to need, never hypothetical gains; no ceremony
   for ceremony's sake.

## Decision

1. **Skills are the product.** The Suspec methodology ships as the skill family — authoring,
   splitting, implementing, reviewing, and finding disciplines. A capable harness plus the skills
   is a complete Suspec install. _Level: convention._

2. **Tools reinforce; they never carry the methodology.** The CLI is a deterministic checker over
   artifacts it is handed ([ADR-0143](./0143-path-agnostic-check-cli-contract.md)); the MCP server
   adapts that same surface for shell-less runners; the checks contract stays data
   (`checks/checks.yaml`). Nothing in the loop requires a tool
   (upholds [ADR-0134](./0134-self-contained-spine.md)). _Level: convention._

3. **Suspec coexists with native planning.** It never modifies, replaces, or races the harness's
   own plan mode; a developer who wants lightweight native planning keeps it. Suspec artifacts
   are produced alongside, by skills, when the work earns them. _Level: convention._

4. **Proportional rigor is existential.** The least structure that changes execution or
   reviewability ([ADR-0131](./0131-minimum-useful-rigor.md)): a trivial fix gets a one-line
   inline spec and no file; a feature gets a lean spec (roughly five to eight requirements,
   non-goals, acceptance criteria); large work extends rather than pads. Entry method never sets
   ceremony level. _Level: convention._

5. **Checks advise and report; Suspec owns no gate.** The deterministic checks yield facts and
   exit codes at check time — clean, warning, blocking — and the human decides what blocks a
   merge. The gate-command mechanic retires with the decisions that actually own it
   ([ADR-0143](./0143-path-agnostic-check-cli-contract.md) Decision 7); the principle that
   ungrounded model judgment is not a review signal —
   [ADR-0121](./0121-evidence-gating-load-bearing-mechanic.md), which names no new tool — stands
   untouched. _Level: convention._

6. **Code stays king.** Adopters commit no Suspec artifacts to their repos, unless the project's
   own governance says otherwise ([ADR-0141](./0141-artifacts-beside-native-artifacts.md)
   Decision 1); durable value lives in the layers that already own it — code, tests, ADRs, issues,
   PRs, native memory ([ADR-0142](./0142-findings-become-native-memories.md)). The producer's own
   governance workspace is meta-infrastructure, not the product. _Level: convention._

## Superseded and narrowed decisions

**Narrowed:**
- [ADR-0138](./0138-retire-the-starter-kit.md) — the kit's retirement stands; its successor claim
  (CLI `init` seeding, CLI-embedded scaffolds as the artifact-shape home) is retired: skills carry
  the shapes and placement guidance, the checks contract stays the machine-readable shape source,
  and the CLI seeds nothing ([ADR-0143](./0143-path-agnostic-check-cli-contract.md)).
- [ADR-0111](./0111-kit-skill-scope.md)/[ADR-0112](./0112-two-tier-skills.md) — the physical
  two-home placement (Suspec-coupled skills → the kit's `.agents/skills/`, framework-free skills →
  the catalog) retires with the starter kit itself ([ADR-0138](./0138-retire-the-starter-kit.md)):
  there is no more kit home to place anything in, so every skill — coupled or not — now ships from
  the one global catalog. The underlying coupling test (does a skill name a Suspec concept) survives
  only as descriptive vocabulary for what a skill assumes, not as an enforced placement rule.

**Upheld, load-bearing in v3:** [ADR-0121](./0121-evidence-gating-load-bearing-mechanic.md)
("ungrounded model judgment is not a review signal" and the evidence-bound review discipline
stand untouched — it never named a new tool, so Decision 5 has nothing of 0121's to narrow; the
gate-command mechanic it is sometimes conflated with belonged to
[ADR-0077](./0077-suspec-cli-reconcile-only-harness.md)/[ADR-0084](./0084-boundary-safe-prepare-verbs.md)/
[ADR-0107](./0107-fast-track-staleness-detection.md)/[ADR-0128](./0128-mint-c020-unresolvable-ref.md)/
[ADR-0129](./0129-c013-cmd-mismatch-blocks-at-gate.md)/[ADR-0130](./0130-review-staleness-content-drift.md)/
[ADR-0136](./0136-launcher-boundary-automate-not-agent.md), retired/narrowed by
[ADR-0143](./0143-path-agnostic-check-cli-contract.md)), [ADR-0131](./0131-minimum-useful-rigor.md) (Decision 4 elevates it
to doctrine), [ADR-0134](./0134-self-contained-spine.md) (by-hand path for every step),
[ADR-0132](./0132-revolver-rotating-refine-loop.md)/[ADR-0133](./0133-examine-dont-ruminate.md)
(review and examination disciplines),
[ADR-0113](./0113-product-vs-docs-boundary.md), [ADR-0109](./0109-output-economy-convention.md).

## Alternatives considered

| Alternative | Why rejected |
|---|---|
| Finish v2 as designed (store + gate + 20-command CLI) | The internal trial shows the apparatus is where the cost lives and the gate caught nothing; the organs contradict "owns no record"; the external sweep shows heavyweight bundles lose on ceremony. |
| Pitch Suspec as an output improver | The value claim is unproven internally (parity) and externally (no study isolates structured-vs-freeform planning artifacts); structure/consistency is the honest, defensible register. |
| Ride or transform native plan mode | Vendor plan surfaces are unstable, suppress skill invocation in places, and are owned by the vendor; coexistence keeps Suspec composable with whatever ships next. |
| Tools as the product, skills as accessories | A CLI-led methodology re-creates v2: the tool must then own locations, lifecycles, and gates — the organs this decision removes. |

## Consequences

- Positive: the product surface shrinks to what demonstrably differentiates (opinionated skills
  over a deterministic honesty floor); every v2 organ with no v3 subject retires; adoption is a
  skills install, not a harness migration.
- Negative: the whole doc surface must be rewritten in one coordinated sweep — v3 is presented as
  originally designed (fresh-product voice), so no page may narrate the transition.
- Neutral: the value of structured planning artifacts over freeform plans remains an open
  hypothesis; the honest floor claim (a reviewer cannot pass work with no evidence, a wrong
  command, or a silent coverage gap) is what ships.

## Status

Accepted (2026-07-10). Narrows [ADR-0138](./0138-retire-the-starter-kit.md) and
[ADR-0111](./0111-kit-skill-scope.md)/[ADR-0112](./0112-two-tier-skills.md) (the kit/catalog
physical placement retires with the starter kit; the coupling test survives only as descriptive
vocabulary); upholds
[ADR-0121](./0121-evidence-gating-load-bearing-mechanic.md), [ADR-0131](./0131-minimum-useful-rigor.md),
[ADR-0134](./0134-self-contained-spine.md), [ADR-0132](./0132-revolver-rotating-refine-loop.md),
[ADR-0133](./0133-examine-dont-ruminate.md), [ADR-0113](./0113-product-vs-docs-boundary.md),
[ADR-0109](./0109-output-economy-convention.md). Companion decisions:
[ADR-0141](./0141-artifacts-beside-native-artifacts.md) (placement),
[ADR-0142](./0142-findings-become-native-memories.md) (memory),
[ADR-0143](./0143-path-agnostic-check-cli-contract.md) (CLI contract).

## Propagation

- `docs/adrs/README.md` — ledger rows for 0140–0143; disposition flips for every ADR the four
  name.
- Full fresh-voice rewrite (no banners, no migration framing): `README.md`, `AGENTS.md`,
  `docs/README.md`, `docs/01`–`docs/10`, `docs/ADOPTING.md`, `docs/artifact-registry.md`,
  `docs/reference/` (cheatsheet, checks, cli, glossary, memory, agent-guides), `checks/README.md`,
  `docs/tutorial/` (all), `docs/examples/` (all); delete `docs/reference/advanced-lifecycle.md`
  and `docs/reference/step-bars.md`.
- corpus-skills: catalog rewrite per [ADR-0141](./0141-artifacts-beside-native-artifacts.md)/
  [ADR-0142](./0142-findings-become-native-memories.md); corpus-cli:
  [ADR-0143](./0143-path-agnostic-check-cli-contract.md); corpus-mcp, corpus-agents,
  corpus-starter-kit: derived sweeps.
- SPEC-suspec-v3 (corpus-works) governs the sweep; SPEC-suspec-v2 is superseded.
