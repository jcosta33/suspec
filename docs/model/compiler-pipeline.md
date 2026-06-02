# The Compiler Pipeline

> Authoritative source: Swarm Kernel Specification Part 03 (`.agents/specs/swarm/03-compiler-pipeline.md`), §9 (phases & passes), §10 (the improve operation set), §11 (lowering & decomposition), §13 (the plan). This is a reference projection; where it and the spec disagree, the spec governs.

Swarm models the journey from a human-authored specification to a promoted, verified change as a **compiler pipeline**. Nothing here is shipped code: there is no runtime that runs these passes (Invariant 1). Every pass, gate, and emitter named below is a **contract** — checkable today by a human or agent following a written pass guide, and enforced by a future tool. A conformant repository MUST frame any emitted artifact (IR, plan) as "the contract a future tool emits," never as the output of shipped tooling.

This document is a shorter reference view over the spec sections above. It keeps the counts, the closed sets, and the normative rules exact; it leaves long-form rationale, the full IR schema (§12), and the formal JSON Schemas (Appendices) to the spec.

---

## 1. Two levels: phases and passes

The pipeline is described at **two levels of granularity that MUST NOT be conflated** (§9):

- A **phase** is a *conceptual compiler stage*. The seven phases are a fixed-order taxonomy naming *where in the pipeline* a piece of work sits. Phases are descriptive grouping, **not schedulable units**.
- A **pass** is a *schedulable transformation*. The nine passes are the concrete units of work an author, agent, or future tool actually runs; each consumes one or more artifacts and produces one or more artifacts.

Several passes MAY map to one phase (both `lower` and `decompose` sit in `LOWER`). No pass spans two phases except `lint`, which the mapping table assigns to two (`PARSE` + `NORMALIZE`) because it is partly well-formedness detection and partly normalization of detected smells.

> Design rationale (§9): compiler theory distinguishes phase (a stage) from pass (a traversal). Swarm inverts the common case so the small fixed phase taxonomy is the stable conceptual spine and the larger pass set is the schedulable surface.

### 1.1 The seven phases (fixed order)

A conformant description MUST present them in exactly this order and MUST NOT add, remove, or reorder them in v0.1 (§9.1):

```text
PARSE -> NORMALIZE -> LOWER -> EXECUTE -> VERIFY -> REVIEW -> PROMOTE
```

| Phase | What the phase establishes | Nature |
| --- | --- | --- |
| `PARSE` | Surface SOL is recognized; blocks, ids, clauses, modals identified; well-formedness (`SOL-S###`) decided. | Deterministic |
| `NORMALIZE` | The recognized spec is brought into canonical, smell-free, semantics-preserving form. | Deterministic + heuristic |
| `LOWER` | The normalized spec becomes the IR obligation graph and is partitioned into task-sized work packets. | Mostly deterministic |
| `EXECUTE` | Code, docs, and tests are produced against the lowered work packets. | Heuristic |
| `VERIFY` | Each bound proof is run; each obligation receives a core verdict. | Deterministic |
| `REVIEW` | Trace claims judged against obligations, diffs, evidence; lifecycle decorators applied; merge gate computed. | Hybrid |
| `PROMOTE` | Durable discoveries become findings, ADRs, memory, or spec amendments. | Hybrid but routable |

### 1.2 The nine passes (pipeline order)

```text
author -> lint -> improve -> lower -> decompose -> implement -> verify -> review -> promote
```

This is the default sequencing. A launcher MAY interleave passes across multiple specs, but **for a single obligation the partial order MUST be respected** — an obligation cannot be `verify`-ed before it is `implement`-ed, nor `implement`-ed before `lower`-ed (§9.2). There is no runtime: each pass is a contract performed today by a human or agent following a pass guide.

### 1.3 Pass-to-phase mapping (normative)

