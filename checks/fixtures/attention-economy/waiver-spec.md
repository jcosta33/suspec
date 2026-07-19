---
type: spec
id: SPEC-waiver
title: Waiver fixture
status: ready
owner: test
sources: [ISSUE-3]
---

## Intent

Exercise accepted review waiver capture.

## Requirements

### AC-001 - Local behavior
- When: the command runs locally
- Then: the command MUST report its local behavior
- Verify with: `npm test -- deterministic`

### AC-002 - External observation
- When: the command affects the external system
- Then: the operator SHOULD record the external system observation
- Verify with: named operator observation
