---
name: pass-promote-findings
description: How to run the `promote` pass — the durable feedback loop that closes a task. ALWAYS load this guide when finishing a task that surfaced discoveries (durable facts, decisions, patterns, terminology, or workflow rules), or when resolving a promotion queue before task closure. It walks the discovery-to-target routing, the seven-value promotion status, the provenance and `Load when` discipline, and the validation/rollback rules. This guide documents HOW to promote; the routing/status rules, modality, authority order, and verification it relies on are canonical Swarm rules summarized inline here.
---

# Pass guide: promote

This guide tells you HOW to execute the `promote` pass. The promotion protocol, the seven-value status enum, the discovery-to-target routing table, the mandatory provenance fields, validation/rollback, and the `Load when` discipline are all stated inline below so the pass is runnable from this file alone.

## Purpose

`promote` is the last of the nine passes (`author → lint → improve → lower → decompose → implement → verify → review → promote`). It is the durable feedback loop: a discovery made during a task does **not** become memory by being written down — it becomes memory by being **promoted**. This pass takes each discovery a task surfaced, routes it to a durable target, indexes it, records its disposition, and resolves the promotion queue so the task may close.

The model it writes into is two-tier and provenance-anchored: a compact Tier-1 map (`memory/INDEX.md` + `memory/glossary.md`) over an immutable Tier-2 evidence store. Chat transcripts and inline prose are not memory — they are unindexed, unprovenanced, and unfalsifiable. The procedure below earns durability for a fact through a recorded promotion.

`promote` ships a stdlib pass guide in v0.1; it is one of the five tooled-first passes (with `lint`, `decompose`, `implement`, and `review[profile: skeptic]`). Like every Swarm pass it has **no runtime**: this guide is a contract a human, an agent, or a future tool performs by hand against the files the kernel ships. It composes the `distillation-discipline` fragment — promotion is the upstream-flowing companion to distillation, and the loss-budget discipline applies when a discovery crosses into a durable artifact.

## Consumes

- The task's **discoveries** — every durable fact, decision, pattern, terminology clarification, or workflow rule the task surfaced (from `task.md`, the traces, and the `review` verdict record).
- The **promotion queue** — the resolved-or-pending list of promotion items raised during the task.
- The current Tier-1 map: `memory/INDEX.md` and `memory/glossary.md` (to check for existing entries, prior findings to corroborate against, and terms already bound).
- The relevant `origin_obligations` (`AC-/C-/I-/IF-…`) and `origin_traces` (`*.swarm.trace.md`) that produced each discovery's evidence.

## Produces

- Durable writes to `.swarm/sources/` (findings, ADRs, audits, bug-reports) and `.swarm/memory/` (patterns, glossary), routed per the routing table below.
- For a universal workflow rule: a **pass-guide edit (the procedure) plus at most a one-line `AGENTS.md` pointer** — never inline procedure in `AGENTS.md` (the G9 tie-break).
- An updated `memory/INDEX.md`: a new `Load when` entry for every `promoted` finding, and a retraction entry for every `rolled-back` finding.
- A **fully-resolved promotion queue**: every item carries one of the seven canonical statuses, and no item is `pending`.

## Preserves

- **The authority floor.** `memory` is the lowest domain on Axis B. A promotion that would *weaken* an existing obligation is forbidden at any target — it is a `SOL-M004` authority-conflict routed to amendment. A promoted finding may **inform** an obligation; it may never **narrow or weaken** one *as memory*.
- **Epistemic stance.** An observation stays an observation, a decision stays a decision; promoting a discovery into intent (a spec obligation, via the routing table) is an authoring act that re-states it with its own ID, modality, and `VERIFY BY` — not a silent re-labelling. Re-stating a finding as a spec obligation is a **domain-promotion**: the obligation acquires its *new container's* authority (intent acquiring rank), not the `memory` floor being breached.
- **The loss budget.** The `task.md → finding.md` distillation MAY drop the step-by-step execution log but MUST preserve the actionable claim, its applicability, and its evidence. Apply the `distillation-discipline` fragment at the boundary.
- **Immutability.** A `finding.md` body does not silently change once `accepted`/`promoted` (status may advance); an `adr.md` is Nygard-immutable — amend only by superseding ADR. A withdrawal is a recorded retraction, never a silent delete.

## Rejects

- Closing a task while any promotion item is `pending` (the close gate — normative).
- A `promoted` finding that is missing from `memory/INDEX.md`, lacks a `Load when`, or lacks full provenance.
- An `INDEX.md` entry that cannot name *when it matters* — the load-when discipline removes it as dead weight against the loss budget and the recall-map density cap.
- Promoting a single finding **directly** to a `memory/patterns/*.md` pattern: promote to a `finding.md` first, and to a pattern only once a **second corroborating finding** exists; a pattern MUST cite the findings it generalizes.
- Inlining procedure into `AGENTS.md` for a universal-workflow-rule promotion (G9).
- Skipping `validated` for a high-consequence promotion or for a `pending` finding from an externally-authored (untrusted) source.
- Defining or restating any kernel semantics here (modality, authority order, verification, the routing rules) — those are canonical Swarm rules; this guide only delivers the procedure for applying them.

