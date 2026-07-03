---
type: adr
id: adr-0129
status: accepted
created: 2026-07-04
updated: 2026-07-04
---

# ADR-0129 — C013 cmd-mismatch blocks at the gate (contract 0.14.0 → 0.15.0; amends ADR-0083)

## Context

ADR-0083 minted C013 (`verify-evidence-binding`) as a **consistency fact** shipped conservatively at
`warning` on every face, "the structured-form mismatch is hard-capable but ships conservative … until
field-tested." A round-1 enforcement probe (suspec-works #95) then showed the softest face is a real
hole: a review whose verify block records `cmd=<fabricated>` — a command name that disagrees with the
requirement's named `Verify with:` — draws only an **advisory** warning, so a fabricated/renamed
command name slips the gate. This is distinct from the other C013 faces (free-form-only is genuinely
fuzzy; malformed/duplicate are shape nits): a cmd-mismatch is a **structural contradiction** — the
recorded evidence claims to run one command while the spec names another.

The field test ADR-0083 asked for has happened; the mismatch face has earned promotion. The broader
"the Verify chain is citation, not proof" point in #95 is **working as designed** and stays so — the
CLI is reconcile-only (ADR-0085) and never executes a Verify command; C013 confirms the recorded
command's consistency, not that it ran. Promotion tightens the consistency check; it does not add an
executor.

## Decision

**A C013 cmd-mismatch is a hard error at the GATE face** (`suspec check <review>`) — a recorded verify
block whose `cmd` disagrees with the requirement's named command blocks. The other C013 faces
(free-form-only, malformed, duplicate, result-fail) stay `warning`, and the **reconcile face**
(`suspec review`) stays advisory on every face (ADR-0077 D8 — the CLI never blocks there). C013's
nominal contract severity remains `warning` (the row); the cmd-mismatch elevation is a per-face,
per-kind override, exactly the inverse of C016 (nominally hard-error, advisory in reconcile).

Contract version bumps **0.14.0 → 0.15.0**. C013's id and name are unchanged; the `checks.yaml`/
`checks.md` rows note the gate-face cmd-mismatch behavior.

## Consequences

- suspec-cli's gate wrapper `check_verify_binding` ships the cmd-mismatch diagnostic hard-error;
  `verify_binding_facts` (the reconcile face) is untouched. The drift guard reconciles the version.
- A fabricated command name in a review packet now fails `suspec check <review>` instead of nudging.
- The honest boundary is unchanged and documented: nothing re-runs the command; C013 is a consistency
  check. If a future measurement shows the promotion over-fires, it supersedes cleanly.

## Status

Accepted (2026-07-04). Amends [ADR-0083](./0083-mint-c013-verify-evidence-binding.md).
