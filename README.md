# Suspec

**Put coding agents on rails. Keep humans on the decisions.**

Suspec ships as standalone skills: explicit intent in, evidence out, human decisions where they
matter. A deterministic CLI catches structural holes without a model. Your harness writes the code.
Plain Markdown keeps the work portable and the repository clean.

## Install

Install the skill family for your harness (Codex shown):

```bash
npx skills add jcosta33/suspec-skills -g -a codex
```

The skills are a complete install. Add [suspec-cli](https://github.com/jcosta33/suspec-cli) when
deterministic checks improve review.

## Use the least structure that pays

A trivial fix needs no file. Paperwork is not progress:

```text
Fix: expired refresh tokens must redirect to /login, not 500.
Verify with: pnpm test:run auth-refresh-expired-token
```

Implement it, run the command, and preserve the output.

When intent needs a structured working contract, `sus-spec` writes a spec with observable
requirements:

```markdown
### AC-001 — CSV export honors the selected date range

The export endpoint must filter rows to the selected date range before generating the CSV.

Verify with: `pnpm test:run export-date-range-filter`
```

Ordinary artifacts live outside the repository under
`~/.agents/artifacts/<workspace>/` and move by absolute path. See
[where files live](docs/03-where-files-live.md).

## Check

```bash
suspec check <path>
suspec check <review-path> --spec <spec-path>
suspec check <review-path> --spec <spec-path> --task <task-path>
```

Exit `0` is clean, `1` is warning, and `2` is blocking. The checker verifies recorded structure,
coverage, command binding, evidence presence, and references. It reports facts. It does not bless the
work.

## Method

Every change states intent, receives review, and decides what it taught. Extra scaffold must pay for
itself:

- a spec when one precise sentence cannot govern the work;
- a task when one spec must split into separately dispatchable slices;
- an inventory when present behavior or ownership is unclear;
- a change plan when structural work must preserve behavior across stages;
- a formal review when risk exceeds direct human inspection.

Suspec does not replace native plan mode, project guidance, issue trackers, PRs, CI, tests, or human
acceptance. Skills install globally; repository commands, architecture, and policy stay in the
repository that owns them.

## Fit

Use Suspec when a change outgrows direct attention, several workers share it, or someone must later
reconstruct intent and proof. Skip it when native planning, project instructions, tests, and direct
review already make the work obvious.

Its distinct mechanism is deterministic reconciliation keyed to requirement IDs. Agents assess and
recommend. Humans own intent, waivers, irreversible actions, and acceptance.

## Repositories

| Need                                            | Owner                                                      |
| ----------------------------------------------- | ---------------------------------------------------------- |
| Install the method                              | [suspec-skills](https://github.com/jcosta33/suspec-skills) |
| Run deterministic checks                        | [suspec-cli](https://github.com/jcosta33/suspec-cli)       |
| Give shell-less clients the checker             | [suspec-mcp](https://github.com/jcosta33/suspec-mcp)       |
| Read the method, formats, checks, and decisions | this repository                                            |

Start with [the basic workflow](docs/02-basic-workflow.md), [adoption](docs/ADOPTING.md), or the
[tutorial](docs/tutorial/README.md). Exact formats and contracts live under
[reference](docs/reference/). Decision history lives in the [ADR ledger](docs/adrs/README.md).
