# Inspections

Inspection methods attack different failure classes. They return compact chat or improve the target.

| Method | Question | Mutation | Output |
|---|---|---|---|
| Bulletproof | Which explicit or load-bearing implied claims survive active fact-checking? | target read-only | claim assessments in chat |
| Demolition | What is the strongest persuasive case for rejecting this target? | target read-only; output quarantined from evidence | advocacy in chat |
| Revolver | What survives at least six sequential target-derived stances? | each supported finding fixed before the next stance | fixes, proof, and consequential refutations in chat |
| Triple-check | What survives exactly three fresh top-tier passes? | each supported finding fixed before the next pass | fixes, proof, and consequential refutations in chat |

## Loops

Exact sequencing, resolution, and stopping rules: [review stances](review-stances.md).

## Evidence boundary

Bulletproof checks every explicit and load-bearing implied claim through primary sources, code
inspection, and non-mutating checks. It returns assessments and direct evidence in chat.
Demolition runs only on explicit request and opens with `Advocacy exercise, not evidence.` It marks
speculation, attacks ideas rather than people, and ends without balance or verdict. It may not
fabricate sources, quotations, incidents, users, commands, or test output. Nothing from Demolition
becomes a finding until independently verified.
