# Agent guides

Suspec agents are isolation and role adapters. They are useful when a fresh context or a
read-only permission boundary improves the work; they are not the methodology. Every
procedure remains usable from its skill alone or by hand.

Source: [suspec-agents](https://github.com/jcosta33/suspec-agents).

## Roles

| Agent | Owns | Does not own |
| --- | --- | --- |
| `suspec-reviewer` | independent review against a spec and rerun evidence | implementation or merge authority |
| `suspec-auditor` | present-state observations with evidence | requirements or fixes |
| `suspec-challenger` | pressure-testing an uncommitted proposal | reviewing finished work |
| `suspec-spec-author` | verifiable requirements and scope boundaries | implementation choices not decided by the source |
| `suspec-documentarian` | human-facing documentation | product decisions |
| `suspec-researcher` | evidence for one decision-informing question | the decision itself |

Use the runner's normal code exploration together with `codebase-exploration` for code
location work.

## Dispatch contract

A dispatch prompt names every input by full path and says what the agent returns. Include:

- the target spec, task, diff, or source files
- the repository or worktree to inspect
- write permissions and explicit boundaries
- commands the agent must run
- the expected return shape

Agents do not discover Suspec artifacts. A review names its spec and split task paths; an
implementation names its spec or task path.

## Independence

The implementer does not issue the review result. Use a fresh session, another agent, or a
human reviewer. Worker output is an index of claims; the reviewer reruns evidence and
inspects the code.

For rotating review, derive stances from the actual target. Do not preload a default
stance menu into the reviewer definition.

## Projections

Canonical Markdown definitions and hand-maintained Codex TOML projections must remain
semantically exact. Edit the canonical agent first, then compare its name, description, and body
against the projection before handoff.

## Human authority

Agents report findings, severity, and evidence. They leave coverage results, packet status,
waivers, and the merge decision to the human reviewer; checker output never becomes a verdict.

Related: [review stances](review-stances.md) · [reviewing output](../08-reviewing-output.md)
