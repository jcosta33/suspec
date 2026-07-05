# The `suspec` CLI

`suspec-cli` is optional. The markdown workflow does not require it.

The CLI prepares files, launches configured agents, and reconciles evidence.
It does not write code and does not decide whether code is correct.

Use the [suspec-cli README](https://github.com/jcosta33/suspec-cli#commands) for exact flags and shipped commands.

## Boundary

| CLI owns | Agent or team owns |
| --- | --- |
| scaffolding | coding loop |
| intake snapshots | model reasoning |
| checks | edits |
| task packets | provider credentials |
| worktrees | tool-calling runtime |
| launch envelope | correctness |
| review draft | merge decision |

## Shipped surface

The command set includes:

- `init`
- `update`
- `check`
- `new`
- `worktree`
- `status`
- `clean`
- `stamp`
- `review`
- `pull`
- `promote`
- `run --agent`
- `work <SPEC>`
- `show`
- `agents emit --codex`
- `help`

`suspec-mcp` exposes CLI data over MCP. It shells out to the CLI `--json` contract.

## Non-goals

The CLI does not provide:

- `suspec close` that mutates the board
- code generation
- spec compilation
- automatic task decomposition
- architecture enforcement
- agent runtime
- model configuration
- verdicts

## Deferred or measured-out

Deferred:

- `suspec inventory new`
- per-adapter hook generation
- run-record `commands[]`
- strict SOL parser
- per-task cost attribution

Measured-out:

- hard oversized-packet threshold. Diff size is reported as neutral review information.

## Command contracts

### `suspec init`

Creates a workspace from the starter kit.

Writes `AGENTS.md`, templates, guides, flow folders, examples, and `status.md`.

### `suspec pull <ticket>`

Captures an external ticket into `intake/`.

It does not write a spec.

### `suspec new spec <slug> [--title <t>] [--owner <o>]`

Creates `specs/<slug>/spec.md` from the template.

The user fills requirements.

### `suspec check [file...]`

Reads specs or workspace files and reports diagnostics. Accepts one or more files in a single
invocation (the exit code is the max across them), so a batch — e.g. the pre-commit hook's staged
set — is checked in one process rather than paying the startup cost per file. With no file, it
renders the whole-workspace verdict — including that the workspace has the paths the kit's
`suspec-kit.yaml` declares as required (a manifest-less kit falls back to a built-in default).

Exit codes:

- `0`: clean
- `1`: warnings
- `2`: hard errors

It reports facts. It does not issue a merge verdict.

### `suspec new task --from <SPEC-id> [--scope AC-...]`

Creates a task packet from declared scope.

It does not invent requirements.

### `suspec new change-plan <slug> [--title <t>] [--owner <o>]`

Creates a draft change plan.

Use it for migrations, rewrites, or structural changes that need waves.

### `suspec worktree <create|list|remove|prune>`

Creates and tracks task worktrees.

One task gets one branch or worktree.

### `suspec clean [--apply]`

Reports spent ephemeral task and review artifacts.

With `--apply`, it prunes the spent artifacts that are safe to remove.

### `suspec stamp <ref>`

Writes staleness provenance for a spec snapshot or review evidence hash.

It makes later drift checks compare against an explicit recorded revision.

### `suspec run <task> --agent <name>`

Launches a configured agent in the task worktree.

Records the launch envelope. The agent does the work.

### `suspec work <SPEC>`

Works a spec directly — the task is optional. Creates or reuses the spec's worktree, runs project-declared
setup from `suspec.config.json` (advisory — a failed setup warns and launches anyway), generates a lean
prompt pointing the agent at the spec, launches the configured adapter, and records the run.

It renders no verdict and writes no board — its only writes are the run record and the transient prompt
under `.suspec/work/`. The by-hand path (create the worktree, `cd` in, run your agent against the spec)
needs no CLI (ADR-0134); `work` only accelerates it.

### `suspec review <task>`

Drafts a review packet from the task, diff, spec, and change plan.

It routes mismatches and exceptions to human attention. It does not decide the result.

### `suspec status`

Prints a derived board from workspace files — the state of record where the CLI is installed.

`--needs-review` narrows the human-readable board to the specs with an actionable task (awaiting
review or needing a human), so what needs attention is visible at a glance at volume; the summary
lines always render, and `--json` stays the raw, unfiltered board a client slices itself.

Committed `status.md` stays hand-edited as the Human-attention list and durable links, never a
state cache.

### `suspec show <task|spec|review|checks> [ref]`

Projects a parsed artifact or the checks contract as JSON.

It reads only and renders no verdict.

### `suspec update [--check | --write]`

The kit drift surface: `--check` (the default) reports where the local workspace guides/templates
have drifted from the shipped kit; `--write` lands the kit content (leaving `*.suspec-bak` backups).
It refreshes only the paths the kit declares as its own in `suspec-kit.yaml` — a manifest-less kit
falls back to a built-in default — never an adopter's own artifacts. It renders no verdict.

### `suspec promote <task>`

Scaffolds one `findings/<slug>.md` from a closing task's Findings section, pre-filling `from:`. It
never mutates the board.

### `suspec agents emit --codex [--from <dir>] [--force]`

Generates Codex TOML from Claude Code agent definitions.

Tool scoping and hooks remain Claude-Code-only; the emitter carries prose discipline.

### `suspec help`

Prints the command reference.

## Local state

If the CLI is used inside a code repo, it may create a gitignored directory:

```text
.suspec/
  config.yaml
  work/
  cache/
  tmp/
```

Rules:

- never commit `.suspec/`
- deleting it loses no durable record
- specs, reviews, and findings stay in the workspace

## Adapter shape

```yaml
agents:
  codex:
    command: codex
    working_directory: task_worktree
    startup_instruction: "Read AGENTS.md, then read the task file you were given."
```

Adapters launch existing tools. They do not carry credentials or model settings.

## Run record

Reserved machine shape:

```json
{
  "task_id": "...",
  "changed_files": [],
  "commands": [],
  "out_of_scope": [],
  "findings": [],
  "provenance": {}
}
```

This is reconciliation input. Markdown remains the durable artifact.

## Source policies

| Policy | Meaning |
| --- | --- |
| `generated` | emitted from a named source artifact |
| `governed` | implementation under a spec requirement |
| `observed` | existing code with no spec yet |
| `external` | third-party code |
| `deprecated` | migration or removal only |

`observed` is the brownfield default. Code is not silently treated as governed.

## Related

- [Checks](checks.md)
- [Structured requirements](structured-requirements.md)
- [Advanced lifecycle](advanced-lifecycle.md)
- [Memory](memory.md)
