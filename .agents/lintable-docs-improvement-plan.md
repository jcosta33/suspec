# Plan — fortify Swarm's checkable-document layer (research-grounded)

> Companion to `.agents/audits/claims-and-evidence-audit.md`. This is a **plan**, not changes —
> it records the latest empirical evidence (web-verified, 2024–2026), the realizations that
> follow, and a phased set of Swarm improvements. Every source is tier-labeled per §0.7 (real
> science, not astrology); unconfirmed claims are excluded with reasons. Nothing here is applied
> to the framework yet.

## The question this researched

Swarm uses a controlled obligation language (SOL) + a lint pass for **specs**. Should the
*lintable / structured-checkability* discipline extend to the **other agent-interpreted documents**
(audits, bug-reports, research notes, findings, reviews), and what does the latest evidence say
about whether structured, machine-checkable, stance-separated, provenance-anchored documents make
LLM agents more reliable? Six literature angles were swept with live web verification.

## The headline realization — the thesis is right, but the *expansion* must flip from additive to subtractive

The naïve reading ("extend lintable structure to agent docs ⇒ more structure ⇒ more reliable") is
**contradicted by the strongest, most recent measured evidence.** The evidence instead says:

> **Keep obligation-blocks spec-only. For the other agent docs, the lint's job is to MINIMIZE,
> CHECK, and KEEP-FRESH — not to add structure.** Structure helps when it is *checkable evidence
> binding, provenance, and typed metadata on the frame*; it hurts when it is *more prose, rigid
> in-body schema, or conclusion-before-reasoning ordering*. The reliability lever is a
> **deterministic external check**, never the model judging or formatting itself.

Five realizations, each measured:

1. **More structured agent prose is net-neutral-to-negative.** Gloaguen et al. *Evaluating AGENTS.md*
   (arXiv:2602.11988, preprint, controlled, multi-model): LLM-generated context files **−3% task
   success, +>20% cost**; even developer-written ones only **+4%** and add cost; **over-specification
   makes tasks harder.** Han et al. *SWE-Skills-Bench* (arXiv:2603.15401, controlled): of 49 skills,
   **39 gave zero improvement and 3 actively degraded performance −9 to −10pp** via stale/version-
   mismatched guidance + "template interference." → *Adding lintable docs is a measured liability
   unless each earns its place.* **This is the finding that most changes the plan.**
2. **What helps is machine-CHECKABLE / EXECUTABLE, not machine-readable.** Li et al. *ORACLE-SWE*
   (arXiv:2604.07789, controlled): a **reproduction test ≫** prose plans (plans weren't worth
   isolating). Chen *EviBound* (arXiv:2511.05524, N=8 caveat): prompt-only governance =
   **100% hallucinated completion; dual machine-checkable gates = 0%.** → bind "done" / "true" to a
   checkable evidence anchor.
3. **Provenance pays off only when an automated pass VERIFIES the referent.** Rao et al.
   (arXiv:2604.03173): a citation-resolving checker cut non-resolving citations **16%→0.6% (26×)** and
   **6.1%→0.1% (79×)**, p<10⁻³⁵. CiteGuard (arXiv:2510.17853): LLMs fabricate **78–90%** of citations;
   structured validation recovers to near-human. → provenance must be *lint-enforced*, not a convention.
4. **Structure the frame, not the reasoning; never conclusion-before-evidence.** Tam et al. *Let Me
   Speak Freely?* (arXiv:2408.02442, **EMNLP 2024, peer-reviewed**): JSON-mode collapsed chain-of-
   thought purely because the schema put the *answer field before the reason field* (GSM8K 76%→49%,
   Claude-Haiku 86.5%→23.4%) — yet the **same structure helped classification/extraction**. Parsing
   errors were ~0%, so the damage is reasoning-order compression, not validation. *Let Me Speak
   Freely* + Lee et al. *The Format Tax* (arXiv:2604.03616) + *When Thinking Fails* (arXiv:2505.11423)
   converge on the mitigation: **decouple — reason free-form, then emit the structured artifact**
   (recovers +6.8 to +9.2pp); frontier models pay near-zero tax.
5. **The reliability lever is a deterministic EXTERNAL check — not the model self-checking or
   voting.** Kamoi et al. *self-correction survey* (**TACL 2024**): LLMs can't reliably self-correct
   without external feedback. *No Free Labels* (arXiv:2503.05061): LLM-judge agreement collapses
   κ 0.86→0.30 without a reference. *Consensus is Not Verification* (arXiv:2603.06612) + Kim et al.
   *Correlated Errors* (**ICML 2025**, arXiv:2506.07962): voting **amplifies shared errors**, and
   bigger models err *more* correlatedly even across providers. → Swarm's deterministic lint + the
   `VERIFY BY` checker IS the validated mechanism; **do not** add LLM-judge "critique" passes or
   multi-agent voting as reliability mechanisms.