| Pass | Phase(s) | Input → Output | What it does | Lint layer touched (§8) |
| --- | --- | --- | --- | --- |
| `author` | entry (pre-`PARSE`) | chat / `research.md` / `audit.md` / `bug-report.md` / prior spec → `spec.swarm.md` draft | Captures human intent as SOL obligations + APS prose. | — (produces input to lint) |
| `lint` | `PARSE` + `NORMALIZE` | `spec.swarm.md` → lint report + blocking status | Detects defects **without changing semantics**; decides well-formedness, surfaces smells. | S / P / M / V / O |
| `improve` | `NORMALIZE` | spec + lint report → normalized spec + improvement report | Applies the closed 10-operation set (§2), strictly semantics-preserving. | answers the codes mapped in §2 |
| `lower` | `LOWER` | approved spec → `*.swarm.ir.json` | Assigns IR node ids, builds typed edges, normalizes `verify_by`, emits the two derived graphs. | `SOL-O###` |
| `decompose` | `LOWER` | `*.swarm.ir.json` → `task.md` packets (+ `*.swarm.plan.json`) | Partitions the graph into write-disjoint work packets. | `SOL-O###` (e.g. `SOL-O005`) |
| `implement` | `EXECUTE` | `task.md` → code/docs/tests + `trace.md` | Produces the change for assigned obligations only; records TRACE claims, gathers evidence. | — (claims feed verify/review) |
| `verify` | `VERIFY` | `trace.md` + bound proofs + `AGENTS.md > Commands` → per-obligation core verdict | Runs each `VERIFY BY` binding through its resolved adapter; one verdict per binding. | `SOL-V###` |
| `review` | `REVIEW` | spec + `trace.md` + diff + evidence → `review.md` | Judges claims; applies lifecycle decorators; computes the merge gate. | `SOL-M###`, `SOL-V###` |
| `promote` | `PROMOTE` | discoveries + `trace.md` + `review.md` + source authority → `finding.md` / `adr.md` / amendment / memory update | Moves durable discoveries into provenance-anchored artifacts. | — (routes through source authority §22) |

**Pass contract notes (§9.3.1):**

- `author` precedes `PARSE`: its output is the first compiler-visible artifact and is not itself analyzable.
- `lint` is **non-mutating** — diagnostics only. The **only** pass permitted to rewrite the spec is `improve`, and only semantics-preservingly.
- `improve` runs **only after** `lint`; with no lint findings to answer it is a no-op.
- `lower` requires an **approved, lint-clean** spec. An unresolved BLOCKING diagnostic or a blocking `QUESTION` MUST NOT be lowered (see §3.4).
- `decompose` consumes the **IR**, not the surface spec, so packet boundaries come from the typed graph.
- `verify` is the **only profile-independent pass** — deterministic evidence-gathering; no heuristic profile (§27) alters whether a run `PASS`-es.

### 1.4 The five stdlib pass guides

A **pass guide** is a lazily-loaded procedural document (a "skill" in legacy vocabulary). Pass guides are SOFT control (Invariant 2): they MUST NOT define SOL/APS semantics, modality, authority order, or verification meaning — those live only in SOL and the IR. Of the nine passes, **exactly five** ship with a stdlib pass guide in v0.1 (§9.4): `lint`, `decompose`, `implement`, `review[profile: skeptic]`, and `promote`. The remaining four (`author`, `improve`, `lower`, `verify`) are fully specified by the spec and MAY gain guides in a later framework release with no language-version change. (Naming note: the legacy `adversarial-review` skill is not its own guide — it is `review[profile: skeptic]`.)

---

## 2. The improve operation set (§10)

`improve` is the `NORMALIZE`-phase pass that rewrites a spec to satisfy SOL and APS. It is a **closed set of exactly ten operations** — a conformant pass MUST NOT invent operations outside it, and "improve the spec" with no named operation is not a valid request.

```text
NORMALIZE  ATOMIZE  CONCRETIZE  QUANTIFY  BIND  SCOPE  CLARIFY  DECONFLICT  COMPRESS  PROMOTE
```

### 2.1 The hard rule: improve is semantics-preserving

> **R-IMPROVE.** Every improve operation MUST be strictly semantics-preserving. It MUST NOT add, remove, weaken, strengthen, or otherwise change the **intent** of any obligation. Any intent change — a new requirement, a relaxed constraint, a different actor, a changed trigger or response — MUST route to **amendment/review**, never to `improve`.

Two corollaries (§10.1):

- The improvement report MUST carry a *Semantic changes* row, flagged `requires approval: yes`, for any edit the author is unsure preserves intent; such edits belong to amendment, not `improve`.
- **R-DECOMPOSE-NOT-IMPROVE.** `decompose` is a *pass* (§3), not an improve operation — it changes the artifact partition, not the prose. `ATOMIZE` is distinct: it splits one bundled obligation into multiple obligations *within the same spec*, preserving the spec as the unit.

