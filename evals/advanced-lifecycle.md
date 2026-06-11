# Advanced-lifecycle rubrics

*Advanced design note — internal rationale; not needed to use Swarm.*

> The bars for the finer steps of the [nine-step lifecycle](../docs/reference/advanced-lifecycle.md)
> — `author → lint → improve → lower → decompose → implement → verify → review → promote` —
> compressed onto one page. Same scoring model as the [six-step rubrics](README.md): boolean
> predicates over a step's input and output artifacts, any failing predicate fails the step.

The six-step rubrics keep applying at their loop positions (Spec covers `author`–`improve`,
Task covers `lower`–`decompose`, Run covers `implement`–`verify`, Review covers `review`, Close
covers `promote`). This page adds what the finer steps are *additionally* accountable for when a
team runs them explicitly on high-risk work. This page may use the reference-tier names — the
[glossary](../docs/reference/glossary.md) maps them to the happy-path vocabulary.

## `author` — write the source document

Scored by [spec.md](spec.md)'s predicates (requirement form, stance preserved, uncertainty
surfaced, nothing invented as sourced) against whichever document the step writes — spec,
inventory, change plan, or audit — each read against its own template.

## `lint` — diagnose without touching

- Every defect from the [checks catalogue](../docs/reference/checks.md) present in the document
  is reported with its check code and severity; a defective document is never reported clean.
- Every **blocking** defect is caught — partial recall on advisory checks is tolerable, a missed
  blocker is not.
- Not one character of the document changes. A lint that rewrites has overstepped into
  `improve`; a lint report over a silently edited document fails regardless of its recall.

Toolable: swarm-cli's `swarm spec check` is the reference implementation of these checks.

## `improve` — repair without meaning change

- No edit changes what any requirement asks: actor, trigger, behavior, or strength. The only
  approval-free edits are textual repairs.
- No requirement id, requirement, or `Verify with:` line is dropped or weakened across the diff.
- Every edit is attributable to one of the ten improve operations
  ([defined here](../docs/reference/advanced-lifecycle.md#the-ten-improve-operations)); an edit
  no operation explains is an unreviewed authoring decision.
- Every blocking check from `lint` is repaired or explicitly carried forward with a reason —
  never deleted from the report while the defect remains in the text.
- A meaning-changing edit is escalated as an amendment and flagged for review — never applied
  silently as a repair.

## `lower` — structure without loss

- Every requirement survives into the structured form with its id, verification method,
  dependencies, and the files it may touch — nothing dropped, nothing weakened in transit.
- No invented dependency: every dependency in the structured form traces to a stated
  relationship in the spec.
- Nothing is emitted while a blocking open question stands — the clarify-before-splitting
  checkpoint. Splitting work over an open ambiguity hands the ambiguity to every agent at once.

## `decompose` — partition safely

- Tasks planned to run in parallel have pairwise-disjoint written files, or an explicit
  dependency serializes them.
- The partition respects dependency order and contains no cycle.
- Every in-scope requirement is assigned to exactly one task — none unassigned, none assigned
  twice (the coverage-before-running checkpoint).
- Each task carries its requirements as stated in the spec, not paraphrases — the agent
  implements the text it is handed.

When several agents run at once, the coordination record's ownership rows are scored under the
first predicate: owned paths pairwise disjoint across workers, confirmed before anyone spawns.

## `implement` — work inside the lines

Scored by [run.md](run.md) (changed files complete, real output, declared out-of-scope edits,
stuck-means-stop), sharpened by one scope predicate:

- The diff stays inside the task's affected areas; the recorded changed-file set is never
  narrower than the diff. Understating the footprint is the dangerous direction — it hides
  edits from review.

## `verify` — gather evidence, judge nothing

- Every verification method named by the task is run, and every scoped requirement gets exactly
  one recorded result — Pass, Fail, Blocked, or Unverified.
- A verification method that cannot run records **Blocked, never a silent Pass**; one that was
  never bound or never run records Unverified — the weaker, more honest claim.
- Every result cites the command and its real output; no requirement is recorded satisfied on a
  check that produced nothing.

`verify` gathers; `review` judges. A pasted test run is evidence — calling it a Pass on a
requirement is the next step's call.

## `review` — judge and gate

Scored by [review.md](review.md) (coverage, evidence, routed exceptions, honest gate,
spot-check), extended by the full result model:

- The lifecycle values are applied wherever their condition holds, with their required fields:
  **Waived** (on Fail or Unverified only — who, why, expiry), **Stale** (on a prior Pass whose
  text or exercised code changed — prior result, what changed), **Contradicted** (anywhere two
  pieces of evidence disagree — both references). A condition that holds with no value applied
  fails, and so does a value applied without its condition.
- The merge gate follows the rule in plain words: merge only when every requirement in scope
  shows Pass or a live Waived — and none shows Fail, Blocked, Unverified, Stale, or
  Contradicted. A gate opened over an unreconciled Stale row is a failure: stale evidence is a
  claim about a system that no longer exists.
- An empty scope never passes by vacuity, and results are judged against the spec, the diff,
  and the evidence — never the run record's self-report alone
  [[SELFPREFER]](../docs/research/sources.md#SELFPREFER)
  [[JUDGEBIAS]](../docs/research/sources.md#JUDGEBIAS).

## `promote` — save what outlives the task

Scored by [close.md](close.md) (findings saved, board updated, nothing pending), sharpened by:

- Every saved finding carries its provenance: where it came from, the evidence that grounds it,
  and where it applies / does not apply.
- A finding that contradicts a requirement is surfaced for reconciliation — it never silently
  outranks the spec. Intent changes by amendment, not by accumulated findings.
- Nothing ephemeral is saved as durable: scratch notes, transient debugging, and one-off output
  stay in the task record.

## Cross-step predicates

The [four cross-step predicates](README.md#the-cross-step-predicates) apply unchanged; the chain
simply gains links — requirement → structured item → task → result → review row — and "chain
unbroken" is scored across all of them. Every predicate on this page is a checklist-level rule
unless a swarm-cli command is named beside it.

## Related

- [The advanced lifecycle](../docs/reference/advanced-lifecycle.md) — the steps, the ten improve
  operations, the full result model, and the merge gate these rubrics grade against.
- [Step rubrics](README.md) — the six-step bars this page extends.
- [Checks](../docs/reference/checks.md) — the catalogue `lint` reads and `improve` repairs.
