# Run notes: {{title}}

- Task packet: `tasks/{{TASK-slug}}.md`
- Spec: `specs/{{feature}}/spec.md`
- Worktree / branch: {{branch}}
- Created: {{YYYY-MM-DD}} · Status: active

> **Feature task** — build exactly the listed ACs. Survey before you invent. Halt on ambiguity.
> No opportunistic refactoring. Nothing leaves your hand unverified.
>
> **Commands** resolve from the code repo's `AGENTS.md` Commands table. For any command you need
> that is undefined, ask the user — do not guess.

## Scope (from the task packet)

Implement:

- AC-001 — {{one line}}
- AC-002 — {{one line}}

Do not change: {{areas the packet rules out}}

## Plan

Written before implementation. Every AC mapped to a step.

1.
2.
3.

## Progress checklist

- [ ] Task packet and spec read in full
- [ ] Every AC mapped to an implementation step
- [ ] Pattern survey done — existing helpers/types consulted before inventing
- [ ] Core logic implemented
- [ ] A test per AC added or updated
- [ ] Each new test flipped → fails → restored → passes (transition pasted below)
- [ ] Checks run after each batch; output pasted below
- [ ] Every Verify item run after the final edit; output pasted below
- [ ] Findings recorded; self-review answered

## Evidence (paste actual command output — never paraphrase)

- Check command (last lines + exit):
- Test command (last lines + exit):
- Flip transition per new test (fails flipped → passes restored):

## Decisions

Implementation choices the requirements did not constrain — and why a new pattern was introduced
instead of reusing an existing one, if it was. Silently resolved ambiguities never go here; they go
to Blocked questions.

-

## Findings

Durable discoveries — debt spotted, a neighboring gap, a missing AC. Candidates for the
workspace's `findings/` at Close.

-

## Blocked questions

Ambiguous or contradictory ACs surfaced for the spec owner. Do not invent the requirement.

-

## Next steps

Concrete starting points if this session ends incomplete.

-

## Self-review

Answer in writing, evidence pasted. A feature that diverges silently from its ACs ships drift.

- **Scope:** every change traces to a listed AC — or is recorded as an exception with a reason.
  Anything beyond the ACs?
- **Coverage:** does every AC map to a part of the diff you can point at? Anything missing?
- **Patterns:** reused what exists; any new pattern justified in Decisions?
- **Tests:** does each new test fail when flipped and pass when restored, transition pasted?
- **Evidence:** every Verify item ran after the final edit, output pasted — no "tests passed"
  without output?
- **Findings:** nothing left only in this session; no review result issued on your own work.
