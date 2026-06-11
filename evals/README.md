# Step rubrics

*Advanced design note — internal rationale; not needed to use Swarm.*

This directory holds Swarm's producer-side self-tests: one rubric per step of the loop —
**Pull → Spec → Task → Run → Review → Close** — that scores whether a step was actually
*performed*, not just whether its output file matches a template. They grade this repository's
own examples and fixtures, and any agent executing the loop. They are not installed into an
adopted workspace: an adopter gets the templates and guides, not these pages.

## What a rubric is

Each rubric is a small set of **checkable boolean predicates** over a step's **input artifact**
and **output artifact** — never a quality score, never a running tool. A predicate either holds
or it does not, and it is decidable by reading the two files alone. **A single failing predicate
fails the step.**

Rubrics exist because a well-formed file is not a well-performed step. A task packet can match
[the template](../starter-kit/templates/task.md) perfectly and still pull a requirement its spec
never stated; a review packet can have every column filled and still rest on the agent's own
summary. The [checks catalogue](../docs/reference/checks.md) covers format and hygiene; these
rubrics grade the transformation between the files.

Every predicate here is a **checklist**-level rule: a scorer decides it by reading; nothing in
this repository runs or enforces it. Where a predicate is toolable, the page says so and names
the swarm-cli command.

## The rubrics

| Step | Rubric | Grades |
|---|---|---|
| Pull | [pull.md](pull.md) | verbatim capture, provenance, no editorializing |
| Spec | [spec.md](spec.md) | requirement form, fidelity to sources, surfaced uncertainty |
| Task | [task.md](task.md) | scope drawn from the source, boundaries declared, checks mapped |
| Run | [run.md](run.md) | complete summary, real output, declared exceptions |
| Review | [review.md](review.md) | full coverage, evidence-backed results, routed exceptions, honest gate |
| Close | [close.md](close.md) | findings saved, board updated, nothing left dangling |

The conditional steps — Inventory and Change Plan — produce authored documents, so they are
scored with [spec.md](spec.md)'s fidelity predicates against their own templates. Teams running
the full nine-step lifecycle score the finer steps with
[advanced-lifecycle.md](advanced-lifecycle.md).

## The cross-step predicates

Four predicates are not owned by a single step: they assert the loop-wide invariants, and the
suite scores them wherever the relevant artifact appears. Each rubric page re-states the ones
that apply at its step; this table is the single definition.

| Predicate | What it asserts | Scored at |
|---|---|---|
| **Re-parses clean** | Every file a step writes still reads as its `type:` — frontmatter fields and required sections per its template, so a second reader reconstructs the same artifact. | Pull, Spec, Task, Review, Close |
| **Chain unbroken** | The requirement → task → review chain holds end to end: every scoped requirement reaches a review row, and every task scope item, verify item, and review row names a requirement that exists upstream. | Task, Run, Review |
| **Result consistent with evidence** | Every recorded result matches what its evidence actually shows: a Pass carries pasted output or a CI link; an empty Evidence cell means Unverified, never Pass. | Run, Review |
| **Drift surfaced** | A mismatch between what the spec says and what was built is named somewhere visible — a coverage row, a Human attention entry, a board item — never silently passed. | Review, Close |

## How a rubric is scored

1. Read the step's input artifact and its output artifact.
2. Decide each predicate on the rubric page as a boolean, citing the span that decides it.
3. Re-check the cross-step predicates listed for that step.
4. Report the failing predicates. **Any failing predicate fails the step.**

Because every predicate is decided from the files alone, the score is reproducible by hand today
and automatable later without trusting the agent under test. The
[checks fixtures](../conformance/README.md) are the pinned test data a checker scores these
predicates over.

## Related

- [Basic workflow](../docs/02-basic-workflow.md) — the loop these rubrics grade.
- [Checks](../docs/reference/checks.md) — the format and hygiene catalogue these rubrics build on.
- [Templates](../starter-kit/templates/) — the frozen artifact formats every rubric reads against.
- [Advanced-lifecycle rubrics](advanced-lifecycle.md) — the finer-step bars for high-risk work.
