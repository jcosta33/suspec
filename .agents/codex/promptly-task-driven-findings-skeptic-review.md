---
type: adversarial-review
id: CODEX-PROMPTLY-TASK-DRIVEN-FINDINGS-SKEPTIC-REVIEW
status: recorded
subject:
  - .agents/codex/promptly-task-driven-stress-adversarial-findings.md
  - .agents/audits/codex/promptly-task-driven-reliability-rollup.md
  - .agents/audits/codex/promptly-task-driven-job-040-validation-durability.md
  - .agents/audits/codex/promptly-task-driven-job-041-runtime-capability-preflight.md
  - .agents/audits/codex/promptly-task-driven-job-042-inference-stall-recovery.md
  - .agents/audits/codex/promptly-task-driven-job-043-extension-validation-harness.md
date: 2026-06-13
reviewer: codex
stance: skeptic
---

# Promptly task-driven findings skeptic review

## Scope

This is an adversarial review of the findings I recorded after CHANGE-040. It
does not re-review Promptly product code. It attacks whether the Swarm findings
and audits overclaim, miss risks, or phrase inferences as proven facts.

## Findings

### P1 - Review independence is overclaimed for TASK-043

The rollup says independent review was possible and the review packets preserved
the Pass/Blocked distinctions. That is mostly true for delegated tasks, but
TASK-043 was implemented by the lead and reviewed by the lead. The Promptly-docs
review names `reviewer: codex-lead` and also names `Lead worker: Codex`.

That means the CHANGE-040 review-independence acceptance rule was not fully
satisfied. The finding should be read as: independent review discipline improved
for delegated tasks, but TASK-043 is an exception and should not be used as
evidence that the full four-task run met reviewer/worker separation.

Evidence:

```text
$ rg -n "reviewer:|Lead worker|independent review|Task-status|Suggested decision" /Users/josecosta/dev/promptly-docs/reviews/043-extension-validation-harness.md .agents/audits/codex/promptly-task-driven-reliability-rollup.md
.agents/audits/codex/promptly-task-driven-reliability-rollup.md:51:working tree, not as isolated patches. That made independent review possible
/Users/josecosta/dev/promptly-docs/reviews/043-extension-validation-harness.md:7:reviewer: codex-lead
/Users/josecosta/dev/promptly-docs/reviews/043-extension-validation-harness.md:22:Lead worker: Codex.
/Users/josecosta/dev/promptly-docs/reviews/043-extension-validation-harness.md:92:## Task-status update confirmation
/Users/josecosta/dev/promptly-docs/reviews/043-extension-validation-harness.md:96:## Suggested decision
(exit 0)
```

### P1 - "Task files were genuinely used" is stronger than the proof

The rollup states "Task files were genuinely used this time." The available
evidence is worker self-report in completion messages and the lead's observation
that workers produced scoped edits. That is useful evidence, but it is not the
same as an independently inspectable transcript proving the task files shaped
the workers' internal execution.

The safer finding is: workers reported reading and using task files, and their
edits were consistent with the task scopes. The stronger claim that the task
files were "genuinely used" should be treated as an inference, not a proven
fact.

Evidence:

```text
$ rg -n "genuinely used|reported reading|reported exact boot|boot manifests|self-report|task files" .agents/audits/codex/promptly-task-driven-reliability-rollup.md .agents/codex/promptly-task-driven-stress-adversarial-findings.md /Users/josecosta/dev/promptly-docs/findings/040-task-file-boot-discipline.md
.agents/codex/promptly-task-driven-stress-adversarial-findings.md:77:This run answers the user's earlier question about task files: yes, the
.agents/codex/promptly-task-driven-stress-adversarial-findings.md:78:delegated workers read and used the task files this time. They also reported
.agents/audits/codex/promptly-task-driven-reliability-rollup.md:28:Task files were genuinely used this time. The three delegated workers all
.agents/audits/codex/promptly-task-driven-reliability-rollup.md:29:reported reading their task packet, linked spec, linked change plan, Promptly
.agents/audits/codex/promptly-task-driven-reliability-rollup.md:31:the earlier Promptly run, the task files acted as real boot anchors rather than
.agents/audits/codex/promptly-task-driven-reliability-rollup.md:43:- TASK-040 worker reported exact boot reads and stayed in `.gitignore` plus
.agents/audits/codex/promptly-task-driven-reliability-rollup.md:45:- TASK-041 worker reported exact boot reads and stayed in background/messaging
.agents/audits/codex/promptly-task-driven-reliability-rollup.md:47:- TASK-042 worker reported exact boot reads and stayed in inference/response
(exit 0)
```

