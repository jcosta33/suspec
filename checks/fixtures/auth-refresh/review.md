---
type: review
id: REVIEW-auth-refresh
task: TASK-auth-refresh
pr: https://example.test/pr/412
decision: pending
---

# Silent token refresh on 401

## Changed files

- `web/src/http/client.ts`
- `web/src/auth/refresh.ts`

## Requirement coverage

| ID | Assessment | Evidence |
|---|---|---|
| AC-001 | Supported | `replays-after-refresh ✓` — PR run #88 |
| AC-002 | Unverified | No named test or current output. |
| AC-003 | Supported | `timeout ✓` — PR run #88 |

## Open decisions

- AC-002: add the missing test or accept with an explicit waiver.
