# Review stances

A stance is one bounded, target-derived question with a concrete failure surface and refuting evidence.
It is a procedure, not a tone or reusable role label.

Derive stances from the spec, diff, trust boundaries, data flow, failure modes, and verification gaps.
Payment migrations, parsers, public APIs, and documentation require different questions.

## Reviewer contract

Give each fresh reviewer:

- current target and source spec by explicit path;
- one stance;
- verification output as an index, not proof;
- read-only permissions;
- a return contract: evidenced actionable findings or no finding.

Reviewers never decide acceptance.

## Revolver

1. Derive at least six materially distinct stances. Use no canned menu or fixed upper limit.
2. Fix the pool and order.
3. Run one fresh reviewer at a time without prior reviewer prose.
4. Verify every finding. Fix supported defects; refute false findings with decisive evidence; stop on
   a human decision or concrete blocker.
5. Dispatch the next stance only after resolution.
6. Complete a full rotation. Repeat only after a productive rotation. Stop after a quiet rotation or
   the hard three-cycle cap.

Revolver creates no artifact. Final chat contains material changes, proof, consequential refutations,
and blockers.

Model variety may reduce correlated framing but proves no independence. Judge surfaced defects and
rerun evidence, not model labels.

Use Bulletproof for active claim verification and Triple-check for exactly three deep fresh passes.
Methods never replace independent review or human authority.

Related: [review](../08-reviewing-output.md) · [native subagents](agent-guides.md)
