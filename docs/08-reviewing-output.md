# Review

`sus-review` independently reconciles finished work against a ready spec. A task narrows scope and
indexes evidence; it cannot replace the spec. The implementer cannot review their own work.

## Shape

```markdown
---
type: review
id: REVIEW-checkout-expiry
task: TASK-checkout-expiry
reviewer: session-or-name
decision: pending
---

# Checkout expiry review

## Requirement coverage

| ID     | Assessment | Evidence                                  |
| ------ | ---------- | ----------------------------------------- |
| AC-001 | Supported  | `3 passed` — `evidence-checkout.md#E-001` |
| AC-002 | Unverified | CI run is unavailable.                    |
```

The review ID and non-empty `Requirement coverage` table are required. Add changed files, findings,
open decisions, or change-plan coverage only when they carry information.

| Assessment    | Meaning                               |
| ------------- | ------------------------------------- |
| `Supported`   | evidence demonstrates the requirement |
| `Unsupported` | evidence demonstrates failure         |
| `Unverified`  | evidence is missing or insufficient   |
| `Blocked`     | a dependency prevents assessment      |

The agent leaves `decision: pending`. Valid decisions are `pending`, `accepted`,
`changes-requested`, and `deferred`.

When a task executes a change-plan wave, `Change-plan coverage` uses the same columns and assessments.
C016 and the accepted-review Blocked rule apply to both coverage tables. C012, C013, and waivers apply
only to Requirement coverage.

## Evidence

Rerun every applicable `Verify with:` command against the judged state. Worker output remains a claim.
Keep short decisive output once. Move dominating raw output into an adjacent
[evidence receipt](reference/artifact-formats.md#evidence-receipt) and link its stable anchor beside a
verbatim excerpt.

A structured record may bind the command:

````markdown
```verify id=AC-001 cmd="npm test -- expired-session" result=pass
3 passed
Full output: `evidence-checkout.md#E-001`
```
````

Its info string records consistency; it does not prove the body or issue a verdict.

## Check

```bash
suspec check <review-path> --spec <spec-path>
suspec check <review-path> --spec <spec-path> --task <task-path>
```

The checker reports coverage, command binding, evidence presence, references, and severity. C016
blocks `Supported` with empty evidence. The checker never accepts work.

## Human decision

After assessment, recommend:

- **Accept:** every row is supported and no blocker remains.
- **Request changes:** unsupported rows or material findings remain.
- **Defer:** blocked rows or unresolved material decisions remain.
- **Accept with waivers:** the owner deliberately accepts unsupported or unverified requirements.

Write the human selection to `decision`. For accepted work, `waivers` is absent unless Requirement
coverage contains `Unsupported` or `Unverified`. Then list every such ID exactly once, no others,
and record owner, reason, and follow-up in the project's decision channel.

Accepted reviews contain no `Blocked` assessment or non-empty `Open decisions`. Blocked work cannot
be waived.

The review remains live through findings and requested fixes. Close its complete transient set only
after no downstream step needs it; see [artifact close](03-where-files-live.md#close).

For broad risk, Revolver runs at least six target-derived stances sequentially and resolves each
before the next. For narrow depth, Triple-check runs exactly three fresh top-tier passes. Neither
creates an artifact.

Exact review contract: [artifact formats](reference/artifact-formats.md).

Next: [findings and memory](09-saving-findings.md). Previous: [execution](07-running-agents.md).
