---
type: adr
id: 0048-installed-payload-is-the-runtime-surface
status: accepted
created: 2026-06-06
updated: 2026-06-06
supersedes:
superseded_by:
---

# ADR-0048: The installed payload is the runtime surface, not the whole kernel

## Context

ADR-0040/0044 defined the installable payload as `kernel/.agents/` and shipped it **wholesale** into an
adopter's `.swarm/kernel/` — `skills/`, `templates/`, `language/` (the full SOL/APS/errors/versioning
manuals), `passes/` (the nine pass reference docs with rationale), `conformance/` (the golden corpus),
and `memory/`. The justification was offline self-containment.

Adopting `swarm-cli` made the cost visible: ~1.2 MB of framework documentation copied into the repo, of
which an agent **loads almost none** at runtime. Per the load-what-the-task-names doctrine, an agent
loads the *skill* the task names; it never opens the full `passes/`/`language/` manuals or the
conformance corpus. With skills now self-contained ([0047](./0047-skills-are-self-contained.md)), the
only thing that made the kernel ship `passes/` + `language/` — keeping skill citations from dangling —
is gone. The corpus (`conformance/`) is test data for a *checker*, never used by an adopting project.

## Decision

1. **The installed payload is the runtime surface only:** `skills/` (self-contained) + `templates/` +
   the `memory/` seed + the `AGENTS.md` bootloader + `config.yaml` + `overlays/` + `.swarm-version`.
2. **`passes/`, `language/`, and `conformance/` are NOT installed.** They are the framework's **human
   reference and test data**, and they live canonically in the `swarm` repo (`docs/passes/`,
   `docs/language/`, and the conformance corpus). An adopter that wants depth reads the `swarm` repo.
3. The bootloader and skills **name** the deep reference (provenance) but link nothing that isn't
   shipped, so the slim payload has no dangling refs.

This **refines ADR-0044**: `docs/` remains canonical, but the kernel no longer carries derived
`passes/`/`language/` *twins for shipping* — the self-contained skills are the shipped derivative, and
the deep reference stays upstream. (The twin-maintenance burden 0044 introduced shrinks accordingly.)

## Alternatives considered

| Alternative | Why rejected |
| --- | --- |
| Ship the whole kernel (status quo) | ~1.2 MB of reference an agent never loads, duplicated into every adopter; the user-visible bloat that prompted this. |
| Ship a compact normative *card* instead of the manuals | Still a shipped reference the skills would cite (a hop); [0047](./0047-skills-are-self-contained.md) shows the hop is unreliable, so the rules belong inline in the skills, not in a shipped card. |
| Fetch the reference from the network on demand | Breaks offline use and pins a repo location; the reference is for *humans*, who can open the `swarm` repo. |

## Consequences

- **Positive:** the adopter's `.swarm/kernel/` drops to the runtime surface (skills + templates); no
  manuals, no corpus. Upgrades copy less; there is less to drift.
- **Negative:** an agent cannot read the full pass rationale offline. Acceptable: the skills carry the
  operational rules ([0047](./0047-skills-are-self-contained.md)); rationale is a human concern, upstream.
- **Neutral:** `kernel/.agents/{passes,language,conformance}` remain in the `swarm` repo (the reference +
  the corpus a future `swarm-core` checker tests against); they are simply outside the installed subset.

## Status

Accepted (v0.1). `ADOPTING.md` copies the runtime subset; `swarm-cli`'s `.swarm/kernel/` was trimmed to
`skills/` + `templates/` (1.2 MB → ~0.79 MB, almost all of it the skills).

## Affected obligations / constraints

- Refines: [0044](./0044-kernel-is-derived-and-self-contained.md) (kernel no longer ships passes/language
  twins), [0040](./0040-kernel-payload-directory.md) (payload = a defined subset of `kernel/.agents/`).
- Depends on: [0047](./0047-skills-are-self-contained.md) (self-contained skills make the trim safe).
- Does NOT change: `docs/` as canonical, any closed set, or the obligation grammar.
