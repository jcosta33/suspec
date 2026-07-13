# Review stances

A stance is a bounded question a reviewer asks of the current target. It is a procedure,
not a tone or default role menu.

## Derive from the target

Inspect the spec, diff, trust boundaries, data flow, failure modes, and verification gaps.
Name distinct stances that can expose different classes of error in this change. A stance
earns a slot only when it owns a concrete surface and can state what evidence would refute
the work.

Examples are intentionally not prescribed. A payment migration, parser change, public API,
and documentation rewrite require different questions. Reusing a familiar label without a
target-specific threat or invariant adds ceremony, not coverage.

## Reviewer contract

Each reviewer receives:

- the current target and source spec by explicit path
- one stance and its bounded question
- relevant verification output as an index, not proof
- read-only permissions
- a return contract: actionable findings with evidence, or no finding

The reviewer does not issue the final review decision.

## Revolver

For substantial work:

1. Derive at least six distinct stances justified by the target. Use no canned menu or fixed upper
   limit.
2. Fix the stance pool and order, then run one fresh reviewer at a time without prior reviewer prose.
3. After each stance, the orchestrator verifies every finding and fixes, rejects, or stops for a
   human decision. Reviewers never edit.
4. Dispatch nothing else while a material finding remains unresolved. The next reviewer sees the
   addressed target, including every prior fix.
5. Complete a full rotation. Repeat only after a rotation produces a new supported finding, and stop
   after a quiet rotation or the hard three-cycle cap.

Revolver creates no artifact. Its final chat handoff contains only material changes, verification,
trust-relevant rejected findings, and unresolved human choices.

Model variety can be used as a practical hedge, but it is not evidence that failures are
independent. Judge the review by surfaced defects and rerun checks, not model labels.

## Focused methods

Use `bulletproof` for hostile scrutiny of an important claim, decision, spec, plan, or finding.
When trust boundaries or dangerous sinks are reachable, derive a security stance from that target
and verify concrete reachability. Methods do not replace independent review or human authority.

Related: [reviewing output](../08-reviewing-output.md) · [agent guides](agent-guides.md)
