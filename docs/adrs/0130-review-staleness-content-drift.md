---
type: adr
id: adr-0130
status: accepted
created: 2026-07-04
updated: 2026-07-04
---

# ADR-0130 — Review staleness also catches diff-content drift (amends ADR-0107)

## Context

ADR-0107's fast-track staleness pins (`reviewed_sha` + `evidence_hash`, written by `suspec stamp`)
are meant to flag a review Stale when "the diff or the cited evidence drifts." A round-3 probe
(suspec-works #97) found a hole in the most dangerous case: `evidence_hash` is a digest over the diff's
**path set** + the coverage rows' evidence cells, **not** the diff **content**. So mutating the
content of an already-reviewed file — same path set, a new commit on the branch (e.g. adding a
backdoor to a file that was already in the diff) — leaves the digest unchanged, `reviewed_sha` falls
behind the new tip, and `suspec review` raises no Stale flag. The post-review content mutation the pin
exists to catch goes undetected.

## Decision

**A reviewed file that now differs from its `reviewed_sha` state is content drift → also Stale.**
`suspec review` additionally flags Stale when, for a packet carrying `reviewed_sha`, any path in the
review's own diff set differs between `reviewed_sha` and the worktree (via the existing
`paths_changed_since`). This is OR'd with the existing digest-mismatch trigger; the Stale posture is
unchanged (a `warning` that re-routes to re-review, never a block — ADR-0077 D8).

**Precise and 0-FP by construction:** only the review's own diff paths count (an unrelated post-review
commit does not stale the review), and when `reviewed_sha` does not resolve, `paths_changed_since`
returns null and the check degrades to the prior digest-only behavior rather than false-flagging. The
git access is an **injected predicate** into the pure reconcile engine (mirroring C009's `exists` /
C010's `spec_ref_resolves`); reconcile-only — no minted check, no contract version bump.

## Consequences

- suspec-cli's `reconcile_review` ORs a content-drift signal into `reviewStale`; `resolveReviewRun`
  injects `paths_changed_since(worktreePath, reviewed_sha)`. Fixture reconciles that inject no
  predicate keep the digest-only behavior.
- A post-review content mutation of an already-reviewed file now re-routes to re-review — closing the
  exact attack the pin was meant to cover.

## Status

Accepted (2026-07-04). Amends [ADR-0107](./0107-fast-track-staleness-detection.md).
