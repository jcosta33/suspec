---
type: adr
id: adr-0135
status: accepted
created: 2026-07-05
updated: 2026-07-05
---

# ADR-0135 — The kit declares its layout in a manifest; the CLI reads it, never a hardcoded `templates/` path

## Context

[ADR-0134](./0134-self-contained-spine.md) established that an additive accelerator must not dictate the
mandatory kit's structure. The CLI violates this: it **hardcodes the starter-kit's `templates/` layout**
— `initWorkspace` copies `templates/`, `applyUpdate` syncs it, `scaffoldSpec`/`scaffoldChangePlan`
materialize from `templates/<artifact>.md`, and `checkWorkspace` validates that a workspace *has*
`templates/`. The dependency is inverted: the CLI's fixed paths **block the kit from placing its artifact
scaffolds where self-containment wants them** (skill `references/` for skill-specific scaffolds; a
kit-chosen home for the shared loop artifacts). The held "#8 templates ↔ references" question and the
CLI-coupling smell are the same problem.

## Decision

**The kit declares its layout in a manifest; the CLI reads the manifest and assumes no fixed path.**

1. **A kit manifest** (at the kit root) maps each artifact/scaffold **role** to its **path within the
   kit** — `spec`, `task`, `review`, `finding`, `change-plan`, `intake`, `inventory`, `adr`, etc. The kit
   **owns its layout**: moving a template is a manifest edit, not a CLI change.
2. **The CLI resolves the kit's layout through the manifest, never a hardcoded `templates/` string**, at
   the points that are actually path-coupled: `update` refreshes the kit-owned prefixes the manifest
   lists, and `check` validates the required paths it names. A manifest-less kit falls back to the
   built-in default so it never breaks (AC-004). (`init` copies the whole kit and `new` renders each
   artifact inline from its frozen format — neither is `templates/`-path-coupled; see the Correction.)
3. **Two homes, both manifest-declared.** The **shared loop artifacts** (spec/task/review/finding — the
   mandatory glue of ADR-0134) keep one canonical home the **kit** chooses; **skill-specific scaffolds**
   live in each skill's `references/` (already true for the `write-*` skills). The manifest can point at
   either, so the kit is free to place each where self-containment wants it.
4. **The manifest freezes only *where*, not *what*.** The artifact **formats** stay frozen in their own
   ADRs ([0058](./0058-two-tier-spec-format.md)/[0060](./0060-suspec-workspace.md)/0061/0067/0068); the
   manifest declares location. The single-sourcing rule is refined: *the kit declares its layout, the CLI
   discovers it* — the CLI never defines the layout. The drift-guard keys on the manifest.

## Consequences

- **CLI change (contract-adjacent, ADR-gated):** the two real `templates/`-coupling points —
  `applyUpdate`'s kit-owned prefix set and `checkWorkspace`'s required-path check — read the kit's
  `suspec-kit.yaml` manifest (a manifest-less kit falls back to the built-in default). The CLI stays
  scaffold-additive/reconcile-only ([ADR-0085](./0085-suspec-mcp-adapts-the-json-contract.md)/0134) — it
  discovers and materializes, never dictates. (The Correction below narrows this from the five use-cases
  the Context named to these two — the other three are not `templates/`-path-coupled.)
- **The kit is free to place templates per self-containment**; the CLI adapts. Resolves the ADR-0134
  inversion and the held #8 question.
- **Implementation shipped (2026-07-05)** under SPEC-cli-kit-manifest: the kit gained `suspec-kit.yaml`
  (corpus-starter-kit@f125523) and the CLI reads it at those two coupling points (corpus-cli@845697e),
  keeping a built-in default for manifest-less kits; the single-sourcing wording in canon + the kit
  `AGENTS.md` was updated to match.

## Status

Accepted (2026-07-05) — and **implemented the same day** (SPEC-cli-kit-manifest): the CLI reads the
kit's manifest at its two `templates/`-coupling points, replacing the hardcoded `KIT_OWNED_PREFIXES`
constant the Correction below quotes; per [ADR-0063](./0063-honesty-framework-and-tooling-boundary.md)
the mechanism is now _toolable_ and shipped — the CLI applies it where a manifest is present, and a
manifest-less kit keeps the built-in default. Resolves the CLI↔`templates/` coupling under
[ADR-0134](./0134-self-contained-spine.md); refines the single-sourcing rule (kit declares layout, CLI
discovers it). Honors [ADR-0117](./0117-no-count-bearing-prose.md).

> **Correction (2026-07-05, code-verified).** The Context above overstated the coupling. Verified
> against the CLI source, the hardcoded-`templates/` coupling is **only two points**: `applyUpdate`'s
> `KIT_OWNED_PREFIXES = ['templates/', '.agents/skills/', 'advanced/', 'hooks/']` (what `suspec update`
> refreshes) and `checkWorkspace`'s blocking `missing-template` finding (a workspace must have a
> `templates/` dir). `initWorkspace` copies the **whole** kit, so it is not path-coupled.
> `scaffoldSpec`/`scaffoldChangePlan` do **not** read `templates/<artifact>.md` — they **render the
> skeleton inline** (`render_spec`) mirroring the frozen format, so `suspec new` is coupled to the
> format (a separate duplication concern), not to the `templates/` path. The manifest decision stands;
> its implementation targets those two points. This correction is itself the examine-don't-ruminate
> rule ([ADR-0133](./0133-examine-dont-ruminate.md)) catching an unverified claim in this ADR's own
> Context.
