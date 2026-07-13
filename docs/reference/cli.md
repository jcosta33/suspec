# The `suspec` CLI

[suspec-cli](https://github.com/jcosta33/suspec-cli) is a read-only deterministic checker. It runs no
model or verification command, writes nothing, and renders no acceptance decision.

## Commands

```bash
suspec check <artifact> [<artifact>...]
suspec check <review-path> --spec <spec-path> [--task <task-path>]
suspec check --contract
```

Several spec, task, or change-plan paths share one process and receive individual checks plus C002
duplicate-ID reconciliation. Reviews run alone because companion flags belong to one target.

## Inputs

- Paths are absolute or relative to the process working directory.
- Frontmatter `type:` selects the checker face; filenames and locations do not.
- `spec`, `task`, `review`, and `change-plan` are checked.
- `inventory`, `audit`, and `research` return `checked: false`.
- Missing and unknown types block.
- Review companions are explicit. `--spec` is mandatory; `--task` is required exactly when the
  review names a task.
- Unknown options and missing option values fail before file reads.

The strict frontmatter subset accepts top-level string scalars and flat string lists, optional UTF-8
BOM, and comments outside quotes. It rejects malformed delimiters, duplicates, nesting, multiline
values, tags, references, empty list heads, coercion, and field-shape mismatches.

## Reference resolution

The CLI discovers no repository, configuration, store, primary artifact, or companion.

- C009 and C015 resolve named paths from the spec directory.
- C010 resolves `SPEC-id#AC-NNN` against `spec.md` in the plan directory and immediate sibling
  directories only.

## Output

| Exit | Meaning                         |
| ---- | ------------------------------- |
| `0`  | clean                           |
| `1`  | warning                         |
| `2`  | blocking finding or usage error |

`--json` emits one document per report in input order; several reports form JSON Lines.
`suspec check --contract` emits the contract version and definitions.

The checker verifies structure, coverage, command binding, evidence presence, and references. It does
not run commands, prove evidence, compare live diffs, set merge policy, or accept work.

Exact check behavior: [checks](checks.md). Runtime installation and implementation:
[suspec-cli README](https://github.com/jcosta33/suspec-cli).
