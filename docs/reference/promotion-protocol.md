# Promotion Protocol

> Authoritative source: `.agents/specs/swarm/07-governance-memory.md` §23.4 (the promotion statuses + workflow), with the §23.1–§23.3 and §23.5 memory-model context it cites. This is a reference projection; where it and the spec disagree, the spec governs.

A discovery made during a task does **not** become memory by being written down. It becomes memory by being **promoted** — an explicit, recorded act that moves a fact from a task's ephemeral scratch into a durable, indexed, provenanced artifact (§23.4). This document is the promotion protocol the kernel references by name (§20, §23.4.2): the status enum, the mandatory-before-close gate, the discovery-to-target routing table, and the validation/rollback discipline.

Promotion exists because chat transcripts and inline prose are *not* memory — they are unindexed, unprovenanced, and unfalsifiable (§23). Memory MUST be a promotion system (a fact earns durability through a recorded promotion) backed by an immutable evidence store, with a compact index over it (§23, §23.1, §23.2). The protocol is markdown-only and NO-RUNTIME (Principle 1, §2): it describes the *files and the discipline* a future retrieval/checker tool would build against, not a shipped engine.

## The promotion-status enum (seven values)

Every promotion item raised during a task MUST resolve to one of these statuses before the task closes (§23.4):

| Promotion status | Meaning |
| ---------------- | ------- |
| `pending` | Raised, not yet dispositioned. |
| `promoted` | Written to its durable target and indexed. |
| `deferred` | Recorded for a future task, with reason. |
| `rejected` | Judged non-durable, with reason. |
| `blocked` | Cannot promote yet (e.g. needs an ADR), with reason. |
| `validated` | High-consequence intermediate (`pending → validated → promoted`); requires independent corroboration (§23.4.3). |
| `rolled-back` | A promoted finding later withdrawn (poisoned / `CONTRADICTED` / `STALE`), recorded as a retraction (§23.4.3). |

The promotion-status enum is therefore exactly these **seven** values (§23.4). Note this is the *promotion* enum and is distinct from a `finding.md`'s own `status` enum (`candidate | accepted | promoted | rejected | stale | superseded`, §23.5) — a finding's status tracks the life of one durable artifact; a promotion's status tracks the disposition of one queue item.

### How the seven statuses behave at the close gate

The seven statuses do not all play the same role (§23.4.2):

- **`pending`** is the unresolved state. **A task MUST NOT close while any promotion item is `pending`** (§23.4). This is the core gate.
- **`validated`** is a **non-terminal intermediate** in the chain `pending → validated → promoted` (§23.4.3); it does *not* satisfy the close gate on its own — an item parked at `validated` is still unresolved for the purpose of closing.
- **`rolled-back`** is a **post-promotion disposition**: it records the withdrawal of an already-`promoted` finding (§23.4.3), so it is reached *after* promotion, not as a way to resolve a fresh queue item.
- The remaining four non-`pending` statuses — **`promoted` / `deferred` / `rejected` / `blocked`** — are **terminal for this task**. Of these, `deferred`, `rejected`, and `blocked` each MUST carry a reason (§23.4, §23.4.2).

## The mandatory-before-close gate

Promotion is **mandatory before task closure** (§23.4, §23.4.2). Every discovery a task surfaces enters the **promotion queue** and MUST resolve to one of the canonical seven statuses; a task MUST NOT close while any item is `pending`. Two consequences follow:

- A `promoted` finding MUST appear in `memory/INDEX.md` with a `Load when` condition (§23.1.1) and carry full provenance (§23.3). The `Load when` is the trigger telling a future agent the entry is relevant to its current task; an entry that cannot name *when it matters* is dead weight and MUST be removed (the **load-when discipline**, §23.1.1).
- **"Keep in the task only" is a real disposition, not an omission.** A purely local execution detail is still recorded in the queue and resolved — dispositioned `rejected` with reason "execution-local" (§23.4.2). The mandatory-before-close rule admits **no silent drops**: every discovery is either promoted somewhere durable or explicitly resolved as non-durable, on the record.

