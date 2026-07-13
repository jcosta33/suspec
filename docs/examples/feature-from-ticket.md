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

Placed in the agent-neutral workspace:

```text
~/.agents/artifacts/reports-app/report-csv-spec.md
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

## Affected areas

- `app/reports/`
- `test/e2e/`
```

Lint it:

```bash
suspec check ~/.agents/artifacts/reports-app/report-csv-spec.md
```

## Task split

One requirement, one worker — this is the common 1:1 case
([creating tasks](../06-creating-tasks.md)), so this example skips the task packet: the
review below reconciles straight against the spec. If a wider version of this feature
landed three export formats in parallel, a task per format would keep the workers off
each other's files — see [large PR review](large-pr-review.md) for a split-task shape.

## Human-finalized review

`~/.agents/artifacts/reports-app/report-csv-review.md`

```markdown
---
type: review
id: REVIEW-report-csv
pr: none yet
decision: accepted
---

## Requirement coverage

| ID | Assessment | Evidence |
| --- | --- | --- |
| AC-001 | Supported | `npm run test:e2e -- report-csv-export` -> `1 passed` |

```verify id=AC-001 cmd="npm run test:e2e -- report-csv-export" result=pass
1 passed
```
```

Check it against the spec. No `task:` in the frontmatter means no `--task` on the call:

```bash
suspec check ~/.agents/artifacts/reports-app/report-csv-review.md \
  --spec ~/.agents/artifacts/reports-app/report-csv-spec.md
```

Exits clean: the coverage row carries evidence and the matching `verify` block records the exact
command and result. The checker confirms structure and consistency; the human still owns acceptance.

## Close

No durable lesson emerged, so nothing is saved as memory. The spec and review served the
live work; the exported CSV code and its test remain.

The files now have no downstream consumer. Present one disposition choice covering both:

1. **Delete (recommended)** — the code and test now hold the durable value.
2. **Leave** — keep the transient files for near-term reuse.
3. **Promote** — move selected files into a project-owned durable destination.
4. **Other** — state another disposition for the complete set.

Execute the human selection.

## Lesson

Intent was explicit, review bound it to evidence, and the findings decision was "nothing
durable learned." The spec and checker were scaffold that made this feature cheaper to
judge; the task split was not.
