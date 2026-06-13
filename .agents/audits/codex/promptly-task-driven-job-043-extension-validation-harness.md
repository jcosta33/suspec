---
type: audit
id: AUDIT-codex-promptly-task-driven-job-043
title: Promptly task-driven job 043 - extension validation harness
status: closed
owner: codex
date: 2026-06-13
---

# Promptly Task-Driven Job 043 - Extension Validation Harness

## Scope

This audit records Swarm usage for TASK-043 in the Promptly CHANGE-040 stress
test. It collects datapoints only and does not propose or implement Swarm
framework changes.

## Product value delivered

Promptly now has `pnpm validate:extension`, a repeatable local runtime harness
that records extension path, profile path, browser channel, manifest worker,
manifest popup, service-worker status, popup smoke, content-script mount,
selection trigger, overlay open, and Escape close where registration succeeds.

Promptly artifacts:

- `/Users/josecosta/dev/promptly-docs/tasks/043-extension-validation-harness.md`
- `/Users/josecosta/dev/promptly-docs/reviews/043-extension-validation-harness.md`
- `/Users/josecosta/dev/promptly-docs/specs/043-extension-validation-harness/spec.md`
- `/Users/josecosta/dev/promptly-docs/change-plans/040-task-driven-reliability-ux-swarm-stress-test.md`

## Artifact usefulness

The task packet was enough for implementation. It named a narrow write scope
and the exact required script. The spec's key value was distinguishing Fail
from Blocked: local Chrome refusing to register an unpacked extension is not the
same as the extension failing after registration.

## Skill and guide behavior

The lead worker read Promptly `AGENTS.md`, the task, the spec, the change plan,
`implement-task`, and `empirical-proof` before editing. This was not delegated,
so it did not test subagent boot for TASK-043.

## Worker behavior

TASK-043 was local lead work. It still followed the task-first rule and recorded
a boot manifest in the Promptly-docs review. The useful stress datapoint is that
the lead had to revise the harness after the first run revealed it was accepting
an unrelated Chrome extension service worker. The task packet did not predict
that failure mode, but the review loop caught it.

## Review evidence

Sufficient:

```text
$ PROMPTLY_BROWSER_CHANNEL=bundled pnpm validate:extension
[Pass] extension service worker: chrome-extension://dkpgmmfnlmmbcgahhfcldaplimofnheb/background.js
[Pass] extension id: dkpgmmfnlmmbcgahhfcldaplimofnheb
[Pass] popup smoke: Extension ON OFF Promptly enabled Appearance Theme Select an option System Light Dark Model Selection Extension Connected WebGPU Available Model Llama-3.2-1B-Instruct-q4f16_1-MLC Runtime Unloaded Model runtime No model loaded Load Unload Mo
[Pass] content script mount: promptly-root attached
[Pass] selection trigger: Open Promptly trigger visible
[Pass] overlay open: Promptly overlay close control visible
[Pass] overlay escape close: Promptly overlay closed
(exit 0)
```

Blocked as expected by the spec:

```text
$ pnpm validate:extension
[Blocked] extension service worker: Timed out waiting for Promptly service worker background.js; seen chrome-extension://fignfifoniblkonapihmkfakmlgkbkcf/service_worker.js; local Chrome may be blocking command-line extension loading, retry with PROMPTLY_BROWSER_CHANNEL=bundled to isolate browser policy from extension behavior
[ELIFECYCLE] Command failed with exit code 2.
(exit 2)
```

## Safety versus ceremony

Useful safety: the harness now refuses to proceed to popup/overlay assertions
unless the Promptly `background.js` service worker is the registered worker.
Ceremony: requiring local Google Chrome remains important, but a fallback
diagnostic browser is needed to separate browser policy from extension behavior.
