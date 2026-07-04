---
type: adr
id: adr-0134
status: accepted
created: 2026-07-05
updated: 2026-07-05
---

# ADR-0134 — Suspec's self-contained spine: the mandatory triad, artifacts-are-the-glue, additive accelerators

## Context

Suspec's parts must compose into a working loop while each stays independently usable. The failure mode
to prevent: a **canonical step silently depending on an optional part** — a universal skill, the MCP, the
CLI, an agent catalog — so the loop breaks, or degrades unnoticed, when that part is not installed. The
framework ships many pieces (artifacts, templates, kit skills, CLI, MCP, agent catalog, universal
skills); what was never stated as an invariant is **which are the mandatory spine and which are additive
accelerators**, and that the spine must complete with none of the accelerators present.

## Decision

**The spine is the artifacts and their relationships; everything else is additive.** _Level: convention
(architectural)._

1. **The mandatory triad.** `spec → run → close` is the mandatory loop — a change is specified, run
   (implemented with evidence), and closed (reviewed-and-recorded). **`intake`, `task`, and `review` are
   optional steps** layered on when the work warrants them.

2. **Artifact relationships are not optional, even when the step is.** An optional step, once used,
   carries its mandatory dependency: a `task` depends on its `spec`; a `review` reconciles against its
   `spec`. **A review reconciles against the spec, never the task** — two optional steps must not depend
   on each other, or they stop being independently optional. Review coverage keys on the **spec's** ACs; a
   task, if present, is only an evidence source, never the review's target.

3. **Skills and tools are additive accelerators, never dependencies.** Every canonical step completes with
   the **artifacts + the assumed harness alone**. A universal/global skill, the MCP, the CLI, or the agent
   catalog MAY accelerate a step, but the step MUST have a self-contained path that needs none of them.
   **No canonical (kit) part may assume an optional part exists** — no kit skill references or depends on a
   universal skill (`revolver-review`, `fix-flaky-test`, …), on the MCP, or on another skill. A kit skill
   that punts a case to an optional global skill is a **defect** to close.

4. **Automated checks are early-warning, never a replacement.** The CLI and MCP surface fast, cheap
   signals (a lint, a reconcile). A green automated check **never** substitutes for the manual/agent pass:
   if `suspec check` passes, an agent or human still validates the work — the check is an early-warning
   layer, additive to the real review, not a stand-in for it. This applies to **every** QOL/tooling
   addition ([ADR-0085](./0085-suspec-mcp-adapts-the-json-contract.md)'s reconcile-only posture is the CLI
   case of this rule).

5. **The assumed floor is a capable agent harness (≈ Claude Code / Codex).** It can spawn a subagent,
   read and write files, and run commands. Capabilities the floor provides are **not** "optional parts":
   the independence invariant (reviewer ≠ implementer, [ADR-0119](./0119-independent-review-invariant.md))
   is satisfied by **spawning a fresh subagent to review** — a harness capability, not an installed
   catalog. The `suspec-reviewer` agent / `suspec-agents` catalog is an accelerator over that path, never
   the only way to get independence.

## Consequences

- Kit skills carry their own method, reference **no** sibling skill and **no** universal skill; the
  skill-to-skill links and the optional-global-skill punts (e.g. `write-fix`/`write-testing` → the global
  `fix-flaky-test`) are removed.
- The review skill reconciles against the **spec**, states the **spawn-a-fresh-subagent** independence
  path, and names no universal skill (no `revolver-review` mention in the canonical review).
- The CLI, MCP, agent catalog, and universal skills are each documented as **additive accelerators with a
  by-hand fallback**.
- The kit `AGENTS.md` floor states the harness-capability assumption alongside the examine-don't-ruminate
  norm ([ADR-0133](./0133-examine-dont-ruminate.md)).
- **Open (governed by this ADR, decided separately):** where the *method* lives vs the *shared loop
  artifacts*. The loop artifacts (`spec`/`task`/`review`/`finding`) are the mandatory glue — the interface
  between skills — and stay single-sourced; the **method** is the skill's own (body + `references/`). The
  naive "move `templates/` into a skill's `references/`" is rejected: `templates/` is referenced by canon
  ADRs, the single-sourcing rule, and the CLI (`init`/`update`/`check`), and the artifacts are shared
  glue, not one skill's scaffold.

## Status

Accepted (2026-07-05). Names the architectural spine implicit across
[ADR-0057](./0057-practical-first-repositioning.md)/[ADR-0060](./0060-suspec-workspace.md)/[ADR-0075](./0075-starter-kit-template-repo.md)/[ADR-0085](./0085-suspec-mcp-adapts-the-json-contract.md)/[ADR-0112](./0112-two-tier-skills.md).
Honors [ADR-0063](./0063-honesty-framework-and-tooling-boundary.md)/[ADR-0117](./0117-no-count-bearing-prose.md);
relates [ADR-0119](./0119-independent-review-invariant.md)/[ADR-0085](./0085-suspec-mcp-adapts-the-json-contract.md)/[ADR-0133](./0133-examine-dont-ruminate.md).
