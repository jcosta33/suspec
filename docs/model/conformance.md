# Conformance

> Authoritative source: `.agents/specs/swarm/06-artifacts.md` §20.4 (the conformance definition) and `.agents/specs/swarm/09-conformance-and-rework.md` §32 (the conformance contract / manifest) and §32.8 (the maturity ladder). This is a reference projection; where it and the spec disagree, the spec governs.

Swarm is markdown-only and has **no runtime**. Nothing in this page executes. The "checker" that would consume a conformance manifest is a *contract* a future Swarm toolchain would build against — it is never shipped here. Until such a launcher exists, the same contract still serves: a human validates a repository against it by hand, and the golden corpus pins the expected verdicts independently of any tool.

This page answers two questions: *what makes a repository Swarm-conformant?* (a single binary predicate) and *how far along the adoption path is a repository?* (a five-tier ladder of diagnostic labels). The manifest is the inert, versioned data that encodes the mechanically checkable parts of the definition.

## The conformance definition

A repository is **Swarm-conformant if and only if** all four clauses hold (§20.4, restated in §32.2). Omit any one and the repository MUST NOT be described as Swarm-conformant.

| # | Clause | Checkable evidence |
|---|---|---|
| (a) | **Language references present** | A self-contained copy of all six Tier-2 language/reference docs exists: the SOL reference, the APS reference, the lint/error taxonomy (the `SOL-<LAYER>NNN` catalogue), source-authority, the promotion protocol, and the distillation-loss-budget. |
| (b) | **The seven core templates exist** | A copyable template is present for each of the seven Tier-1 core artifacts — `spec.swarm.md`, `task.md`, `trace.md`, `review.md`, `finding.md`, `adr.md`, `memory/INDEX.md` — and each template satisfies its §21 contract. |
| (c) | **Populated `AGENTS.md` bootloader** | `AGENTS.md` exists (not an empty placeholder), stays within the density cap of ≤200 lines / ≤25 KB, and its `Commands` table binds at least the required command rows. |
| (d) | **Version file present** | The framework/package version file exists with a valid semver — `scaffold/.agents/.swarm-version` in the framework-dev repo, or `.swarm/VERSION` in an adopted project. |

A repository that fails any clause is **non-conformant**. Conditional artifacts (Tier 3 stdlib source-doc templates) and the reserved `.swarm.*.json` contract files are **not** required for conformance. Clauses (b)–(d) are the parts a manifest can mechanically encode; clause (a) is presence of the reference docs.

## The conformance contract (the manifest)

A Swarm repository ships a machine-readable conformance encoding under `scaffold/.agents/conformance/`. It is **inert versioned data**: the precise, testable definition a future checker would honour, and the artifact a human uses to validate a repository by hand today. Per the no-runtime invariant, nothing under this directory executes — Swarm ships the contract, never the checker.

The conformance directory contains exactly three things:

| Path | Kind | Role |
|---|---|---|
| `scaffold/.agents/conformance/conformance.yaml` | manifest (data) | the task-file schema, command rows, placeholder set, lint scheme, and required-suite matrix |
| `scaffold/.agents/conformance/README.md` | prose | states inertness, provenance, and the "checker is deferred" framing |
| `scaffold/.agents/conformance/fixtures/` | fixture suite | the golden corpus |

*Design rationale.* That a contract is publishable and useful without a shipped tool follows the SARIF precedent — an OASIS JSON-schema interchange contract that is independent of any analyzer that consumes it `[SARIF]`. The conformance contract is, by the same logic, a framework artifact in its own right.

The manifest declares the `language` discriminator it targets (e.g. `SOL/0.1`) so a checker and the corpus reference one versioned definition. Its load-bearing sections are below.

### Task-file schema

The manifest encodes, as inert data, the structural and content rules a well-formed `task.md` satisfies, keyed to the §21 `task.md` template:

- **Required sections** — the H2 headings that MUST be present: *Parent contract*, *Scope*, *Assigned obligations*, *Constraints and invariants*, *Implementation or pass trace*, *Verification matrix*, *Promotion queue*, *Self-review*.
- **Content rules** — chiefly:
  - `non-empty-paste` (on the *Verification matrix*): every required paste slot holds non-empty, non-placeholder text — a fenced command-output block, or `n/a` with a one-line reason — never a bare `[Paste output]` placeholder.
  - `no-open-critical`: no blocking `QUESTION` remains unresolved anywhere in the task when its frontmatter status is the terminal value `done`.