### 2.2 The ten operations (normative)

Each operation is triggered by one or more lint codes, with a precondition and a postcondition. Trigger codes use the unified `SOL-<LAYER>###` namespace; legacy `APS-*` codes are retired (§10.2).

| # | Operation | Trigger code(s) | Repairs |
| --- | --- | --- | --- |
| 1 | `NORMALIZE` | `SOL-P003`, `SOL-V###` | Informal/lowercase modal or non-canonical phrasing → approved uppercase modal in canonical clause order; no meaning changed. |
| 2 | `ATOMIZE` | `SOL-P004` | One block bundling ≥2 separable obligations → each its own block with its own id; bindings distributed. |
| 3 | `CONCRETIZE` | `SOL-P005` | Vague-quality word with no observable criterion → replaced by **observable behavior** (actor + action + object). |
| 4 | `QUANTIFY` | `SOL-P005` | Unbounded quality with no measurable threshold → carries a **measurable threshold** or named measurable criterion. |
| 5 | `BIND` | `SOL-V001`, `SOL-V###` | Obligation lacking a binding/source/interface/trace → valid `VERIFY BY <type>:<adapter>:<artifact>` + required references (merges legacy `Bind` + `Trace`). |
| 6 | `SCOPE` | `SOL-O###` | Missing non-goals / applicability / write surfaces / exclusions → explicit `Non-goals` / applicability / `WRITES` / exclusions present. |
| 7 | `CLARIFY` | `SOL-P008` | Behavioral uncertainty buried in prose → an explicit interpretation **OR** a `QUESTION` block. |
| 8 | `DECONFLICT` | `SOL-M002` | Two obligations (or obligation vs higher artifact) contradict → resolved per source authority (§22), or raised to amendment. |
| 9 | `COMPRESS` | `SOL-P054`, `SOL-P055` | Non-load-bearing noise / redundancy → removed; text interpreted consistently (merges legacy `Compress` + `Stabilize`). |
| 10 | `PROMOTE` | promotion protocol (§23) | Durable fact in task-local state → moved to `finding.md` / `spec.swarm.md` / `adr.md` / memory with provenance. |

`CONCRETIZE` and `QUANTIFY` share trigger `SOL-P005` but differ in repair: `CONCRETIZE` substitutes *observable behavior* (qualitative), `QUANTIFY` a *measurable threshold* (quantitative). The author picks whichever the obligation's nature requires; both exit the same code (§10.2).

### 2.3 Semantic-diff classification (the operational test)

Every spec edit reaching `improve` or `review` MUST be classified into **exactly one of twelve closed categories** (§10.4). An edit fitting none is itself a defect (an unanalyzable diff) and MUST be split until each part classifies. The classification converts a free-form text diff into a typed change whose approval requirement is then mechanical.

