---
type: adr
id: adr-0168
status: accepted
created: 2026-07-22
---

# ADR-0168 - Render structured chat output

## Context

Dissect and Bulletproof wrapped Markdown reports in `text` fences. Tables became monospace blobs;
labels lost hierarchy; evidence became harder to scan. The structure was useful. The wrapper was
not.

Suspec has two output classes: durable or transient artifacts written by `sus-*` authors, and direct
chat from universal methods. Chat is a rendered interface, not a file attachment pretending to be
one.

## Decision

1. **Artifact authorship stays closed.** Only `sus-*` artifact authors create Suspec artifacts.
   Structured output alone does not justify a file.
2. **Chat structure renders as Markdown.** Use headings, bold labels, prose, lists, and normal tables.
   Never wrap a report, table, or prose handoff in a fence.
3. **Fences carry literal material only.** Code and untouched raw evidence may use an appropriate
   fence. Artifact templates may show fenced source because their destination is a file, not chat.
4. **A summary may follow a report.** Keep it brief and add it only when it improves orientation.
   Never restate the report.
5. **The catalog gate owns the rule.** Every skill Output section rejects fenced content. Method-
   specific gates preserve required labels, tables, evidence, and unknown-state handling.

## Narrowed decisions

- [ADR-0109](./0109-output-economy-convention.md): economical output remains; readability is not
  waste.
- [ADR-0157](./0157-ruthless-skills-and-closed-artifact-authorship.md): universal methods still
  return chat and artifact authorship remains closed.
- [ADR-0161](./0161-semantic-skill-contracts-and-evidence.md): constrained handoffs use rendered
  chat structure unless they are literal code, raw evidence, or artifact templates.

## Consequences

- Structured reports remain compact and become scannable.
- A formatting requirement cannot accidentally create an artifact.
- Literal code and proof retain exact formatting without swallowing the surrounding report.

## Status

Accepted (2026-07-22). Narrows ADR-0109, ADR-0157, and ADR-0161.
