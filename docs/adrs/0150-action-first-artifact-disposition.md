---
type: adr
id: adr-0150
status: accepted
created: 2026-07-13
updated: 2026-07-13
---

# ADR-0150 - Act first; disposition artifacts at close

## Context

Artifact-only handoff reduced repeated chat prose, and neutral placement kept working files out of
repositories. Neither rule said when an artifact was warranted or what happened after its work was
done. An agent could turn an instruction into a document about the instruction, then leave that
document and its sidecars behind indefinitely.

## Decision

1. **An action request triggers action.** When the user directs a change, the agent performs it. It
   does not create a note, decision record, plan, or other meta-artifact instead unless the user
   requests that document or the applicable Suspec workflow requires an artifact before execution.
2. **Artifacts exist for a job.** Ordinary conversation and direct action do not become Suspec
   artifacts. Create an artifact when the user requests it or the applicable Suspec workflow requires
   it as a live input; the user need not literally ask for a file. A document must never substitute
   for the implementation, edit, command, or decision it governs.
3. **Disposition happens at lifecycle close.** Track every transient artifact and sidecar created or
   consumed by the active work. Once no current or expected downstream step needs them, present one
   structured human choice covering every path: delete, leave, or promote. Group related files, but
   account for each one. Use the native picker when available, with a state-derived recommendation
   first and automatic `Other`; otherwise render the same numbered choices plus `Other`. The agent
   selects no option. Inaction is not Leave.
4. **Timing is strict.** Do not ask at creation, after every revision, or while an artifact remains a
   live input. If work hands off before close, carry the absolute paths forward. The final consumer
   owns the disposition prompt.
5. **Each choice is literal.** Delete removes the selected transient set and the selection is the
   irreversible-action confirmation. Leave keeps the files at their current neutral paths without
   adding state or cleanup machinery. Promote sanitizes and moves them into a human-selected,
   project-owned durable destination, repairs references, validates, and never pushes implicitly.
6. **Handoff follows the work.** When an artifact is the deliverable, chat links it without
   restating its contents. When the requested result is an action, chat reports the action and its
   evidence normally. At close, the disposition picker replaces path-only handoff; returning links
   alone or declaring completion before selection is not close.

## Narrowed decisions

- [ADR-0145](./0145-attention-economy-and-decision-rails.md): artifact-only handoff applies when an
  artifact is the deliverable; it never converts an action request into a document.
- [ADR-0147](./0147-artifact-promotion.md): promotion remains explicit; selecting Promote in the
  close picker is that explicit request.
- [ADR-0148](./0148-agent-neutral-artifact-workspace.md): no automated cleanup or lifecycle state is
  added; explicit per-run disposition replaces indefinite accumulation as the normal close path.
- [ADR-0149](./0149-skills-state-rules-directly.md): every artifact-producing skill states the close
  behavior directly and remains complete when installed alone.

## Consequences

- User instructions produce work, not unsolicited paperwork.
- Active artifacts remain available through every dependent step.
- Completed transient artifacts cannot disappear or accumulate without a human choice.
- Suspec still owns no store, registry, cleanup daemon, or lifecycle state.

## Status

Accepted (2026-07-13).
