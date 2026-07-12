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
- read/write permissions
- a return contract: actionable findings with evidence, or no finding

The reviewer does not issue the final review decision.

## Revolver

For substantial work:

1. Derive a diverse stance pool from the target.
2. Run one reviewer at a time.
3. Reconcile the finding and apply a legitimate fix before the next round.
4. Make every next reviewer inspect the revised state.
5. Complete a full rotation, then repeat only while a rotation finds new relevant issues
   and the cycle bound has not been reached.

Model variety can be used as a practical hedge, but it is not evidence that failures are
independent. Judge the review by surfaced defects and rerun checks, not model labels.

## Focused methods

Use `bulletproof` for hostile scrutiny of an important claim, decision, spec, plan, or
finding. Use `security-review` when trust boundaries or dangerous sinks are reachable.
These methods define procedures; they do not replace independent review or human authority.

Related: [reviewing output](../08-reviewing-output.md) · [agent guides](agent-guides.md)
