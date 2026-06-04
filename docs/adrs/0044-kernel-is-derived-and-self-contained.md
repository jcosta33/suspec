---
type: adr
id: 0044-kernel-is-derived-and-self-contained
status: accepted
created: 2026-06-04
updated: 2026-06-04
supersedes:
superseded_by:
---

# ADR-0044: The kernel is a derived, self-contained payload — `docs/` is canonical for the language/passes twins

## Context

`docs/language/` ↔ `kernel/.agents/language/` and `docs/passes/` ↔ `kernel/.agents/passes/` are
maintained as **duplicate copies** (the rule recorded in this repo's `AGENTS.md`). In practice they
are *divergent re-renderings*: a 13-file-pair analysis (recorded in
[`.agents/installable-kernel-plan.md`](../../.agents/installable-kernel-plan.md) and its discovery
pass) found that neither side is uniformly more current — the kernel is ahead on some pairs
(`errors.md` carries a ~95-line legacy-code translation table absent from `docs/`; `lint.md` carries
the `APS-`-prefix-retirement facts; `promote.md`/`improve.md` carry the self-standing clause and an
author-judgment section) while `docs/` is ahead on others (`decompose.md` is the only fully
de-sectioned pass file and carries ~140 lines of normative scope-vocabulary the kernel lost; `SOL.md`
carries a `CONSTRAINT WHERE`-clause the kernel regressed). The hand-maintained twin is the recurring
**"fix one copy, miss the twin"** defect.

The same analysis surfaced a **larger, latent defect the twins were hiding: the shipped kernel is not
actually self-contained.** An adopter installs `kernel/.agents/` into `.swarm/kernel/` and receives
**no `docs/`** and **no §-numbered monolith** — yet the kernel files carry **614 `§N` references and 9
`Appendix-X` references** that resolve only against the frozen, never-shipped build source
(`.agents/specs/swarm/`), including in the **always-loaded `kernel/AGENTS.md`** (`§14`/`§17`/`§20.5`/…)
and in `conformance.yaml` (`§21`/`§25`/`§32`/`§33`, plus `catalogue_ref: docs/language/errors.md`
pointing at a path the adopter never gets). Several kernel files also still carry **migration framing**
the de-pivot forbids ("the earlier 4-value enum is upgraded", "merges legacy Bind+Trace", "two competing
payloads are reconciled").

This ADR decides the steady-state shape of that payload. (The *execution* — the one-time reconciling
merge, the §-rewrite, and the bug fixes the analysis catalogued — is the K2 work item, run pair-by-pair
under this decision.)

## Decision

1. **`docs/` is the single canonical source** for the `docs/language/` ↔ `kernel/.agents/language/`
   and `docs/passes/` ↔ `kernel/.agents/passes/` twins. `kernel/.agents/language/` and
   `kernel/.agents/passes/` are **derived, checked copies** — established after a **one-time reconciling
   merge** that pulls every kernel-only load-bearing fact *up* into `docs/` and fixes `docs/`'s own gaps,
   so the canonical `docs/` corner is a true superset of load-bearing content. This **refines**
   [0040](./0040-kernel-payload-directory.md) and relates to [0042](./0042-skill-carrier-and-standalone-conditioning.md)/[0016](./0016-skills-are-self-contained.md) (thin skills cite-don't-define) and [0041](./0041-two-axis-versioning.md).

2. **The kernel is self-contained and MUST resolve offline** for an adopter who receives no `docs/`.
   Therefore the kernel MUST NOT cite `§N`/`Appendix-X` anchors from any document it does not ship,
   MUST NOT link into the docs-only trees (`model/`, `reference/`, `artifacts/`, `research/`,
   `PRINCIPLES.md`, `library/`, `grammar.md`), and `conformance.yaml`/`AGENTS.md` MUST NOT reference
   `docs/` paths. Deriving the kernel *from* `docs/` does **not** make `docs/` defer to the kernel — the
   kernel is a payload, not a peer; `docs/` remains self-standing.

3. **`grammar.md` stays docs-only** (not a fourth twin): no kernel file references it, and the kernel
   `SOL.md` already carries its own inline EBNF. (The docs-internal EBNF triplication — `grammar.md`
   vs `SOL.md` fragments — is a separate docs-layer item, not part of this twin decision.)

4. **The derivation transform (§A) and the equality-modulo-render check (§B) are recorded verbatim
   below** and are **NO-RUNTIME**: the "build" is an agent (or future tool) copying the canonical
   `docs/` file and applying fixed rewrite rules; the "check" is a diff. Neither is shipped code.

5. **The §-resolution policy (§C)** eliminates cross-document `§N`/`Appendix-X` from **both** twins:
   rewrite each to a relative link to the shipping file that owns the content, or inline the small fact;
   the only legitimate surviving §-numbering is `versioning.md`'s own local `§1`–`§4` headings (anchors
   defined where referenced).

6. **A coherence gate is added** (alongside the existing closed-set count reconciliation against
   `docs/reference/flow-graph.md`): a build FAILs if any shipped file contains a `§N`/`Appendix-X` token
   not defined as a heading within its own shipped tree, and FAILs if a twin diff carries a difference
   unattributable to a recorded transform rule.

7. **Execution discipline:** the merge runs **pair-by-pair** (the merge direction differs per pair —
   `decompose.md` regenerates the kernel *from* docs; `errors.md`/`lint.md`/`promote.md` merge kernel→docs),
   running the equality check **after each pair**. Never a single bulk copy — that would destroy the
   more-current side. `conformance.yaml` and `kernel/AGENTS.md` (always-loaded entry points) are fixed
   **first**.

### §A — The derivation transform (canonical `docs/` → kernel rendering)

- **LINK-1 (research citations):** strip every inline `[[KEY]](../research/sources.md#KEY)` suffix; keep
  the prose claim verbatim. The kernel ships no `research/` corner.
- **LINK-2 (same-dir language links):** docs `[SOL](SOL.md)` → kernel backtick `` `./SOL.md` `` (drop the
  label, `./` prefix), and likewise `APS.md`/`errors.md`/`versioning.md`.
- **LINK-3 (cross-dir sibling links):** docs `[lint](../passes/lint.md)` (or `[lint](lint.md)` within
  `passes/`) → kernel backtick `` `../passes/lint.md` ``.
- **LINK-4 (docs-only-tree links — the one non-mechanical rule; a FIXED lookup table):** links into
  `model/`, `reference/`, `artifacts/`, `PRINCIPLES.md`, `library/`, `research/`, `grammar.md` have no
  kernel twin and are re-homed, never emitted dangling:
  `../reference/proof-types.md` → fold into `../passes/verify.md` (the nine proof types);
  `../reference/promotion-protocol.md` → `../passes/promote.md`;
  `../model/source-authority.md` → inline the gloss "approved spec/ADR > task > chat";
  `../model/compiler-pipeline.md`, `../model/conformance.md` → drop (prose survives);
  `../artifacts/spec.md` → `../templates/spec.swarm.md`; `../artifacts/review.md` → `../templates/review.md`;
  `../artifacts/trace.md` → `../templates/trace.md`; `../artifacts/task.md` → `../templates/task.md`;
  `../language/grammar.md` → fold into the `./SOL.md` Related bullet.
- **LINK-5 (kernel-only payload links):** the kernel gains links docs cannot carry (docs has no
  `skills/`/`templates/` tree): `../skills/<name>/SKILL.md` (pass guides, `persona-*` carriers, the
  `empirical-proof`/`distillation-discipline` fragments) and `../templates/*`. The canonical `docs/`
  MUST *name* these referents in prose (e.g. "served by the empirical-proof fragment") so the renderer
  attaches the path from a fixed name→path map.
- **PROSE-1 (audience noun):** docs "This page" → kernel "This file"; docs "the reference" → kernel "the
  working contract".
- **PROSE-2 (leading abstract):** the canonical carries a `>` blockquote abstract under the H1; the
  kernel rendering emits it as a plain lead paragraph (fixed per-surface rule).
- **PROSE-3 (self-standing clause):** the kernel lead appends "self-standing — the authority for this
  pass lives here".
- **SECTION-1 (§-refs):** because the canonical `docs/` is de-sectioned first (§C), the derivation is
  identity on §-refs. `versioning.md`'s local `§1`–`§4` are preserved on both sides.
- **TABLE-1 (closed-set subset render):** where the kernel shows a curated subset of a canonical
  closed-set table (e.g. `verify.md` shows 7 of the 17 `task_kind` rows), it is a **fixed, named subset**
  drawn from the canonical full table — never a hand-maintained second table. The subset row-keys are
  recorded in the renderer note.
- **STRUCTURE-1 (depth pruning):** where the kernel legitimately omits whole docs-only-depth sections
  (e.g. `verify.md`'s design-rationale / soft-vs-hard / enforcement-lane sections, carried by other
  kernel passes/`PRINCIPLES`), the renderer drops a **fixed, named** set of headings — never an ad-hoc
  omission. The pruned-section list per file is recorded.

### §B — The equality-modulo-render check (manual runbook; NO shipped code)

Run at K2 and on every twin edit thereafter. (1) From the canonical `docs/` file, mechanically apply
§A to produce an EXPECTED kernel rendering in a scratch buffer. (2) Diff the EXPECTED rendering against
the actual kernel twin. (3) PASS iff every residual difference maps to a recorded §A rule.
**COMPARES (must match after transform):** every normative sentence; every table cell (taxonomy,
present `task_kind` subset rows, op/verdict tables); every code name (the closed sets); every EBNF
production; the prose adjacent to any stripped citation. **IGNORES (the "modulo"):** citation suffixes;
link rendering and the LINK-4 re-homes; the PROSE-1 audience nouns; the PROSE-2 carrier; the named
STRUCTURE-1 pruned sections and TABLE-1 non-subset rows; `versioning.md`'s local §-numbering.
**GUARD:** `diff` produced a *false* "identical" on `APS.md`/`versioning.md` under the local proxy, so
the check MUST corroborate with `cmp -s` + an md5/sha comparison of the rendered-vs-actual buffers —
never trust a single `diff` "identical".

### §C — §-resolution policy

The kernel is the product and MUST NOT cite `§N`/`Appendix-X` from a document it does not ship. Rewrite
each cross-document reference, in leverage order: (1) fix `conformance.yaml` and `kernel/AGENTS.md`
first; (2) repoint to the shipping twin that owns the content (`§8`/Appendix B → `../language/errors.md`;
proof types → `../passes/verify.md`; the IR schema → `../passes/lower.md`, and **ship the cited-as-normative
IR JSON Schema into the kernel or demote it from "governing" to descriptive**); (3) for a heading's own
back-reference label like "## The COVERAGE gate (§11.6.2)", drop the trailing `(§N)`; (4) inline small
load-bearing facts (the pattern already used for the 5 modals / 9 proof types / 7 verdicts). Preserve
`versioning.md`'s legitimate local §-headings verbatim.

## Alternatives considered

| Alternative | Why rejected |
| --- | --- |
| **Kernel canonical, `docs/` rendered from it** | The reverse transform is lossy/ambiguous (you would have to *add* citations, §-context, and the docs-only-depth sections); and `docs/` is the rich human corner that carries the `[[KEY]]` research citations, which must stay there. |
| **Hybrid steady-state (different canonical side per pair)** | Multiplies the rules a human/agent must remember and reintroduces the exact "which copy is truth" confusion the effort exists to kill. (The *one-time* K2 merge is per-pair by necessity, but the steady state is single-direction.) |
| **Keep hand-maintained twins** | The status quo — the recurring "fix one, miss the twin" defect, plus it left the self-containment defect undetected. |
| **Vendor `docs/` into the adopter so the kernel can link it** | Re-bloats the install with the human tutorial layer the minimality evidence (ADR-0043) warns against, and defeats the operational-payload-vs-upstream-reference split. |
| **Add `grammar.md` as a fourth twin** | No kernel file needs it; the kernel `SOL.md` already carries its own EBNF — adding it would *create* a new twin defect. |

## Consequences

### Positive

- One canonical home per body of content; the twin becomes a **checked invariant**, not a silent-drift
  hazard. The "fix one, miss the twin" defect class is closed.
- The shipped kernel becomes **genuinely self-contained** — it resolves offline for an adopter, fixing a
  latent defect (614 dangling refs) the twins were hiding.
- The de-pivot and several real bugs (the `SOL` `WHERE`-clause regression, the dropped `review.md`
  `## Claimed coverage` row, the `improve.md` Skeptic-excludes-improve contradiction, the lost
  `lower.md` plan-before-execute sentence, the `decompose.md` content loss) are corrected as part of the
  reconciliation rather than persisting in shipped content.

### Negative

- The one-time K2 reconciliation is **large and high-risk** (shipped normative content across 13 pairs +
  a 614-reference §-rewrite + `conformance.yaml`/`AGENTS.md`); it must run pair-by-pair with the equality
  check after each, never bulk.
- The derivation transform is mostly mechanical but has **one non-mechanical rule** (the LINK-4 re-home
  table), which must be maintained by hand as the docs-only tree evolves.

### Neutral / tradeoffs

- No canonical closed set changes (7 block types · 5 modals · 7 verdicts · 9 proof types · 7 phases ·
  9 passes · 10 improve ops · 5 lint layers · 7 edge types · 17 `task_kind`); the merge keeps the full
  set canonical in `docs/` and renders subsets deterministically.
- Until a future tool exists, the derivation and the check are **agent-run procedures** (Invariant 1,
  NO RUNTIME) — the contract a launcher will later automate without changing its semantics.

## Status

Accepted (v0.1). Execution is the K2 work item (the one-time reconciling merge + §-rewrite), run under
§§A–C and the execution discipline above.

## Affected obligations / constraints

- Adds: the canonical-direction rule (`docs/` canonical, kernel derived); the kernel self-containment
  invariant (no unshipped `§N`/`Appendix-X`, no docs-only-tree links, no `docs/` paths in
  `conformance.yaml`/`AGENTS.md`); the derivation transform (§A); the equality-modulo-render check (§B);
  the §-resolution policy (§C); the new coherence gate.
- Modifies: the `AGENTS.md` "docs↔kernel are duplicate copies, propagate by hand" rule → "`docs/` is
  canonical; the kernel is derived and checked".
- Refines: [0040](./0040-kernel-payload-directory.md). Relates to [0042](./0042-skill-carrier-and-standalone-conditioning.md), [0016](./0016-skills-are-self-contained.md), [0041](./0041-two-axis-versioning.md), [0034](./0034-unified-lint-namespace.md).
- Does NOT change: any canonical closed set, the obligation grammar's meaning, or the artifact set.
