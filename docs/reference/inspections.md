# Inspections

Inspections route different questions through different evidence and cost contracts. Every
substantive run writes one `type: inspection` artifact and no ship verdict.

| Method | Question | Mutation |
|---|---|---|
| Bulletproof | Which explicit or load-bearing implied claims survive active fact-checking? | target read-only |
| Demolition | What is the strongest persuasive case for rejecting this target? | target read-only; output quarantined from evidence |
| Revolver | What do all distinct target-justified risk stances find? | inspect by default; explicit refine through orchestrator |
| Triple-check | What do three fresh top-tier passes find on the highest-consequence surfaces? | inspect by default; explicit refine through orchestrator |

## Modes

`inspect` keeps the target fixed. Revolver completes risk-derived rotations and stops after a
quiet rotation or its hard cycle cap. Triple-check completes exactly three fresh passes and hides
peer reports between them.

`refine` requires an explicit request. Reviewers remain read-only. The orchestrator verifies each
finding, applies accepted fixes, and pins the revised target before the next fresh pass.

## Evidence boundary

Bulletproof may inspect primary sources and run non-mutating checks to fill evidence gaps.
Demolition opens with `Advocacy exercise, not evidence.` It may speculate but may not fabricate
sources, quotations, incidents, or test output. Nothing from Demolition becomes a finding until
independently verified.

## Artifact

```yaml
type: inspection
method: bulletproof # bulletproof | demolition | revolver | triple-check
target: path-or-stable-identifier
mode: inspect       # optional
```

Large evidence and round logs use adjacent sidecars with stable anchors.
