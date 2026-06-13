---
type: audit
id: AUDIT-codex-promptly-task-driven-job-041
title: Promptly task-driven job 041 - runtime capability preflight
status: closed
owner: codex
date: 2026-06-13
---

# Promptly Task-Driven Job 041 - Runtime Capability Preflight

## Scope

This audit records Swarm usage for TASK-041 in the Promptly CHANGE-040 stress
test. It collects datapoints only and does not propose or implement Swarm
framework changes.

## Product value delivered

Promptly now exposes runtime capability messaging and a popup readiness surface
for extension/background connection, WebGPU, selected model, and model runtime
status. The bundled Chromium validation path showed the readiness surface before
model load in Promptly commit `82e3b3d`.

Promptly artifacts:

- `/Users/josecosta/dev/promptly-docs/tasks/041-runtime-capability-preflight.md`
- `/Users/josecosta/dev/promptly-docs/reviews/041-runtime-capability-preflight.md`
- `/Users/josecosta/dev/promptly-docs/specs/041-runtime-capability-preflight/spec.md`
- `/Users/josecosta/dev/promptly-docs/change-plans/040-task-driven-reliability-ux-swarm-stress-test.md`

## Artifact usefulness

The task packet was enough for implementation. It named the exact message types,
payload shape, affected areas, and non-goal that preflight must not trigger a
model download. The spec was useful because it made `selectedModelId` and
`ModelRuntimeStatus` part of the contract rather than incidental UI data.

## Skill and guide behavior

The worker reported reading Promptly `AGENTS.md`, the task, the spec, the
change plan, `implement-task`, and `empirical-proof`. The right guide triggered
for a task packet, and the worker used the task's write scope.

## Worker behavior

Pascal behaved like a Swarm-booted implementation worker in its report: boot
manifest, bounded file list, verification output, and explicit runtime blocker.
The gap was that it could not independently complete runtime validation because
its environment rejected escalation and localhost binding. The lead reran
runtime validation in the main environment.

## Review evidence

Sufficient:

```text
$ pnpm compile
$ tsc --noEmit
(exit 0)
```

```text
$ PROMPTLY_BROWSER_CHANNEL=bundled pnpm validate:extension
[Pass] popup smoke: Extension ON OFF Promptly enabled Appearance Theme Select an option System Light Dark Model Selection Extension Connected WebGPU Available Model Llama-3.2-1B-Instruct-q4f16_1-MLC Runtime Unloaded Model runtime No model loaded Load Unload Mo
(exit 0)
```

Blocked:

```text
$ pnpm validate:extension
[Blocked] extension service worker: Timed out waiting for Promptly service worker background.js; seen chrome-extension://fignfifoniblkonapihmkfakmlgkbkcf/service_worker.js; local Chrome may be blocking command-line extension loading, retry with PROMPTLY_BROWSER_CHANNEL=bundled to isolate browser policy from extension behavior
[ELIFECYCLE] Command failed with exit code 2.
(exit 2)
```

Missing: local Google Chrome registration remains blocked, so the local-Chrome
popup path is not a Pass.

## Safety versus ceremony

Useful safety: the spec and task non-goals prevented preflight from becoming
model loading or provider switching. Ceremony: the review needed both blocked
local Chrome evidence and bundled Chromium evidence, which is noisy but
important for browser-extension truthfulness.
