# Feature from ticket

```text
WEB-123

Add a "Download CSV" button to the report page.
It should export the currently filtered rows.
```

## Spec

`~/.agents/artifacts/reports-app/report-csv-spec.md`:

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
- When: a user exports the report
- Then: the report page MUST export the currently filtered rows as CSV
- Verify with: `npm run test:e2e -- report-csv-export`

## Affected areas

- `app/reports/`
- `test/e2e/`
```

```bash
suspec check ~/.agents/artifacts/reports-app/report-csv-spec.md
```

One requirement and one worker need no task. Splitting nothing still produces nothing.

## Review

`~/.agents/artifacts/reports-app/report-csv-review.md`:

````markdown
---
type: review
id: REVIEW-report-csv
spec: SPEC-report-csv
pr: none yet
reviewer: fresh-review-session
decision: pending
---

## Requirement coverage

| ID     | Assessment | Evidence                                              |
| ------ | ---------- | ----------------------------------------------------- |
| AC-001 | Supported  | `npm run test:e2e -- report-csv-export` -> `1 passed` |

```verify id=AC-001 cmd="npm run test:e2e -- report-csv-export" result=pass
1 passed
```
````

```bash
suspec check ~/.agents/artifacts/reports-app/report-csv-review.md \
  --spec ~/.agents/artifacts/reports-app/report-csv-spec.md
```

The checker confirms structure and command consistency. The human selects Accept; the workflow
changes `decision` to `accepted`. No durable lesson emerged. Good. The code and test retain the value, so
[close the transient files](../03-where-files-live.md#close).
