# Review stances

A stance is one bounded, target-derived question with a concrete failure surface and refuting
evidence. It is a procedure, not a costume.

Derive stances from the spec, diff, trust boundaries, data flow, failure modes, and verification gaps.
Payment migrations, parsers, public APIs, and documentation require different questions.

## Reviewer contract

Give each fresh reviewer:

- current target, plus the source spec by explicit path when the workflow is spec-backed;
- one stance;
- verification output as an index, not proof;
- read-only permissions;
- a return contract: evidenced actionable findings or no finding.

Reviewers never decide acceptance. Finding a defect does not confer executive power.

## Revolver

Use Revolver for breadth: at least six target-derived stances, one fresh reviewer at a time, and every
finding resolved before the next. Complete full rotations; repeat after a productive rotation; stop
after a quiet rotation or three cycles. It creates no artifact.

Executable procedure: [Revolver](https://github.com/jcosta33/suspec-skills/tree/main/skills/revolver).

## Triple-check

Use Triple-check for narrow depth: exactly three distinct high-consequence stances, one fresh top-tier
reviewer per pass, and every real defect fixed and verified before the next. Complete all three. It
creates no artifact.

Executable procedure:
[Triple-check](https://github.com/jcosta33/suspec-skills/tree/main/skills/triple-check).

Different model names are not a scientific control. Model variety may reduce correlated framing but
proves no independence. Judge surfaced defects and rerun evidence, not model labels.

Use Bulletproof for active claim verification. Methods never replace independent review or human
authority.

Related: [review](../08-reviewing-output.md) · [native subagents](agent-guides.md)
