# Writing specs

A spec states intended behavior.

Write a spec when:

- behavior changes
- an agent needs a clear contract
- reviewers need an acceptance bar
- a ticket is vague or partial

Skip a new spec when an existing accepted spec already covers the work. **Amend that spec in place** — a spec is a living document: edit the requirement (it keeps its id), let its status move to `active`, and mint a new spec only when a whole feature is replaced.

## Minimum shape

```markdown
---
type: spec
id: SPEC-checkout
title: Expired checkout sessions
status: draft
owner: checkout-team
sources:
  - intake/SHOP-4012.md
---

# Expired checkout sessions

## Intent

...

## Non-goals

- ...

## Requirements

### AC-001 - Expired session returns 409

When a checkout session is older than 30 minutes, the API must return
`409 SESSION_EXPIRED` and must not return a 5xx.

Verify with: `npm run test:integration -- expired-session`

## Open questions

- None.

## Affected areas

- `src/checkout/`
```

## Requirement rules

Each requirement:

- has an `AC-NNN` id
- states one behavior
- names the actor or system
- uses at least one binding word: `must`, `must not`, `should`, `should not`, or `may` (more than one flags a split candidate)
- has a `Verify with:` line
- avoids hidden uncertainty

Move uncertainty to **Open questions** — framed as a decision (options and a recommendation), not a bare question.

## Non-goals

Use non-goals to stop scope creep. Write them in three parts: the prohibition, what to do
instead, and the escape hatch — blocked by the boundary? stop and ask. A bare "do not" is
measured weak; prohibition plus a stop option cuts violations by an order of magnitude
([[IMPOSSIBLE]](research/sources.md#IMPOSSIBLE), [[OVEREAGER]](research/sources.md#OVEREAGER)).

Good non-goals name likely misunderstandings:

- no schema change
- no pricing change
- no public API change
- no migration of old records

## Sources

Name the source in frontmatter.

If the spec does not implement part of the source, record it under **Dropped from sources** with the reason.

## Status

Use `draft` while questions remain.

Use `ready` only when:

- every requirement has `Verify with:`
- blocking questions are resolved
- non-goals are stated
- affected areas are named

## Execution

Append-only run record on the spec. The implementer adds one dated entry per change-cycle: the
changed files, evidence, and blocked questions for that run. An entry may be plain prose, or a
structured change-record carrying **Scope** (the ACs touched), **Coverage** (each in-scope AC
mapped to the evidence that closed it), and **Pins** (`reviewed-sha:` + `evidence-hash:`, written
at close) — see [ADR-0110](adrs/0110-execution-change-record.md). This is the durable residue once
the ephemeral review evaporates.

## Optional SOL form (experimental)

Plain markdown is the default — and in practice the only form this project's own workspace still
writes. SOL, an EARS-like structured syntax for high-risk requirements, remains available behind
`format: sol` as an **experimental annex**: the human-side evidence for controlled syntax is real,
the LLM-side evidence is absent, and our own usage abandoned it. Details, honestly labeled:
[structured requirements](reference/structured-requirements.md). Do not mix plain `AC-NNN`
headings and SOL blocks in one spec.

## Checks

Use [checks](reference/checks.md) as the review checklist. `suspec check` can report the toolable subset.

## Related

- Next: [Brownfield work and change plans](05-brownfield-and-change-plans.md)
- Previous: [Where files live](03-where-files-live.md)
