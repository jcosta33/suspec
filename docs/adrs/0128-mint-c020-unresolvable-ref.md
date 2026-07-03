---
type: adr
id: adr-0128
status: accepted
created: 2026-07-04
updated: 2026-07-04
---

# ADR-0128 — Mint C020 unresolvable-ref (contract 0.13.0 → 0.14.0)

## Context

The blocking review checks — C012 (coverage), C013 (verify-binding), C016 (pass-needs-evidence) —
key on the review's source spec, resolved from its `task:` → `tasks/<id>.md` → `source:` spec (or,
for a 1:1 review, its `spec:` id). When that ref does **not** resolve — a typo'd/renamed task id, a
review checked in an isolated/minimal repo — `suspec check <review>` returned a CLEAN report with
no diagnostic: the checks simply could not run, so nothing fired. Measured in the round-3
enforcement-teeth stress test (suspec-works #89): a review with `task: TASK-none` (unresolvable)
and an **empty-evidence Pass row** gated clean (0 errors), while the same review with a resolvable
task correctly hit C016. So a dangling ref silently bypassed the honesty gate — the check comment's
assumption that "the spec/workspace checks already cover a missing artifact" does not hold; the
workspace checker does not validate a review file's refs.

## Decision

**Mint C020 `unresolvable-ref` (hard-error).** When `suspec check <review>` finds the review's
`task:` ref resolving to **no local task packet** (`tasks/<id>.md` absent), it emits C020 instead of
a silent clean pass. A task packet is always local, so an unresolvable `task:` is unambiguously a
dangling ref — a hard error at the gate face, mirroring C016 (not a judgment call). The `suspec
review` reconcile face stays advisory (ADR-0077 D8).

**Deliberately narrow.** C020 does *not* fire when a resolved task's `source:` spec is unreachable,
nor on a 1:1 review whose `spec:` does not resolve: a spec may legitimately live in another repo
(cross-root, ADR-0100 — checked via the task's embedded snapshot when present), which is
indistinguishable from a typo at this workspace. Firing there would break the ADR-0100
cross-root-no-snapshot case (which stays clean by design). C020 covers only the provable dangling
ref — the missing task packet — which is exactly the bypass #89 demonstrated (`task: TASK-none` with
an empty-evidence Pass gating clean). A review that names no ref at all is unchanged.

Contract version bumps **0.13.0 → 0.14.0**. C018 remains reserved (ADR-0094/0097); C020 is the next
minted id after C019.

## Consequences

- suspec-cli's `check_review_file` emits C020 on an unresolvable `task:` or `source:`/`spec:` ref;
  `CORE_CHECKS` gains the C020 row; the drift guard reconciles version + row against canon.
- `checks.yaml` + `checks.md` carry the C020 row; the honesty gate no longer has a silent-pass hole
  for dangling refs.
- No change to the reconcile face's advisory posture, or to reviews that name their spec correctly.

## Status

Accepted (2026-07-04).
