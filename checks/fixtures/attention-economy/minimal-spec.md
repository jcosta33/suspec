---
type: spec
id: SPEC-minimal
title: Minimal spec
status: ready
owner: test
sources: [ISSUE-1]
---

## Intent

Expose one deterministic behavior.

## Requirements

### AC-001 - Deterministic behavior
- When: the command receives the same input more than once
- Then: the command MUST return the same record
- Verify with: `npm test -- deterministic`
