# Run — step rubric

*Advanced design note — internal rationale; not needed to use Swarm.*

> The bar for the Run step: the agent's summary is an honest record — every changed file named,
> every check run with its real output pasted, every departure from scope declared. Each
> predicate is a boolean a scorer decides by comparing the task packet and the diff against the
> run summary.

Run is the agent doing the work. This rubric does not grade the code; it grades the **record**
the agent leaves behind, because that record is what Review judges. An honest record of a failed
run scores better here than a glossy record of a hidden one.

**Input artifact:** the task packet and the diff the run produced.
**Output artifact:** the agent's run summary (changed files, commands run, findings — as the
packet's agent instructions require).

## Predicates

Each predicate must hold. Any single failing predicate fails the step.

| # | Predicate | Holds when | Fails when |
|---|---|---|---|
| R1 | **Changed files complete** | The summary names every file the diff touches. | The diff touches a file the summary omits — the run claims a smaller footprint than reality. |
| R2 | **Real output pasted** | Every Verify item in the packet was run, and the summary carries the command with its real output. | A check is skipped silently, or reported as a bare "tests passed" with no output — a claim without output counts as unverified [[REFLEXION]](../docs/research/sources.md#REFLEXION). |
| R3 | **Out-of-scope edits declared** | Every edit outside the packet's scope or inside its "Do not change" areas is declared in the summary with a reason. | An out-of-bounds hunk goes unmentioned. |
| R4 | **Stuck means stop** | A requirement that could not be met as written is reported with why. | The agent improvised around the requirement and reported success. |

## Notes for the scorer

- R1's decisive set is diff-minus-summary: a non-empty remainder is the dangerous direction —
  understating the footprint. Overstating (a listed file the diff never touched) is sloppy but
  routes to Review as noise, not as a hidden edit.
- R3 does not forbid out-of-scope edits — sometimes the fix genuinely needs one. It forbids
  *silent* ones: declared, they become a Human attention row at Review; silent, they become an
  unreviewed change in production.

## Cross-step predicates scored here

- **Chain unbroken** — every scoped requirement is either addressed in the summary or declared
  blocked with a reason; none simply disappears between the packet and the record.
- **Result consistent with evidence** — every claim in the summary is backed by what its pasted
  output actually shows; a green claim over red output fails here even if R1–R4 hold.

## Not graded here

Whether each requirement is *actually* met — Review judges that against the evidence, scored by
[review.md](review.md). Run is graded on the honesty and completeness of its record.

## Related

- [Task template](../starter-kit/templates/task.md) — the agent instructions whose record this rubric grades.
- [Running agents](../docs/07-running-agents.md) — the guide for the step under test.
- [review.md](review.md) — where the record is judged.