## Procedure

1. **Collect the queue.** Enumerate every discovery the task surfaced into the promotion queue. A discovery left out of the queue is a silent drop — even a purely local detail is queued and resolved (`rejected`, reason `execution-local`), never omitted.

2. **Route each item by kind.** The kinds are mutually exclusive by intent; a discovery with two faces (e.g. both a durable decision *and* a reusable pattern) is promoted to each applicable target and each lands as its **own** queue item.

   | Discovery | Promote to |
   |---|---|
   | New intended behaviour (a real obligation to build against) | `spec.swarm.md` (new/amended `REQ`/`CONSTRAINT`/`INVARIANT`/`INTERFACE`), or an ADR when gated on an undecided architectural/product choice |
   | Durable architectural/product decision (choice + alternatives + trade-offs) | An ADR (`.swarm/sources/adrs/<nnnn>-<slug>.md`) |
   | Present-state risk or debt (what *is*, observed, not yet a chosen change) | An audit (`.swarm/sources/audits/<slug>.md`) — observation-only, never prescriptive |
   | Reproduced defect evidence (root cause + expected vs actual) | A bug-report (`.swarm/sources/bugs/<slug>.md`) — diagnosis-only; the fix promotes onward to a `task_kind: fix` task |
   | Reusable project fact (durable evidenced claim) | A finding (`.swarm/sources/findings/<slug>.md`), indexed in `memory/INDEX.md` with `Load when` + full provenance |
   | Repeated cross-task pattern (recurring solution shape across >1 task) | `memory/patterns/*.md` |
   | Terminology clarification (ambiguous/drifted term) | `memory/glossary.md` |
   | Universal workflow rule (a procedure for every future task) | A **pass-guide edit (the procedure) PLUS at most a one-line `AGENTS.md` pointer** — never inline procedure |
   | Purely local execution detail (relevant only to this run) | Keep in the task only (`task.md`); disposition `rejected`, reason "execution-local" |

3. **Check the authority floor before writing.** If a promotion would weaken or narrow an existing obligation, STOP — do not write it as memory. It is a `SOL-M004` authority-conflict; route it to amendment/review. Re-stating it as a spec obligation (a domain-promotion) is allowed and acquires the spec's authority; weakening one *as memory* is not.

4. **Write the durable target, applying the loss budget.** Create the routed artifact. When the source is a `task.md`, distil per the `distillation-discipline` fragment: drop the execution log, preserve the actionable claim, applicability, and evidence. For a finding, fill the full provenance record — every field below:

   | Field | What to record |
   |---|---|
   | `claim` | The one durable fact, as a single proposition |
   | `evidence` | The file/command/output/source grounding the claim |
   | `origin_obligations[]` | The obligation IDs the finding was discovered against |
   | `origin_traces[]` | The `*.swarm.trace.md` entries that produced the evidence |
   | `pass` + `profile` | The pass + heuristic profile it was found under (e.g. `review` + `skeptic`) |
   | `reviewer_or_tool` | The human reviewer or tool/adapter that confirmed it |
   | `timestamp` | When it was promoted |
   | `content_hash` | Hash of the cited source/surfaces at promotion time (drives staleness) |
   | `confidence` | `high` \| `medium` \| `low` |
   | `applies_when` / `does_not_apply_when` | The scope envelope; mirrors the INDEX `Load when` |

   A finding without provenance is chat, not memory — do not let it reach `accepted`/`promoted`.

5. **Apply the validation gate where required.** For a **high-consequence** promotion, or any `pending` finding from an externally-authored/untrusted source (the poisoning vector), advance through `pending → validated → promoted`. `validated` requires **independent corroboration** — a second finding, a re-run proof, or a reviewer who is not the promoting agent — generalizing the two-finding rule for patterns. `validated` is **non-terminal**: it does not satisfy the close gate on its own; carry it through to `promoted` (or disposition otherwise) before closing.

6. **Index every promoted finding.** Add a row to `memory/INDEX.md` with a usable `Load when` that names the trigger telling a future agent the entry is relevant. The INDEX **links into** Tier-2; it MUST NOT duplicate bodies. If you cannot write a `Load when`, the entry does not belong — reconsider whether the discovery is durable.

   ```text
   ## Durable findings

   | Finding | Status | Load when |
   | ------------------------------- | -------- | ------------------------------------------------- |
   | finding-refresh-token-replay.md | promoted | Touching auth token rotation or refresh endpoints |
   ```

