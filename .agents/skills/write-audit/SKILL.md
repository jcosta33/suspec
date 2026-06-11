---
name: write-audit
type: agent-guide
description: >-
  Write an audit: a present-state record of a code or docs area — what is true
  today, the risk it carries, and the evidence behind every claim.
  Observation-only. ALWAYS apply when asked for a code audit, tech-debt survey,
  cleanup or benchmark report, or a quality assessment of an existing area —
  including deepening a prior audit. Never assert intended behavior, prescribe
  a fix, write requirements, or leave an observation without file:line or
  pasted-output evidence. Skip when writing a forward-looking spec, diagnosing
  one defect, or surveying open options (write-research).
---

# Writing an audit

An audit makes an area legible so the work on it can be planned. It records what is true
**today**, grounds each claim in evidence, names the risk that state carries — and stops there.
The format is the kit template `starter-kit/advanced/audit.md` (Scope · Observations · Risks ·
Candidate requirements); do not reinvent its sections. In this repo the deliverable lives under
`.agents/audits/`; in an adopted workspace it lives in `specs/<feature>/`. Load the Auditor
stance alongside (`../persona-auditor/SKILL.md`).

Audits fail in two directions: they drift into prescription (telling the reader what to build —
a spec's job), or they stay vague (impressions and TODO-scrapes nobody can act on). The rules
below pin the audit to its **observation-only** stance. They are conventions backed by review —
nothing in this repo enforces them.

## Rules

### 1. State the goal and bound the scope first

Without a goal, "current state" has no meaning. Write a measurable goal ("surface anything
blocking a Q3 change to the pricing engine"), not a vague intention ("improve billing"). Then
fill the scope section with both **in scope** and **out of scope**. An unstated boundary makes
the audit unfalsifiable, and the scope silently expands under whoever acts on it.

### 2. Ground every observation in evidence

Each observation cites the observable that grounds it: `path:line`, command output, a grep
result. State the fact, never the fix. The citation makes the observation checkable and lets the
next reader navigate straight to it; an ungrounded claim is an opinion wearing a fact's clothes.

### 3. Run the dynamic checks; do not trust static reading

Concurrency, lifecycle, resource cleanup — reading the source does not prove these. Run the
project's test or check commands (the Commands table in the workspace `AGENTS.md`; if a command
is missing, ask — never guess) and paste the output. The highest-value findings are properties
that _look_ held in the source but are not held at runtime.

### 4. Grep for callers across the whole codebase

For every public surface you observe, search for callers everywhere, not just the audited
module. Zero-caller code is itself an observation (a cleanup candidate). The cross-module grep
is the only thing distinguishing a live surface from a fossil.

### 5. Name each risk with its firing condition

Risks are things that _could_ go wrong but were not observed firing. Each names the failure mode
and the condition under which it would fire — not the remedy. A risk without a trigger is
unactionable noise; the condition lets the reader decide whether it is in scope for the work the
audit feeds. An empty risks section means you have not finished looking.

### 6. Calibrate severity by blast radius

Tag each observation and risk Blocker / Major / Minor by _what breaks and how far the damage
spreads_ — never by how hard the finding was to surface or how alarming it feels. A subtle
defect with a one-edge-case blast radius is Minor; an obvious gap that lets unsafe work proceed
is a Blocker. When a call is contestable, record the reasoning inline so a reviewer can
re-derive it.

### 7. Recommend requirements in prose — never write them

The template's candidate-requirements section describes, in plain prose, what a future spec
should require. Write what the spec should carry, not how to change the code. Do not write AC
items or SOL blocks (`docs/reference/structured-requirements.md`) — a requirement acquires force
only when someone lifts it into a spec, and an audit that writes requirements lets an
observation be read as an approved decision nobody made.

### 8. Deepening a prior audit: read it closed

Set the prior audit's framing aside and re-derive every finding from the code; verify that its
cited `path:line` references still resolve. Inheriting a conclusion is how a real defect stays
hidden across two audits.

## What does not belong

- Prescriptions ("we should refactor X") or any fix, patch, or remedy design.
- Assertions of intended behavior ("the new behavior will be Y") — that is spec material.
- Requirements in any form: no AC items, no SOL blocks.
- TODO-comment scrapes, surface impressions, or any claim with no evidence anchor — sharpen
  each until it cites an observable, or cut it.
- Code edits. An audit session is read-only on source; it produces a document.

## Before you finish

Walk the draft once as its harshest reviewer; fix what you find before delivering. Then paste
the completeness table into your task file — any ❌ means the audit is not deliverable yet:

| Item | Evidence present? | Severity                | Firing condition (risks)? |
| ---- | ----------------- | ----------------------- | ------------------------- |
| O1   | ✅ / ❌           | Blocker / Major / Minor | ✅ / ❌ / n/a             |

- [ ] Every observation cites `path:line`, command output, or a grep result — none ungrounded.
- [ ] Every observation and risk carries a severity, calibrated by blast radius, with reasoning
      recorded for any contestable call.
- [ ] Every risk names its firing condition.
- [ ] Dynamic claims were run, not read — the output is pasted, not paraphrased.
- [ ] No fix, no intended behavior, no requirement anywhere; recommendations are prose only.
- [ ] The scope section matches what you actually examined.
- [ ] Anything durable you learned along the way is routed per `../save-findings/SKILL.md`.

## Bundled resources

- `references/task-template.md` — a fillable session frame: metadata, constraints, progress
  checklist, the deliverable structure inlined, and a self-review hard gate with the
  completeness table. Instantiate it into your task file, fill it as you work, and copy the
  deliverable block to its final home at close.
