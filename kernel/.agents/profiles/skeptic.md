# Heuristic profile: Skeptic

> A **heuristic profile** is an optional cognitive stance applied to a pass (§27.1). It changes *what an agent looks for and refuses* while running the pass; it never changes *how* the pass runs (that is the pass guide, §26) and it never defines load-bearing meaning. This profile defines **no** modality, authority order, verdict value, proof type, lint code, or any IR field — those live exclusively in the language reference (`.swarm/kernel/language/`) and the typed IR, per the semantic-ownership prohibition (§26.1). Where this file names a verdict (`PASS`, `UNVERIFIED`, …), a proof type, the proof-strength order, or the merge gate, it is **citing** SOL/IR, not defining it; the authoritative text is the `verify`/`review` pass contracts and the language reference.

The Skeptic is the canonical reference profile (§27.2). It is the stance of **refute-by-default**: assume a claim is unproven until its evidence forces the opposite conclusion. It parameterizes the `review` and `verify` passes (§27.3) — the two passes where claims of completion already exist and can be falsified. It is a mindset, not a character, not an actor, and not a procedure.

## Prevents

Premature acceptance of plausible but unverified claims — the failure mode where confident-sounding prose, a green-looking summary, or a small diff is taken as proof that an obligation was met. (Single failure class, per §27.2.)

## Default questions

The stance forces these questions while running the pass. They are the legacy "six adversarial questions" carried forward as a refute-by-default checklist, not as a pass procedure:

- **What would falsify this?** State the observation that would prove the claim *false*; if none exists, the claim is not yet a verifiable claim.
- **Does the evidence prove the exact obligation, by ID?** For each required obligation in scope (`AC-`, `C-`, `I-`, `IF-` surface ids), point at the evidence that addresses *that* id — not a neighbouring one, not the change in general.
- **What was the intent, in your own words?** If you cannot restate what the change is supposed to do, you have not read enough to judge it.
- **What did *not* change that should have?** Renamed surfaces, unchanged callers, tests, docs, dependency-graph rules. The defect is often in untouched code that needed updating. Search the codebase for callers of every changed public surface and read the calling code, not only the changed module.
- **What edge cases and production failure modes are unhandled?** Empty/maximal input, concurrency, partial state, unicode, time-zone boundaries, network errors, retries, resource exhaustion — pick the ones the change actually touches and check them.
- **What was claimed but never verified?** Comb the trace and task prose for "should never", "harmless", "by happy accident", "edge case unlikely to fire" — treat each as a confession of an unverified assumption, not an assurance.
- **Did the branch change behavior outside the assigned obligations?** Walk the diff for changes that trace to no authorizing obligation.

If a question does not apply to the change in front of you, say so explicitly — do not skip it silently.

## Required evidence

The stance demands this evidence *before* it accepts a claim. (What counts as a proof, and the closed proof taxonomy, are defined in the `verify` pass contract / §15 — cited here, not redefined.)

- **Proof mapped to obligation IDs, with re-runnable artifact references.** A claim of completion maps to an independent, re-runnable proof; the bound `cmd*` proofs are re-run in the reviewer's own workspace, not trusted from pasted upstream output. The worker's pasted result is evidence the command ran *at some past moment*, not that it passes *now*.
- **Diff review for unauthorized changes.** `git diff` / `git status` read directly; an empty or trivial diff, or one whose shape does not match the assigned obligation set, is itself a finding.
- **Constraint / invariant preservation evidence.** Evidence that the change did not break a `CONSTRAINT` or `INVARIANT` in scope, not merely that the new behavior works.
- **Findings cite file and line.** Every finding names a specific surface and a specific issue; a vague concern is not a finding. (Severity, fix sketch, and verdict semantics are owned by the pass contract, not by this stance.)

## Refuses

The red-flag table (ADR 0013, amended — the legacy "iron law" recast as an enumerated refusal set, §27.2). Each row is a pattern the stance rejects on sight. The dispositions named (`UNVERIFIED`, "reject") are the verdict vocabulary the `review`/`verify` contracts define; this table *applies* them, it does not define them.

| Red flag | Action |
| --- | --- |
| Summary-only proof | reject; demand the proof artifact |
| "Tests passed" with no command, exit code, or output | reject as `UNVERIFIED` |
| A trace passing an obligation with missing or mismatched evidence | reject as `UNVERIFIED` |
| Acceptance resting on the worker's own pasted verification | reject; re-run the bound proofs yourself, then judge |
| The implementer rendering the verdict on their own change | reject; require an independent reviewer (self-preference hazard `[MTBENCH]`) |
| A `manual`/judge verdict with no recorded reasoning, or from a judge sharing lineage with the generator | reject; the judgment does not count `[PREFLEAK]`, `[TRUSTJUDGE]` |
| Confident-sounding language ("harmless", "should never", "by happy accident") standing in for a check | reject; investigate the assumption, then judge on evidence |
| A small diff skimmed and waved through | reject; walk the default questions — small diffs hide subtle defects |
| "I can't reproduce, must be environment-specific" | the discrepancy is itself a finding; do not dismiss it |
| Schema-valid / well-formed output offered as proof of correctness | reject; shape is not truth |

The proof-strength order, the seven-value verdict model, and the merge-gate predicate that make these dispositions binding live in the `verify`/`review` pass contracts; the Skeptic refuses *under* them, never *over* them.

## Self-review delta

What the agent additionally checks in its own self-review when this profile is active:

- Re-check every `PASS` verdict against the cited evidence before closing — did the evidence prove the exact obligation, or did you stop at the first plausible match?
- Confirm you read the callers, not only the changed file.
- Confirm you verified dynamic invariants by running, not only by reading static code.
- Confirm no finding was demoted in severity, or softened into "maybe consider", to avoid blocking the work — optimizing throughput over correctness is the exact failure mode this stance exists to prevent.

## Applies when

- pass ∈ {`review`, `verify`}; `task_kind` ∈ {`review`, `fix`}.
- Reviewing another agent's branch, re-walking a prior audit being deepened, or root-causing a defect — root-causing demands the same hostility to plausible explanations as review (ADR 0006, recast: Skeptic is a *profile* on the `fix`/`review` passes, not an owner of `fix` tasks).

## Does not apply when

- The pass is `author`, `lint`, `improve`, `lower`, `decompose`, or `promote` — no completion claim exists yet to falsify, so refute-by-default has nothing to bite on and would only obstruct authoring.
- Original authoring of a spec, research, audit, or bug-report, where the appropriate stances are Architect / Surveyor / Researcher / Auditor / Bug Hunter (§27.3).
