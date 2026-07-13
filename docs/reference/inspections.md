# Inspections

Inspection methods route different questions through different evidence, output, and cost contracts.
Compact implementation proof stays in the implementation handoff: command, numeric exit, and
decisive raw output, with no new artifact.

| Method | Question | Mutation | Output |
|---|---|---|---|
| Bulletproof | Which explicit or load-bearing implied claims survive active fact-checking? | target read-only | inspection artifact |
| Demolition | What is the strongest persuasive case for rejecting this target? | target read-only; output quarantined from evidence | inspection artifact |
| Revolver | What survives at least six sequential target-derived stances? | orchestrator addresses each stance before the next | target changes and compact chat; no artifact |
| Triple-check | What do three fresh top-tier passes find on the highest-consequence surfaces? | inspect by default; explicit refine through orchestrator | inspection artifact |

## Modes

Triple-check's `inspect` mode keeps the target fixed through exactly three fresh passes and hides
peer reports between them.

Triple-check's `refine` mode requires an explicit request. Reviewers remain read-only. The
orchestrator verifies each finding, applies accepted fixes, and pins the revised target before the
next fresh pass.

Revolver has no fixed-snapshot mode. It derives at least six distinct stances, runs one fresh
reviewer at a time, and addresses every finding before the next stance sees the current target. A
full rotation is mandatory. It repeats only after a rotation produces a new supported finding and
stops after a quiet rotation or three cycles.

## Evidence boundary

Bulletproof inspects the target claim set, checks every explicit and load-bearing implied claim,
and uses primary sources, code inspection, and non-mutating checks to fill evidence gaps. A compact
claim check may report assessments and direct evidence inline; a substantive run uses the inspection
artifact below.
Demolition opens with `Advocacy exercise, not evidence.` It may speculate but may not fabricate
sources, quotations, incidents, or test output. Nothing from Demolition becomes a finding until
independently verified.

## Artifact

```yaml
type: inspection
method: bulletproof # bulletproof | demolition | triple-check
target: path-or-stable-identifier
mode: inspect       # optional; Triple-check only: inspect | refine
```

Use `bulletproof`, `demolition`, or `triple-check` as the artifact method. Revolver creates no
artifact or sidecar. Large evidence and round logs for artifact-producing methods use adjacent
sidecars with stable anchors.
