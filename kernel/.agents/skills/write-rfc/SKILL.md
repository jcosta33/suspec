---
type: pass-guide
name: write-rfc
pass: author
description: >-
  Author an `rfc.md` for the `author` pass: capture ONE technical proposal — its problem, the
  advocated approach, the alternatives weighed, and the decision requested — as a pre-decision
  source that commits nothing and authors no obligations, so *why this approach and not the
  others* outlives the change. ALWAYS apply when asked to write, draft, or revise an RFC or design
  proposal, or when weighing alternatives before committing to one. Do not author
  REQ/CONSTRAINT/INVARIANT/INTERFACE or TRACE blocks, leave alternatives unconsidered, or word a
  sentence as a settled decision. Skip for a decision already made (ADR), the spec a proposal
  promotes into, an audit, a bug-report, or commit-to-nothing research.
---

# Pass guide: write-rfc (`author` · `rfc.md`)

> **This guide is SOFT control.** It tells you *how* to author an RFC well; it never defines
> SOL/APS semantics, modality, authority order, the obligation-block grammar, the QUESTION
> blocking rule, or any verification meaning — those live only in the SOL/APS language references
> and the IR, and this guide *applies* them, restating their load-bearing meaning inline so the
> RFC is authorable from this file alone. Where this guide and the language references disagree,
> the references govern. The `author` pass itself emits no lint codes and runs no gate; it
> produces the source the rest of the pipeline reads. This guide carries the **proposal** stance:
> you are advocating one approach in enough detail to be evaluated, recording the comparison that
> justifies it — and deciding nothing.

## Purpose

A design discussed only in chat is unindexed, unprovenanced, and forgotten the moment the session
ends; six months later no one can reconstruct *why this approach and not the alternatives*, and
the rejected options get re-litigated from scratch. An RFC is the durable answer: it records one
technical proposal — the problem that forces it, the advocated mechanism, the alternatives weighed
against it, and the exact decision being asked for — so the comparison survives the change it
prompted. Its knowledge is **pre-decision**, and that boundary is the whole point. An RFC advocates
one approach but commits to none until the decision is made; once that decision lands it promotes
forward — into an immutable architecture decision, into the obligation-bearing behavioral contract,
or both — and the proposal stance is preserved across that promotion. The failure this guide
prevents is a proposal being read as something it is not: an approved contract, or a settled choice.

`author` is the first of the nine passes (`author → lint → improve → lower → decompose → implement
→ verify → review → promote`) and the entry pass that runs before analysis begins — it is where new
intent and its parents legitimately *enter* the pipeline. An RFC is one of the recognized **parents
of a spec** that the `author` pass normalizes forward; this guide is for authoring that parent. It
is **not** for the artifacts an RFC sits beside or promotes into, each of which has its own stance
and its own discipline (see *What does not belong*).

## Project context (the `cmd*` slots)

An RFC is hand-authored Markdown; authoring it needs no build or test command. If the project lints
or formats Markdown sources, resolve those through the consuming repo's `AGENTS.md > Commands` slots
— the format-hygiene command (`cmdFormat`, run on the file before close) and the aggregate
validation command (`cmdValidate`, if the project lints docs). A Markdown doc-lint command
(`markdownlint`, `vale`, or similar) is **not** a standard slot — if the project uses one, **ask the
user** which command it is rather than guessing, because a guessed command produces a false proof.
If `AGENTS.md` is missing or a slot you need is undefined, ask the user before claiming the file is
clean.

## Consumes

- The **problem pressure** that forces a proposal: the originating product-outcome source (a PRD),
  the durable evidenced fact (a finding), or the present-state observation and risk (an audit)
  where one exists. The RFC's `## Problem` cites it; it does not restate the whole upstream artifact.
- The **chat or design discussion** the proposal emerged from — the raw material you are converting
  into a durable, provenanced source.

## Produces

