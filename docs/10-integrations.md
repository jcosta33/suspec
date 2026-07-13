# Integrations

Suspec uses Markdown and explicit paths. Skills carry the method; integrations reinforce it.

## CLI

[suspec-cli](https://github.com/jcosta33/suspec-cli) checks supplied artifacts without discovering a
repository, configuration, or store.

```bash
suspec check <path>
suspec check <review-path> --spec <spec-path>
suspec check <review-path> --spec <spec-path> --task <task-path>
suspec check --contract
```

Exit `0` is clean, `1` warning, and `2` blocking. `--json` returns structured reports. Missing
required review companions block instead of weakening the check.

Source and citation paths resolve from the spec directory. C010 scans `spec.md` in immediate child
directories of the change-plan directory's parent, including the plan directory, and never deeper.

The CLI reports facts, never acceptance. See [CLI reference](reference/cli.md) and
[checks](reference/checks.md).

## MCP

[suspec-mcp](https://github.com/jcosta33/suspec-mcp) exposes `suspec_check`,
`suspec_get_checks`, and `suspec://checks` to shell-less MCP clients.

`suspec_check` accepts an ordered non-empty array of absolute primary paths and passes it through one
CLI invocation so C002 can run. Exactly one review target may add `specPath` and `taskPath`. The
server validates every CLI payload, requires checks contract `0.19.0`, and returns `ok`, `source`,
`data`, optional `note`, and `responseFormat`.

Agents with shell access can call the CLI directly.

## Harnesses

Give any worker:

- project instructions;
- the spec and optional task by absolute path;
- the repository or worktree.

The UI and provider are replaceable. Suspec ships no custom agents.

## Project systems

Keep existing owners:

- issue trackers hold backlog and source IDs;
- PRs show diffs and discussion;
- CI runs commands;
- review maps those results to requirements;
- project policy decides which CLI exit codes block;
- project records hold durable decisions and lessons.

The checker verifies coverage, evidence presence, references, and command matches for structured
`verify` blocks. Free-form evidence receives advisory human review. Suspec never owns credentials,
model settings, editor UI, tracker state, CI configuration, or merge authority.

Adopter repositories receive no Suspec configuration, directories, or gitignore entries. Their own
agent guides remain project policy.

Previous: [findings and memory](09-saving-findings.md). Start: [what Suspec is](01-what-is-suspec.md).
