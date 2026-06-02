---
name: pass-decompose-spec
description: How to run the `decompose` pass — partition a lowered IR obligation graph into task-sized, write-disjoint work packets and emit the plan, applying the single safe-parallelism predicate and the COVERAGE gate before any `implement` pass runs. Load when a task names the `decompose` pass (typically under the Lead Engineer profile). This is a procedural guide; it does not redefine modality, authority order, verification semantics, or any IR/SOL meaning — it relies on those as already fixed and applies them.
---

# Pass guide: decompose

This guide documents *how* to perform the `decompose` pass — the fifth of the nine passes (`author → lint → improve → lower → decompose → implement → verify → review → promote`) and the second of the two `LOWER`-phase passes. Where `lower` builds the IR obligation graph, `decompose` partitions that graph into schedulable work packets and emits the plan.

This guide is procedural only. The load-bearing meaning — what `merge_safe` *means*, what overlap/subset *mean*, what a verdict *means*, the authority order — is fixed elsewhere and applied here, never redefined (§26.1). A correctly lowered IR is understandable without this guide; the guide only says how to run the pass over it. The structures it operates over:

- The decompose pass contract: §13 (compiler pipeline) and §18 (orchestration).
- The plan envelope and work-packet record: §13.3–§13.5.
- The single safe-parallelism predicate and its surface semantics: §18.5, §18.5.1.
- The COVERAGE gate: §11.6.2.
- The carrier profile: the Lead Engineer heuristic profile (§27).

## Purpose

Partition the IR obligation graph into task-sized, **write-disjoint** work packets — each carrying its assigned obligations, the constraints/invariants in force, the interfaces it touches, its write surfaces, and its verification bindings — and emit the plan: the kernel's static coordination contract that answers "what units of work exist, in what order, on which surfaces, and which are safe to run at the same time" (§13). The plan is documented, versioned data a future launcher would consume; it is never a running scheduler (§13.1, Principle 1).

## Consumes

- The lowered IR — `*.swarm.ir.json` — including the two derived graphs the `lower` pass emitted: the dependency DAG (from `DEPENDS ON`) and the write-surface conflict graph (from `WRITES`/`SURFACE`/`READS`) (§18.4). `decompose` operates on the IR, **not** the surface spec, so packet boundaries are computed from the typed graph rather than re-parsed from prose (§9.3.1).
- The `SURFACE` declarations and their attributes (`append-only`, `integration`, `shared`) referenced by the obligations' `WRITES`/`READS` (§18.3, §18.3.1).

If an obligation reaches `decompose` with no `verify_by`, that is a `SOL-V001`-class defect `BIND` should have answered during `improve` (§11.4) — surface it; do not invent a binding here.

## Produces

- One `task.md` work packet per partition unit — "the lowered work packet for one pass," the unit a single `implement` run owns (§21).
- The plan, named-as-contract `*.swarm.plan.json` (`auth-refresh.swarm.ir.json → auth-refresh.swarm.plan.json`, §20). A SOL plan is a single JSON object with **exactly four top-level keys** (§13.3):

  | Key | Type | Cardinality | Carries |
  |---|---|---|---|
  | `meta` | object | exactly 1 | plan identity; `derived_from` (the IR path); `language` `SOL/0.1`; `version`; optional `max_parallel` (advisory launcher hint, `null` = unspecified) |
  | `packets` | array | 0..n | the schedulable work units (§13.5) |
  | `edges` | array | 0..n | inter-packet relationships, recorded **once** here (the single-source-of-relationship-truth rule, §12.5.1) |
  | `provenance` | object | exactly 1 | emission facts, same shape as the IR's `provenance` (§12.9) |

  Each `packets[]` record carries: `id`, `pass` (one of the nine), optional `profile`, `inputs`, `outputs`, `writes`, `reads`, `depends_on`, optional `lane`/`batch`, and `merge_safe` (§13.5). There is **no `locks` field anywhere** — a lock group *is* a named write SURFACE, so lock analysis reduces to write-set analysis (§13.2, §18.3).

## Preserves

`decompose` is bound by the distillation-loss discipline (§11.4, §24): the two `LOWER` passes MUST NOT drop an obligation id, modality, actor, trigger, response, constraint, invariant, verification binding, or authority. The COVERAGE gate (below) is the structural complement: distillation-loss forbids *dropping* an obligation during lowering; COVERAGE forbids *stranding* one afterward. Together they make the lowered work a bijection over obligations — nothing lost, nothing left uncovered or pointed at a phantom (§11.6.2). This is the `distillation-discipline` fragment applied at `decompose` (§26.3); the loss-budget table itself lives in §24.