## Discovery-to-promotion-target routing

Given the *kind* of discovery, the protocol fixes the single durable target the `promote` pass (§9) writes to. The kinds are mutually exclusive by intent; when a discovery has two faces (e.g. it is both a durable decision and a reusable pattern), it is promoted to each applicable target and each lands as its **own queue item** (§23.4.2).

| Discovery | Promote to |
| --------- | ---------- |
| New intended behaviour (a real obligation/constraint to build against) | `spec.swarm.md` (a new or amended `REQ`/`CONSTRAINT`/`INVARIANT`/`INTERFACE`), or an ADR when the behaviour is gated on an undecided architectural/product choice. |
| Durable architectural or product decision (a choice with consequences, alternatives, trade-offs) | An ADR (`.swarm/sources/adrs/<nnnn>-<slug>.md`). |
| Present-state risk or debt (what *is*, observed but not yet a chosen change) | An audit (`.swarm/sources/audits/<slug>.md`) — observation-only, never prescriptive (§20.3.3). |
| Reproduced defect evidence (root cause + expected vs actual, reproducible) | A bug-report (`.swarm/sources/bugs/<slug>.md`) — diagnosis-only; the fix promotes onward to a `task_kind: fix` task (§20.3.3). |
| Reusable project fact (a durable claim learned during work, with evidence) | A finding (`.swarm/sources/findings/<slug>.md`), indexed in `memory/INDEX.md` with a `Load when` (§23.1.1) and full provenance (§23.3). |
| Repeated cross-task pattern (a recurring solution shape seen across more than one task) | `memory/patterns/*.md`. |
| Terminology clarification (a term whose meaning was ambiguous or drifted) | `memory/glossary.md` (the canonical lexicon; resolves `SOL-P`-layer terminology drift — `SOL-P006` undefined-term, `SOL-P057` terminology-drift — at the source). |
| Universal workflow rule (a procedure that should apply to every future task) | A pass-guide edit (the procedure) **plus at most a one-line `AGENTS.md` pointer** — NEVER inline procedure in `AGENTS.md`; the bootloader holds persistent facts, not steps (§23.4.1). |
| Purely local execution detail (relevant only to this task's run) | Keep in the task only (`task.md`); it is **not** durable and is dispositioned `rejected` for promotion with reason "execution-local". |

Two normative consequences hold across **every** row (§23.4.2):

1. **A promotion that would *weaken* an existing obligation is forbidden at any target.** It is a `SOL-M004` authority-conflict routed to amendment, because `memory` is the floor domain on Axis B of source authority (§22.4). A fact can never quietly relax an obligation it was discovered against.
2. **No silent drops.** As above, "keep in the task only" is an explicit `rejected`-with-reason disposition recorded in the queue, not a quiet omission.

### G9 — the "universal workflow rule" tie-break

Routing a *universal workflow rule* toward `AGENTS.md` collides with the ≤200-line bootloader cap and ADR 0017 (only persistent **facts** belong in `AGENTS.md`; **procedures** belong in pass guides). The kernel resolves this normatively (G9, §23.4.1):

> A "universal workflow rule" promotion MUST become **a pass-guide edit (the procedure) PLUS at most a one-line `AGENTS.md` pointer (the fact that the guide exists and when to load it).** It MUST NOT inline the procedure into `AGENTS.md`.

| Where it goes | What goes there |
| ------------- | --------------- |
| Pass guide (`docs/skills/…`, §26) | The actual procedure / steps. |
| `AGENTS.md` | One line: the pointer + its load-when, nothing procedural. |

Example (§23.4.1): promoting "always run the migration dry-run before applying" adds the dry-run procedure to the `implement` pass guide; `AGENTS.md` gains only `- Before applying a migration, load the implement pass guide (migration section).` This keeps the bootloader a map (consistent with §31) and the procedure lazily loaded.

## Provenance — mandatory on every promoted finding

Every finding that reaches `accepted` or `promoted` status MUST carry the full provenance record (§23.3). Provenance is what makes a finding *falsifiable* and *staleness-checkable*; a finding without it is chat, not memory.

| Field | Meaning |
| ----- | ------- |
| `claim` | The one durable fact, stated as a single proposition. |
| `evidence` | The file/command/output/source that grounds the claim. |
| `origin_obligations[]` | The obligation IDs (`AC-`/`C-`/`I-…`) the finding was discovered against. |
| `origin_traces[]` | The `*.swarm.trace.md` entries that produced the evidence. |
| `pass+profile` | The pass and heuristic profile under which it was found (e.g. `review[profile: skeptic]`, §26–§27). |
| `reviewer_or_tool` | The human reviewer or tool/adapter that confirmed it. |
| `timestamp` | When it was promoted. |
| `content_hash` | Hash of the cited source/surfaces at promotion time (drives staleness, §23.5). |
| `confidence` | `high` \| `medium` \| `low`. |
| `applies-when` / `does-not-apply-when` | The scope envelope; mirrors the `Load when` of the INDEX entry. |

A single finding MUST NOT be promoted directly to a pattern. Promote it to a `finding.md` first, and to a `memory/patterns/*.md` pattern only once a **second corroborating finding** exists, since a pattern is the distillation of *several* findings and MUST cite the findings it generalizes (§23.2).

## Validation and rollback (memory governance)

**Authorization is not validation.** The v0.1 base model (`pending → promoted` on approval) is forward-only; governance research argues a memory write MUST pass *consistency verification* — not merely owner approval — before consolidation, naming three failure points: poisoning at ingestion, semantic drift at consolidation, and conflict/hallucination at retrieval `[SSGM]` (conceptual framework, no headline number). Two additions close the gap (§23.4.3):

- **The `validated` status.** A high-consequence promotion MUST pass `pending → validated → promoted`, where `validated` requires **independent corroboration** — a second finding, a re-run proof, or a reviewer who is *not* the promoting agent — generalizing the §23.2 two-finding rule for patterns. A `pending` finding produced by an externally-authored source (the §17.5.2 untrusted-source boundary; the rule/config-file poisoning vector `[NVIDIA-AGENTSMD]`, `[RULESBACKDOOR]`) MUST NOT skip `validated`.
- **Rollback.** A `promoted` finding later shown poisoned, `CONTRADICTED` (§14), or `STALE` (§16) MUST be withdrawable via the `rolled-back` disposition. Rollback records a **retraction entry in `memory/INDEX.md`** — *not* a silent delete; the chain stays auditable under Nygard immutability (§30) — and **re-opens any obligation it had narrowed** (§22.4, §23.4.2).

> **Supersession vs. rollback.** Supersession *replaces* a fact with a better one; rollback *withdraws* a fact that should never have been promoted (§23.4.3). They are different acts with different audit meanings.

The two-tier index/store model is cited as **design lineage, not validation** of any Swarm-specific number: OS-style two-tier context management `[MEMGPT]`, extract–consolidate–retrieve pipelines `[MEM0]`, self-linking agentic notes `[AMEM]`, and tiered episodic→semantic consolidation `[MEMTIER]` (tripartite, not two-tier). Automated validation scoring, decay, and embedding retrieval remain deferred (§23.6, §35.2).

## Staleness of a promoted finding

A `promoted` finding does not stay authoritative forever. A finding becomes **`stale`** when its `content_hash` (§23.3) no longer matches the cited source/surfaces — the same drift signal that produces the `STALE` verdict lifecycle decorator (§14) and the spec↔code drift reconcile (§16). A `stale` finding MUST NOT be relied on as authority; it is routed to re-verification or supersession, and a `superseded` finding records its replacement in `memory/INDEX.md`'s stale/superseded table (§23.5).

The kernel ships the **fields** that make staleness computable (`content_hash`, `origin_traces`); it does **not** ship the comparator. Recomputing the hash and flipping `accepted → stale` is a harness/CLI concern, aspirational/manual today (Principle 1, §16, §17, §23.5).

## How the protocol joins the rest of the kernel

(The block-type, modal, verdict, and lint-layer counts named below are the kernel's fixed vocabulary — **7 block types, 5 modals, 7 verdicts (4 core + 3 lifecycle), 5 lint layers S/P/M/V/O** — defined in §4–§8 and §14; this projection reproduces them by reference, it does not redefine them.)

- **The verdict model (§14).** The `promote` pass runs after the change-set verdict is recorded. Rollback triggers (`CONTRADICTED`, `STALE`) are two of the **three lifecycle verdicts** in the 4-core + 3-lifecycle (= 7-verdict) model (§14.1, §23.4.3).
- **Source authority (§22).** `memory` is the floor domain on Axis B, which is *why* a promotion can never weaken an obligation — that path is a `SOL-M004` authority-conflict routed to amendment (§22.4, §23.4.2).
- **The ledger (§23.7).** A `promotions/` ledger entry records the disposition of every queue item — `promoted` / `deferred` / `rejected` / `blocked` (and `validated` / `rolled-back` where §23.4.3 applied). Because a task cannot close with any `pending` item, the ledger entry records a fully-resolved queue *by construction* (§23.7.3).
- **The loss budget (§24).** The `task.md → finding.md` boundary is a distillation boundary: the step-by-step execution log MAY be dropped, but the evidence for the durable claim MUST survive (§24.2). Promotion is one of the two boundaries (with spec→task lowering) the loss budget most acutely governs (§24).

## Preserved / Dropped / Still-uncertain

**Preserved (the load-bearing claims this projection keeps from §23.4 and the context the memory model cites):**
- The seven-value promotion-status enum and each status's exact meaning (§23.4).
- The role each status plays at the close gate — `pending` blocks; `validated` is a non-terminal intermediate; `rolled-back` is post-promotion; `promoted`/`deferred`/`rejected`/`blocked` are terminal-for-this-task, with reasons on the latter three (§23.4.2).
- The mandatory-before-close gate, the load-when + provenance requirements on a `promoted` finding, and "keep in the task only" as an explicit `rejected`-with-reason disposition (no silent drops) (§23.4, §23.4.2).
- The full discovery-to-target routing table and its two cross-row consequences (no-weakening / no-silent-drops) (§23.4.2).
- The G9 universal-workflow-rule tie-break (procedure to pass guide + one-line `AGENTS.md` pointer) (§23.4.1).
- The mandatory provenance fields, the no-direct-to-pattern / two-finding rule, the `validated` corroboration step, and the `rolled-back` retraction/obligation-re-open mechanics (§23.2, §23.3, §23.4.3).
- The promoted-finding staleness signal and the fields-not-comparator NO-RUNTIME stance (§23.5).
- The lineage citations cited *as lineage* (`[SSGM]`, `[MEMGPT]`, `[MEM0]`, `[AMEM]`, `[MEMTIER]`) and the security poisoning vectors that force `validated` (`[NVIDIA-AGENTSMD]`, `[RULESBACKDOOR]`).

**Dropped (left to the spec — out of scope for this reference view):**
- The full Tier-1 / Tier-2 memory-model bodies (`memory/INDEX.md` table shape, `glossary.md` one-word-one-meaning discipline, the Tier-2 artifact-mutability table) — named here only where the protocol depends on them; defined in §23.1–§23.2.
- The complete ledger specification (locations, ephemeral-vs-durable boundary, per-field compaction) — summarized as one join point; defined in §23.7.
- The complete verdict model, source-authority ladder, and loss-budget matrix — referenced by name and count, defined in §14, §22, §24.
- The §23.6 deferred-to-post-v0.1 list beyond the one-line summary (embedding retrieval, automatic eviction, automatic staleness hashing, cross-session identity, dashboards).

**Still-uncertain (the spec itself defers; this projection does not resolve):**
- The staleness comparator: the kernel ships `content_hash`/`origin_traces` but not the differ that flips `accepted → stale` — aspirational/manual today, awaiting a tool that does not yet exist (§23.5, §23.6, §2).
- Automated validation *scoring*, decay, and embedding retrieval — explicitly deferred (§23.4.3, §23.6, §35.2); the `validated` status today is satisfied by human/second-finding/re-run corroboration, not a scored gate.
