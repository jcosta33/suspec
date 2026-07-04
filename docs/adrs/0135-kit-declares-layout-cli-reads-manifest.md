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
2. **The CLI resolves every template path through the manifest**, never a literal `templates/` string:
   `init` copies what the manifest lists, `update` syncs against it, `new <artifact>` materializes from
   the manifest's path for that role, `check` validates presence via the manifest. A missing manifest is
   a clear error, never a silent assumption.
3. **Two homes, both manifest-declared.** The **shared loop artifacts** (spec/task/review/finding — the
   mandatory glue of ADR-0134) keep one canonical home the **kit** chooses; **skill-specific scaffolds**
   live in each skill's `references/` (already true for the `write-*` skills). The manifest can point at
   either, so the kit is free to place each where self-containment wants it.
4. **The manifest freezes only *where*, not *what*.** The artifact **formats** stay frozen in their own
   ADRs ([0058](./0058-two-tier-spec-format.md)/[0060](./0060-suspec-workspace.md)/0061/0067/0068); the
   manifest declares location. The single-sourcing rule is refined: *the kit declares its layout, the CLI
   discovers it* — the CLI never defines the layout. The drift-guard keys on the manifest.

## Consequences

- **CLI change (contract-adjacent, ADR-gated):** `initWorkspace`/`applyUpdate`/`scaffoldSpec`/
  `scaffoldChangePlan`/`checkWorkspace` resolve paths via the manifest. The CLI stays
  scaffold-additive/reconcile-only ([ADR-0085](./0085-suspec-mcp-adapts-the-json-contract.md)/0134) — it
  discovers and materializes, never dictates.
- **The kit is free to place templates per self-containment**; the CLI adapts. Resolves the ADR-0134
  inversion and the held #8 question.
- **Implementation is a follow-up engineering effort** (a family-workspace spec + tasks): add the
  manifest to the kit, refactor the CLI's five use-cases to read it, migrate the drift-guard to the
  manifest, and update the single-sourcing wording in canon + the kit `AGENTS.md`.

## Status

Accepted (2026-07-05) — the decision; **implementation pending** (not yet shipped, so the mechanism is
_toolable_ once the CLI lands it, not enforced today, per [ADR-0063](./0063-honesty-framework-and-tooling-boundary.md)).
Resolves the CLI↔`templates/` coupling under [ADR-0134](./0134-self-contained-spine.md); refines the
single-sourcing rule (kit declares layout, CLI discovers it). Honors
[ADR-0117](./0117-no-count-bearing-prose.md).
