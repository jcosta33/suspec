---
type: research
id: RESEARCH-codex-subagent-orchestration
title: Subagent orchestration controls for Swarm boot critique
status: closed
owner: codex
date: 2026-06-12
---

# Research: Subagent orchestration controls for Swarm boot critique

## Question

Which documented orchestration controls should inform a critique of delegated
agents that did not behave like fully Swarm-booted workers?

## Boundaries

- This is inquiry, not a decision record or change plan.
- The question is orchestration and handoff evidence, not whether Swarm should
  ship a runtime.
- The conclusion below is advisory context for an audit; it does not set
  requirements.

## Sources

- OpenAI Agents SDK, "Agent orchestration" and "Handoffs":
  <https://openai.github.io/openai-agents-python/multi_agent/> and
  <https://openai.github.io/openai-agents-python/handoffs/>,
  retrieved 2026-06-12.
- LangChain docs, "Multi-agent", "Subagents", and "Handoffs":
  <https://docs.langchain.com/oss/python/langchain/multi-agent>,
  <https://docs.langchain.com/oss/python/langchain/multi-agent/subagents>, and
  <https://docs.langchain.com/oss/python/langchain/multi-agent/handoffs>,
  retrieved 2026-06-12.
- Google ADK docs, "Workflows", "Collaborative workflows", "Agent routing",
  and "Agent team": <https://adk.dev/workflows/>,
  <https://adk.dev/workflows/collaboration/>,
  <https://adk.dev/agents/routing/>, and
  <https://adk.dev/tutorials/agent-team/>, retrieved 2026-06-12.
- Microsoft AutoGen AgentChat docs, "Teams" and "Termination":
  <https://microsoft.github.io/autogen/stable/user-guide/agentchat-user-guide/tutorial/teams.html>
  and
  <https://microsoft.github.io/autogen/stable/user-guide/agentchat-user-guide/tutorial/termination.html>,
  retrieved 2026-06-12.
- Anthropic Engineering, "How we built our multi-agent research system":
  <https://www.anthropic.com/engineering/multi-agent-research-system>,
  retrieved 2026-06-12.
- Swarm local docs and templates:
  `docs/06-creating-tasks.md`, `docs/07-running-agents.md`,
  `docs/reference/advanced-lifecycle.md`, `starter-kit/AGENTS.md`,
  `starter-kit/templates/task.md`, and `starter-kit/templates/review.md`.

## Findings

### R-001 - Handoffs are a shaped interface, not just a spawn event.

Observation: OpenAI's Agents SDK documents two orchestration modes: letting an
LLM decide the agent flow, or controlling the flow in code. Its handoff guide
models delegation as a tool-like surface with a destination agent, description,
optional structured handoff input, callbacks, and input filters. It also
recommends handoff-aware prompt material so models understand how to use
handoffs.

What this bears on: if Swarm treats a task packet as the delegation handoff, the
packet or launch prompt is the contract surface. A bare subagent objective is
weaker than the patterns documented here because it does not say which context
arrives, which metadata is logged, or what the receiving agent should emit.

### R-002 - Supervisor/subagent systems rely on explicit specs, inputs, and outputs.

Observation: LangChain's subagents pattern keeps a main agent in control while
calling subagents as tools. Its docs name context engineering as central to
multi-agent design and break subagent control into specs, inputs, and outputs.
The subagents page also records a common failure mode: a subagent can do work
but fail to include the useful result in its final message, so the supervisor
does not receive what it needs.

What this bears on: a Swarm worker handoff needs more than "do this task"; it
needs enough context and an output contract for the lead/reviewer to consume.
That maps directly to Swarm's `Run summary`, Verify evidence, and Findings
surfaces.

### R-003 - Deterministic orchestration is the common alternative when routing must be predictable.

Observation: OpenAI distinguishes LLM-driven orchestration from code-driven
flows; ADK documents graph workflows, template workflows, routed agents, and
collaborative workflows; LangChain documents router and custom-workflow
patterns. These sources frame routing and control flow as architecture choices,
not merely prompting style.

