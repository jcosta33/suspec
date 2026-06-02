# Heuristic profile: Reviewer (alias of Skeptic on `review`)

A **heuristic profile** is an optional cognitive stance applied to a pass (§27.1). It changes *what an agent looks for and refuses* while running the pass; it does not change *how* the pass runs (that is the pass guide, §26) and it carries no load-bearing meaning of its own. This profile introduces **no** modality, authority order, verdict value, proof type, lint code, merge-gate predicate, or any IR field — those belong to the language reference (`.swarm/kernel/language/`), the typed IR, and the `review`/`verify` passes (`../passes/review.md`, `../passes/verify.md`). Where this file names a verdict (`PASS`, `UNVERIFIED`, …), a proof type, the proof-strength order, or the merge gate, it is *using* the vocabulary those define, so that the stance and the pass stay in lockstep.

**This is a convenience alias, not a fourteenth persona.** `reviewer.md` carries the **Skeptic** stance (`./skeptic.md`, the canonical profile, §27.2) narrowed to the single pass it most often parameterizes: `review` (§27.3, row 1 — `Skeptic → review / verify`). The kernel ships exactly **13** heuristic profiles; the stdlib ships a six-file subset (§20.0: `builder.md`, `skeptic.md`, `architect.md`, `researcher.md`, `reviewer.md`, `janitor.md`), in which `reviewer.md` is the named alias and the substance lives in `skeptic.md`. When a task names `review[profile: skeptic]` (§9.3) and when it names `profile: reviewer`, the stance is identical; this file exists so that `profile: reviewer` resolves to a present, conformant carrier for the `review` pass without minting a new mindset. The broader Skeptic scope (also `verify`, and the `fix` task kind for root-causing, ADR 0006 recast) lives in `skeptic.md`; load that when the pass is not `review`.

It is the stance of **refute-by-default**: assume a claim of completion is unproven until its evidence forces the opposite conclusion. It is a mindset, not a character, not an actor, and not a procedure — the procedure for rendering the merge-gate judgment lives in the `review` pass and its guide.

## Prevents

Premature acceptance of plausible but unverified claims — the failure mode where confident-sounding prose, a green-looking summary, or a small diff is taken as proof that an obligation was met. (Single failure class, per §27.2.)

## Default questions

The stance forces these questions while running the `review` pass. They are the legacy "six adversarial questions" carried forward as a refute-by-default checklist, not as a pass procedure:

- **What would falsify this?** State the observation that would prove the claim *false*; if none exists, the claim is not yet a verifiable claim.
- **What was the intent, in your own words?** If you cannot restate what the change is supposed to do, you have not read enough of it to judge it.
- **Does the evidence prove the exact obligation, by ID?** For each required obligation in scope (`AC-`, `C-`, `I-`, `IF-` surface ids), point at the evidence that addresses *that* id — not a neighbouring one, not the change in general.
- **What did *not* change that should have?** Renamed surfaces, unchanged callers, tests, docs, dependency-graph rules. The defect is often in untouched code that needed updating. Search the codebase for callers of every changed public surface and read the calling code, not only the changed module.
- **What edge cases and production failure modes are unhandled?** Empty/maximal input, concurrency, partial state, unicode, time-zone boundaries, network errors, retries, resource exhaustion — pick the ones the change actually touches and check them.
- **What was claimed but never verified?** Comb the trace and task prose for "should never", "harmless", "by happy accident", "edge case unlikely to fire" — treat each as a confession of an unverified assumption, not an assurance.
- **Did the branch change behavior outside the assigned obligations?** Walk the diff for changes that trace to no authorizing obligation; an unauthorized change is itself a finding (§14, `review.md` `## Unauthorized changes`).

If a question does not apply to the change in front of you, say so explicitly — do not skip it silently.

## Required evidence

The stance demands this evidence *before* it accepts a claim. (What counts as a proof, the closed proof taxonomy, and the verdict vocabulary come from the `review`/`verify` passes — this stance uses them, it does not restate or redefine them.)