## Rejects

- A packet whose owned paths fall outside the union of its assigned obligations' declared `WRITES` surfaces — the owned-path containment violation, `SOL-O005` (§11.3, §18.7, §19.7).
- Two conflicting packets (sharing a write surface, a boundary node, or a read/write conflict) marked into the same parallel batch — `SOL-O001`, raised to **ERROR** because a write-conflict marked parallel is the precise failure that produces silent merge corruption (§18.7).
- A partition that leaves any obligation uncovered (`SOL-O007`) or double-owned across two `implement` packets (`SOL-O008`) — the COVERAGE gate's blocking conditions (§11.6.2).
- Any plan that adds a fifth top-level key, ships a `locks` field, uses a pass outside the closed nine-pass set, or duplicates an inter-packet relationship outside `edges[]` (§13.8).

This guide does not assign verdicts or evaluate the merge gate — those are `review`/`verify` and §14/§19.8.3 concerns. `decompose` only emits the static contract they will read.

## Procedure

1. **Read the IR, not the prose.** Load `*.swarm.ir.json` and its two derived graphs (§18.4). Resolve every obligation's `WRITES`/`READS` to `SURFACE` path-pattern sets, noting any `append-only`/`integration`/`shared` attribute (§18.3.1). If a `SURFACE` is unnamed, treat each raw path/glob as its own singleton pattern set (§18.5.1).

2. **Partition into write-disjoint packets.** Group obligations into the smallest set of packets such that each packet is a single pass (under an optional profile) over a selected set of obligations with declared scope. The partition *heuristic* — how finely to split — is your judgment as the carrier (§27); the kernel fixes only the predicate (step 5) the partition must satisfy. Carry into each packet its assigned obligations, the constraints/invariants in force, the interfaces it touches, its write surfaces, and its verification bindings (§11.2, §21). When two candidate sub-tasks need the same file, they are not independent: sequence them with a `DEPENDS ON` edge rather than parallelizing (Lead Engineer hard constraint; §19.2).

3. **Project owned paths and check containment.** For each packet, derive its `writes` as the file/glob projection of its assigned obligations' `WRITES` surfaces. Each owned pattern set MUST be a subset of that union under the §18.5.1 pattern-language subset semantics — every path the owned set matches must also be matched by the declared `WRITES` set. An owned path touching a file outside any assigned obligation's declared write surface is the disjoint-scope violation `SOL-O005`; fix it by re-scoping the packet or by widening the obligation's `WRITES` in the source spec — never silently (§19.7).

4. **Compute merge order.** Build the partial order from the `depends_on` edges (the dependency DAG, which `lower` already proved acyclic; a cycle is `SOL-O002`). Each packet's `depends_on[]` array is the *declaration*; emit a matching `depends_on`-type edge in `edges[]` so ordering is computable from the graph, not just from packet scalars (§13.5).

5. **Apply the single safe-parallelism predicate to set `merge_safe`.** Use the kernel's **one** predicate verbatim — no relaxed alternative is permitted (§18.5). Two packets `a` and `b` may run in parallel **iff** they are dependency-independent **and** write-disjoint:

   ```text
   parallel_safe(a, b)  ⇔
         ¬reachable_DAG(a, b) ∧ ¬reachable_DAG(b, a)   # dependency-independent
      ∧  writes(a) ∩ writes(b) = ∅                     # no shared write surface
      ∧  ¬shares_interface_or_migration(a, b)          # no shared boundary node
      ∧  ¬readwrite_conflict(a, b)                      # §18.6
   ```

   Compute overlap and subset **syntactically over the glob pattern lattice** (§18.5.1: `**` = any number of segments, `*` = one segment, `?` = one character) — string inequality does **not** imply disjointness, and the test is never against a live filesystem (Principle 1). Two packets share a boundary node iff both reference the same `INTERFACE` via `DEPENDS ON`/`AFFECTS`, or both write an `integration`/`shared` surface. Read/read never conflicts; read/write and write/write do (§18.6). Set `merge_safe: false` whenever the predicate fails, whenever a packet has an unresolved `conflicts_with` edge to a batch-mate, or whenever any input is unscoped (empty `writes` where a write is implied).

   Honour the two non-weakenable defaults (§18.5): **unscoped serializes** — an obligation with no `WRITES` is assumed to conflict with everything and MUST NOT be co-scheduled in a parallel batch (the write side stays single-threaded by default, ADR 0010); and **shared serializes** — any obligation touching a `shared`/`integration` surface or a shared `INTERFACE` serializes. The verdict is *static*: a launcher MAY further serialize for its own reasons but MUST NOT parallelize a pair the plan marks unsafe. Read-only passes (`lint`, `review`, any pass declaring only `READS`) MAY run broadly in parallel.

