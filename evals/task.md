# Task — step rubric

*Advanced design note — internal rationale; not needed to use Swarm.*

> The bar for the Task step: the packet's scope is drawn entirely from its named sources, its
> boundaries are stated, and every scoped requirement has a check the agent can run. Each
> predicate is a boolean a scorer decides by comparing the source spec (and change plan, if any)
> against the task packet.

Task bounds the agent's work. A packet that invents a requirement, omits its boundaries, or
leaves a requirement uncheckable hands the agent exactly the ambiguity the spec existed to
remove — and preliminary evidence places the handoff into the coding agent as the dominant
multi-agent failure surface [[PLANCODER]](../docs/research/sources.md#PLANCODER).

**Input artifact:** the source spec — and the change plan, when the task executes one.
**Output artifact:** the task packet ([template](../starter-kit/templates/task.md)).

## Predicates

Each predicate must hold. Any single failing predicate fails the step.

| # | Predicate | Holds when | Fails when |
|---|---|---|---|
| T1 | **Scope drawn from the source** | Every requirement id in the packet's scope exists in the named spec or change plan. | The scope carries an id its sources never defined, or an id from a document the packet does not name. |
| T2 | **Boundaries declared** | "Do not change" is present and substantive — it names real areas the agent must leave alone. | The section is missing, empty, or boilerplate that bounds nothing. |
| T3 | **Checks mapped to scope** | Every Verify item names a scoped requirement id, and every scoped requirement has at least one Verify item. | A scoped requirement has nothing that checks it, or a Verify item checks nothing in scope. |

## Notes for the scorer

- T1 is a subset check: scope ids minus the union of the named sources' ids must be empty. The
  packet may scope *fewer* requirements than the spec defines — partial scope is normal; phantom
  scope is the failure.
- For T3, the requirement's own `Verify with:` line is the natural Verify item; a packet that
  swaps it for something weaker without a reason is leaving the strongest signal on the table.
- The packet carries the requirements it scopes as stated in the spec — a paraphrase that drifts
  from the source text is scored against T1, because the agent will implement the paraphrase.

## Cross-step predicates scored here

- **Re-parses clean** — the file reads as `type: task` with the template's frontmatter and
  sections.
- **Chain unbroken** (opening half) — every scope item and Verify item resolves to a requirement
  that exists upstream; nothing in the packet points at a phantom.

## Not graded here

Whether the agent honored the packet — that is the Run step, scored by [run.md](run.md). A
perfect packet ignored at Run fails Run, not Task.

## Related

- [Task template](../starter-kit/templates/task.md) — the frozen format this rubric reads against.
- [Creating tasks](../docs/06-creating-tasks.md) — the guide for the step under test.
- [run.md](run.md) — where the packet's instructions are graded for compliance.
