# The `suspec` CLI

`suspec-cli` is Suspec's reinforcement tool: a deterministic checker over the artifacts it
is handed. It reads files, reports facts, and exits. It never writes code, never runs a
model, never renders a verdict, and never decides what merges. The methodology itself lives
in the skill family; every step keeps a by-hand path, and no step requires this tool
(level: convention).

What it earns its keep on is the honesty floor — structural facts the checker can verify
at zero model cost:

- **coverage-complete** — every in-scope requirement has a coverage row in the review
- **command-matches** — a structured evidence block names the same command as the spec
- **supported-needs-evidence** — no `Supported` with an empty evidence cell
- **ref-resolves** — every referenced artifact and anchor resolves

plus the single-artifact lint for each artifact kind. The contract — every check, with its
severity — is [checks](checks.md) (`checks/checks.yaml` in this repo).

Source: [suspec-cli](https://github.com/jcosta33/suspec-cli).

## The surface

The complete command surface (level: enforced — suspec-cli):

```bash
suspec check <artifact> [<artifact>...]                            # spec / task / change-plan files
suspec check <review-path> --spec <spec-path> [--task <task-path>] # a review packet
suspec check --contract                                            # the checks contract as JSON
```

There is no other command — no interactive mode, no dashboard, no scaffolds. A `check`
invocation does take several spec/task/change-plan paths at once: each runs its own single-artifact
lint, plus a cross-file duplicate-id check (C002) over the passed set, and the exit code is the
max severity across every file — a batching convenience for a caller checking a staged set in
one process, not a second command.

## Argument semantics

- **Explicit input paths, with bounded artifact-relative references** (level: enforced —
  suspec-cli). The CLI reads exactly the files it is handed, accepting absolute paths or paths
  relative to the process's current working directory. It never resolves a state location,
  config, or repo root. C009 and C015 resolve named paths from the passed artifact's directory;
  they do not scan. C010 alone resolves a change plan's `preserves: SPEC-id#AC-NNN` references by
  checking `spec.md` in the plan directory and in each immediate sibling directory. It never walks
  deeper or accepts another filename. Every other check has no opinion on file placement.
- **Kind from frontmatter.** The primary artifact's kind is read from its own required `type:`
  frontmatter, never from its filename or location. Missing and unknown types are blocking usage
  errors. `inventory`, `audit`, `research`, and `inspection` are recognized and return
  `checked: false`; `spec`, `task`, `review`, and `change-plan` have checker faces.
- **Report identity is explicit.** Every per-artifact JSON report repeats its recognized `type`.
  Checked faces carry diagnostics; unchecked types carry `checked: false`. The optional final
  `(file set)` C002 report is not an artifact and carries no type.
- **Strict frontmatter.** The parser accepts string scalars and flat string lists under top-level
  keys, with an optional UTF-8 BOM and comments outside quotes. It rejects malformed delimiters,
  duplicate keys, nesting, multiline values, YAML tags/references, empty list heads, and field-shape
  mismatches. It never coerces scalar values. Spec `sources`; task `source` and `scope`; review
  `waivers`; and change-plan `sources` and `preserves` are lists.
- **Companions are explicit flags.** A review packet reconciles against its spec — and its
  task, when it names one. Those companions are passed with `--spec` and `--task`; nothing
  is inferred or discovered.
- **Tasks remain spec-backed.** A task's `source` names the spec that owns its scoped
  requirements. Change-plan wave and preservation details are context, never replacement
  requirement authority. The spec status is exactly `ready` before task dispatch or review.
- **Reference checks resolve artifact-relative** (level: enforced — suspec-cli). Source
  references and a named `sources.md` resolve from the passed artifact's own directory
  using the relative paths in frontmatter, even when those paths climb folders. No root
  is inferred.
- **Unknown options fail before file reads.** A misspelled or unsupported flag is a usage error,
  never ignored and never treated as an artifact path.
- **Option values are not options.** `--spec` and `--task` require a following non-option token.
  End-of-input or another `--...` token reports `option <flag> requires a value` before help or
  artifact loading; the next option is never consumed as a path.

## The missing-companion rule

A review packet checked without a required companion is a blocking error: exit 2, naming
the missing flag (level: enforced — suspec-cli). The reconciliation checks — coverage,
command match, evidence binding — cannot run without the artifacts the review reconciles
against, and the floor never degrades silently into a shallower check. Provide the companions
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
- **No acceptance.** It never accepts work. Review assessments (`Supported` / `Unsupported` /
  `Unverified` / `Blocked`) are written by the independent reviewer; the checker verifies their
  shape and evidence binding. Review IDs and Requirement coverage are non-empty; decision and
  assessment enums are closed. Change-plan coverage is parsed with the same row shape; C016 and
  accepted-review Blocked rejection apply to both tables. C012, C013, and waivers read Requirement
  coverage only. Waivers are accepted-only, reject duplicates, and exactly reconcile Unsupported
  and Unverified requirement rows; accepted reviews have no non-empty Open decisions or Blocked
  assessment. Blocked cannot be waived. The human owns the decision and waivers.
- **No execution.** It does not run your verify commands, your tests, or any agent. It
  checks that recorded evidence matches what the spec named — not that the commands pass.
- **No writes.** It scaffolds nothing, seeds nothing, manages nothing. The filesystem is
  read-only to it.

## MCP

`suspec-mcp` adapts checking for shell-less runners. `suspec_check` accepts a non-empty array of
absolute primary paths and preserves input order through one CLI invocation, including C002. One
review target may add explicit `specPath` and `taskPath` companions. The adapter validates every
CLI payload and requires checks contract `0.18.0` (level: toolable - suspec-mcp).

## Related

- [Checks](checks.md) — the contract
- [Local checks](local-checks.md) — project-specific checks beyond the CLI's generic ones
- [Cheatsheet](cheatsheet.md)
- [Artifact formats](artifact-formats.md)
- [Structured requirements](structured-requirements.md)
