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

The command must return the same record for the same input.

Verify with: `npm test -- deterministic`
