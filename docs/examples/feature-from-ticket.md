# Example: feature from ticket

Goal: turn one ticket into a reviewed feature — the full spec -> optional split ->
review -> check flow.

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

## Task (optional split)

One requirement, one worker — this feature doesn't need a split. If a wider version of
this feature landed three export formats in parallel, a task per format would keep the
workers off each other's files:

`~/.claude/notes/reports-app/report-csv-task.md`

```markdown
---
type: task
id: TASK-report-csv
source:
  - SPEC-report-csv
scope: [AC-001]
status: review-ready
---

## Scope

- AC-001 - export currently filtered rows as CSV.

## Do not change

- report filtering semantics

## Verify

- [x] `npm run test:e2e -- report-csv-export` (AC-001)

      1 passed

## Run summary

- Changed files: `app/reports/export.ts`, `app/reports/page.tsx`, `test/e2e/report-csv.spec.ts`
- Verify results:
  - `npm run test:e2e -- report-csv-export` (AC-001): PASS, output above
- Out-of-scope edits: none
- Blocked questions: none
```

## Review

`~/.claude/notes/reports-app/report-csv-review.md`

```markdown
---
type: review
id: REVIEW-report-csv
task: TASK-report-csv
pr: none yet
status: pass
---

## Requirement coverage

| ID | Result | Evidence | Human attention |
| --- | --- | --- | --- |
| AC-001 | Pass | `npm run test:e2e -- report-csv-export` -> `1 passed` | no |

Spot-checked: AC-001 - reran the e2e test; output matched.

## Human attention

- None.

## Suggested decision

Merge.
```

Check it against both companions:

```bash
suspec check ~/.claude/notes/reports-app/report-csv-review.md \
  --spec ~/.claude/notes/reports-app/report-csv-spec.md \
  --task ~/.claude/notes/reports-app/report-csv-task.md
```

Exits clean: one requirement, one coverage row, evidence present.

## Close

No durable lesson beyond the spec itself — nothing to save as a memory here. The spec,
task, and review have served their purpose; the exported CSV code and its test are what
remain.

## Lesson

The review coverage row is the important artifact. It binds the ticket's acceptance
criterion to evidence — everything upstream of it (the ticket, the spec) exists to make
that row possible to write honestly.
