# Run notes: {{title}}

- Task packet: `tasks/{{TASK-slug}}.md`
- Spec: `specs/{{feature}}/spec.md`
- Worktree / branch: {{branch}}
- Created: {{YYYY-MM-DD}} · Status: active

> **Documentation task** — write for a human who has not read the code and arrived with one
> question. One frame held throughout. Lead with what the reader must do. Every example runs as
> written; every behavior claim cites file:line. No hedging.
>
> **Commands** resolve from the code repo's `AGENTS.md` Commands table (format; doc-lint if the
> project has one). The runner for a code *example* is the example's own command. For any command
> you need that is undefined, ask the user — do not guess.

## Scope (from the task packet)

- Document: the requirements the packet lists — nothing wider.
- Do not change: docs outside the packet's areas; "while I'm here" polish goes to Findings.

## Doc target

- **File:** `{{path}}`
- **Frame (exactly one):** tutorial (linear, no choices) / how-to (a recipe for one task) /
  reference (lookup, no narrative) / explanation (the why)
- **Audience:** {{specific — "developers integrating our SDK for the first time", not "developers"}}
- **Reader's question:** {{the one question, stated as the reader would ask it}}

## Source material

What the doc draws on — code, the packet's requirements, prior docs, runtime behavior. Every claim
in the doc traces to one of these.

-

## Examples to verify

Every code example runs as written. The captured output goes under Evidence.

| Example | Run command | Expected outcome |
|---|---|---|
| | | |

## Plan

What is the lead — the action the reader's question asks about? What supports it? Which examples
and file:line citations does each requirement need?

1.
2.

## Progress checklist

- [ ] Packet read; frame, audience, and reader's question fixed above
- [ ] Doc written, action in the first ~100 words
- [ ] Every example run as written; output captured and pasted below
- [ ] Every behavior claim cross-checked against the code and cited file:line
- [ ] Hedges removed — behavior stated, or its condition stated
- [ ] In-scope docs that contradict this one reconciled; out-of-scope contradictions recorded as
      findings
- [ ] Format / doc-lint run on every touched file (output pasted)
- [ ] Findings recorded; self-review answered

## Evidence (paste actual command output — never paraphrase)

- Per example: the captured run output proving it works as written:
- Format command on touched files (last lines + exit):
- Doc-lint, if the project has one (last lines + exit):

## Decisions

Authoring choices the requirements did not constrain — frame, structure, what to cut. A behavior
claim you could not anchor to a line goes to Blocked questions, not here.

-

## Findings

Contradicting docs outside the packet's areas, behavior no requirement covers, real issues spotted
while writing — candidates for the workspace's `findings/` at Close.

-

## Blocked questions

A requirement the code contradicts, a claim with no findable anchor — surfaced, not papered over
in prose.

-

## Next steps

-

## Self-review

Answer in writing, evidence pasted. A doc that hedges, ships unrun examples, or contradicts the
code actively misleads — and the reader cannot tell.

- **Reader-first:** does someone with the reader's question find the action in the first ~100
  words?
- **Examples:** every example executed as written — self-contained, output pasted?
- **Currency:** every behavior claim cited to a file:line that checks out at this commit? No
  `TODO`/`FIXME` left behind?
- **Frame:** one frame held throughout — no tutorial/how-to/reference/explanation drift?
- **Hedging:** every "should"/"might"/"could" replaced with the behavior or its condition?
- **Scope:** only the packet's requirements documented; contradictions out of scope recorded as
  findings; no review result issued on your own work.
