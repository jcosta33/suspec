# Agent guides

*Works today — plain markdown plus your agent; no Swarm tooling required.*

The guides are short procedural documents an agent CLI loads on demand (each ships as a
`SKILL.md`, auto-discoverable by agent tools and plainly readable by humans). They carry
procedure; the templates carry shape; this page is the index.

## Core (ship in `starter-kit/agent/`, copied beside your own skills)

| Guide | Use when |
|---|---|
| `write-spec` | turning a ticket/intake into a spec — intent not implementation, one behavior per requirement, every requirement verifiable |
| `implement-task` | executing a task packet — stay in scope, run every Verify item, paste real output, self-review the diff before handoff |
| `review-output` | filling a review packet — refute by default, re-run checks, evidence rules, route the exception triggers |

## Advanced (ship in `starter-kit/advanced/`, copy when needed)

| Guide | Use when |
|---|---|
| `write-audit` | recording the present state of an area — observation only, evidence per finding |
| `write-inventory` | mapping brownfield code before structural change — the contract map |
| `write-change-plan` | planning a refactor/rewrite/migration — baseline, preservation guarantees, waves, rollback |
| `write-research` / `persona-surveyor` | depth research on one question / breadth surveys across many examples |
| `write-bug-report` | reproducing and root-causing a defect — diagnosis, never the fix |
| `write-prd` / `write-rfc` | upstream intent and proposals |
| `spec-check` | running the checks of `checks.md` by hand |
| `split-work` | partitioning a large change into parallel-safe tasks |
| `save-findings` | the Close step — routing durable discoveries to findings |

## Implementation guides (library, for code-side depth)

`docs/library/code-skills/` carries long-form execution guides per change shape
(feature, fix, refactor, rewrite, migration, performance, testing, documentation,
flaky tests) plus `implement-task` in long form. Optional — copy what your team uses.

Guides are conventions: they steer an agent, nothing enforces them. Review stances —
the cognitive postures the guides embed — are described in
[review-stances.md](review-stances.md).
