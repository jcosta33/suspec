# Example: feature from ticket

Goal: turn one ticket into a reviewed feature — spec -> implementation -> review ->
check, with no scaffold the work does not earn.

## Ticket

```text
WEB-123

Add a "Download CSV" button to the report page.
It should export the currently filtered rows.
```

## Spec

Placed beside the author's own working files — one example:

```text
~/.claude/notes/reports-app/report-csv-spec.md
```

```markdown
---
type: spec
id: SPEC-report-csv
title: Report CSV export
status: ready
owner: reporting-team
sources:
  - WEB-123
---

# Report CSV export

## Intent

Users can export the rows currently visible in the report.

## Non-goals

- No scheduled exports.
- No export of hidden or unfiltered rows.

## Requirements

### AC-001 - Export visible rows

The report page must export the currently filtered rows as CSV.

Verify with: `npm run test:e2e -- report-csv-export`

## Open questions

- None.

## Affected areas

- `app/reports/`
- `test/e2e/`
```

Lint it:

```bash
suspec check ~/.claude/notes/reports-app/report-csv-spec.md
```

## Task split

One requirement, one worker — this is the common 1:1 case
([creating tasks](../06-creating-tasks.md)), so this example skips the task packet: the
review below reconciles straight against the spec. If a wider version of this feature
landed three export formats in parallel, a task per format would keep the workers off
each other's files — see [large PR review](large-pr-review.md) for a split-task shape.

## Human-finalized review

`~/.claude/notes/reports-app/report-csv-review.md`

```markdown
---
type: review
id: REVIEW-report-csv
pr: none yet
status: pass
---

## Requirement coverage

| ID | Result | Evidence | Human attention |
| --- | --- | --- | --- |
| AC-001 | Pass | `npm run test:e2e -- report-csv-export` -> `1 passed` | no |

Reran: AC-001 - the e2e test output matched.

## Human attention

- None.

## Suggested decision

Merge.
```

Check it against the spec — no `task:` in the frontmatter means no `--task` on the call,
per [ADR-0143](../adrs/0143-path-agnostic-check-cli-contract.md):

```bash
suspec check ~/.claude/notes/reports-app/report-csv-review.md \
  --spec ~/.claude/notes/reports-app/report-csv-spec.md
```

Exits with an advisory warning (exit 1): one requirement, one coverage row, evidence
present — C013 flags the free-form Evidence cell and routes it to human attention. Add a
`verify` block ([ADR-0083](../adrs/0083-verify-evidence-reconcile.md)) to machine-confirm
it and exit clean instead.

## Close

No durable lesson emerged, so nothing is saved as memory. The spec and review served the
live work; the exported CSV code and its test remain.

## Lesson

Intent was explicit, review bound it to evidence, and the findings decision was "nothing
durable learned." The spec and checker were scaffold that made this feature cheaper to
judge; the task split was not.
