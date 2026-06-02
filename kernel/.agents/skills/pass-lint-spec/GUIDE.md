---
name: pass-lint-spec
description: How to run the `lint` pass over a `spec.swarm.md` — detect S/P/M defects, emit the diagnostic record, decide blocking status, and run the CLARIFY gate, without changing a single character of the spec. Load this guide when a task names the `lint` pass. Apply the Skeptic profile. Do NOT use this guide to rewrite the spec — that is the `improve` pass; `lint` only names repairs.
---

# Pass guide: pass-lint-spec

This guide tells you *how* to perform the `lint` pass well. It is SOFT control: it carries procedure, not meaning. It MUST NOT define modality, authority order, verification semantics, lint-code meaning, or any other load-bearing fact — those live only in SOL and the IR (the language reference governs; §7.1, §26.1). Where this guide and the language reference disagree, the reference wins. Every code, severity, gate, and record shape named below is defined normatively elsewhere and merely *applied* here:

- The lint taxonomy, the `SOL-<LAYER><NNN>` namespace, the diagnostic record shape, BLOCKING/ADVISORY, and the principal code lists: `02-aps-and-lint.md` §8 (and §7 for the APS prose families behind the `P` layer).
- The `lint` pass contract (non-mutating, `PARSE`+`NORMALIZE`, Skeptic carrier, no runtime): `03-compiler-pipeline.md` §9.3, §9.3.1, §9.4.
- The CLARIFY gate: `03-compiler-pipeline.md` §11.6.1 (and §11.1.2 for R-BLOCKING-Q).
- The reference projection of all of the above: `docs/passes/lint.md`.

## Purpose

Read one `spec.swarm.md` and emit a **lint report** — an array of diagnostic records plus an overall blocking status — *without changing the spec*. `lint` is the highest-leverage pass: it catches defects before any work is committed (§9.4). Run it with the **Skeptic** stance (§27): assume each obligation is under-specified until its actor, modality, object, and proof are present and observable, and refuse to wave through a clause because it "reads fine."

You only *detect and name* defects here. You do not repair them — repair is the `improve` pass (§10), which runs after `lint` and is triggered by the codes you emit. Naming the repair in each diagnostic's `suggest` field is part of detection; *applying* it is not.

## Consumes

- One `spec.swarm.md` (the surface artifact; prose + SOL blocks).
- The language reference for the codes and record shape (cited above) — for lookup, never as a thing this guide redefines.
- Optionally, a project `swarm.config.json`/`.yaml` (or the `lint:` section of `.swarm/config.yaml`) carrying severity overrides and waivers (§8.6), and `memory/glossary.md` for term resolution (`SOL-P006`/`SOL-P057`).

## Produces

- A **lint report**: `{ code, severity, layer, span, message, suggest }[]` plus an overall **blocking status** (the report blocks if any unwaived diagnostic carries `severity: BLOCKING`). The record shape is fixed by §8.1.2.
- No edit to the spec. `lint` is **non-mutating** (§9.3.1): if you changed a character of the spec, you left the `lint` pass.

## Preserves

- **The spec, byte-for-byte.** Emit diagnostics only; never rewrite, reorder, or "tidy" the source. The one pass allowed to rewrite the spec is `improve`, and only semantics-preservingly (§9.3.1, §10.1).
- **Code identity.** Cite only unified `SOL-<LAYER><NNN>` codes. `APS-*`, flat `SOL101/201/301`, and `SOL-L###` are retired aliases (§8.5) — never emit them.
- **Default severities.** A code's default BLOCKING/ADVISORY status and its `layer` are fixed by the spec. You MAY apply a project's recorded overrides/waivers (§8.6); you MUST NOT invent, rename, relayer, or silently demote a code.

## Rejects

Refuse, and emit no report claim instead, when any of these hold:

