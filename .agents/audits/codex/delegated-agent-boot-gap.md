---
type: audit
id: AUDIT-codex-delegated-agent-boot-gap
title: Delegated-agent boot evidence gap
status: closed
owner: codex
date: 2026-06-12
sources:
  - .agents/audits/codex/subagent-orchestration-research.md
  - docs/06-creating-tasks.md
  - docs/07-running-agents.md
  - docs/reference/advanced-lifecycle.md
  - starter-kit/AGENTS.md
  - starter-kit/templates/task.md
  - starter-kit/templates/review.md
  - /Users/josecosta/dev/promptly-docs/tasks/011-enabled-state.md
  - /Users/josecosta/dev/promptly-docs/tasks/012-theme-selector.md
  - /Users/josecosta/dev/promptly-docs/tasks/013-copy-response.md
  - /Users/josecosta/dev/promptly-docs/tasks/014-overlay-close-cancel.md
  - /Users/josecosta/dev/promptly-docs/reviews/010-control-utilities-validation.md
  - /Users/josecosta/dev/promptly-docs/status.md
---

# Audit: Delegated-agent boot evidence gap

## Scope

- Goal: record the narrow gap behind the Promptly subagent question: delegated
  agents can contribute to a Swarm-shaped run without leaving evidence that they
  booted as Swarm workers.
- In scope: Swarm's starter task/review surfaces, run guidance, advanced
  parallel-worker handoff text, and the Promptly task/review artifacts that
  survived the stress test.
- Out of scope: changing templates, judging Promptly feature quality, auditing
  the full Promptly adoption, or deciding a specific implementation path.

## Research Context

The accompanying research note records current primary-source orchestration
patterns from OpenAI Agents SDK, LangChain, ADK, AutoGen, and Anthropic. Its
cross-source finding is that mature subagent systems make delegation payloads,
context boundaries, return contracts, and termination evidence explicit. This
audit uses that research as context only; the observations below are grounded in
Swarm and Promptly artifacts.

## Observations

- **Major - Swarm correctly treats the task packet as the worker handoff.**
  Evidence: `docs/06-creating-tasks.md:5` through
  `docs/06-creating-tasks.md:16` define a task as bounded work for one agent and
  say the task packet is the written handoff where agent work otherwise goes
  wrong. `docs/07-running-agents.md:5` through
  `docs/07-running-agents.md:22` say Swarm does not run agents, that the packet
  is plain markdown, and that the normal handoff is pointing the agent at the
  task file.

- **Major - The starter boot procedure lives in `AGENTS.md`, but the task
  template does not ask the worker to record that it read `AGENTS.md` or loaded
  the relevant guide.** Evidence: `starter-kit/AGENTS.md:7` through
  `starter-kit/AGENTS.md:18` define Swarm startup: read the task packet, read
  linked sources, stay in scope, run Verify, self-review, fill the run summary,
  and update status. `starter-kit/templates/task.md:38` through
  `starter-kit/templates/task.md:49` repeat source reading, scope, Verify,
  self-review, run summary, and Findings, but contain no field for `AGENTS.md`
  read evidence or skill/guide activation evidence.

- **Major - The review packet can judge requirement evidence without checking
  whether the worker booted through Swarm.** Evidence:
  `starter-kit/templates/review.md:20` through
  `starter-kit/templates/review.md:35` cover requirement rows, evidence rules,
  and spot-checking. `starter-kit/templates/review.md:45` through
  `starter-kit/templates/review.md:58` route exceptions and suggest a decision.
  Neither section records a worker boot row, a skill/guide row, or a launch
  prompt/source-packet row.

- **Major - Swarm's advanced lifecycle names the missing multi-worker handoff
  facts, but they sit outside the core run path.** Evidence:
  `docs/reference/advanced-lifecycle.md:215` through
  `docs/reference/advanced-lifecycle.md:223` say multi-agent runs keep a
  coordination record with a worker tracker and a per-worker hand-off containing
  objective, deliverable, acceptance bar, and boundaries carried verbatim into
  the task file. The core run guide still tells users that no prompt preamble is
  needed because rules travel in the template (`docs/07-running-agents.md:18`
  through `docs/07-running-agents.md:22`) and identifies worktree setup as a
  convention that nothing enforces (`docs/07-running-agents.md:43` through
  `docs/07-running-agents.md:46`).