- One `rfc.md` — a **working artifact** (plain `.md`, **never** the `.swarm.` infix; it is not
  parsed or emitted by a compiler). In an adopted project it lives under the sources tree beside the
  other parents of a spec, never under the generated-packets tree and never under the memory tree.
- The six required sections, in order, each on the proposal side of the line: `## Problem`,
  `## Proposal`, `## Alternatives`, `## Migration plan`, `## Open questions`, `## Decision
  requested`, under the frontmatter contract (`type: rfc`, `id`, `status`, `created`, `updated`).

## Preserves

- **The proposal stance.** Every sentence stays pre-decision. The moment a sentence reads as an
  approved behavioral contract it belongs in the spec the `author` pass will produce; the moment it
  reads as a settled choice it belongs in the ADR. Neither belongs in the RFC.
- **Provenance.** The `## Problem` cites the upstream source that forced the proposal rather than
  re-deriving it, so the chain from pressure to proposal stays auditable.

## Rejects

These MUST NOT appear in a conformant RFC, and any of them blocks the file from being delivered:

- **Obligation blocks.** An RFC MUST NOT author `REQ`, `CONSTRAINT`, `INVARIANT`, or `INTERFACE`
  blocks. Those come into existence only when the RFC promotes — into an accepted ADR, an approved
  spec, or both — via the `author` pass. Embedding one lets a *proposal* be read as an
  already-approved contract and silently bypasses both the authoring step where a proposal acquires
  obligation force and the decision step where it acquires commitment. This is the same boundary
  that keeps a product source's goals from being read as obligations and a defect diagnosis from
  prescribing its own fix.
- **`TRACE` blocks in the migration plan.** The `## Migration plan` is steps and ordering from the
  present state to the proposed state — prose, never authored `TRACE` blocks. Tracing binds an
  implementation to obligations *after* a spec exists; it cannot happen inside a proposal that has
  authored no obligations.
- **"No alternatives considered."** The `## Alternatives` section is mandatory, and an empty one is
  a defect, not an omission — an RFC's durable value *is* the comparison it records. A future reader
  trusts the chosen approach precisely because the rejected ones are written down beside it; an RFC
  with no alternative has discarded the one thing it exists to preserve.
- **A sentence worded as a decision or a contract.** "We will adopt X" / "the system MUST do Y"
  smuggle a settled choice or an obligation into a pre-decision document. State the proposal as an
  advocated approach ("this RFC proposes X because…"), and lift any genuine behavioral requirement
  into the `## Decision requested` as something the spec would author *on acceptance* — never as an
  obligation here.
- **A blocking open question left to promote.** An RFC carrying an unresolved point that gates the
  decision MUST NOT be promoted — a proposal cannot become an obligation or a decision while the
  thing that gates it is still undecided.

## Procedure

### 1. Find the pressure and cite it; state the problem, never the obligation

Open with `## Problem`: the technical problem that forces a proposal, in enough detail that a reader
can judge whether the proposal answers it. Cite the originating product source, finding, or audit
where one exists, rather than re-deriving the whole upstream artifact. *Why:* the problem is what
makes the proposal legible — without it the reader cannot tell whether the advocated approach is
proportionate; and the citation keeps the provenance chain from pressure to proposal auditable.
State what *is* wrong, never what the system *must* do — the latter is an obligation, which an RFC
does not author.

### 2. Advocate exactly one approach, in enough detail to evaluate

In `## Proposal`, describe the single mechanism you advocate — the design, how it works, what it
touches — in enough detail that a reviewer can weigh it against the alternatives. Describe a
mechanism; author **no** obligation blocks. *Why:* an RFC advocates *one* approach (the alternatives
are recorded in the next section, not proposed here); a proposal vague enough to be un-evaluable
records no real comparison, and one written as obligation blocks has crossed into being a contract
before anyone approved it.

### 3. Record the alternatives as a table — "none" is a defect