## What the evidence AFFIRMS (no change)

- **Obligation-blocks stay spec-only.** Affirmed by every angle: obligations are typed answer-
  slots/output-contracts (the regime where structure *helps*); pushing them into free-reasoning
  agent docs is the harmful regime (Tam/Format-Tax) and blurs the epistemic boundary the injection
  literature (MINJA, NeurIPS 2025) motivates.
- **The SOL/APS controlled-language + verification-gate spine.** MAST (arXiv:2503.13657): ~63% of
  multi-agent failures are spec + verification — exactly Swarm's hardened layers. SEMAP
  (arXiv:2510.12120): contracts + structured messaging + lifecycle-verification cut failures
  64–70%, with the biggest single win in **under-specification (71–73%)**.
- **NO-RUNTIME / deterministic-check / "shape is not truth."** Validated by the self-correction +
  judge-reliability literature: the external deterministic check is the lever, not the model.
- **Prose is an unreliable cross-turn carrier.** *LLMs Get Lost in Multi-Turn* (arXiv:2505.06120):
  −39% multi-turn, +112% unreliability, triggered by underspecification — affirms "load-bearing
  meaning on a stable typed surface, re-read each pass."

## The plan

Eight items, priority-ordered. Each names the Swarm surface it touches and the evidence behind it.
All are **reinforce/alter/add** at the design layer; an ADR gates the load-bearing ones.

- **P1 — ADR: "Checkable documents — what is lintable, and with what."** Record the partition the
  evidence sharpened: (a) obligation-blocks spec-only; (b) for other agent-interpreted docs, the
  lint is **subtractive + checkable** (minimality, provenance, staleness, claim→evidence), never
  additive structure; (c) structure binds the *frame/metadata*, prose reasoning stays free; (d)
  enforcement is deterministic, never an LLM judge. Refines the artifact model (§20.3.4 stance
  table) and the lint taxonomy (§8). *This is the gate for P2–P5.*

- **P2 — Make provenance lint-ENFORCED, not a convention (highest-value).** Swarm already mandates
  provenance on findings by prose; extend the lint so a **fact-shaped claim in any agent doc that
  carries no resolving evidence anchor is a defect** — and the anchor must *resolve* (the `file:line`
  exists, the citation/URL resolves, the tool-receipt is present), not merely be non-empty. This
  generalizes `task.md`'s `non-empty-paste` rule to findings/audits/research, as an advisory-or-
  blocking `SOL-P`-family check. Evidence: Rao (26–79×), CiteGuard, EviBound, tool-receipts (87–94%).

