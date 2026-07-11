---
type: adr
id: adr-0144
status: accepted
created: 2026-07-11
updated: 2026-07-11
---

# ADR-0144 — Keys and scaffold: intent, review, and findings are the keys; everything else is scaffold

## Context

1. **Optionality vocabulary stopped carrying information.** With the store retired
   ([ADR-0141](./0141-artifacts-beside-native-artifacts.md)) and the tools demoted to
   reinforcement ([ADR-0140](./0140-skills-are-the-product-tools-reinforce.md)), Suspec is an
   opinionated engine for the agent's internal working artifacts — nothing in it is imposed, so
   *everything* is optional in the trivial sense. A doctrine built on mandatory-vs-optional
   ([ADR-0134](./0134-self-contained-spine.md)'s triad) now sorts the parts by a distinction
   that no longer separates them.
2. **The derived surfaces had already drifted apart.** The rewritten loop pages carried the
   review inside the numbered happy path while the ledger still called it an optional layer —
   two stories about the same step. The useful question is not "which steps may I skip?" but
   "which parts will I touch on virtually every change, however light, and which parts does the
   work pull in when it earns them?"
3. **The owner named the keys.** Every change starts with intent — even when the next step is
   straight to code. Nearly every change ends with a judgment of the result and a decision about
   what it taught. Those three moments — intent, review, findings — are present at minimum
   ceremony; the rest is what Suspec builds around them.

## Decision

1. **The keys: intent → review → findings.** The three parts of the loop present on virtually
   every change, at whatever weight the change earns. Intent may be one sentence folded inline;
   review may be the owner reading the diff; findings may be the deliberate decision that
   nothing durable was learned. Weight flexes ([ADR-0131](./0131-minimum-useful-rigor.md));
   presence is the norm. _Level: convention._

2. **The scaffold: what Suspec erects around the keys when the work earns it.** The spec (the
   structured form intent graduates into), the task split, the inventory, the change plan, and
   the deterministic checker are scaffold — pulled in proportionally, never a station to pass
   through. Implementation itself is neither key nor scaffold; it is the work the loop exists
   to serve. _Level: convention._

3. **Keys-and-scaffold replaces mandatory-vs-optional as the doctrine and the vocabulary.**
   Docs, skills, and the site describe parts as keys or scaffold; they do not sort steps into
   mandatory and optional bins. _Level: convention._

4. **The seal reads accordingly.** The hexagon is the full loop
   (intent · spec · implement · review · check · findings); the triangle inside it is the three
   keys (intent · review · findings). _Level: convention._

## Superseded and narrowed decisions

**Narrowed:**
- [ADR-0134](./0134-self-contained-spine.md) — Decision 1's mandatory triad
  (`spec → run → close`, with intake/task/review as optional steps) is replaced by Decisions
  1–3 above. Decision 2 stands verbatim (artifact relationships are not optional once a part is
  used; a review reconciles against the spec, never the task). Decision 3 stands verbatim
  (every part keeps a by-hand path; skills and tools are additive; no canonical part depends on
  an optional one — now read as: no key depends on scaffold).
- [ADR-0140](./0140-skills-are-the-product-tools-reinforce.md) Decision 4 — proportional rigor
  stands, restated through this lens: the keys are always present, the scaffold is what
  proportionality dials.

**Upheld:** [ADR-0131](./0131-minimum-useful-rigor.md) (the weight dial),
[ADR-0121](./0121-evidence-gating-load-bearing-mechanic.md)-as-narrowed (the review key is
where the evidence discipline and the deterministic floor live),
[ADR-0142](./0142-findings-become-native-memories.md) (the findings key's destination).

## Alternatives considered

| Alternative | Why rejected |
|---|---|
| Keep ADR-0134's triad and re-demote review to an optional layer | Restores ledger consistency but tells adopters the honesty floor's home is a skippable extra — the product's flagship mechanic would hang off an "optional" step. |
| Declare review mandatory | Contradicts the engine's whole posture: nothing is imposed; "mandatory" is the vocabulary this decision retires. |
| Keys = spec · review · findings (the previous seal reading) | The spec is the form intent takes when the work earns structure — at minimum ceremony it collapses into a sentence of intent. Intent is the invariant; the spec is its scaffold. |

## Consequences

- Positive: one story everywhere — the loop pages, the skills, and the seal say the same thing;
  the trivial path stops looking like an exception to the doctrine and becomes its cleanest
  expression (keys only, zero scaffold).
- Negative: a vocabulary migration across canon, skills prose, and the site (this ADR's
  propagation); "optional" lingers in older ADR bodies, which stay immutable.
- Neutral: the seal's geometry is unchanged; only its stated semantics move.

## Status

Accepted (2026-07-11). Narrows [ADR-0134](./0134-self-contained-spine.md) and
[ADR-0140](./0140-skills-are-the-product-tools-reinforce.md) Decision 4; upholds
[ADR-0131](./0131-minimum-useful-rigor.md),
[ADR-0142](./0142-findings-become-native-memories.md). Part of the
[ADR-0140](./0140-skills-are-the-product-tools-reinforce.md) re-founding.

## Propagation

- `docs/adrs/README.md` — ledger row + disposition notes on 0134 and 0140.
- Canon: `docs/02-basic-workflow.md` (keys and scaffold replace "the loop" + "the optional
  layers"), `docs/01-what-is-suspec.md`, `README.md`, `docs/reference/cheatsheet.md`,
  `docs/reference/glossary.md` (key · scaffold entries), tutorial and examples where they sort
  steps by optionality.
- corpus-skills: catalog prose that sorts the loop into mandatory/optional.
- corpus-website: the loop page, the step rail, the seal/logo semantics (hexagon = the loop,
  triangle = intent · review · findings), what-is-suspec.
- corpus-works: the workspace bootloader's triad line.
