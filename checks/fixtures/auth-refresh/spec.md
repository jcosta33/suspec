---
# checks fixture — expected results pinned in EXPECTED.md
type: spec
id: SPEC-auth-refresh
title: Silent token refresh on 401
status: ready
owner: auth-team
sources:
  - AUTH-731
---

# Silent token refresh on 401

## Intent

When an access token expires mid-session, the web client refreshes it transparently and
replays the original request, so the user never sees a spurious login screen.

## Non-goals

- Server-side token issuance or rotation policy — owned by the identity service.
- Long-lived offline sessions.

## Requirements

### AC-001 — replay on 401
- When: a request returns 401 and a refresh token is present
- Then: the auth client MUST replay the original request once with a refreshed session
- Verify with: `npm test -- auth-refresh.spec.ts` (case `replays-after-refresh`)

### AC-002 — expired refresh token ends the session
- When: the refresh token is expired
- Then: the auth client MUST redirect to `/login`
- Verify with:

### AC-003 — refresh timeout
- When: the refresh request times out
- Then: the auth client MUST handle the failure gracefully
- Verify with: `npm test -- auth-refresh.spec.ts` (case `timeout`)

## Open questions

- None.

## Affected areas

- `web/src/http/client.ts`
- `web/src/auth/refresh.ts`
