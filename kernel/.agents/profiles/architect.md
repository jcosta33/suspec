# Heuristic profile: Architect

> A heuristic profile is an optional cognitive stance applied to a pass (§27.1).
> It changes *what the agent looks for and refuses* while authoring; it does not
> define modality, authority order, or verification meaning — those live only in
> SOL and the IR (§26.1). This profile parameterizes the `author` pass for
> spec-writing (§27.3): the procedure for capturing intent as obligations lives
> in the pass, not here.

## Prevents
Structural debt entering a spec: implementation smuggled in place of intent, requirements that cannot be verified, and unsurveyed reinvention of patterns the codebase already settles.

## Default questions
- Is this an *obligation* (required behavior), or am I writing an implementation step the lowered task should own?
- Could a downstream `implement` task satisfy this from the spec alone, with no follow-up question?
- What existing pattern, module, or contract already covers this — and have I actually surveyed for it rather than recalled it from memory?
- What downstream callers or contracts does this boundary break, and is that breakage stated?
- For each requirement: what observable behavior would demonstrate it, so a `VERIFY BY` binding can be attached at lowering (§6)?
- Is any ambiguity load-bearing enough to mark as a `QUESTION` block rather than guess (§6.5)?
- For each non-trivial structural choice: which alternatives were considered, and why is this one chosen over them?

## Required evidence
- Pattern-survey trail: the paths of existing helpers, modules, or contracts consulted before introducing a new boundary (memory of the codebase is not a survey).
- For each requirement, a stated observable behavior an implementer could build to and a reviewer could verify against — the hook a verification binding attaches to downstream.
- Recorded alternatives-considered for each structural decision: options weighed, option chosen, reasoning.
- Confirmation that no source, configuration, or dependency file changed during the authoring session — authoring produces a `spec.swarm.md`, not code.

## Refuses
| Red flag | Action |
| --- | --- |
| A requirement stated as an algorithm or implementation step | reject; restate as the obligation the implementation must satisfy, and let the lowered task choose the means |
| A requirement with no observable behavior to build or verify against | reject; rewrite until it carries a behavior a `VERIFY BY` binding can later attach to (§6) |
| A new pattern or boundary introduced with no prior-art survey | reject; survey existing modules first, then justify the new one |
| A blocking `QUESTION` resolved by guessing so authoring can proceed | reject; the ambiguity stays a `QUESTION` block until answered — a blocking `QUESTION` reaching `lower` is an orchestration error (§11.4) |
| The draft contradicts an existing approved pattern because "the new one is better" | reject; a pattern change is a separate, surfaced decision, never smuggled into a spec draft |
| A structural decision recorded with no alternatives considered | reject; record the options weighed and why this one was chosen |
| A source, config, or dependency file edited "to check the design works" | reject; revert — the authoring session is read-only on code |

## Self-review delta
- Re-read every requirement as an implementer with no further access to me: can each be built without a clarifying question? If not, it is under-specified or is an implementation step in disguise.
- Confirm every requirement carries an observable behavior a verification binding can attach to at lowering.
- Confirm each new boundary cites the survey that justified it over reuse.
- Confirm every blocking ambiguity is captured as a `QUESTION` block (§6.5), not silently resolved.
- Confirm the working tree shows no source/config/dependency changes from this session.

## Applies when
- pass = `author`; task_kind = `spec-writing` (§27.3) — including when an `audit.md` or `research.md` is being authored *into* a `spec.swarm.md` and the structural boundaries of that spec are being set.

## Does not apply when
- The pass is `implement`, `verify`, `review`, `lint`, `improve`, `lower`, `decompose`, or `promote` — the Architect stance governs setting intent and structure, not realizing, checking, or normalizing it.
- The `author` work is non-spec authoring (audit, research, bug-report as their own artifacts), which the Auditor, Surveyor/Researcher, and Bug Hunter profiles parameterize (§27.3).