`non-empty-paste` is the single most load-bearing rule: it closes the hallucinated-completion hole, since a "tests passed" claim with no pasted output is an invalid proof — schema-valid output is not verification.

### Required command rows

`<adapter>` slots in SOL `VERIFY BY` bindings resolve through the `AGENTS.md > Commands` table; a binding whose adapter has no row is unresolvable. The manifest enumerates three tiers of `cmd*` slots:

| Tier | Slots | Conformance force |
|---|---|---|
| **required** | `cmdValidate`, `cmdTest`, `cmdFormat` | MUST be present; absence is non-conformant. These are the slots `VERIFY BY` adapters MUST be able to resolve. |
| **extended** | `cmdInstall`, `cmdTypecheck`, `cmdLint`, `cmdBuild`, `cmdValidateDeps`, `cmdBenchmark` | SHOULD be present when the project's required-suite references them, because an unbound adapter makes the suite unresolvable. |
| **out-of-contract** | `cmdMarkdownLint`, `cmdLinkCheck`, `cmdCitationCheck` | MAY be present; never required. |

### Legal placeholder set

Templates use placeholder tokens (e.g. `{{cmdTest}}`) that a runner substitutes. The manifest fixes the legal namespaces; a runner substitutes every required placeholder and leaves unrecognised ones untouched.

| Namespace | Example | Status |
|---|---|---|
| `cmd*` | `{{cmdValidate}}` | reserved; resolves to an `AGENTS.md > Commands` row; new `cmd*` names require an ADR |
| `""` (no prefix) | `{{title}}` | framework scaffolding names; reserved as above |
| `swarm:` | `{{swarm:version}}` | framework-owned values |
| `project:` | `{{project:name}}` | consumer-owned values; free to define |
| `vendor:` (any other prefix) | `{{vendor:frobnicate}}` | legal vendor extension; a runner leaves it untouched |

Introducing a new `cmd*` or no-prefix name without an ADR is non-conformant (the illegal-placeholder defect class).

### Lint scheme and required-suite matrix

The manifest carries the unified lint scheme as inert data so the checker and the corpus reference one namespace: a single prefix `SOL`, **five layers**, and the form `SOL-<LAYER>NNN`. Every diagnostic record has the shape `{code, severity, layer, span, message, suggest}`.

| Layer letter | Layer |
|---|---|
| `S` | SYNTAX |
| `P` | PROSE |
| `M` | SEMANTIC |
| `V` | VERIFICATION |
| `O` | ORCHESTRATION |

`APS` is the prose-standard's *name*, not a code prefix — the `APS-` prefix is retired, and APS violations surface as `SOL-P*` codes. The full catalogue is the source of truth; the manifest only references it.

The manifest also encodes the per-task-type **required verification suite** (the proof-type/phase defaults that resolve to `cmd*` slots). Bare entries are `cmd*` adapter slots resolved through `AGENTS.md > Commands`; a `merged:` prefix means the slot runs on the post-integration merged result; and `gate:<name>` entries are equivalence/coverage gates:

- `acceptance-criteria-coverage` — every acceptance criterion of the obligation maps to a passing proof.
- `regression-test` — a test that failed before the change and passes after.
- `behaviour-preservation` — a property / differential / metamorphic check that the change preserves prior behaviour.
- `scope-disjointness` — the merged workers' OWNED paths are pairwise disjoint.
- `merge-intent` — each merge-conflict resolution preserves both obligations' intent.

The canonical matrix is the human-readable companion (`docs/reference/flow-graph.md`); the manifest is its machine-readable shadow with one row per task kind (e.g. `feature`, `fix`, `refactor`, `orchestration`).

## The conformance maturity ladder

The definition above is a single *binary* predicate — the terminal judgement. But a repository adopting Swarm passes through observable intermediate states, and because adoption MAY be incremental, the spec needs a vocabulary for "how far in" a repository is *without overloading the word conformant*. §32.8 gives a **five-tier ladder**. Each tier is named, each is bound to checkable clauses already specified elsewhere (the ladder introduces **no new obligations**), and each is a strict superset of the tier below it — a repository at tier *n* satisfies tiers `1..n`. The tiers are diagnostic labels for adoption progress; the only tier that coincides with the normative `Swarm-conformant` predicate is tier 4, **Swarm-verifiable**.