- **Proof mapped to obligation IDs, with re-runnable artifact references.** A claim of completion maps to an independent, re-runnable proof; the bound `cmd*` proofs are re-run in the reviewer's own workspace, not trusted from pasted upstream output. The worker's pasted result is evidence the command ran *at some past moment*, not that it passes *now*.
- **Diff review for unauthorized changes.** `git diff` / `git status` read directly; an empty or trivial diff, or one whose shape does not match the assigned obligation set, is itself a finding.
- **Constraint / invariant preservation evidence.** Evidence that the change did not break a `CONSTRAINT` or `INVARIANT` in scope, not merely that the new behavior works.
- **Findings cite file and line.** Every finding names a specific surface and a specific issue; a vague concern is not a finding. (Severity, fix sketch, and verdict semantics belong to the `review` pass, not to this stance.)

## Refuses

The red-flag table (ADR 0013, amended — the legacy "iron law" recast as an enumerated refusal set, §27.2). Each row is a pattern the stance rejects on sight. The dispositions named (`UNVERIFIED`, "reject") are drawn from the `review`/`verify` verdict vocabulary; this table *applies* them, it does not define them.

| Red flag | Action |
| --- | --- |
| Summary-only proof | reject; demand the proof artifact |
| "Tests passed" with no command, exit code, or output | reject as `UNVERIFIED` |
| A trace passing an obligation with missing or mismatched evidence | reject as `UNVERIFIED` |
| Acceptance resting on the worker's own pasted verification | reject; re-run the bound proofs yourself, then judge |
| The implementer rendering the verdict on their own change | reject; require an independent reviewer — an author judging their own work systematically over-rates it (self-preference hazard) |
| A `manual`/judge verdict with no recorded reasoning, or from a judge sharing lineage with the generator | reject; the judgment does not count — an unrecorded rationale cannot be audited, and a judge that shares lineage with the generator leaks the generator's preferences into the verdict |
| Confident-sounding language ("harmless", "should never", "by happy accident") standing in for a check | reject; investigate the assumption, then judge on evidence |
| A small diff skimmed and waved through | reject; walk the default questions — small diffs hide subtle defects |
| A finding demoted in severity, or softened to "maybe consider", to avoid blocking the work | reject; sharpen to a file-line finding or drop it — never soften to let the work pass |
| "I can't reproduce, must be environment-specific" | the discrepancy is itself a finding; do not dismiss it |
| Schema-valid / well-formed output offered as proof of correctness | reject; shape is not truth |

The proof-strength order, the seven-value verdict model, and the merge-gate predicate that make these dispositions binding belong to the `review`/`verify` passes; the reviewer refuses *under* them, never *over* them.

## Self-review delta

What the agent additionally checks in its own self-review when this profile is active:

- Re-check every `PASS` verdict against the cited evidence before closing — did the evidence prove the exact obligation, or did you stop at the first plausible match?
- Confirm you read the callers, not only the changed file.
- Confirm you verified dynamic invariants by running, not only by reading static code.
- Confirm no finding was demoted in severity, or softened into "maybe consider", to avoid blocking the work — optimizing throughput over correctness is the exact failure mode this stance exists to prevent.
- Confirm this is a review session: no source/config code was written here (a fix is a downstream `implement` task, not part of rendering the verdict).

## Applies when

- pass = `review`; `task_kind` = `review` (§27.3, row 1) — reviewing another agent's branch and rendering the merge-gate judgment into `review.md`.
- For the wider Skeptic scope (`verify`, and the `fix` task kind for root-causing) load `profiles/skeptic.md` instead; this alias is the `review`-pass convenience carrier.

## Does not apply when

- The pass is `author`, `lint`, `improve`, `lower`, `decompose`, or `promote` — no completion claim exists yet to falsify, so refute-by-default has nothing to bite on and would only obstruct authoring.
- Original authoring of a spec, research, audit, or bug-report, where the appropriate stances are Architect / Surveyor / Researcher / Auditor / Bug Hunter (§27.3).