7. **For a pattern,** confirm a second corroborating finding exists, then write/append `memory/patterns/<topic>.md` citing the findings it generalizes; append-on-supersession (do not overwrite). For a **glossary** clarification, bind exactly one term to one definition in `memory/glossary.md`; split a contested term into distinct terms, never overload (resolves `SOL-P006` undefined-term / `SOL-P057` terminology-drift at the source).

8. **For a universal workflow rule, apply G9.** Put the procedure in the owning pass guide; add at most one line to `AGENTS.md` — the pointer plus its load-when, nothing procedural. Example: promoting "always run the migration dry-run before applying" adds the dry-run procedure to the `implement` guide; `AGENTS.md` gains only `- Before applying a migration, load the implement pass guide (migration section).`

9. **Handle rollback when withdrawing a fact.** If a previously `promoted` finding is shown poisoned, `CONTRADICTED`, or `STALE`, set it `rolled-back`: record a **retraction entry in `memory/INDEX.md`** (never a silent delete — the chain stays auditable under Nygard immutability) and re-open any obligation it had narrowed. Distinguish from supersession: supersession replaces a fact with a better one; rollback withdraws a fact that should never have been promoted.

10. **Resolve and check the close gate.** Disposition every queue item to one of the seven statuses below. A task MUST NOT close while any item is `pending`. Each of `deferred`/`rejected`/`blocked` carries a **reason**.

    | Promotion status | Meaning | Terminal for this task? |
    |---|---|---|
    | `pending` | Raised, not yet dispositioned | No — the close gate forbids it |
    | `promoted` | Written to its durable target and indexed | Yes |
    | `deferred` | Recorded for a future task **with reason** | Yes |
    | `rejected` | Judged non-durable **with reason** | Yes |
    | `blocked` | Cannot promote yet (e.g. needs an ADR) **with reason** | Yes |
    | `validated` | High-consequence intermediate (`pending → validated → promoted`); independent corroboration | No — non-terminal |
    | `rolled-back` | A promoted finding later withdrawn, recorded as a retraction | Post-promotion disposition |

## Output contract

- The promotion queue is **fully resolved**: every item carries one of the seven statuses, and **no item is `pending`** (close gate).
- Every `promoted` finding (a) exists as a Tier-2 artifact under `.swarm/sources/`, (b) appears in `memory/INDEX.md` with a `Load when`, and (c) carries the full provenance record.
- Every `deferred`/`rejected`/`blocked` item carries a recorded reason; "keep in the task only" appears as `rejected` with reason "execution-local", not as an omission.
- No promotion weakened an obligation as memory (no introduced `SOL-M004`); any behaviour-changing promotion to a spec/ADR went through amendment with the approval authority resolved.
- No pattern was created from a single finding; any pattern cites the findings it generalizes.
- No `AGENTS.md` change inlines procedure; any workflow-rule promotion is a guide edit plus a one-line pointer.
- Any withdrawal is a `rolled-back` retraction entry in the INDEX, not a deletion.
- This guide added no kernel semantics: the disposition leaned only on the canonical routing/status/provenance rules.

## Self-review delta

Before declaring the pass complete, confirm:

- [ ] Is every discovery the task surfaced represented in the queue (no silent drops, including execution-local details dispositioned `rejected`)?
- [ ] Is every item dispositioned, and is **nothing** still `pending`?
- [ ] Does every `promoted` finding have a Tier-2 body, an INDEX `Load when`, and full provenance?
- [ ] Did any item route to two faces (decision + pattern, etc.) and land as **separate** queue items?
- [ ] Did a high-consequence or externally-authored promotion pass `pending → validated → promoted` rather than skipping `validated`?
- [ ] Was a pattern created only with ≥2 corroborating findings it cites?
- [ ] Did any promotion weaken an obligation as memory (a `SOL-M004` floor breach)? If so, it was rejected and routed to amendment, not written.
- [ ] For a workflow-rule promotion, did the procedure go to a pass guide and only a one-line pointer to `AGENTS.md`?
- [ ] Was any withdrawal recorded as a `rolled-back` retraction (with re-opened obligations), not a silent delete?
- [ ] Did this guide stay procedural — applying, not redefining, the routing, status, and provenance rules?

> Note on staleness: the kernel ships the **fields** that make staleness computable (`content_hash`, `origin_traces`); it does **not** ship the comparator. Recomputing the hash and flipping `accepted → stale` is a harness/CLI concern, aspirational/manual today. Likewise embedding retrieval, automatic eviction, and memory analytics are deferred post-v0.1.

## Related

- `../../passes/promote.md` — the `promote` pass this guide delivers.
- `../../templates/finding.md` — the finding artifact and provenance record this pass writes.
- `../../profiles/skeptic.md` — the adversarial review profile whose verdict record feeds discoveries into the promotion queue.
- `../distillation-discipline/GUIDE.md` — the fragment this guide composes for the loss budget at the `task.md → finding.md` boundary.
