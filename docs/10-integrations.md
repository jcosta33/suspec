# Integrations

Suspec uses markdown. Any tool that can read files can use it. The methodology is the
skills; every step keeps a by-hand path, and each integration below reinforces work that
can still be done without it (level: convention).

## The CLI

[suspec-cli](https://github.com/jcosta33/suspec-cli) is the deterministic checker — the
honesty floor. It is explicit-path: it discovers no primary artifact or companion beyond the paths
passed as absolute or current-working-directory-relative inputs. It resolves no config or repo root.
These reference checks are artifact-relative: source
paths and citation files resolve from the spec's
directory using the paths its frontmatter names. For a change plan, C010 scans `spec.md`
in each immediate child directory of the plan directory's parent, including the plan's
own directory. A plan and `spec.md` in one directory therefore work; deeper trees are not
searched (level: enforced — suspec-cli).

The surface:

```bash
suspec check <path>                                           # spec, task, or change plan
suspec check <review-path> --spec <spec-path>                       # review packet
suspec check <review-path> --spec <spec-path> --task <task-path>    # split-task review
suspec check --contract                                       # the checks contract as JSON
```

- Companions are explicit flags; a review packet checked without a required companion is
  a blocking error (exit 2) — the floor never degrades silently.
- Exit codes are the API: `0` clean, `1` warning, `2` blocking. `--json` is the
  structured face.
- It reports facts — a missing coverage row, a `Supported` with no evidence, a command that
  does not match the spec, a reference that does not resolve, artifact lint — and never
  renders acceptance.

The full surface and the checks it runs: [CLI reference](reference/cli.md) and
[checks](reference/checks.md).

## The MCP server

[suspec-mcp](https://github.com/jcosta33/suspec-mcp) gives MCP-capable, shell-less runners
`suspec_check`, `suspec_get_checks`, and the checks-contract resource. `suspec_check` accepts a
non-empty array of absolute primary paths, preserves input order, and passes the set through one CLI
invocation so C002 remains available. One review target may add explicit `specPath` and `taskPath`
companions. The server validates every CLI payload and requires checks contract `0.19.0`. Its
response envelope is `ok`, `source`, `data`, optional `note`, and `responseFormat`. An agent that can
run shell commands does not need MCP.

## Agents

Give the agent:

- `AGENTS.md` (or your harness's equivalent standing instructions)
- the spec — and the task packet, when work is split — by absolute path
- the repo checkout or worktree

Common setup:

| Tool | Integration |
| --- | --- |
| Claude Code | reads `AGENTS.md`; can share it through a `CLAUDE.md` symlink |
| Codex | reads `AGENTS.md` and the spec/task paths in the prompt |
| Cursor | read the spec or task packet in chat, or attach the file |
| GitHub Copilot | paste or link the spec or task packet |
| Aider / other CLIs | point the command at the spec or task file |

The spec is the contract; a task packet narrows it when work is split. The agent UI is replaceable.

## Issue trackers

Keep the tracker as the backlog.

Use Suspec for the working contract:

1. Point the spec's `sources` at the ticket URL or stable tracker ID.
2. Write a working spec when the change earns structured intent.
3. Link the PR and the review outcome back to the tracker.

## PRs and CI

Keep PRs and CI.

The review packet connects CI output to requirements:

- the PR shows the diff
- CI runs commands
- the review packet records which requirement each result supports

`suspec check` emits facts and an exit code; a team that wants a hard gate wires CI to
block on the exit code (level: toolable — `suspec check`, exit codes 0/1/2). The gate is
the team's — Suspec reports, it never owns merge authority. The check's bounds are
honest: it verifies coverage, evidence presence, reference resolution, and — for a `Supported`
row backed by a structured `verify` block — command match (a `Supported` row backed only by
free-form evidence is flagged advisory, routed to a human, not machine-matched);
whether the evidence demonstrates the requirement is the reviewer's own run and the
human's review decision.

## Code repos

Code repos stay clean. Nothing lands in the adopter's repo — no config, no directories,
no gitignore entries (level: convention). Committed agent guides (`AGENTS.md` and
friends) are your project's own practice; Suspec artifacts stay outside in the
agent-neutral artifact workspace, per [where files live](03-where-files-live.md).

## Boundaries

Suspec does not own:

- model settings
- provider credentials
- editor UI
- issue tracker state
- CI configuration
- merge authority

## Related

- Previous: [Saving findings](09-saving-findings.md)
- Start over: [What is Suspec?](01-what-is-suspec.md)
