# Output economy

How agents should shape output: readable and economical, by convention (ADR-0109). A floor, not a rule
a tool enforces.

## The floor

- **Evidence first.** Lead with the result/finding and its evidence; put prose after, if at all.
- **Structure over prose.** Use a table or list when it carries the same signal in less space.
- **Signal-dense.** No filler, no restating the prompt, no persuasion. Cut what a reader would skim.
- **Reason free, emit lean.** Think in whatever form works; emit the structured artifact ([[FORMATFREE]](../research/sources.md#FORMATFREE)).
- **Justify to be checked, not to convince.** A "why" exists to make verification cheap — long
  persuasive prose raises trust without raising scrutiny ([[OVERRELIANCE-REVIEW]](../research/sources.md#OVERRELIANCE-REVIEW)).

## Clarity outranks brevity

Never compress at the cost of correctness or safety. Keep full, unambiguous prose for:

- security notes and irreversible-action confirmations
- multi-step sequences where order matters

Brevity is the default, not a mandate.

## The dial

Want stronger economy? Install the optional concision skill from the
[suspec-skills](https://github.com/jcosta33/suspec-skills) catalog. It is opt-in conditioning — not a
Suspec requirement, and not a runtime hook.

## The artifact leverage test

The same economy applies to *artifacts*, not just an agent's chat output (ADR-0131, extending ADR-0109).
Every artifact, section, and template earns its place by improving at least one of:

- **clarity** — the intent is easier to understand
- **scope** — what is in and out of bounds is pinned
- **execution-context** — the implementer knows something they'd otherwise guess
- **verification** — a claim becomes checkable
- **reviewability** — a reviewer can judge it faster or better
- **durable-memory** — a lesson survives past this task

If a section serves none of these — no consumer reads it, nothing changes when it's gone — cut it. This
is a **checklist** item (a spec-check / review question), not something a tool enforces. It is the
artifact-level companion to [the rigor ladder](rigor-escalation.md): the ladder decides *how many*
artifacts a change warrants; the leverage test decides whether *this* artifact (or section) is pulling
weight.

## Related

- [Rigor ladder](rigor-escalation.md) · [Principles](principles.md) · [Vocabulary tiers (glossary)](glossary.md) · [ADR-0109](../adrs/0109-output-economy-convention.md) · [ADR-0131](../adrs/0131-minimum-useful-rigor.md)
