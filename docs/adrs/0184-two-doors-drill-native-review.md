---
type: adr
id: adr-0184
status: accepted
created: 2026-08-19
---

# ADR-0184 - Drill, native independent review, delete the review packet

## Context

ADR-0144 already makes intent, review, and findings the keys and allows review to be reading the
diff. ADR-0119 already splits independent judgment from the formal packet. Canon and the cheatsheet
still sold the six-step loop as the product. `type: review` was a first-class checked artifact:
`sus-review` wrote it; the checks contract listed it; C012, C013, C016, C020, C026, and C027 keyed
on it. The owner asserts no live packets to preserve.

## Decision

1. **Identity is the skill catalog.** Each skill does one job. Use the skill the work needs.
2. **The six-step sequence is the path for spec-governed work, not the product.**
3. **Review stays a key.** A non-implementer judges the result on a native PR, via Revolver,
   Triple-check, or Bulletproof. No Suspec review file. The implementer cannot accept the work or
   render the verdict.
4. **Delete the review packet.** No `type: review`, no `REVIEW-` prefix, no `sus-review`, no
   `review_file` contract. CLI `--task` is unknown. Tasks bind with `--spec` only. Checks contract
   version `0.26.0`. C012, C013, C016, C020, C026, and C027 are RESERVED and never reused. Task
   status `review-ready` remains a task lifecycle value.
5. **Keep `sus-change-plan`** as the closer when preservation, cutover, or rollback must be a
   checked staged map.
6. **Add `drill`** as a universal method. Levels: Language → Obligation → Place → Slice. No Suspec
   artifact. No `CONTEXT.md`. Obligation names preservation, verify-with, and rollback for this
   slice without writing `type: change-plan`. Escalate to a change plan when ordered waves plus
   rollback must outlive the session.

## Consequences

- `type: review` is `unknown_type`.
- Independent review remains; the packet does not.
- The skill catalog removes `sus-review` and adds `drill` in the same major. `npx skills add` does
  not prune; remove `sus-review` and re-add the family so `drill` lands.
- Historical ADR bodies stay frozen. This record narrows 0119, 0128, 0134, 0143, 0144, 0151, 0153,
  0154, 0157, 0158, and 0159.

## Status

Accepted (2026-08-19). Narrows ADR-0119, ADR-0128, ADR-0134, ADR-0143, ADR-0144, ADR-0151, ADR-0153, ADR-0154, ADR-0157, ADR-0158, and ADR-0159.