- You are asked to **fix** the spec under the banner of linting. That is `improve` (§10); route there.
- You are asked to **emit a legacy or invented code**, change a code's layer, or demote a blocker without a complete waiver record (`code`, `scope`, `to`, `authority`, `reason`, `expiry`, `recorded_at` — all required, §8.6). An incomplete waiver does not take effect; the blocker stands.
- You are asked to produce an IR `note`-level diagnostic. `note` has **no surface producer in v0.1** (§8.2); a conformant checker MUST NOT emit it.
- You are asked to claim the lint or the CLARIFY gate is **enforced by shipped tooling**. There is no runtime (Invariant 1); both are review-checkable contracts performed by hand today (§9.2, §11.6).

## Procedure

Run these steps in order. Steps 1–3 are detection (which produces the report); step 4 decides blocking status; step 5 runs the CLARIFY gate as a separate predicate. Throughout, hold the binding-clause vs commentary boundary (§7.2) in mind: an APS prose rule applies with full force inside a typed obligation block (`REQ`/`CONSTRAINT`/`INVARIANT`) and as an advisory only in commentary.

1. **Scan the `S` layer (well-formedness, `PARSE`).** For each SOL block, decide whether it parses as well-formed. Look for: a precondition (`WHEN`/`IF`/`WHILE`) with no actor clause or no modal consequence (`SOL-S001`); an actor clause with no modal verb (`SOL-S003`); an id prefix that does not match the block type (`SOL-S005`, e.g. `REQ C-001:`); a `SHOULD`/`SHOULD NOT` with no accompanying `BECAUSE` or `EXCEPT` (`SOL-S006`); and a missing required top-level section, or sections out of mandated order (`SOL-S012`). Look up the exact defect definitions in §8.3; do not re-derive them.

2. **Scan the `P` layer (controlled prose, `NORMALIZE`).** For every binding clause, walk the APS rule families (§7.3–§7.5) and emit the prose code each resolves to. The blocking set is `SOL-P001`–`SOL-P008`: dangling condition (`P001`), missing actor (`P002`), missing/informal modality (`P003`), bundled obligation joined by `and`/`or`/`and/or` (`P004`), high-risk/vague-quality word with no same-line observable criterion (`P005`, §7.4), undefined term (`P006`), bare `MUST NOT` with no paired affirmative (`P007`), and uncaptured behavioral uncertainty not lifted to a `QUESTION` (`P008`). The advisory set is `SOL-P050`–`SOL-P058` (pronoun, passive, length, tense, noise, redundancy, unbaselined comparative, terminology drift, deprecated modal alias) — emit these as `warning`. Apply the §7.2 reclassification: `SOL-P056` (comparative without baseline) is BLOCKING inside an obligation block, ADVISORY in commentary; the high-risk-word rules are BLOCKING only inside binding clauses.

3. **Scan the `M` layer (semantic, `NORMALIZE`).** Across obligations, check for actor/object incompleteness — a modal present but no resolvable actor *and* object (`SOL-M001`) — and contradiction — two obligations sharing a contradiction key with opposed modalities, **exact-key match only in v0.1** (`SOL-M002`, §8.3). (The `M` layer is *repaired* by `improve`, but `lint` *surfaces* it; layers and passes are 1:1 by domain, not by who reports — §8.1.1.) The `V` and `O` layers (`SOL-V001` missing verification path; `SOL-O001`/`SOL-O005` orchestration) are surfaced by their owning passes/gates downstream; record them only when they are already determinable from the surface spec, and otherwise leave them to `verify`/`decompose`.

4. **Emit each diagnostic and decide blocking status.** For every defect, emit the record `{ code, severity, layer, span, message, suggest }` (§8.1.2): `severity` is `BLOCKING` or `ADVISORY`; `layer` is the code's letter; `span` is at minimum `{ file, block }`; `message` is a one-line defect statement; `suggest` names the repair — the `improve` op the code maps to (e.g. `SOL-P004`→`ATOMIZE`, `SOL-P005`→`CONCRETIZE`/`QUANTIFY`, `SOL-P008`→`CLARIFY`, `SOL-M002`→`DECONFLICT`, `SOL-V001`→`BIND`; full map in §10.2) — or `null` if none. Apply any project severity overrides/waivers from §8.6. The **overall blocking status** is BLOCKING if any unwaived `BLOCKING` diagnostic remains; such a diagnostic MUST be resolved before the artifact advances past the gate its layer is checked at (S/P/M at the lint→`lower` gates, §11.6).

