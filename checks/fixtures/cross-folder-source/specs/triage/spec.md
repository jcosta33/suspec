---
type: spec
id: SPEC-triage
title: Triage queue
status: ready
owner: support-platform
sources:
  - ../../sources/sup-204.md
---

# Triage queue

## Intent

A minimal internal triage queue so support can post, sort, and close issues without a
spreadsheet.

## Non-goals

- No auth, no per-user views, no notifications — a single shared queue only.

## Requirements

### AC-001 — post an issue
- When: a client POSTs `/issues` with `{title, severity}`
- Then: the service MUST create the issue and return `201` with its id
- Verify with: `pytest tests/test_triage.py::test_post_creates`

### AC-002 — open queue sorted by severity
- When: a client GETs `/issues`
- Then: the service MUST return the open issues ordered by severity, high first
- Verify with: `pytest tests/test_triage.py::test_sorted_high_first`

### AC-003 — reject an unknown severity
- When: a POST `/issues` body carries a severity outside `[low, med, high]`
- Then: the service MUST respond `400`
- Verify with: `pytest tests/test_triage.py::test_unknown_severity_400`

## Open questions

- none

## Affected areas

- `src/triage.py`

## Dropped from sources

- The ticket's `POST /issues/<id>/close` endpoint — deliberately out of this fixture's
  scope (the fixture exercises cross-folder source resolution, not full ticket fidelity).

- The "sorted by severity" tie-break order within a severity is unspecified — left FIFO.
