# Inspections

Inspection methods attack different failure classes. They return compact chat or improve the target.

| Method | Question | Mutation | Output |
|---|---|---|---|
| Bulletproof | Which explicit or load-bearing implied claims survive active fact-checking? | target read-only | claim assessments in chat |
| Demolition | What is the strongest persuasive case for rejecting this target? | target read-only; output quarantined from evidence | advocacy in chat |
| Revolver | What survives at least six sequential target-derived stances? | each supported finding fixed before the next stance | fixes, proof, and consequential refutations in chat |
| Triple-check | What survives exactly three fresh top-tier passes? | each supported finding fixed before the next pass | fixes, proof, and consequential refutations in chat |

## Loops

Revolver derives at least six distinct stances, runs one fresh reviewer at a time, and resolves
every finding before the next stance sees the target. It completes a full rotation, repeats after a
productive rotation, and stops after a quiet rotation or three cycles.

Triple-check derives exactly three high-consequence stances and runs exactly three fresh top-tier
reviewers. Each receives the current target and no peer prose. A supported defect is fixed and
verified before the next pass.

## Evidence boundary

Bulletproof checks every explicit and load-bearing implied claim through primary sources, code
inspection, and non-mutating checks. It returns assessments and direct evidence in chat.
Demolition opens with `Advocacy exercise, not evidence.` It may speculate but may not fabricate
sources, quotations, incidents, or test output. Nothing from Demolition becomes a finding until
independently verified.
