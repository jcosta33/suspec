---
type: review
id: REVIEW-{{slug}}
task: TASK-{{slug}}
pr: {{pr-url}}
status: {{draft | pass | blocked | needs-human}}
---

# Review: {{title}}

## Summary

{{2–3 sentences: what changed, what is verified, what is not.}}

## Changed files

- `{{path}}`

## Requirement coverage

| ID | Result | Evidence | Human attention |
|---|---|---|---|
| AC-001 | Pass | `{{test}}` output pasted/linked | no |
| AC-002 | Unverified | no test output found | yes |

<!-- Results: Pass · Fail · Unverified · Blocked.
     A Pass needs pasted output or a CI link. An empty Evidence cell means
     Unverified, never Pass. Spot-check at least one green row's evidence
     yourself — do not rubber-stamp the table. -->

## Change-plan coverage

<!-- Only when the task executes a change plan: one row per preservation
     guarantee / wave item, same columns as above. Delete otherwise. -->

| ID | Result | Evidence | Human attention |
|---|---|---|---|
| {{SPEC-x#AC-001 (preserved)}} | {{result}} | {{evidence}} | {{yes/no}} |

## Human attention

<!-- Route the exceptions, not the diff: unverified or failed requirements ·
     out-of-scope changes · risky files · missing test output · changed public
     interfaces · DB migrations · security-sensitive changes · new finding
     candidates · blocked questions. -->

1. {{exception — why it matters — suggested action}}

## Suggested decision

{{Merge / Block until …}}
