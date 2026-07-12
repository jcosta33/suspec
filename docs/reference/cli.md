# The `suspec` CLI

`suspec-cli` is Suspec's reinforcement tool: a deterministic checker over the artifacts it
is handed. It reads files, reports facts, and exits. It never writes code, never runs a
model, never renders a verdict, and never decides what merges. The methodology itself lives
in the skill family; every step keeps a by-hand path, and no step requires this tool
(level: convention — [ADR-0134](../adrs/0134-self-contained-spine.md)).

What it earns its keep on is the honesty floor — structural facts the checker can verify
at zero model cost:

- **coverage-complete** — every in-scope requirement has a coverage row in the review
- **command-matches** — a structured evidence block names the same command as the spec
- **pass-needs-evidence** — no `Pass` with an empty evidence cell
- **ref-resolves** — every referenced artifact and anchor resolves

plus the single-artifact lint for each artifact kind. The contract — every check, with its
severity — is [checks](checks.md) (`checks/checks.yaml` in this repo).

Source: [suspec-cli](https://github.com/jcosta33/suspec-cli).

## The surface

The complete command surface (level: enforced — suspec-cli):

```bash
suspec check <artifact> [<artifact>...]                            # spec / change-plan files (exit = max across files)
suspec check <review-path> --spec <spec-path> [--task <task-path>] # a review packet
suspec check --contract                                            # the checks contract as JSON
```

There is no other command — no interactive mode, no dashboard, no scaffolds. A `check`
invocation does take several spec/change-plan paths at once: each runs its own single-artifact
lint, plus a cross-file duplicate-id check (C002) over the passed set, and the exit code is the
max severity across every file — a batching convenience for a caller checking a staged set in
one process, not a second command.

## Argument semantics

- **Path-agnostic, with narrow artifact-relative reference checks** (level: enforced —
  suspec-cli). The CLI reads exactly the files it is handed, accepting absolute paths or
  paths relative to the process's current working directory. It never resolves
  a state location, config, repo root, or surrounding filesystem tree — except these reference checks,
  each of which resolves one level of sibling directory relative to the passed artifact:
  C009 and C015 (see the next bullet), and C010, which resolves a change plan's `preserves:
  SPEC-id#AC-NNN` refs by looking one level above the plan's own directory, then globbing
  that parent's immediate subdirectories for a file literally named `spec.md` (never a tree
  walk). Concretely, the resolver globs every immediate subdirectory of the plan's parent
  for a file named `spec.md` — which trivially includes the plan's own directory, so
  `<parent>/<plan-dir>/change-plan.md` beside `<parent>/<spec-dir>/spec.md` resolves, and so
  does a `spec.md` placed directly alongside `change-plan.md` in one flat folder. What never
  resolves is a `spec.md` nested any deeper than one level, or named anything else. Every
  other check and artifact kind has no opinion on where your files live.
- **Kind from frontmatter.** The primary artifact's kind is read from its own `type:`
  frontmatter, never from its filename or location. The lint that runs is that kind's own.
- **Companions are explicit flags.** A review packet reconciles against its spec — and its
  task, when it names one. Those companions are passed with `--spec` and `--task`; nothing
  is inferred or discovered.
- **Reference checks resolve artifact-relative** (level: enforced — suspec-cli). Source
  references and a named `sources.md` resolve from the passed artifact's own directory
  using the relative paths in frontmatter, even when those paths climb folders. No root
  is inferred.

## The missing-companion rule

A review packet checked without a required companion is a blocking error: exit 2, naming
the missing flag (level: enforced — suspec-cli). The reconciliation checks — coverage,
command match, evidence binding — cannot run without the artifacts the review reconciles
against, and the floor never degrades silently into a shallower check. Pass the companions
or get a blocking exit; there is no partial mode.

## Exit codes

The exit code is the API (level: enforced — suspec-cli). It reports the most severe finding:

| Exit | Meaning |
| --- | --- |
| `0` | clean |
| `1` | warning — nothing blocking |
| `2` | blocking — a blocking finding, a missing required companion, or a usage error |

What blocks a merge is the human's decision. The CLI reports severity at check time and
stops there.

## `--json`

Every invocation takes `--json`: the same facts, structured — check id, severity, message,
location. A single checked artifact emits one JSON document. A multi-artifact invocation
emits one JSON document per line in input order: JSON Lines, not one array or one combined
document. `suspec check --contract` prints one JSON document containing the contract
version and check definitions.

## What the checker does not do

- **No discovery.** It never finds primary artifacts or companions for you. Every input
  path is explicit; only C009, C015, and C010 perform the bounded artifact-relative
  reference lookups described above.
- **No gate.** It does not decide "done". It reports facts and exit codes; the human
  decides what blocks a merge.
- **No verdicts.** It never judges whether code is correct or a requirement is met. Review
  results (`Pass` / `Fail` / `Unverified` / `Blocked`) are written by the human reviewer; the
  checker verifies their shape and their binding to evidence, nothing more.
- **No execution.** It does not run your verify commands, your tests, or any agent. It
  checks that recorded evidence matches what the spec named — not that the commands pass.
- **No writes.** It scaffolds nothing, seeds nothing, manages nothing. The filesystem is
  read-only to it.

## MCP

`suspec-mcp` adapts this same surface for shell-less runners: path-explicit tools that
shell out to `suspec check --json` (level: toolable — suspec-mcp).

## Related

- [Checks](checks.md) — the contract
- [Local checks](local-checks.md) — project-specific checks beyond the CLI's generic ones
- [Cheatsheet](cheatsheet.md)
- [Artifact formats](artifact-formats.md)
- [Structured requirements](structured-requirements.md)
