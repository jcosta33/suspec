---
type: spec
id: SPEC-deferred
title: Deferred decision
status: draft
owner: test
sources: [ISSUE-2]
---

## Intent

Choose the public error contract.

## Requirements

### AC-001 - Stable error

The API must return a documented error record.

Verify with: `npm test -- error-contract`

## Open questions

- Error representation blocks implementation. Recommendation: structured object.
  Options: structured object; stable string code; defer the API. Other remains available.
