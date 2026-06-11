---
name: write-rfc
type: agent-guide
description: >-
  Write an RFC: ONE pre-decision proposal — problem, advocated approach,
  alternatives, decision requested — committing to nothing and writing no
  requirements, so *why this approach and not the others* outlives the change.
  ALWAYS apply when asked to write, draft, or revise an RFC or design proposal,
  or when weighing alternatives before committing. Never write requirements,
  leave the alternatives section empty, or word a sentence as a decision. Skip
  for a decision already made (an ADR), the spec written from it, an audit, a
  bug report, or commit-to-nothing research.
---

# Writing an RFC

*Works today — plain markdown plus your agent; no Swarm tooling required.*

A design discussed only in chat is forgotten the moment the session ends; six months later no
one can reconstruct *why this approach and not the alternatives*, and the rejected options get
re-litigated from scratch. An RFC is the durable answer: one technical proposal — the problem
that forces it, the advocated approach, the alternatives weighed against it, the exact decision
asked for. The format is the kit template `starter-kit/advanced/rfc.md` (Problem · Proposal ·
Alternatives · Migration plan · Open questions · Decision requested); do not reinvent its
sections. In this repo an accepted RFC lands as an ADR under `docs/adrs/`; in an adopted
workspace it lives in `specs/<feature>/`, beside the spec it argues for.

The stance is **proposal**: advocate one approach in enough detail to be evaluated, record the
comparison that justifies it, and decide nothing. The rules below are conventions backed by
review — nothing in this repo enforces them.

## Rules

### 1. State the problem and cite its source

Open with the technical problem forcing a proposal, in enough detail that a reader can judge
whether the proposal answers it. Cite the originating document — a PRD, a finding, an audit —
where one exists, rather than re-deriving it. State what *is* wrong, never what the system
*must* do: the latter is a requirement, and an RFC writes none.

### 2. Advocate exactly one approach, in enough detail to evaluate

Describe the single approach you advocate — the design, how it works, what it touches — so a
reviewer can weigh it against the alternatives. Describe a mechanism; write no requirements. A
proposal too vague to be evaluable records no real comparison; one written as requirements has
become a contract before anyone approved it.

### 3. Record the alternatives as a table — "none" is a defect

Fill the alternatives section as a two-column table — `Alternative | Why weaker than the
proposal` — with at least one real row. Each row is a recorded judgment a future reader (or a
superseding RFC) can reopen. The comparison is the RFC's whole value: a future reader trusts the
chosen approach because the rejected ones sit written down beside it. If you genuinely cannot
name an alternative, the proposal is under-explored — the section is not optional.

### 4. Write the migration plan as ordered steps

List the steps from the present state to the proposed state — a numbered prose sequence.
Adoption ordering is part of evaluating a proposal: a great design with an impossible migration
is a weak proposal. Keep it prose; task splitting and verification happen later, downstream of
the decision.

### 5. Surface every unresolved point as an open question

List each unresolved point that gates the decision, and say whether it blocks. Behavioral
uncertainty is lifted into an explicit question, never left as hedged prose ("we might…", "it
could…"). An RFC with a blocking open question is not ready for a decision — resolve or
downgrade it before asking for one.

### 6. State the exact decision requested and where it lands

Close with the precise decision asked for, naming where the proposal lands on acceptance — in
this repo, an ADR in `docs/adrs/` (and the docs/ pages that will carry the rules); in an adopted
workspace, an ADR in `decisions/` and/or the spec in `specs/<feature>/`. An RFC exists to be
*decided*; a proposal that does not say what decision it asks for cannot be acted on — and
naming the target reminds everyone the requirements are written *there*, on acceptance, not
here.

### 7. Keep every sentence pre-decision

Set the frontmatter per the template (`type: rfc`, `id`, `title`, `status: proposed`, `owner`,
`sources[]`), then re-read the whole file against one line: is any sentence worded as a settled
choice or an approved contract? "We will adopt X" and "the system must do Y" smuggle a decision
or a requirement into a pre-decision document — rewrite as "this RFC proposes X because…", and
lift any genuine requirement into the decision-requested section as what the spec would carry
on acceptance.

## What does not belong

- **Requirements in any form** — no AC items, no SOL blocks
  (`docs/reference/structured-requirements.md`); they are written into the spec on acceptance.
- **A settled decision** — that is an ADR; an accepted RFC's content moves into one.
- **Present-state observation and risk** — that is an audit; the problem section may *cite*
  one but does not become one.
- **A defect diagnosis** — that is a bug report; it is not a proposal.
- **Open-ended inquiry** — a survey committing to no recommendation is research; an RFC commits
  to one advocated approach.
- **Desired product outcomes** — *what outcome* is wanted and why is a PRD; an RFC proposes
  *how* a technical approach delivers it.

## Anti-patterns

- ❌ A requirement written into the proposal → describe the mechanism in prose; requirements are
  written into the spec on acceptance, never here.
- ❌ "Alternatives: none considered" → record at least one real alternative with why it is
  weaker; an empty comparison voids the RFC's durable value.
- ❌ "We will adopt X" / "the system must do Y" → "this RFC proposes X because…"; genuine
  requirements go to the decision-requested section as future spec content.
- ❌ Hedged prose carrying a real open question ("we might also need to…") → lift it into the
  open-questions list with its blocking status.
- ❌ Asking for a decision while a blocking question stands → resolve or downgrade it first.
- ❌ A decision-requested section that names no landing place → name the ADR and/or spec the
  proposal moves into, or the decision cannot be acted on.

## Before you finish

- [ ] Every sentence is pre-decision — none worded as a settled choice or an approved contract.
- [ ] Zero requirements anywhere in the file.
- [ ] The problem section states the technical problem and cites the originating document where
      one exists.
- [ ] The proposal advocates exactly one approach, in enough detail to weigh against the
      alternatives.
- [ ] The alternatives table is non-empty, with at least one genuine `Alternative | Why weaker`
      row.
- [ ] The migration plan is ordered prose steps from present to proposed state.
- [ ] Every unresolved point is an explicit open question with its blocking status, and no
      blocking question is carried into the decision request.
- [ ] The decision requested is exact and names where the proposal lands on acceptance.
- [ ] Frontmatter is complete per the kit template.
