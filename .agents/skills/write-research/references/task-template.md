# Research session: {{title}}

## Metadata

- Slug: {{slug}}
- Guide: write-research · Stance: Researcher (depth) / Surveyor (breadth)
- Created: {{createdAt}}
- Status: active
- Deliverable: a research note in the kit template's shape (`starter-kit/advanced/research.md`)
  — in this repo, beside the work it informs; in an adopted workspace, `specs/<feature>/`

---

> **RESEARCH (INQUIRY) SESSION** — produces a research note, not code and not a spec. It
> SURVEYS options and evidence and commits to NO decision. No source/config/dependency changes;
> no requirements (no AC items, no SOL blocks). Copy the `## Deliverable` block to the path
> above at close.
>
> **Commands:** a product-behavior finding's runner is the finding's own command (a `curl`, a
> sandbox script). Anything project-specific resolves from the workspace `AGENTS.md` Commands
> table; if the command you need is missing, ask before substituting.

---

## Objective

The one decision-informing question this research must answer, and the downstream decision it
informs. One paragraph maximum. Be concrete: "Which scheduling approach minimizes jitter at
10ms lookahead?" — not "how does scheduling work".

---

## Linked context

- Triggering ask: <the request, or the upstream document with the open question>
- Prior research / findings / audits relevant: `<paths>`
- Codebase context (if applicable): `<paths>`

---

## Constraints

- **No source/config/dependency changes — research document only.**
- **No requirements.** Evidence acquires force only when lifted into a spec or an ADR.
- **Inquiry stance — commit to no decision.** Findings survey; the recommendation is advisory.
- Use search tools aggressively — codebase, official docs, papers, standards, library source.
- Mark unverified claims `[unconfirmed]`; never present them as findings.
- Survey breadth-first, then depth. At least three independent sources (a floor, not a target).

---

## Plan (breadth-first, then depth)

1. Refine the research question in the `## Deliverable` block below.
2. List sub-topics and candidate options (breadth) before drilling in.
3. Conduct the survey; capture sources and R-NNN findings as you go.
4. Verify product-behavior claims by exercising the product; record observed output.
5. Compare options explicitly in a table where multiple exist.
6. Surface unresolved points as open questions (Q-NNN).
7. Write an actionable, advisory recommendation naming the R-NNN it rests on.
8. Fill the visibility table; copy the `## Deliverable` block to its final home.

## Progress checklist

- [ ] Question stated concisely (one or two sentences)
- [ ] Sources planned breadth-first; at least three independent sources consulted
- [ ] Findings recorded as R-NNN with Claim · Evidence · Confidence · Bears on
- [ ] Product-behavior claims verified (not inferred from docs)
- [ ] Options compared side by side where multiple exist
- [ ] Open questions captured as Q-NNN
- [ ] Recommendation actionable (or: why none + the unblocking Q-NNN)
- [ ] Visibility table all ✅
- [ ] `## Deliverable` block copied to its final home

---

## Deliverable

> Copy everything between this line and `--- END DELIVERABLE ---` into the deliverable path at
> session close. Frontmatter follows the kit template: `type: research`,
> `id: RESEARCH-{{slug}}`, `title`, `status: open`, `owner`, `sources[]` (the originating
> question or ticket).
>
> **Every finding cites a source.** Vague attribution ("according to common practice") is not
> citation. If a claim cannot be traced to a paper, doc, repo, standard, or verified product
> behavior, mark it `[unconfirmed]` or omit it. A fabricated finding poisons every document
> that later cites it.

### Mode

Technical (libraries / APIs / algorithms / standards / source code) — or UX/market (user
expectations, competitor behavior, design patterns; load the Surveyor stance). Pick exactly
one; if the topic is genuinely both, split it.

### Question

The specific, decision-informing question. One or two sentences. If it will not state
concisely, the scope is unclear — clarify before continuing.

### Sources