| Tier | Name | What it means | Bound to |
|---|---|---|---|
| **1** | **Swarm-readable** | The canonical structure is installed: a human or agent can read the repository as a Swarm repository. Nothing is yet checked for correctness. | Conformance clauses (a) and (b) hold — the six Tier-2 docs and seven Tier-1 templates are present and copyable. Clauses (c)/(d) MAY still be unmet. |
| **2** | **Swarm-lintable** | Authored specs are structurally and prose-valid: the obligation language parses and carries no blocking surface/prose defect. | Every approved `*.swarm.md` emits **zero blocking `SOL-S*` and zero blocking `SOL-P*`** diagnostics (blocking = the `severity` field's `BLOCKING` value, which lowers to IR `level` `error`). `SOL-M*`/`SOL-V*`/`SOL-O*` are not gated here. |
| **3** | **Swarm-compilable** | Approved specs can be lowered into tasks deterministically: every lowering precondition is present. | For every approved obligation: a stable ID, a proof binding (`VERIFY BY <type>:<adapter>:<artifact>` — a bare ref is advisory but a binding MUST exist), declared non-goals/scope, resolvable referenced `INTERFACE` blocks, and resolvable `DEPENDS ON` edges; and **no unresolved blocking `QUESTION` reaches lowering**. This is exactly the `lower`/`decompose` precondition set. |
| **4** | **Swarm-verifiable** | For implemented work, trace and review are complete and every completion claim is tied to evidence. | `trace.md` and `review.md` exist for the implemented obligations; each `IMPLEMENTS`/`PRESERVES`/`PROOF` claim carries content-hashed evidence and a core verdict; every completion claim binds to pasted proof output, never a bare "tests passed" claim (the `non-empty-paste` rule). |
| **5** | **Swarm-orchestratable** | Work can be partitioned across agents and sequenced safely: the static coordination contract is complete. | The §18/§19 contract is fully satisfied: declared write surfaces (named `SURFACE`s — there is no `locks` primitive) with the safe-parallelism predicate holding (no `SOL-O001`), obligation IDs preserved across the source→execution tiers, the coordination hand-off fields (owned/forbidden paths, status, parent contract), liveness/stall states, and the promotion queue. |

**Tier 4 is the normative line.** A repository is *Swarm-verifiable if and only if it is Swarm-conformant* — tier 4 is exactly the §20.4 / §32.2 definition. Tiers 1–3 below it and tier 5 above it are adoption labels, not the conformance predicate.

A repository MAY sit at any tier. Because adoption is incremental, tiers 3–5 are optional adoption *depth*, not a defect when unmet. When reporting a repository's standing, a tool or human SHOULD report the **highest fully-satisfied tier**, and MUST NOT report a higher tier than is fully satisfied — a partially satisfied tier is, within that tier, non-conformant. Per the no-runtime invariant, tier 5 certifies the *contract*, not a live scheduler; the scheduler is a deferred launcher concern.

## Preserved / Dropped / Still-uncertain

**Preserved (this projection keeps):** the four-clause if-and-only-if conformance definition; the exact three-file conformance directory; the manifest's task-file schema (required sections + the two named content rules), the three command-row tiers with their exact slots, the five placeholder namespaces, the five-letter lint scheme (S/P/M/V/O) and the five named gate tokens; and the full five-tier maturity ladder with each tier's binding and the tier-4 = conformance identity.

**Dropped (left to the spec):** the verbatim `conformance.yaml` YAML excerpts (this is prose); the full §32.7 deferred CLI verb set and the toolchain↔agent-CLI ownership boundary (the adapter contract, the OWNS/does-NOT-own lists) — adjacent in §32 but outside the named conformance-definition / manifest / ladder scope; the golden corpus contents (§33); the per-task-kind full required-suite matrix beyond illustrative rows; the §34.7 reporting rule's exact cross-references; and the design-rationale grounding for the orchestrator/worker split.

**Still-uncertain (the spec governs):** the spec marks the future checker, the CLI surface, and the scheduler as deferred (a contract, never shipped); this page reflects that deferral but does not resolve it. Section numbers cited here (e.g. §18/§19, §21, §23, §33, §34.7, §35.1) are the spec's own forward references and are authoritative there, not re-derived here.
