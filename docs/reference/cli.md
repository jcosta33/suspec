# The `suspec` CLI

`suspec-cli` is Suspec's reinforcement tool: a deterministic checker over the artifacts it
is handed. It reads files, reports facts, and exits. It never writes code, never runs a
model, never renders a verdict, and never decides what merges. The methodology itself lives
in the skill family; every step keeps a by-hand path, and no step requires this tool
(level: convention — [ADR-0134](../adrs/0134-self-contained-spine.md)).

What it earns its keep on is the honesty floor — the facts a lazy or dishonest reviewer
cannot fake, at zero model cost:

- **coverage-complete** — every in-scope requirement has a coverage row in the review
- **command-matches** — the recorded evidence ran the command the spec named
- **pass-needs-evidence** — no `Pass` with an empty evidence cell
- **ref-resolves** — every referenced artifact and anchor resolves

plus the single-artifact lint for each artifact kind. The contract — every check, with its
severity — is [checks](checks.md) (`checks/checks.yaml` in this repo).

Source: [suspec-cli](https://github.com/jcosta33/suspec-cli).

## The surface

The complete command surface (level: enforced — suspec-cli):

```bash
suspec check <path>                                                # a spec or change plan
suspec check <review-path> --spec <spec-path> [--task <task-path>] # a review packet
suspec check --contract                                            # the checks contract as JSON
```

There is no other command — no interactive mode, no dashboard, no scaffolds.

## Argument semantics

- **Path-agnostic, always** (level: enforced — suspec-cli). The CLI reads exactly the files
  it is handed, by full path. It never resolves a config, a repo root, or a directory
  layout; never scans for sibling files; never reads git. Where your artifacts live is your
  choice — the checker has no opinion.
- **Kind from frontmatter.** The primary artifact's kind is read from its own `type:`
  frontmatter, never from its filename or location. The lint that runs is that kind's own.
- **Companions are explicit flags.** A review packet reconciles against its spec — and its
  task, when it names one. Those companions are passed with `--spec` and `--task`; nothing
  is inferred or discovered.
- **Reference checks resolve artifact-relative** (level: enforced — suspec-cli). Source
  references and citation anchors resolve against the passed artifact's own directory —
  `sources.md` is the spec's sibling — never against any root.

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
location. `suspec check --contract` prints the checks contract itself as JSON (version plus
check definitions), so other tools can consume the same definitions the checker runs.

## What the checker does not do

- **No resolution.** It never finds files for you. Every path is given; nothing is
  discovered, listed, or inferred.
- **No gate.** It does not decide "done". It reports facts and exit codes; the human
  decides what blocks a merge.
- **No verdicts.** It never judges whether code is correct or a requirement is met. Review
  results (`Pass` / `Fail` / `Unverified` / `Blocked`) are written by the reviewer; the
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
- [Cheatsheet](cheatsheet.md)
- [Artifact formats](artifact-formats.md)
- [Structured requirements](structured-requirements.md)