5. **Run the CLARIFY gate (the pre-`lower` checkpoint).** This is a *predicate*, not a new diagnostic — it writes no artifact and introduces no new code (§11.6.1). Decide, per obligation, whether the spec is **lowerable**: a spec is **not lowerable** for an in-scope obligation while any of these holds for that obligation —
   - an unresolved `[blocking]` `QUESTION` `AFFECTS` it (answered, or downgraded to `[non-blocking]` with rationale, clears it; an unresolved one surfaces as `SOL-O003`);
   - a blocking `SOL-M002` contradiction names it;
   - an unresolved `SOL-P008` uncaptured ambiguity attaches to it.

   A tripped gate surfaces as the *existing* code for the condition that tripped it (`SOL-O003`/`SOL-M002`/`SOL-P008`), already in your report from steps 2–3 — the gate aggregates these three into one checkpoint; it is not a fourth code. Do not conflate this gate with the `CLARIFY` *improve op* (§10.2, op 7): the op *creates* the explicit interpretation or `QUESTION` from one buried `SOL-P008`; the gate *waits on* such questions being discharged (§11.6 reconciliation). Verify the predicate by hand against the spec/IR; state it as a review-checkable contract and never claim a tool enforces it.

## Output contract

- A lint report: an array of `{ code, severity, layer, span, message, suggest }` records (each conforming to §8.1.2) plus the overall blocking status.
- Codes are unified `SOL-<LAYER><NNN>` only; no legacy aliases, no invented codes, no IR `note` level.
- The spec is unchanged. The report names repairs (in `suggest`) but applies none.
- The CLARIFY-gate result is stated as a per-obligation lowerable / not-lowerable predicate, referencing the existing code(s) that trip it — not a new diagnostic and not a claim of tool enforcement.

## Self-review delta

Before closing the pass, confirm:

- [ ] **Non-mutating.** The `spec.swarm.md` is byte-for-byte unchanged.
- [ ] **Codes are unified and real.** Every emitted code is a `SOL-<LAYER><NNN>` from §8/Appendix B; no `APS-*`, no flat `SOL###`, no `SOL-L###`, no invented code, no `note`.
- [ ] **Record shape is complete.** Every diagnostic has all six fields; `suggest` names a §10 op or a concrete fix, or is `null`.
- [ ] **Severities follow the spec.** Defaults are as §8.2–§8.4 define; any demotion carries a complete §8.6 waiver record; any promotion is a recorded strict-mode override.
- [ ] **Binding boundary applied.** Position-sensitive codes (e.g. `SOL-P056`, the high-risk-word rules) were classified by §7.2 (binding vs commentary), not by feel.
- [ ] **CLARIFY gate decided, not invented.** The gate is reported as a predicate over existing codes, with no fourth diagnostic and no enforced-by-tooling claim.
- [ ] **No `improve` work leaked in.** No clause was rewritten, concretized, atomized, or deconflicted; repairs were *named*, not *done*.

*Why this pass earns its place (cite):* a lightweight finetuned detector flags defective task descriptions more reliably than frontier LLMs (F1 0.804 / MCC 0.745 vs ≈0.47–0.52), finding under-specification the most severe defect `[SPECVALIDATOR]` — so machine-cheap, pre-generation detection of "what gets built" defects is the BLOCKING criterion (§8.2). The CLARIFY gate before lowering is load-bearing because the planner→coder handoff is the dominant failure surface — the planner-coder gap accounts for 75.3% of failures `[PLANCODER]` — and agents do not reliably ask: on messy/ambiguous specs the best model solves only ~24% of tasks even when handed a help tool `[HILBENCH]`. The cost of unresolved ambiguity is measured: ambiguous descriptions drop Pass@1 by 25–30% and contradictory ones by up to 40% `[AMBIGCODE]`, with >30% degradation across a 1,304-task benchmark `[ORCHID]`; conversely a clarify-then-generate loop raises GPT-4 Pass@1 from 70.96% to 80.80% `[CLARIFYGPT]`. The diagnostic record lowers SARIF-shaped into the IR `diagnostics[]` `[SARIF]`.
