# Writing specs

A spec states intended behavior.

Write a spec when structured intent will change execution or make review possible:

- an agent needs a clear contract
- reviewers need an acceptance bar
- a ticket is vague or partial
- several requirements or boundaries must stay aligned

For a trivial change, state intent and verification inline. A spec is working scaffold for
the live change, not a durable parallel source of truth; code, tests, ADRs, issues, and PRs
carry the lasting record.

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

Use non-goals to stop scope creep. Name the boundary, what to do instead, and the escape
hatch: when the boundary blocks the work, stop and ask rather than editing past it.

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

When one implementer works directly from the spec, use `## Execution` for this run's
changed files, verify output, and blocked questions. If the work is split into task
packets, each task carries its own run notes instead. These notes serve the live review;
they are not a durable lifecycle record.

## Structured SOL form

Plain markdown is the default. A spec can select the stricter EARS-like SOL syntax with
`format: sol` when controlled clauses make ambiguity cheaper to detect. Both forms encode
the same requirement record. See [structured requirements](reference/structured-requirements.md),
and do not mix plain `AC-NNN` headings with SOL blocks in one spec.

## Checks

Use [checks](reference/checks.md) as the review checklist. `suspec check` can report the toolable subset.

## Related

- Next: [Brownfield work and change plans](05-brownfield-and-change-plans.md)
- Previous: [Where files live](03-where-files-live.md)