- **Major - The Promptly task artifacts preserve task scope but not worker boot
  evidence.** Evidence:
  `/Users/josecosta/dev/promptly-docs/tasks/011-enabled-state.md:41` through
  `/Users/josecosta/dev/promptly-docs/tasks/011-enabled-state.md:52`,
  `/Users/josecosta/dev/promptly-docs/tasks/012-theme-selector.md:44` through
  `/Users/josecosta/dev/promptly-docs/tasks/012-theme-selector.md:54`,
  `/Users/josecosta/dev/promptly-docs/tasks/013-copy-response.md:42` through
  `/Users/josecosta/dev/promptly-docs/tasks/013-copy-response.md:52`, and
  `/Users/josecosta/dev/promptly-docs/tasks/014-overlay-close-cancel.md:48`
  through
  `/Users/josecosta/dev/promptly-docs/tasks/014-overlay-close-cancel.md:58`
  contain agent instructions and Findings, but no worker run summary, no
  `AGENTS.md` read evidence, and no skill/guide activation evidence.

- **Major - The Promptly validation review records requirement and environment
  status, not task-worker provenance.** Evidence:
  `/Users/josecosta/dev/promptly-docs/reviews/010-control-utilities-validation.md:33`
  through
  `/Users/josecosta/dev/promptly-docs/reviews/010-control-utilities-validation.md:41`
  record formatting, patch hygiene, TypeScript, ESLint, and runtime behavior
  rows. Those rows do not identify which delegated worker produced which change,
  what launch prompt it received, or whether it loaded the task packet and
  Swarm guides before acting.

- **Minor - The workboard shows completion/validation state but not agent
  provenance.** Evidence:
  `/Users/josecosta/dev/promptly-docs/status.md:30` through
  `/Users/josecosta/dev/promptly-docs/status.md:38` mark the four tasks as
  committed on Promptly main with human validation pending and the reviews as
  needs-human. `/Users/josecosta/dev/promptly-docs/status.md:43` records the
  Promptly implementation commit. None of those rows identifies worker identity,
  boot source, or skill activation.

- **Major - Swarm's own evidence ledger already treats handoff quality as a
  high-risk surface.** Evidence: `docs/06-creating-tasks.md:10` through
  `docs/06-creating-tasks.md:16` cite the task handoff problem, and
  the `[[PLANCODER]]` citation on `docs/06-creating-tasks.md:13` through
  `docs/06-creating-tasks.md:15` resolves to the caveated PlanCoder entry in
  `docs/research/sources.md#PLANCODER`. The core task/review templates do not
  yet expose worker boot as evidence on that same handoff surface.

## Risks

- **Major - A delegated scout can be mistaken for a Swarm worker.** Fires when a
  lead agent spawns a subagent with an objective or file path but not the full
  task-packet boot path; the durable artifacts later show useful work but do
  not prove the worker followed Swarm startup.

- **Major - Skill or guide activation can silently fail.** Fires when a worker
  should use a Swarm guide or persona but the launch context does not include
  it, and the task/review packets provide no field where missing guide evidence
  becomes visible.

- **Major - Review can pass or route requirement rows without noticing an
  orchestration defect.** Fires when the code diff and some checks are present,
  but the worker's input provenance is absent; the reviewer can judge the
  requirement evidence table while the handoff evidence remains unknown.

- **Minor - A heavy-handed boot checklist can add noise to small tasks.** Fires
  if every trivial task must prove too many process facts; Swarm already records
  that too much packet can hurt clear work at `docs/06-creating-tasks.md:93`
  through `docs/06-creating-tasks.md:97`.

## Candidate Requirement Areas

- Distinguish task workers from scouts or research helpers.
- Preserve the minimum boot evidence needed for delegated task workers.
- Give reviewers a visible exception path when boot evidence is missing for a
  worker-run task.
- Decide whether multi-worker runs use the advanced coordination record by
  default or a smaller core handoff surface.
- Decide whether a future CLI should generate the worker handoff from the task
  packet and record the launch envelope.

## Completeness Table

| Item | Evidence present? | Severity | Firing condition recorded? |
|---|---|---|---|
| O1 | yes | Major | n/a |
| O2 | yes | Major | n/a |
| O3 | yes | Major | n/a |
| O4 | yes | Major | n/a |
| O5 | yes | Major | n/a |
| O6 | yes | Major | n/a |
| O7 | yes | Minor | n/a |
| O8 | yes | Major | n/a |
| R1 | yes | Major | yes |
| R2 | yes | Major | yes |
| R3 | yes | Major | yes |
| R4 | yes | Minor | yes |

## Self-Review

- Every observation cites a file range or the accompanying research note.
- Risks include severity and firing condition.
- The audit records present state and candidate requirement areas only; it does
  not edit templates or write a change plan.
- Promptly-specific claims are limited to durable task, review, and status
  artifacts.
