# Spec — step rubric

*Advanced design note — internal rationale; not needed to use Swarm.*

> The bar for the Spec step: every requirement is identifiable and checkable, every claim traces
> to a source or is marked a decision, and every ambiguity is surfaced instead of silently
> resolved. Each predicate is a boolean a scorer decides by comparing the sources against the
> spec.

Spec turns captured input into intended behavior. This rubric grades fidelity and checkability —
not whether the resulting design is good, and not grammar hygiene, which the
[checks catalogue](../docs/reference/checks.md) covers.

**Input artifact:** the intake file(s) and any supporting documents (inventory, research, audit).
**Output artifact:** the spec ([template](../starter-kit/templates/spec.md)).

## Predicates

Each predicate must hold. Any single failing predicate fails the step.

| # | Predicate | Holds when | Fails when |
|---|---|---|---|
| S1 | **Requirement form** | Every requirement has an `AC-NNN` id and a `Verify with:` line (or the structured-requirements equivalent under `format: sol`). | A requirement has no id, or no verification method. |
| S2 | **Stance preserved** | What a source asks for stays a requirement; what a source merely observes stays context. An observation becomes a requirement only by explicit restatement under its own AC id. | A source's stance is flipped — an observation silently acquires binding force, or an ask is demoted to background prose. |
| S3 | **Uncertainty surfaced** | Every ambiguity in the sources lands under Open questions or as a recorded interpretation; a spec with open questions is not `status: ready`. | An ambiguity is resolved silently, or left buried in prose where no one will answer it. |
| S4 | **Nothing invented as sourced** | Every requirement traces to a named source or is visibly an authoring decision; deliberate omissions land under "Dropped from sources". | A requirement asserts behavior no source asked for, reading as if the ticket demanded it. |

## Why these predicates carry weight

Ambiguous or incomplete task input measurably degrades agent code correctness
[[ORCHID]](../docs/research/sources.md#ORCHID)
[[HUMANEVALCOMM]](../docs/research/sources.md#HUMANEVALCOMM), and models usually code anyway
instead of asking [[HUMANEVALCOMM]](../docs/research/sources.md#HUMANEVALCOMM)
[[HILBENCH]](../docs/research/sources.md#HILBENCH) — which is why S3 fails a spec for *burying*
an ambiguity even when every requirement is otherwise well-formed. The `Verify with:` line S1
demands is the highest-value line in the file: an executable acceptance criterion is the
strongest task-input signal yet measured [[ORACLESWE]](../docs/research/sources.md#ORACLESWE).

## Notes for the scorer

- The form half of S1 is toolable — swarm-cli's `swarm spec check` flags a requirement with no
  id or no verification method. The fidelity half (S2–S4) needs the sources open beside the spec
  and stays a checklist judgment.
- The conditional steps produce authored documents too: score an inventory or a change plan with
  these same predicates against its own template, reading "sources" as the codebase observed
  (inventory) or the spec plus inventory (change plan).

## Cross-step predicates scored here

- **Re-parses clean** — the file reads as `type: spec` with the template's frontmatter and
  sections; requirement ids are unique and well-formed.

## Not graded here

Whether the requirements are *satisfiable*, and whether the eventual change meets them — those
surface at Run and Review, scored by [run.md](run.md) and [review.md](review.md).

## Related

- [Spec template](../starter-kit/templates/spec.md) — the frozen format this rubric reads against.
- [Writing specs](../docs/04-writing-specs.md) — the guide for the step under test.
- [Checks](../docs/reference/checks.md) — the hygiene catalogue this rubric deliberately leaves to.
