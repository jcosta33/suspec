# Skill (documentation): `write-spec`

> **For agents:** instructions → [`/scaffold/.agents/skills/write-spec/SKILL.md`](../../scaffold/.agents/skills/write-spec/SKILL.md)

---

## TL;DR

Specs are executable contracts pretending to be Markdown. `write-spec` encodes the completeness heuristics that keep a downstream implementer from inventing the missing behavioural atoms. The skill self-activates when the user asks for a spec, requirements doc, design doc, or acceptance criteria — even phrased as "just write up what we want" — and stays out of present-state observations (those are audits) and defect records (those are bug-reports).

## What the skill actually enforces

A spec is the contract between whoever specifies and whoever builds; an implementer reading it should not need follow-up questions. The body's rules: every requirement is **testable** (a test author can derive a test from each acceptance criterion); state **requirements, not implementations** (the implementer picks the mechanism); **survey existing patterns** before introducing new ones, citing the consulted paths; and document every structural decision with **named, rejected alternatives** (a decision without alternatives can't be told from an oversight).

The hard gate is `[CRITICAL]` open questions — a `[CRITICAL]` is any question whose answer would change the spec's content, and the spec is not finalisable while one is open. The body's **pre-deliver visibility gate** forces the agent to output the `[CRITICAL]` list verbatim and confirm `(none — spec is finalisable)` before delivering; an outstanding `[CRITICAL]` routes to a research/ADR/audit task or a recorded design decision that downgrades it to `[MINOR]`.

## Why authoring is its own skill

Authoring optimises for **density and testability**. It is not a routing check ("is this still a spec and not an audit in disguise?") — that recommendation lives in the framework's routing model, not in an enforced gate. Keeping authoring focused on crispness avoids the historical failure of a single skill that both writes specs and policies their genre, which tends to bloat one duty and soften the other.

## Philosophical hinges

| Choice | Reason |
|--------|--------|
| Acceptance criteria map to assertions | A downstream testing pass can derive tests without interpretive leaps. |
| Named-alternatives log is mandatory | Surfaced rejections close off future reopen battles over already-decided ground. |
| Distillation linkage when distilling from research | Signals inherited research deltas honestly; pairs with the distillation-discipline gate. |

## The architect-prose trap

The architecting mindset (carried by this skill — there is no separate "narrate the spec" persona) must resist telling a triumphant saga instead of pinning interface truth. The body bans speculation dressed as a requirement: a spec states what must hold, not the story of how the team got there.

## Downstream ergonomics

Anything left vague becomes an implementer's `## Blocker`, multiplied by every review cycle that bounces off it. Crispness invested up front is cheaper than the kickback churn it prevents.

## Command resolution

A spec is read-only on code, so it rarely runs project commands — but where it does (e.g. confirming an existing API shape), it resolves them by name through `AGENTS.md > Commands` and asks the user if an entry is missing rather than guessing.

## Failure modes

- Bundling retrospective observations into the spec → audit leakage that wastes a review pass.
- Acceptance criteria fused with implementation detail → premature rigidity the refactor pass must later unwind.
- Leaving a `[CRITICAL]` open and proceeding → the implementer inherits the unresolved decision.

## Bundled resources

- `references/task-template.md` — a fillable spec-writing task template that combines the workflow scaffold (metadata, AGENTS.md command contract, constraints, progress checklist, decisions, Self-review) with the deliverable inlined as a `## Deliverable` block (goal, scope, acceptance criteria, design decisions with alternatives, architectural constraints, pattern survey, open questions, Distillation Loss Statement). At session close, copy the `## Deliverable` block to its final home (`<your-specs-dir>/{{slug}}.md`).

## Related

- [Document: spec](../documents/spec.md)
- [Task: spec-writing](../tasks/spec-writing.md)
- [Distillation-discipline skill](distillation-discipline.md)
