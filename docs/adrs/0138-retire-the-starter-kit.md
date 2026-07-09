---
type: adr
id: adr-0138
status: accepted
created: 2026-07-13
updated: 2026-07-13
---

# ADR-0138 — Retire the starter kit: the CLI seeds, the skills install globally, the shapes live in the contract

## Context

[ADR-0075](./0075-starter-kit-template-repo.md) made the starter kit its own template repo — the
copy-whole workspace adopters started from. [ADR-0137](./0137-personal-harness-transient-artifacts.md)
superseded that face: no committed workspace, artifacts transient in the personal store, the
methodology a globally installed skill family. Its parenthetical kept the kit alive as "a thin
repo-seed", and [ADR-0135](./0135-kit-declares-layout-cli-reads-manifest.md)'s manifest let the CLI
discover the kit's layout for `suspec update`.

An inventory of what the thinned-out kit actually still held found three things:

1. **Reference templates nothing consumes.** The CLI's authoring scaffolds are built in —
   `suspec write spec` and `suspec new` render their skeletons inline from the frozen formats
   (the ADR-0135 Correction code-verified this); no live CLI path reads the kit's `templates/`
   at authoring time.
2. **An `AGENTS.md` example duplicating `suspec init`'s embedded seed.** The CLI seeds the file
   itself; the kit copy is a second source waiting to skew.
3. **An update/manifest path dead on arrival.** `suspec update` compares a repo's
   `.agents/.suspec-version` pin to the kit `VERSION` — but v2's `suspec init` writes no version
   pin, so no v2-seeded repo can ever be "behind". The machinery has no live consumer.

Unconsumed, duplicated, or dead: that is the whole repo. Keeping it is ceremony without
leverage, and its rot mode is exactly the lifecycle failure ADR-0137 root-caused — no death
owner, no consumption pressure, creation cheaper than disposal.

## Decision

1. **The starter kit retires entirely.** The `suspec-starter-kit` repo leaves the family;
   nothing in the canon, the docs, or the tooling references it. _Level: convention._

2. **The install story is two moves.** `suspec init` seeds the repo — config, `AGENTS.md`, the
   skills dirs — from scaffolds embedded in the CLI itself; the universal skill family installs
   globally (`npx skills add jcosta33/suspec-skills -g`). Nothing is copied from a template
   repo. _Level: toolable (`suspec init`) / convention (the global tier, per
   [ADR-0137](./0137-personal-harness-transient-artifacts.md) Decision 5)._

3. **The authoritative artifact shapes are the CLI's built-in scaffolds plus the checks
   contract** (`checks/checks.yaml`). The human-facing shape reference is
   [docs/reference/artifact-formats.md](../reference/artifact-formats.md). Formats stay frozen
   in their ADRs; no manifest declares a layout, because no layout ships. _Level: toolable
   (scaffolds + checks) / convention (the reference page)._

4. **`suspec update` and the kit-manifest machinery retire from the CLI** — the
   `suspec-kit.yaml` reader, the `.agents/.suspec-version` pin, the kit-owned-prefix refresh.
   Skills update through their own channel (re-run the global install); the files `init`
   seeded are the adopter's own from that moment on. _Level: toolable (a deletion in
   suspec-cli)._

5. **Where each former kit job lands.** Scaffolds → the CLI's built-in renderers; artifact
   shapes → the checks contract + [artifact-formats](../reference/artifact-formats.md); the
   repo seed → `suspec init`; the guides and skills → the global catalog
   ([suspec-skills](https://github.com/jcosta33/suspec-skills)). _Level: convention._

## Alternatives considered

| Alternative | Why rejected |
|---|---|
| Keep the kit as a read-only reference example | An example nothing consumes has no death owner and no consumption pressure — the ADR-0137 rot pattern verbatim. It skews against the CLI's embedded seed at the first format change, and a reader cannot tell the live shape from the rotted one. |
| Keep the thin seed (ADR-0137's parenthetical as written) | The seed's only mechanical consumer would be `suspec update`, which is dead on arrival for v2-seeded repos (`init` writes no pin). Keeping a repo alive to feed a dead code path is ceremony without leverage — and every file in it duplicates a source that already exists (CLI scaffolds, the checks contract, artifact-formats). |

## Consequences

- Positive: one fewer repo to keep coherent; a format change is no longer a cross-repo
  template sync; the ADR-0135 layout-coupling question dissolves (no layout to declare);
  adopters get exactly two installs and zero update ceremony.
- Negative: no browsable template repo — someone wanting to see the shapes before installing
  reads [artifact-formats](../reference/artifact-formats.md) (or the CLI source) instead of a
  repo tree.
- Neutral: [suspec-skills](https://github.com/jcosta33/suspec-skills) is unchanged as the sole
  skill-shipping surface; the checks contract was already the shape authority for lint.

## Status

Accepted (2026-07-13). **Supersedes** [ADR-0135](./0135-kit-declares-layout-cli-reads-manifest.md)
(its surviving half — the manifest-declared layout loses its last consumer when `suspec update`
retires) and the kit-survival remainder of [ADR-0075](./0075-starter-kit-template-repo.md)
(already superseded on its copy-a-whole-workspace face by
[ADR-0137](./0137-personal-harness-transient-artifacts.md)). **Narrows**
[ADR-0137](./0137-personal-harness-transient-artifacts.md): the "kit repo survives as a thin
repo-seed" parenthetical and its Decision-5-adjacent kit mentions retire — seeding is
`suspec init`'s job, and the family ships no kit. Honors
[ADR-0063](./0063-honesty-framework-and-tooling-boundary.md) (levels stated) and
[ADR-0117](./0117-no-count-bearing-prose.md).

## Propagation

- `docs/adrs/README.md` — ledger row; flip [0135](./0135-kit-declares-layout-cli-reads-manifest.md);
  disposition notes on [0075](./0075-starter-kit-template-repo.md) and
  [0137](./0137-personal-harness-transient-artifacts.md).
- `README.md` — the family table drops the kit row.
- `AGENTS.md` — the repo-map bullet, the single-sourcing rule, the pointers section.
- `docs/reference/cli.md` — the `suspec update` section retires.
- `docs/ADOPTING.md` — the by-hand template pointer re-aims at artifact-formats; Updating
  keeps only the skills channel.
- `.agents/SKILLS-MANIFEST.md` — shipped-surface and census pointers re-aim at the catalog.
- corpus-cli (parallel change): delete `applyUpdate`, the manifest reader, and the version pin.
- The `suspec-starter-kit` repo itself: archived on GitHub.