- **P3 — The "evidence-before-conclusion" ordering rule + reason-then-emit, made explicit.** Add a
  lint/authoring rule that structured agent docs place **evidence/observation before the
  claim/verdict** (Swarm's `finding`/`audit` already lean this way — make it explicit and checkable),
  and specify in the pass guides that agents **reason free-form, then emit** the structured doc
  (two-phase), never format-while-reasoning. Evidence: Tam (answer-before-reason collapse — the
  single sharpest signal), Format Tax / When-Thinking-Fails (decouple recovers the loss).
  *Consideration to resolve in the ADR:* the `VERDICT <id>: <CORE>` line is conclusion-first, with
  `REASON`/`EVIDENCE` after — assess whether that is safe (a verdict is a *slot-fill emitted after*
  the verify pass reasoned, i.e. the "classification" regime where structure helps) or worth
  reordering.

- **P4 — A staleness / conflict lint for agent docs (first-class, not a nicety).** Extend Swarm's
  obligation drift/staleness model (`content_hash` joins) to agent docs: a finding/audit/memory
  entry whose cited surfaces moved is flagged `STALE`; a doc that conflicts with a fresher one is
  flagged. **A doc that cannot be freshness-checked should not enter agent context.** Evidence:
  SWE-Skills "version-mismatched guidance" (−9 to −10pp), the distractor literature (coherent stale
  prose actively misleads).

- **P5 — A context-minimality / anti-bloat discipline.** Generalize the ≤200-line `AGENTS.md` cap
  (already on `[LOSTMID]`) into a first-class minimality dimension across agent docs: flag bloat,
  flag content restated-from-elsewhere, prefer fewer/scoped/retrieval-gated docs; reinforce
  "load what the task names" (no always-load) and the recall-map-not-dump memory model. Evidence:
  Gloaguen (over-specification hurts, +20% cost), SWE-Skills (inert docs), distractor literature
  (every extra doc is a distractor). *The win condition for extending the lint is subtractive.*

- **P6 — Strengthen the inter-agent coordination contract (the thinnest covered, evidence-backed gap).**
  Swarm's typed IR + trace contracts cover *artifacts*, but the live agent-to-agent / hand-off
  channel (`task-orchestration.md`) is lighter — and inter-agent misalignment is ~37% of MAST
  failures, the one class structure still clearly moves. SEMAP measured 64–70% failure reduction
  partly from **structured messaging/contracts between agents**. Plan: tighten the structured
  hand-off contract (the worker brief + the merge-back protocol) as a checkable artifact.

- **P7 — Bake in the "consensus is not verification" doctrine.** Make explicit (in PRINCIPLES / the
  review pass) that Swarm does **not** treat agent agreement, self-consistency, or LLM self-critique
  as correctness signals — each verdict must carry an external grounded anchor; an independent
  reviewer is protective only if epistemically independent or grounded (not same-family voting).
  Reinforces the empirical-proof primitive + the Skeptic profile's "re-run yourself." Evidence:
  Correlated-Errors (ICML 2025), Consensus-is-Not-Verification, self-correction survey (TACL 2024),
  Self-Critique-Paradox. *Mostly already implied — make it a stated principle so no future pass adds
  voting/self-critique as a reliability mechanism.*

- **P8 — Port the new evidence into `docs/research/sources.md` (continues the audit's fortification).**
  Add the tier-labeled entries below and use them at point-of-use where they ground a claim (this is
  exactly what audit recommendation O-5/F1 asked for). Keep `[SCOT]` (already present). **Exclude**
  the unconfirmed claims (below) per §0.7.

## Evidence base to add (tier-labeled, §0.7-clean)

**Peer-reviewed (may ground a load-bearing claim):**
- `[FORMATFREE]` Tam et al., *Let Me Speak Freely?*, EMNLP 2024 Industry, arXiv:2408.02442 — format
  restriction degrades reasoning via answer-before-reason ordering; helps classification. → P3.
- `[SELFCORRECT]` Kamoi et al., *When Can LLMs Actually Correct Their Own Mistakes?*, TACL 2024,
  arXiv:2406.01297 — self-correction needs external feedback. → P7.
- `[ATTRFIRST]` Slobodkin et al., *Attribute First, then Generate*, ACL 2024, arXiv:2403.17104 —
  evidence-first generation improves attribution + cuts verification time. → P2, P3.
- `[TRUSTALIGN]` Song et al., *Trustworthiness in RAG via Grounded Attributions + Learning to Refuse*,
  ICLR 2025 (oral), arXiv:2409.11242 — grounded-attribution + refuse-when-unsupported raises
  measured trustworthiness. → P2.
- `[CORRELATED]` Kim et al., *Correlated Errors in LLMs*, ICML 2025, arXiv:2506.07962 — bigger models
  err more correlatedly; voting unsafe. → P7.
- `[MINJA]` Dong et al., *MINJA memory-injection attack*, NeurIPS 2025, arXiv:2503.03704 — >95%
  injection exploiting source-confusion; motivates (but does not measure) stance/provenance typing. → P1.
- `[SMELLS]` Femmer et al., *Requirements Smells*, JSS 2017 — lexical smell detection ~48–59%
  precision / 82–87% recall: the false-positive ceiling. → smell checks advisory-only. (already cited as `[SMELLS]`)

**Preprint (finding web-verified; cite as preliminary, never a MUST):**
- `[FORMATTAX]` Lee et al., *The Format Tax*, arXiv:2604.03616 — tax paid at the prompt (−3.9pp) not
  the decoder (−1.6pp); decoupling recovers +6.8/+9.2pp; frontier ≈ 0. → P3.
- `[EVIBOUND]` Chen, *Evidence-Bound Autonomous Research*, arXiv:2511.05524 — machine-checkable gates
  100%→0% hallucinated completion (N=8). → P2.
- `[AGENTSMD-EVAL]` Gloaguen et al., arXiv:2602.11988 — over-specified agent context hurts (the audit
  already tracks this as `[AGENTSMD-HARM]`; reconcile the two). → P5.
- `[SWESKILLS]` Han et al., *SWE-Skills-Bench*, arXiv:2603.15401 — 39/49 skills inert, 3 harmful via
  staleness. → P4, P5.
- `[ORACLESWE]` Li et al., *ORACLE-SWE*, arXiv:2604.07789 — reproduction test ≫ prose plans. → P2.
- `[CITECHECK]` Rao et al., arXiv:2604.03173 + CiteGuard arXiv:2510.17853 — provenance pays off only
  with an automated resolving checker (26–79×). → P2.
- `[NOFREE]` *No Free Labels*, arXiv:2503.05061 + `[CONSENSUS]` *Consensus is Not Verification*,
  arXiv:2603.06612 — LLM-judge/voting unreliable without grounding. → P7.
- `[MULTITURN-LOST]` *LLMs Get Lost in Multi-Turn*, arXiv:2505.06120 — −39% multi-turn, triggered by
  underspecification. → affirms the typed-surface doctrine.
- `[MAST]` Cemri et al., arXiv:2503.13657 (venue unconfirmed — preprint) — 14 failure modes; ~42%
  spec / ~37% inter-agent / ~21% verification. → P1, P6.
- `[SEMAP]` Mao et al., arXiv:2510.12120 — contracts + structured messaging cut failures 64–70%. → P6.
- `[REPORTLOGIC]` arXiv:2602.18446 — agent-report quality axis IS explicit claim→support. → P2.
- Supporting (provenance/structure direction, mechanism-strong/number-weak): `[FOCUSEDCOT]`
  2511.22176, `[PAPERTRAIL]` 2602.21045, `[REQ2LTL]` 2512.17334, `[SPECFIX]` 2505.07270.

**Reject / do-not-cite-as-fact (§0.7):**
- The "17.1% drop / 7B-beats-70B" figure — traced only to a vendor blog, no primary; **unconfirmed**.
- Piskala "50% error reduction / 75% cycle-time" (arXiv:2602.00180) — position/survey, secondhand,
  uncontrolled.
- *Spec-Driven Code Generation* registered report (arXiv:2601.03878) + *Specification as Quality Gate*
  (arXiv:2603.25773) — **no measured results** (design/protocol/opinion); cite as design rationale only.
- The "Tessl / Guillermo Rauch / specs-are-the-new-code" attribution — **mistaken** (no evidence
  Rauch is associated); drop if it appears anywhere.

## What the evidence CHANGED vs the opinion I gave earlier

- **CHANGED — the agent-doc lint flips from additive to subtractive.** Earlier I framed it as "give
  each agent doc a typed content-contract." The measured evidence (P5/P1 findings) says the contract's
  *job* is minimality + checkability + freshness, not more structure. Adding structured prose is a
  measured liability.
- **CHANGED — provenance must be enforced by a resolving checker**, not just declared (P2). The win is
  the checker (26–79×), not the convention.
- **NEW — an explicit "evidence-before-conclusion + reason-then-emit" rule** (P3), which I did not have
  before. The Tam answer-before-reason result is the sharpest single design signal.
- **NEW — staleness/conflict as a first-class lint** (P4); a stale doc is worse than no doc.
- **NEW — the inter-agent coordination contract is the highest-leverage *unaddressed* gap** (P6).
- **NEW — a stated "consensus is not verification, no LLM self-judge" doctrine** (P7).
- **AFFIRMED, unchanged** — obligation-blocks spec-only; the SOL/APS + verification-gate spine; no-runtime.

## Honesty / non-goals (the §0.7 line)

- **Do not claim stance-separation is empirically proven to raise reliability.** It is sound,
  threat-motivated (MINJA), and field-aligned design — the *attack* it defends against is measured;
  the defensive reliability delta is not. State it as design, not result.
- **Do not claim "spec-first measurably improves agent quality."** No controlled spec-first-vs-vibe
  success study exists in the confirmed sources; the only hands-on numbers show heavyweight SDD is
  slower. Swarm's discipline must stay **cheap and load-bearing, not ceremonial.**
- **Do not over-formalize.** The Format-Tax/Tam boundary is real: keep reasoning bodies free; bind
  only the frame, metadata, provenance, and the conclusion-slot.
- **Smell-style prose checks are advisory, never blocking** (~40% false-positive floor); blocking
  precision is only reachable against a defined grammar (the SOL layer).

## Sequencing

1. P1 (ADR) — the gate. 2. P8 (sources) — fortifies the evidence base + serves the open audit.
3. P2 + P3 (provenance-enforced + ordering/decouple) — highest-value, best-evidenced. 4. P4 + P5
(staleness + minimality). 5. P7 (the doctrine, mostly stating what's implied). 6. P6 (inter-agent
contract — larger, separable). Each is a normal `author`→`implement` pass on `docs/` + the kernel
twin; none changes a verified number; all pair with the audit's recommendations.

---

*No framework changes made. This plan + `.agents/audits/claims-and-evidence-audit.md` are the
research/observation deliverables; execution awaits review.*
