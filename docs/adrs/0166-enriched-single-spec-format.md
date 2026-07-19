---
type: adr
id: adr-0166
status: accepted
created: 2026-07-19
---

# ADR-0166 - Enriched single spec format

## Context

ADR-0164 correctly removed a second spec surface and its selector. The surviving format still gave
the checker little structure: one heading, free prose, and a verification line. Predictable structure
earns its cost when it exposes real mechanical defects. It need not improve model reasoning to be
valuable, just as a linter need not design the program it checks.

Agents author written Suspec specs. The skill can therefore emit one canonical shape directly. A
read-only lint-and-rewrite loop is enough; no formatter or CLI write mode is needed.

## Decision

1. **One spec format remains.** The `format:` selector and alternate flush-left surface stay dead.
   Each requirement uses one Markdown heading and three labeled list items:

   ```markdown
   ### AC-001 - Expired session
   - When: a request uses an expired session
   - Then: the API MUST return HTTP 401
   - Verify with: pnpm test -- session.spec.ts
   ```

   `When: always` expresses an unconditional invariant without another requirement type.
2. **C028 `requirement-shape` enforces the block.** Each requirement has exactly one non-empty
   `When`, one non-empty `Then`, and one `Verify with` item, in that order, with no other live body
   line. C003 continues to reject an empty `Verify with` value. C028 is a hard error. This catches
   omitted conditions, omitted responses, duplicate fields, malformed labels, and prose that escaped
   the record without duplicating C003.
3. **C004 becomes exact and blocking.** `one-strength-word` counts only the `Then` value and requires
   exactly one `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, or `MAY`. Zero leaves the obligation
   unbound; several collapse several bindings into one record. Both are hard errors.
4. **Existing verification binding stands.** The one-line `Verify with` value remains the command or
   manual method named by C003 and reconciled by C013. No path-only target grammar is imposed:
   transient artifacts may live outside the repository, literal commands and manual observations
   remain valid, and no demonstrated consumer needs another reference kind.
5. **Block types stay out.** Behavior, constraint, invariant, and interface labels unlock no proven
   check in the current system. Add one only with a real defect and type-specific deterministic rule.
6. **The CLI stays read-only.** It parses and diagnoses. Agents rewrite malformed specs. No `fmt`,
   `--fix`, execution, repository discovery, or write path is added.
7. **Rigor stays proportional.** The enriched block applies only when work earns a written spec.
   Inline intent remains one loose sentence. A minimal written requirement costs three short lines.
8. **The checks contract advances to `0.23.0`.** C028 is new. C004 keeps its ID and name while its
   warning floor becomes an exact hard format rule.

The labels expose structure, not truth. C028 can prove that a condition and response are present; it
cannot prove that the natural-language response is genuinely observable. Human review retains that
job.

## Superseded and upheld decisions

- [ADR-0164](./0164-one-spec-format.md) is **narrowed**: its one-format, no-selector decision stands;
  its behaviors-only sub-decision is superseded by the enriched single block above. SOL does not
  return.
- [ADR-0143](./0143-path-agnostic-check-cli-contract.md) is upheld: checking remains explicit-path
  and read-only.
- [ADR-0131](./0131-minimum-useful-rigor.md) is upheld: fileless inline intent remains available.

## Consequences

- Every agent-authored written spec has one predictable requirement record.
- The checker can reject missing fields, escaped prose, and compound modal bindings without semantic
  guesswork.
- Existing written specs must be rewritten to the enriched block before they pass contract `0.23.0`.
- The single format becomes more lintable without regaining a selector, notation family, or writer.

## Status

Accepted (2026-07-19). Narrows ADR-0164, upholds ADR-0131 and ADR-0143, and advances the checks
contract to `0.23.0`.