Fill `## Alternatives` as a two-column table — `Alternative | Why weaker than the proposal` — with at
least one real row. Each row is a recorded judgment a future reader (or a superseding RFC) can
reopen. *Why:* this is the artifact's point. The reason a future reader can trust the chosen approach
is that the rejected ones are written down beside it; "none considered" discards the durable value
the RFC exists to preserve. If you genuinely cannot name an alternative, that is a signal the
proposal is under-explored, not that the section is optional.

### 4. Write the migration plan as ordered steps, never TRACE blocks

In `## Migration plan`, list the steps and their ordering from the present state to the proposed
state — a numbered prose sequence. *Why:* adoption ordering is part of evaluating a proposal (a great
design with an impossible migration is a weak proposal). But this is *prose*, never authored `TRACE`
blocks: tracing binds an implementation to obligations after a spec exists, and this proposal has
authored none — a `TRACE` here would assert work against obligations that do not yet exist.

### 5. Surface every unresolved point as an Open question with a blocking tag

In `## Open questions`, list each unresolved point that gates the decision. Each is a `QUESTION`
(`Q-NNN`) candidate, written with its blocking tag exactly as the language requires — the tag sits
in brackets before the colon: `QUESTION Q-001 [blocking]:` or `[non-blocking]`. *Why:* behavioral
uncertainty must be lifted into an explicit marked question rather than left as hedged prose ("it
might…", "we could…") — unmarked hedging is the `SOL-P008` failure the downstream gate will flag.
Marking it here makes the gate enforceable: a **blocking** question prevents the proposal from being
lowered into tasks while it stands (an unresolved blocking question reaching the lower pass is
`SOL-O003`), so an RFC with any blocking question open MUST NOT be promoted.

### 6. State the exact decision requested and name the promotion target

Close with `## Decision requested`: the precise decision being asked for, naming where the proposal
promotes on acceptance — an accepted ADR (the immutable decision), an approved spec (the
obligation-bearing contract), or both. *Why:* an RFC exists to be *decided*; a proposal that does not
say what decision it asks for, or where it goes when granted, cannot be acted on. Naming the target
is also what tells the next reader which downstream artifact will carry the obligations or the
decision — they are authored *there*, on promotion, not here.

### 7. Set the frontmatter and keep every sentence pre-decision

Fill the frontmatter contract: `type: rfc`, a stable `id` slug (the citable name for this proposal),
`status: proposed` (one of `proposed | accepted | rejected | superseded`), and the `created` /
`updated` dates. Then re-read the whole file against the line: is any sentence worded as a settled
choice or an approved contract? *Why:* `status` records that this is still a proposal, and the slug
is how the decision and the promoted artifacts will cite it. The re-read is the cheapest defense
against the one failure that voids an RFC — a proposal that reads as a decision or a contract.

## Output contract

The delivered `rfc.md` carries the frontmatter contract and the six sections in order, every
statement on the proposal side of the line, no obligation block and no `TRACE` block anywhere, a
non-empty `## Alternatives`, and a `## Decision requested` that names its promotion target. Two
facts bound what this pass records:

- The RFC authors **no** binding force of its own. Obligations and the decision are authored
  downstream, on promotion, by the `author` pass (into a spec and/or an ADR) — never inside the
  RFC. The RFC's job is to be the durable, decidable record of the proposal those obligations and
  that decision will serve.
- A lower-stance source must not smuggle higher-stance content across the authoring boundary: a
  proposal becomes binding **intent** only when authored into a spec, where SOL obligations carry
  that force. An attempt to relax or pre-empt an existing obligation from inside a proposal is an
  authority conflict (`SOL-M004`), resolved by amendment downstream, never by wording it into the
  RFC.

## What does not belong

- **An obligation block or a `TRACE` block** — an RFC authors neither; obligations are authored into
  a spec on promotion, traces are written after a spec exists.
- **A settled decision** — the immutable architecture decision (with its context, decision,
  alternatives-rejected, and consequences) is an ADR; an RFC's accepted proposal *promotes into* one.
- **The obligation-bearing behavioral contract** — the `REQ`/`CONSTRAINT`/`INVARIANT`/`INTERFACE`
  blocks live in a `*.swarm.md` spec; an RFC's `## Proposal` is the upstream that promotes into it,
  the only place a proposed mechanism acquires obligation force.
- **Present-state observation and risk** — what *is*, observed and not yet a chosen change, is an
  audit; an RFC's `## Problem` may *cite* it but does not become it.
- **A defect diagnosis** — a reproduced root cause with expected-vs-actual is a bug-report; it
  prescribes no fix and is not a proposal.
- **Open-ended inquiry** — a survey of options that commits to no recommendation is research; an RFC
  commits to one advocated approach.
- **Desired product outcomes** — *what outcome* is wanted and why is a PRD; an RFC proposes *how* a
  technical approach delivers an outcome, and its `## Problem` often cites the originating PRD.
- **Kernel semantics** — the obligation-block grammar, modality, the authority order, the QUESTION
  blocking rule, the verification verdicts, and the lint codes are fixed by the SOL/APS references.
  This guide applies them; it never redefines them.

## Anti-patterns

- ❌ A `REQ` / `CONSTRAINT` / `INVARIANT` / `INTERFACE` block in the proposal → describe the mechanism
  in prose; obligations are authored into the spec on promotion, never here.
- ❌ `TRACE` blocks in the migration plan → write ordered prose steps; tracing happens after a spec
  exists, against obligations the RFC has not authored.
- ❌ "Alternatives: none considered" → record at least one real alternative with why it is weaker; an
  empty comparison is the defect that voids the RFC's durable value.
- ❌ "We will adopt X" / "the system MUST do Y" → state it as "this RFC proposes X because…" and lift
  any genuine requirement into `## Decision requested` as what the spec would author on acceptance.
- ❌ Hedged prose carrying a real open question ("we might also need to…") → lift it into a marked
  `QUESTION Q-NNN [blocking|non-blocking]:` in `## Open questions` (unmarked hedging is `SOL-P008`).
- ❌ Promoting an RFC with a blocking question still open → resolve or downgrade the question first; a
  blocking question reaching lowering is `SOL-O003`.
- ❌ A `.swarm.` infix in the filename → an RFC is a working artifact; it stays plain `.md`, never the
  compiler-visible infix.
- ❌ A `## Decision requested` that names no promotion target → name the accepted ADR and/or the
  approved spec the proposal promotes into, or the decision cannot be acted on.

## Self-review

The RFC is not done until every check holds — paste any format/validation output you ran into the
local task file:

- **Stance held end to end.** Is every sentence pre-decision — no sentence worded as a settled
  choice or an approved contract?
- **No binding force.** Is there zero `REQ` / `CONSTRAINT` / `INVARIANT` / `INTERFACE` block and zero
  `TRACE` block anywhere in the file?
- **Problem cited.** Does `## Problem` state the technical problem and cite the originating PRD,
  finding, or audit where one exists?
- **One approach, evaluable.** Does `## Proposal` advocate exactly one mechanism in enough detail to
  weigh against the alternatives?
- **Alternatives real.** Is `## Alternatives` a non-empty table with at least one genuine
  `Alternative | Why weaker` row — never "none considered"?
- **Migration is prose.** Is `## Migration plan` ordered steps from present to proposed state, with
  no authored `TRACE` blocks?
- **Questions marked and gating respected.** Is every unresolved point a `QUESTION Q-NNN
  [blocking|non-blocking]:` rather than hedged prose, and is no blocking question being carried into
  promotion?
- **Decision is exact and targeted.** Does `## Decision requested` name the precise decision and its
  promotion target (an accepted ADR and/or an approved spec)?
- **Frontmatter complete.** Are `type: rfc`, a stable `id`, a valid `status`, and `created` /
  `updated` all set, and is the filename plain `.md` with no `.swarm.` infix?
- **Soft control.** Did this RFC stay a proposal that applies kernel semantics, never one that
  redefines them?