### P2 - "Chrome policy" remains an inference

The findings correctly record that local Google Chrome did not register
Promptly's `background.js`, and that bundled Chromium did. They sometimes phrase
the distinction as "Chrome policy" or say bundled Chromium separates extension
validity from local Chrome policy. That is plausible, but not proven. The exact
proven fact is narrower: the default local Chrome run did not register the
Promptly service worker in this environment; the bundled Chromium run did.

The next finding set should avoid assigning cause until Chrome version,
enterprise policy, launch flags, profile settings, and `chrome://extensions`
error text are captured.

Evidence:

```text
$ rg -n "local Chrome policy|Chrome policy|extension validity|validates|same built extension|bundled Chromium|local Chrome" .agents/audits/codex/promptly-task-driven-*.md .agents/codex/promptly-task-driven-stress-adversarial-findings.md /Users/josecosta/dev/promptly-docs/reviews/04*.md
/Users/josecosta/dev/promptly-docs/reviews/043-extension-validation-harness.md:14:Result: Pass. `pnpm validate:extension` now reports the required local Chrome
/Users/josecosta/dev/promptly-docs/reviews/043-extension-validation-harness.md:43:| AC-004 | Pass | Local Chrome refusal exits 2 with Blocked evidence; bundled Chromium success exits 0. | no |
.agents/codex/promptly-task-driven-stress-adversarial-findings.md:53:local Chrome path does not register Promptly's `background.js`. Bundled
.agents/codex/promptly-task-driven-stress-adversarial-findings.md:54:Chromium registers the same built extension and passes popup/content/overlay
.agents/codex/promptly-task-driven-stress-adversarial-findings.md:55:smoke checks. This separates extension validity from local Chrome policy, but
.agents/codex/promptly-task-driven-stress-adversarial-findings.md:56:the required local Chrome validation remains Blocked.
(exit 0)
```

### P2 - The findings understate the risk of accepting TASK-041 as Pass

TASK-041 passed because the bundled Chromium popup showed the readiness surface
and the code review showed the preflight handler does not construct a model.
That is reasonable, but a stricter skeptic would mark the local Google Chrome
popup path as Blocked and the bundled Chromium path as diagnostic Pass. The
current `Pass, local Chrome Blocked` label is compact but easy to misread as
full browser acceptance.

The safer phrasing is: product code accepted by typecheck/code review and
diagnostic runtime evidence; default local Chrome runtime acceptance remains
Blocked.

### P3 - The audit commit stayed inside Swarm datapoints

This claim holds. The Swarm commit added `.agents/audits/codex/*` and
`.agents/codex/*` files only, not framework docs or starter-kit templates.

Evidence:

```text
$ git show --name-only --oneline --summary 12d3c9c
12d3c9c docs: record Promptly task-driven stress audit
.agents/audits/codex/promptly-task-driven-job-040-validation-durability.md
.agents/audits/codex/promptly-task-driven-job-041-runtime-capability-preflight.md
.agents/audits/codex/promptly-task-driven-job-042-inference-stall-recovery.md
.agents/audits/codex/promptly-task-driven-job-043-extension-validation-harness.md
.agents/audits/codex/promptly-task-driven-reliability-rollup.md
.agents/codex/promptly-task-driven-stress-adversarial-findings.md
(exit 0)
```

## Bottom line

The findings are directionally useful, but two claims should be mentally
downgraded: task-file usage is supported by worker report plus scoped edits,
not independently proven; and review independence failed for TASK-043. The
Chrome diagnosis should also stay causal-neutral until the next run captures
browser policy/profile evidence.