Numbered. Primary sources preferred (standards, peer-reviewed papers, official docs, source
code, verified product behavior). Each entry carries enough specificity to re-find it. A blog
is cited only alongside the primary source it rests on.

1. [<short-key>] <Author / Org>. *<Title>*. <venue / URL / repo+version>.
2. [<short-key>] …

### Findings

Each finding is a citable span with a stable id (another document references it as
`RESEARCH-{{slug}}#R-NNN`; a durable one is saved as a finding at Close). Survey only — draw no
conclusion here.

#### R-001 — <finding title>

- **Claim:** <the one durable fact this finding asserts>
- **Evidence:** <file / command / output / external source — enough to re-verify> [1][3]
- **Confidence:** <high | medium | low>
- **Bears on:** <which downstream question or option this informs>

#### R-002 — <finding title>

- **Claim:** <…>
- **Evidence:** <…> [2]
- **Confidence:** <…>
- **Bears on:** <…>

#### R-003 — <unverified finding>

- **Claim:** <…> `[unconfirmed]`
- **Evidence:** <why it could not be verified — paywalled, unreachable, conjecture from
  secondary material>
- **Confidence:** low
- **Bears on:** <…>

### Comparison

Where multiple options exist, compare them side by side with named criteria. Not narrative — a
table a spec author can lift into a design-decision section.

| Criterion | Option A | Option B | Option C |
| --- | --- | --- | --- |
|  |  |  |  |

### Open questions

Unresolved points the inquiry surfaced. Each carries forward into the spec's open questions —
do not settle one here by asserting a decision.

- [ ] **Q-001** — <unresolved point; what answering it would unblock>
- [ ] **Q-002** — <…>

### Recommendation

A specific, actionable direction a spec author can lift into requirements, naming the R-NNN
findings that ground it. Advisory, not a decision — writes no requirements. If no
recommendation is possible, state *why* and name the open Q-NNN that would unblock one.

--- END DELIVERABLE ---

---

## Decisions (session-level — distinct from the deliverable)

- …

## Session notes (process notes, distinct from the deliverable's R-NNN findings)

- …

## Assumptions

- [pending]

## Blockers

- …

## Next steps

- … (concrete starting points if this session ends incomplete)

---

## Visibility table (fill before close — any ❌ means not deliverable)

| R-NNN | Evidence non-empty? | Confidence set? | Verified, or `[unconfirmed]`? | Recommendation cites it? |
| --- | --- | --- | --- | --- |
| R-001 | ✅ / ❌ | ✅ / ❌ | verified / `[unconfirmed]` | ✅ / n/a |

---

## Self-review

> **Hard gate.** The session is not complete until every question below has a written answer
> directly beneath it. An unanswered question is a skipped check. Review as a senior engineer
> about to greenlight this research as input to a spec or an ADR.

### The inquiry-stance constraint — check this first

- Does the note write any requirement? It must not — those belong to the spec or ADR written
  from it. Did the recommendation stay advisory rather than reading as a committed decision?
  Are open points left open as Q-NNN, not silently settled?
  Answer:

### Source coverage

- Did you consult primary sources (standards, papers, official docs, source code), not just
  secondary commentary? Are at least three independent sources cited? Were product-behavior
  claims verified by exercising the product, not inferred from docs?
  Answer:

### Citation discipline

- Does every R-NNN finding's evidence trace to a numbered source? Are unverified claims marked
  `[unconfirmed]`? Are blogs cited only alongside the primary source they rest on?
  Answer:

### Recommendation actionability

- Could a spec author lift the recommendation directly into requirements? If none is possible,
  did you say why and name the unblocking Q-NNN?
  Answer:

### Open questions

- Is each open Q-NNN flagged for follow-up with what would close it, so it carries forward
  into the spec's open questions?
  Answer:

### Final polish

- What else could you do? Did you miss a primary source? Is a competing option more defensible
  than the one recommended? Did anything dropped while condensing belong in the note?
  Answer:
