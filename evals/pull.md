# Pull — step rubric

*Advanced design note — internal rationale; not needed to use Swarm.*

> The bar for the Pull step: the intake file is a faithful snapshot of what was actually asked —
> copied verbatim, fully attributed, and free of interpretation. Each predicate is a boolean a
> scorer decides by comparing the upstream source against the intake file.

Pull captures the upstream request — a ticket, an issue, a thread — as an intake file before
anyone interprets it. The intake preserves; the spec interprets. This rubric grades the
preservation only.

**Input artifact:** the upstream source (ticket, issue, thread, page).
**Output artifact:** the intake file ([template](../starter-kit/templates/intake.md)).

## Predicates

Each predicate must hold. Any single failing predicate fails the step.

| # | Predicate | Holds when | Fails when |
|---|---|---|---|
| P1 | **Verbatim snapshot** | The body is the upstream content as written — copied, not retold. | The content is summarized, reordered, trimmed, or "cleaned up"; part of the source is silently dropped. |
| P2 | **Provenance present** | The frontmatter carries a real `source`, `url`, and `captured` date. | Any of the three is missing, or still a placeholder. |
| P3 | **No editorializing** | The capture adds no interpretation, opinion, priority call, or requirement of its own; any capture note is clearly separated from the source text. | Commentary is woven into the source text, or the capture states something the source never said. |

## Notes for the scorer

- The decisive comparison for P1 is source-minus-intake: any span present upstream but absent
  from the intake (or altered in it) is a verbatim failure. An ugly, rambling, contradictory
  ticket captured exactly as written is a *passing* intake.
- P3 cuts the other way: intake-minus-source. New sentences, reworded asks, or an added "this
  is really about X" belong in the spec, where they are visible as interpretation.

## Cross-step predicates scored here

- **Re-parses clean** — the file reads as `type: intake` with the template's frontmatter fields
  present; a second reader reconstructs the same capture.

## Not graded here

Whether the request is clear, feasible, or worth doing — that is the Spec step's problem, scored
by [spec.md](spec.md). Pull is judged purely on fidelity of capture.

## Related

- [Intake template](../starter-kit/templates/intake.md) — the frozen format this rubric reads against.
- [Basic workflow](../docs/02-basic-workflow.md) — where Pull sits in the loop.
- [spec.md](spec.md) — the next step's rubric, where interpretation is graded.