Categories 1–11 are all **amendments** that MUST route to approval (§22.6): added obligation, removed obligation, changed trigger, changed actor, changed modality, changed response, changed proof binding, changed non-goal, changed interface, changed invariant, changed question status. **Category 12 — pure normalization** (formatting, casing, keyword form, canonical clause order, dead-link/proof-ref completion, redundancy compression, with **no** change to any obligation's actor/trigger/modality/response/binding/non-goal/interface/invariant/question status) is the **only auto-approved class**.

> **R-SEMDIFF.** Pure normalization is the only auto-approved class. An unclassified edit MUST NOT be promoted. An edit that *combines* normalization with any of categories 1–11 is classified by its **strongest (non-normalization) category** — normalization never "absorbs" a semantic change ridden in alongside it.

This is the operational test behind R-IMPROVE: an improve operation is legitimate **iff** every edit it makes classifies as category 12. The moment an edit classifies as 1–11, the work has left `improve` and entered amendment.

---

## 3. Lowering and decomposition (§11)

`LOWER` turns a normalized, approved spec into machine-shaped work. Two passes occupy it: `lower` (SOL surface → IR obligation graph) and `decompose` (IR → task-sized work packets). They are separate passes — different inputs, outputs, and failure modes; conflating them would mix graph construction with work partitioning. Throughout `LOWER`, the **distillation-loss discipline** (§24) is in force: lowering MUST preserve every obligation, modality, actor, trigger, response, constraint, invariant, verification binding, and the authority of each obligation. Dropping any is a **distillation error**, not an optimization.

### 3.1 The `lower` pass — four steps, in order

`lower` consumes an approved `spec.swarm.md` and produces `*.swarm.ir.json`. Mostly deterministic. It MUST, in order (§11.1):

1. **Assign IR node ids.** Each surface block (e.g. `AC-001`) becomes an IR node; the id MAY be namespaced as `REQ.<spec>.AC-001`. Surface ids stay stable; the namespaced form is IR-only.
2. **Build typed edges.** Relationships are emitted as `edges[]` `{from, to, type, hard}` with `type ∈ {depends_on, blocks, conflicts_with, verified_by, affects, implements, preserves}`. Edges are the **single source of relationship truth** — a relationship MUST NOT be duplicated as a node scalar. (`AFFECTS <node-id>` → `affects` edge; `AFFECTS <surface>` stays in the node's `affects` scope set and contributes `conflicts_with` edges per §18, never an `affects` edge; `WRITES` overlap → `conflicts_with`; each `VERIFY BY` → `verified_by`.)
3. **Normalize `verify_by`.** Each surface `VERIFY BY <type>:<adapter>:<artifact>[#selector]` becomes `{type, adapter, ref, selector, gate}`. The adapter is recorded as written and resolves through `AGENTS.md > Commands` **at verify time**, not at lowering time.
4. **Emit the two derived graphs.** (a) a **dependency DAG** from `depends_on` edges; (b) a **write-surface conflict graph** from `WRITES`/`SURFACE` declarations and the READS/WRITES conflict rule. These are the substrate the safe-parallelism predicate runs on (§18): `lower` produces them, `decompose` consumes them.

### 3.2 AND THE chaining (G3)

A `REQ` MAY chain obligations with `[AND THE <actor> <MODAL> <response>]*`. `lower` MUST split each chained clause into a **distinct IR obligation node**, one per `THE`/`AND THE` clause, each inheriting the parent's bindings unless overridden. The *n*-th clause (the leading `THE` is 1, each `AND THE` thereafter) lowers to id `<surface-id>.<n>` (e.g. `AC-001.1`, `AC-001.2`). A surface `TRACE`/`VERDICT` targeting the parent distributes over all split sub-obligations; the merge gate (§14.4) requires **every** split sub-obligation to carry `PASS`/`WAIVED`.

> **R-CHAIN.** Chained obligations lower into multiple distinct IR obligations. When one block chains **more than two** obligations (three or more clauses), `lower` MUST emit a `SOL-P004`-adjacent **warning** (bundled-obligation smell) suggesting `ATOMIZE`. It MUST NOT be a hard error — chaining is permitted; two chained clauses → no warning.

### 3.3 The `decompose` pass

`decompose` consumes `*.swarm.ir.json` and produces `task.md` work packets. It is the new machinery the legacy task-type model lacked. It MUST (§11.2):

1. **Partition obligations into work packets**, each carrying its assigned obligations, constraints/invariants in force, interfaces touched, write surfaces, and verification bindings (the `task.md` contract, §21).
2. **Project owned paths** for each packet as the file/glob projection of its assigned obligations' `WRITES` surfaces.
3. **Compute merge order** from `depends_on` edges as a partial order, and **prove** owned paths of any two parallel-scheduled packets are pairwise disjoint via the write-surface conflict graph (§18).

### 3.4 Key lowering rules

- **Owned-path containment (G7) — R-OWNED-SUBSET.** An execution-tier owned path MUST be a subset of the union of its assigned obligations' `WRITES` surfaces. A path touching a file outside any assigned obligation's declared write surface is lint code **`SOL-O005`**.
- **Distillation-loss (§11.4).** Dropping an obligation id, modality, actor, trigger, response, constraint, invariant, or verification binding during lowering is a **hard failure** of the pass, not a triageable warning. Authority (§22) MUST ride onto each lowered node so a downstream conflict resolves without re-reading the surface. An obligation reaching `decompose` with no `verify_by` is a `SOL-V001`-class defect that `BIND` should have answered during `improve`.
- **READS/WRITES conflict rule (§11.5).** Conflict-serializability: `READS`/`READS` on the same surface is parallel-safe (no edge); `READS`/`WRITES` or `WRITES`/`WRITES` on the same surface is a conflict (`conflicts_with` edge). A `SURFACE` MAY carry an attribute (`append-only`, `integration`, `shared`) so shared/global/append-only surfaces aren't treated as ordinary write conflicts. `lower` only emits the edges; the full predicate is §18.

### 3.5 The two `LOWER` gates

`LOWER` is bracketed by two **pipeline gates**. A gate is **not a transformation** — it writes no artifact; it is a precondition predicate over already-emitted state. Both are contracts checkable today by review and enforced by a future tool (no runtime). A future tool MUST compute both predicates mechanically from `nodes[]`, `edges[]`, and the plan `packets[]`; until one ships, a conformant repo MUST state both as review-checkable contracts and MUST NOT claim either is tool-enforced.

> **Gate vs improve-op (normative).** The CLARIFY *gate* and the `CLARIFY` *improve operation* (§2, op 7) are distinct and MUST NOT be conflated. The op is a **local edit** in `NORMALIZE` that lifts one buried ambiguity (`SOL-P008`) into an interpretation or a `QUESTION`. The gate is a **checkpoint** at the `NORMALIZE`→`LOWER` boundary that refuses to advance while any such question is open and blocking. The op *creates* the QUESTION; the gate *waits on* it.

**CLARIFY gate (pre-`lower`) — R-CLARIFY-GATE.** `lower` MUST NOT proceed for an obligation while any of these hold for it:
- an unresolved `[blocking]` `QUESTION` `AFFECTS` it (answered, or downgraded to `[non-blocking]` with rationale, clears it);
- a blocking `SOL-M002` (contradiction) names it;
- an unresolved `SOL-P008` (uncaptured behavioral ambiguity) attaches to it.

This is the **named generalization** of R-BLOCKING-Q (§11.1.2): a `[blocking]` `QUESTION` reaching `lower` is orchestration error `SOL-O003`; R-CLARIFY-GATE lifts that into a three-condition checkpoint that also catches `SOL-M002` and `SOL-P008`. The codes are unchanged — a tripped gate surfaces as the *existing* code for whichever condition tripped it; the gate aggregates, it is not a new diagnostic.

> Rationale (cite, §11.6.1): the planner→coder handoff is the dominant multi-agent failure surface, the planner-coder gap accounting for 75.3% of failures [PLANCODER]; with messy/ambiguous specs the best model solves only ~24% of tasks even with a tool to ask for help [HILBENCH]. Ambiguous descriptions drop Pass@1 by 25–30% and contradictory ones by up to 40% (GPT-4 HumanEval 73.8%→6.7%) [AMBIGCODE], with >30% degradation across a 1,304-task benchmark [ORCHID]; a clarify-then-generate loop raises GPT-4 Pass@1 from 70.96% to 80.80% [CLARIFYGPT], and a lightweight finetuned detector flags such defects more reliably than frontier LLMs [SPECVALIDATOR].

**COVERAGE gate (pre-`implement`) — R-COVERAGE-GATE.** Before any `implement` pass runs:
1. **Total coverage.** Every lowered obligation node (every `REQ`/`CONSTRAINT`/`INVARIANT`/`INTERFACE`, including each `AND THE`-split sub-obligation) is assigned to **exactly one `implement` packet**. Uncovered = `SOL-O007` (BLOCKING; resolves by `SCOPE`). Double-owned = `SOL-O008` (BLOCKING). (An obligation legitimately appears in its `implement`, `verify`, and `review` packets across passes; the count is per `implement` packet.)
2. **No orphan targets.** Every `verified_by` edge and every TRACE `implements`/`preserves` edge resolves to a real node id in `nodes[]`. An unresolved target is `SOL-M003` (unbound-cross-reference, surfaced at `review`).

The COVERAGE gate is the structural complement of distillation-loss: distillation-loss forbids *dropping* an obligation during lowering; COVERAGE forbids *stranding* one afterward. Together they make the lowered work a bijection over obligations — nothing lost (§11.4), nothing left uncovered or pointed at a phantom (§11.6.2).

| Gate | Boundary | Predicate (MUST hold to advance) | Surfaced as | Carrier (manual today) |
| --- | --- | --- | --- | --- |
| CLARIFY | `NORMALIZE` → `LOWER` | No open `[blocking]` `QUESTION`, no blocking `SOL-M002`, no unresolved `SOL-P008` on an in-scope obligation | `SOL-O003` / `SOL-M002` / `SOL-P008` (existing codes) | `lint` (Skeptic) |
| COVERAGE | `LOWER` → `EXECUTE` | Every obligation covered by exactly one packet; every TRACE/verdict target resolves | `SOL-O007` (uncovered), `SOL-O008` (double-owned), `SOL-M003` (orphan) | `decompose` (Lead Engineer) |

Neither gate is a new pass; both reuse the existing pass surface and the `SOL-<LAYER><NNN>` namespace, adding only the two new orchestration codes `SOL-O007` and `SOL-O008`.

---

## 4. The plan (§13)

The **plan** is the **schedulable projection of the IR**: it takes the obligation graph (nodes + edges) and groups the work to discharge those obligations into **work packets** — units a launcher could hand to one agent in one lane. Where the IR answers "what must hold and how do the obligations relate," the plan answers "what units of work exist, in what order, on which surfaces, and which are safe to run at the same time." The plan is the kernel's **static coordination contract** (§18) — *not* a running scheduler. The file uses the compiler-visible infix: `auth-refresh.swarm.ir.json` plans to `auth-refresh.swarm.plan.json`.

> **Contract, not executor (normative, §13.1).** The plan schema is **documented, versioned data**. **Plan derivation is the `decompose` pass** — there is no separate "planner" step. What is **out of the kernel** is the **scheduler/harness** that would execute the packets live across agents (a launcher concern, §18.8). This repository ships **no running emitter and no scheduler** (Principle 1): frame any `.swarm.plan.json` as "the contract a future tool emits and a future launcher consumes."

### 4.1 Resolution method (G8)

Two source files disagreed on the plan shape. G8 resolves with the **same method as the IR** — a graph envelope plus a rich per-unit payload, snake_case throughout — with two normative subtractions (§13.2):

- **Drop `locks` entirely.** A lock group is a named coarse write `SURFACE`; lock-set analysis *is* write-set analysis at surface granularity (§18). The plan carries `writes[]`, never a `locks` field.
- **Reconcile the two payloads** into one work-packet record carrying both the *pass/profile* dimension and the *scope/dependency* dimension (`writes`/`reads`/`depends_on`/`merge_safe`).

### 4.2 Top-level envelope

A plan document MUST be a single JSON object with **exactly four keys**: `meta` (×1, plan identity + the spec/IR it derives from + the three version fields), `packets` (0..n work-packet objects), `edges` (0..n; the *same* single-source-of-relationship-truth rule as the IR), `provenance` (×1; same shape as §12.9). Relationships between packets live **only** in `edges[]` (never duplicated as packet scalars); the per-packet `depends_on[]` array is the declaration, and `decompose` MUST also emit a `depends_on`-type edge for each so ordering is computable from the graph (§13.3).

### 4.3 Work packets

A **work packet** is one schedulable unit: a single pass applied (under an optional profile) to a selected set of obligations, with declared scope, ordering, and a merge-safety verdict (§13.5).

| Field | Required | Meaning |
| --- | --- | --- |
| `id` | MUST | Packet identifier, unique within the plan. |
| `pass` | MUST | One of the **9 passes** (§1.2). |
| `profile` | MAY | Heuristic profile parameterizing the pass (e.g. `skeptic` on `review`); `null` = default. |
| `inputs` | MUST | Node ids (obligations/questions/traces) this packet consumes. |
| `outputs` | MUST | Artifacts expected (code paths, `*.swarm.trace.md`, `review.md`, `finding.md`, …). |
| `writes` | MUST (MAY be empty) | Write SURFACE ids, derived from the `writes` scope sets of its `inputs`; each MUST be a subset of its obligations' declared `WRITES` (lint `SOL-O005`). No `locks` field. |
| `reads` | MUST (MAY be empty) | Read surfaces touched. |
| `depends_on` | MUST (MAY be empty) | Packet ids that MUST complete first (the merge-order partial order); each MUST also appear as a `depends_on` edge. |
| `lane` | MAY | Suggested execution lane/worker label; launcher hint, no effect on safety. |
| `batch` | MAY | Suggested wave/round index; launcher hint only. |
| `merge_safe` | MUST | The kernel's verdict on whether this packet may run concurrently with its batch-mates. |

Inter-packet edges use the same `{from, to, type, hard}` object as the IR; the relevant types for a plan are `depends_on` (ordering) and `conflicts_with` (a shared write surface, or a read/write conflict on one surface). `conflicts_with` edges are what make a packet `merge_safe: false` against its conflict-mates (§13.5.1).

### 4.4 The safe-parallelism predicate

`merge_safe` is the surface of the kernel's single canonical safe-parallelism predicate, defined normatively in §18 and restated for the plan (§13.6):

> Two work packets MAY run in parallel **iff** they are **dependency-independent** (neither reachable from the other along `depends_on` edges) **AND write-disjoint** (their `writes` sets share no SURFACE, no read/write conflict on a shared surface, no shared interface/migration node). Anything unscoped or sharing a surface **serializes by default** (G7).

A packet's `merge_safe` MUST be `false` if it has any unresolved `conflicts_with` edge to a packet in the same `batch`, or if any input is unscoped (empty `writes` where a write is implied). `merge_safe` is the kernel's **static** verdict; a launcher MAY further serialize but MUST NOT parallelize two packets the plan marks unsafe.

> Design rationale (§13.6): review entropy and merge collisions, not agent count, are the binding constraint on safe parallelism.

A document is a conformant SOL/0.1 plan iff it has exactly the four top-level keys, populates every required field, carries no `locks` field anywhere, uses only the closed 9-pass set in `packets[].pass` and the closed edge-type set in `edges[]`, represents inter-packet relationships once (as edges), and keeps the three version fields distinct. The formal JSON Schema for the plan is Appendix C.3 (§13.8).

---

## Preserved / Dropped / Still-uncertain

**Preserved (this projection keeps, exact to the spec):**
- The two-level model and its non-conflation rule; the **7 phases** in fixed order and the **9 passes** in pipeline order; the per-obligation partial-order rule.
- The normative pass-to-phase mapping, the pass contract notes, and the **5 stdlib pass guides** (with `review[profile: skeptic]` as a parameter, not a separate pass).
- The closed **10 improve operations** with triggers/repairs; R-IMPROVE, R-DECOMPOSE-NOT-IMPROVE; the closed **12-category** semantic-diff set with category 12 as the sole auto-approved class (R-SEMDIFF).
- The four ordered `lower` steps; the 7 edge types; AND THE chaining (G3 / R-CHAIN); the `decompose` three obligations; R-OWNED-SUBSET (`SOL-O005`); the distillation-loss hard-failure rule; the READS/WRITES conflict rule.
- Both `LOWER` gates (CLARIFY pre-`lower`, COVERAGE pre-`implement`) with their predicates, surfaced codes (`SOL-O003`/`SOL-M002`/`SOL-P008`; `SOL-O007`/`SOL-O008`/`SOL-M003`), carriers, and the gate-vs-improve-op distinction.
- The plan as the schedulable IR projection; G8 (drop `locks`, reconcile payloads); the four-key envelope; the work-packet schema; the safe-parallelism predicate and its `merge_safe` static-verdict semantics.
- The no-runtime framing (Invariant 1 / Principle 1) on every emitter and gate, and all cited rationale [PLANCODER], [HILBENCH], [AMBIGCODE], [ORCHID], [CLARIFYGPT], [SPECVALIDATOR].

**Dropped (left to the spec — out of these four sections or detail this reference view need not carry):**
- The full IR (§12): the top-level envelope, `meta`, the merged `nodes[]` record, `edges[]` detail, scope sets, the three version fields, `diagnostics[]`, `provenance`. Referenced only where §11/§13 lean on them.
- The verification model behind `verify` (§14, §15), promotion protocol (§23), and the full orchestration / safe-parallelism machinery (§18) — referenced, not restated.
- The §10.3 worked before/after SOL snippets for each operation, and the §13.7 full worked plan fragment (the canonical end-to-end example lives in Appendix D).
- The formal JSON Schemas (Appendix C.3 for the plan; conformance lists §13.8) and Appendix B.6 lint-code provenance.

**Still-uncertain (the spec marks open / deferred):**
- Several `SOL-V###`/`SOL-M###`/`SOL-O###` trigger codes are written as families (`###`) rather than fully enumerated here; the authoritative code list lives in §8 / Appendix B.
- Live multi-agent scheduling (executing the plan's packets across agents) is explicitly **out of the kernel** (§13.1, §18.8) and not specified by these sections.
- The four non-stdlib passes (`author`, `improve`, `lower`, `verify`) MAY gain stdlib pass guides in a later framework release (§9.4) — open by design.