6. **Run the COVERAGE gate (the `LOWER → EXECUTE` checkpoint, before any `implement`).** The gate writes no artifact; it is a precondition predicate over the IR `nodes[]`/`edges[]` and the plan `packets[]` (§11.6.2). For every lowered obligation node (`REQ`/`CONSTRAINT`/`INVARIANT`/`INTERFACE`, including each `AND THE`-split sub-obligation), count the `implement` packets whose `inputs` include it:

   ```text
   count == 0  -> SOL-O007  (uncovered obligation)     [BLOCKING] — assign to one packet, or record an explicit non-goal
   count > 1   -> SOL-O008  (double-owned obligation)   [BLOCKING] — re-assign to exactly one packet
   ```

   Then check that every `verified_by` edge and every TRACE `implements`/`preserves` edge resolves to a real node id in `nodes[]`; an unresolved target is an orphan (`SOL-M003`, surfaced at `review`). The coverage count is *per `implement` packet* — an obligation legitimately recurs across its `implement`, `verify`, and `review` packets. All BLOCKING conditions MUST clear before any `implement` pass runs.

7. **Emit the plan.** Write the four-key envelope (§13.3) and one `task.md` per packet (§21). Mirror every `depends_on[]` as a `depends_on` edge and every shared-surface or read/write conflict as a `conflicts_with` edge in `edges[]` (§13.5.1). Set `meta.derived_from`, `language`, `version`, and (optionally) the advisory `max_parallel`. Frame the artifact as the contract a future tool emits and a future launcher consumes — never as the output of a shipped emitter or a live scheduler (§13.1).

The design rationale for the contract-not-scheduler stance: a simple localize→repair→validate pipeline can reach high performance among software agents without any live multi-agent scheduling, so a static plan is sufficient; the write side stays single-threaded because conflicting concurrent actions carry conflicting decisions, and agents are not yet reliable at real-time coordination, so parallelism is opt-in and write-disjoint by default. A recorded hand-off contract per packet attacks the two largest multi-agent failure modes — fuzzy specification and system-design, and inter-agent misalignment — by fixing scope, order, and surfaces statically before any `implement` run.

## Output contract

- A `*.swarm.plan.json` that is a conformant SOL/0.1 plan (§13.8): exactly the four top-level keys; every required field populated (optional fields defaulted); **no `locks` field anywhere**; only the closed nine-pass set in `packets[].pass` and the closed edge-type set in `edges[]`; inter-packet relationships represented **once**, as edges; the three version fields (`meta.version`, the IR's `version`, the spec content version) kept distinct.
- One `task.md` per packet, each carrying its assigned obligations, scope (owned paths ⊆ declared `WRITES`), `depends_on` order, and verification bindings (§21).
- Every packet's `merge_safe` set by the §18.5 predicate verbatim, with the two non-weakenable defaults honoured.
- The COVERAGE gate cleared: no `SOL-O007`, no `SOL-O008`, no unresolved `verified_by`/`implements`/`preserves` target.

For the `auth-refresh` worked fragment (§13.7), a conformant plan groups one `INTERFACE`, one dependent `REQ`, and one `INVARIANT` into three packets: WP-001 (`implement` the interface contract, `batch: 0`) is `merge_safe: false` because it freezes a shared interface contract; WP-002 (`implement`, depends on WP-001, write-disjoint from its batch-mates, `batch: 1`) and WP-003 (`verify`, depends on WP-002, `batch: 2`) are `merge_safe: true`.

## Self-review delta

Before handing off, confirm:

- Could a fresh agent re-derive the conflict graph and the `merge_safe` verdicts from the IR + plan alone, with no state held in your head? The decomposition correctness must be re-derivable from the artifact (§19.7).
- Is every owned path a subset of its obligations' declared `WRITES` (no `SOL-O005`), and is no conflicting pair marked into one parallel batch (no `SOL-O001`)?
- Does the COVERAGE gate pass — every obligation in exactly one `implement` packet, no orphan TRACE/VERDICT targets (§11.6.2)?
- Did you compute overlap/subset over the glob pattern lattice rather than by string equality (§18.5.1)? "Different string" is not "disjoint surface."
- Did anything unscoped or `shared`/`integration` silently end up in a parallel batch? It MUST serialize (§18.5).
- Is the plan framed as a static contract a launcher would consume, with no claim of a running scheduler, emitter, or live batching (§13.1, §18.8)?
- Did you preserve every obligation, modality, actor, constraint, invariant, verification binding, and authority across the partition (distillation-loss, §11.4)?
