---
type: audit
id: AUDIT-codex-promptly-task-driven-reliability-rollup
title: Promptly task-driven reliability stress-test rollup
status: closed
owner: codex
date: 2026-06-13
---

# Promptly Task-Driven Reliability Stress-Test Rollup

## Scope

This rollup compares CHANGE-040 across four Promptly jobs. It collects Swarm
datapoints only and does not propose or implement Swarm framework changes.

## Jobs compared

| Job | Product value | Final review state |
|---|---|---|
| TASK-040 validation durability | `.wxt/` removed from git tracking and ignored | Pass |
| TASK-041 runtime capability preflight | Popup readiness for extension, WebGPU, selected model, and model runtime | Pass, local Chrome Blocked |
| TASK-042 inference stall recovery | Advisory stalled state plus retry/cancel/copy-partial controls | Blocked for real stalled runtime proof |
| TASK-043 extension validation harness | `pnpm validate:extension` with registration, popup, content, and overlay smoke path | Pass |

## Task-file effectiveness

Task files were genuinely used this time. The three delegated workers all
reported reading their task packet, linked spec, linked change plan, Promptly
`AGENTS.md`, and the two relevant skills before implementation. Compared with
the earlier Promptly run, the task files acted as real boot anchors rather than
post-hoc documentation.

The task files were strongest when scope was narrow and verifiable: TASK-040
and TASK-043. They were weaker where runtime behavior required a hard-to-create
state: TASK-042 asked for stalled WebLLM runtime evidence but did not provide a
stall simulation strategy.

## Worker boot quality

Boot quality improved materially:

- TASK-040 worker reported exact boot reads and stayed in `.gitignore` plus
  `.wxt/`.
- TASK-041 worker reported exact boot reads and stayed in background/messaging
  and popup configuration UI files.
- TASK-042 worker reported exact boot reads and stayed in inference/response
  UI files.

The gap was worktree isolation. Worker edits appeared in the shared Promptly
working tree, not as isolated patches. That made independent review possible
but more manual than it should be.

## Review independence

The lead reran checks and did not accept worker claims as final evidence. This
caught and fixed the validation harness false-positive risk where the first
script latched onto an unrelated Chrome extension service worker. It also kept
TASK-042 Blocked instead of turning component code review into runtime proof.

## Ceremony versus useful safety

Useful safety:

- Task-first rule forced explicit source links, scope, non-goals, and verify
  commands before edits.
- Boot manifests made skill/task usage auditable.
- Independent review packets preserved Blocked versus Pass distinctions.
- The validation harness encoded a reusable runtime proof path.

Ceremony:

- Full spec/task/review overhead was heavy for TASK-040's mechanical `.wxt`
  cleanup.
- Repeating Chrome Blocked evidence across reviews added noise, though it kept
  the runtime gap visible.
- Task packets need better guidance for runtime states that require simulation
  or fault injection.

## Candidate requirement areas observed

- Worker handoff should state whether edits were made in an isolated worktree,
  shared worktree, or patch-only handoff.
- Task packets for runtime UX should include a simulation or fixture strategy
  for rare states such as stalls.
- Browser-extension projects need a convention for local Chrome Blocked plus
  alternate Chromium diagnostic evidence.
- Review packets should require task-status confirmation, not leave status
  updates as lead cleanup.

## Close state

Promptly code commit: `82e3b3d`. Promptly-docs commit: `7a68632`. Swarm
datapoints are recorded in this audit set. Swarm framework files and templates
were not changed.