What this bears on: the audit should not say Swarm must become a runtime, but it
can legitimately critique the lack of a recorded launch envelope when humans or
agent runners do the routing. Swarm can remain markdown-first while still
single-sourcing the delegation payload.

### R-004 - Return, termination, and mode are first-class orchestration facts.

Observation: ADK collaborative workflows distinguish subagent modes such as
chat, task, and single-turn, with different interaction and return behavior.
AutoGen teams use group-chat structures, observable message streams, and
termination conditions; their examples surface stop reasons in the returned
task result.

What this bears on: Swarm task execution already has a completion surface in
`Run summary`, but the starter task/review packet does not ask for evidence that
the worker actually loaded the Swarm startup path before returning that summary.
The missing evidence is an orchestration fact, not just documentation polish.

### R-005 - Production multi-agent practice stresses detailed subtask briefs.

Observation: Anthropic's engineering post describes an orchestrator-worker
research system where the lead agent decomposes work and spawns subagents. It
reports that vague subagent instructions caused duplicated work and coverage
gaps, and says subagents need an objective, output format, tool/source guidance,
and clear task boundaries.

What this bears on: this is the closest external analogue to the Promptly run.
It supports critiquing vague or side-channel delegation, but it also cautions
against a simplistic "more agents" answer: useful subagents need precise
boundaries and a return contract.

### R-006 - Swarm already names the task packet as the handoff, but does not preserve boot proof.

Observation: Swarm's task guide says the handoff is where agent work goes wrong
and identifies the task packet as that written handoff
(`docs/06-creating-tasks.md:10` through `docs/06-creating-tasks.md:16`).
The run guide says to point an agent at the task file and that no prompt
preamble is needed because rules travel in the template
(`docs/07-running-agents.md:12` through `docs/07-running-agents.md:22`).
The advanced lifecycle defines a per-worker hand-off record with objective,
deliverable, acceptance bar, and boundaries carried verbatim into the task file
(`docs/reference/advanced-lifecycle.md:215` through
`docs/reference/advanced-lifecycle.md:223`).

What this bears on: Swarm has the right conceptual center of gravity. The gap is
that core task/review artifacts do not make boot evidence observable: whether
the worker read `AGENTS.md`, loaded the relevant skill/guide, followed the task
packet rather than the lead's ad hoc prompt, and returned the expected summary.

## Options Observed

| Option | Evidence fit | Cost / risk |
|---|---|---|
| Keep status quo: point workers at task files | Matches Swarm's markdown-first run guide and avoids overhead | Cannot distinguish a true Swarm-booted worker from a delegated scout when the run goes through an external orchestrator |
| Add a small boot-evidence surface to task/review packets | Aligns with handoff metadata, subagent input/output contracts, and termination evidence in the sources above | Adds ceremony if applied to every tiny task without risk scaling |
| Generate or single-source a worker launch envelope from the task packet | Keeps Swarm markdown-first while reducing side-channel prompts | Requires future tooling or a documented copy/paste convention |
| Promote the advanced coordination record for multi-worker runs | Already exists in Swarm reference docs and maps to orchestrator-worker practice | Too heavy as a default for single-worker or trivial tasks |

## Advisory Reading For The Audit

The critique should be narrow: Swarm does not need to become OpenAI Agents SDK,
LangChain, ADK, or AutoGen. The durable gap is that delegated agents can appear
to participate in Swarm while leaving no artifact that proves they received and
followed the Swarm boot path.

The strongest audit framing is therefore evidence-oriented:

- the task packet is the intended handoff;
- the worker launch can bypass or dilute that handoff;
- the task/review templates do not ask for boot evidence;
- reviewers can validate requirement evidence without noticing that the worker
  was never fully Swarm-booted.

## Open Questions

- Should Swarm distinguish "scout subagent" from "task worker" explicitly?
- Which boot facts are useful evidence rather than process theatre: task path,
  source path, `AGENTS.md` read, skill/guide loaded, Verify commands, worktree,
  branch, or launch prompt?
- Should missing boot evidence be a review exception only for multi-worker runs,
  or for every task packet?
- Is this best handled by templates, an advanced coordination record, or a
  future `swarm run` handoff generator?
