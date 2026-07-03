---
type: adr
id: adr-0127
status: accepted
created: 2026-07-04
updated: 2026-07-04
---

# ADR-0127 — C004 exempts SOL INTERFACE blocks (contract 0.12.0 → 0.13.0)

## Context

C004 (`one-strength-word`, at-least-one since ADR-0126) fired on **every** parsed requirement,
including SOL `INTERFACE` (`IF-`) blocks. But an INTERFACE is a signature **declaration**, not an
obligation: its grammar (`docs/reference/structured-requirements.md`) is
`RETURNS` / `ACCEPTS` / `ERRORS` / `OWNED BY` — there is no strength-word slot. A conformant
INTERFACE therefore always counts zero strength words and always draws the C004 warning "add the
one word (MUST/SHOULD/…) it binds on" — a warning with **no valid fix**, since there is no `MUST`
to add to a `RETURNS`. Measured in the round-5 SOL stress test (suspec-works #96): only INTERFACE
mis-fired; CONSTRAINT (`MUST NOT`) and INVARIANT (`MUST`) in the same spec did not. It trains users
to ignore C004 or deters them from the documented, encouraged way to declare a boundary.

## Decision

**C004 applies to obligation blocks only.** SOL `INTERFACE` (`IF-`) is exempt — it carries no
strength word by grammar, so "binds on nothing" is inapplicable, not a defect. `QUESTION` (`Q-`)
is already excluded upstream (it never parses as a requirement). C004 continues to apply to `REQ`
(`AC-`), `CONSTRAINT` (`C-`), and `INVARIANT` (`I-`), which do bear an obligation.

INTERFACE ids remain parsed, scopeable, and coverage-tracked (unchanged) — the exemption is C004's
applicability only, not the block's status as a requirement. Contract version bumps
**0.12.0 → 0.13.0**; C004's id, name, and severity are unchanged (the applicability rule is the
row's comment in `checks.yaml`).

## Consequences

- suspec-cli pins 0.13.0 and skips `IF-` ids in `check_one_strength_word`; the drift guard
  reconciles the version.
- The `checks.yaml` C004 row and the canon `checks.md` row note the obligation-blocks-only
  applicability.
- An INTERFACE contract with no `MUST` no longer draws an un-actionable warning; the honest signal
  (a REQ/CONSTRAINT/INVARIANT that binds on nothing) is unchanged.

## Status

Accepted (2026-07-04).
