# Reviewing output

`sus-review` reconciles finished work against the spec. A task, when present, only scopes the
requirements and indexes evidence. The agent assesses evidence; the human accepts, requests
changes, defers, or waives.

Use an independent session, agent, or human. The implementer does not assess their own work.
Begin only when the source spec's status is exactly `ready`; a draft, missing, or unknown status
blocks review.

## Review artifact

Write it in the agent-neutral artifact workspace:

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

| ID | Assessment | Evidence |
| --- | --- | --- |
| AC-001 | Supported | `3 passed` — `evidence-checkout.md#E-001` |
| AC-002 | Unverified | CI run is unavailable. |
```

The review ID and `Requirement coverage` are required and non-empty. Add changed files, findings, open
decisions, or change-plan coverage only when they carry information.

Assessments:

- `Supported`: evidence demonstrates the requirement.
- `Unsupported`: evidence demonstrates the requirement is not met.
- `Unverified`: evidence is missing or insufficient.
- `Blocked`: a dependency prevents assessment.

An agent writes every assessment and leaves `decision: pending`.

The decision is one of `pending`, `accepted`, `changes-requested`, or `deferred`; assessments use
only the four values above; other option values are blocking errors. When a task executes a
change-plan wave, `Change-plan coverage` is parsed with the same columns and assessment values.
C016 and the accepted-review `Blocked` rule apply to both tables. C012, C013, and waivers remain
Requirement coverage only.

## Evidence

Rerun every applicable `Verify with:` command against the state being judged. Treat worker
output as a claim. Short decisive output appears once in the review. When raw output would
dominate it, write an adjacent [evidence receipt](reference/artifact-formats.md#evidence-receipt)
and link the stable anchor beside the decisive verbatim excerpt.

Structured command records remain valid:

````markdown
```verify id=AC-001 cmd="npm test -- expired-session" result=pass
3 passed
Full output: `evidence-checkout.md#E-001`
```
````

The info string records command consistency. It does not prove the body or issue a verdict.

## Deterministic check

```bash
suspec check <review-path> --spec <spec-path>
suspec check <review-path> --spec <spec-path> --task <task-path>
```

The checker reports coverage, command binding, evidence presence, reference resolution, and
severity. It never accepts work. `Supported` with empty evidence is C016
`supported-needs-evidence` and blocks at check time.

## Human decision

After assessment, present a state-aware picker. Recommend from the evidence:

- all rows supported and no open blocker: `Accept`
- unsupported rows or material findings: `Request changes`
- blocked rows or unresolved material decisions: `Defer`
- unsupported or unverified rows the owner deliberately accepts: `Accept with waivers`

Write the selection to `decision: accepted | changes-requested | deferred`. `waivers` is absent
before acceptance and absent from an accepted review with no Unsupported or Unverified rows. For
acceptance with waivers, list exactly once every `Unsupported` or `Unverified` Requirement coverage
ID, with no duplicates and no
`Supported` or `Blocked` ID, then record owner, reason, and follow-up where
the project keeps decision context. An accepted review cannot retain a non-empty `Open decisions`
section or any `Blocked` assessment in requirement or change-plan coverage. Resolve the dependency
or defer the review; `Blocked` cannot be waived. Return the artifact link without restating it.
The review remains live through findings routing and any requested fixes; the final consumer asks
whether to delete, leave, promote, or choose `Other` for the complete transient artifact set. That
close picker replaces the path-only return. The agent selects no option; inaction is not Leave.

## Escalation

Use `revolver` to drive broad risk through at least six target-derived stances, one fresh reviewer at
a time. The orchestrator addresses every stance before the next reviewer sees the current target;
Revolver creates no artifact. Use `triple-check` for three deep, independent top-tier passes.

## Related

- Next: [Saving findings](09-saving-findings.md)
- Previous: [Running agents](07-running-agents.md)
