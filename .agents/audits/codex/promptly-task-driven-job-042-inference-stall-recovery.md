---
type: audit
id: AUDIT-codex-promptly-task-driven-job-042
title: Promptly task-driven job 042 - inference stall recovery
status: closed
owner: codex
date: 2026-06-13
---

# Promptly Task-Driven Job 042 - Inference Stall Recovery

## Scope

This audit records Swarm usage for TASK-042 in the Promptly CHANGE-040 stress
test. It collects datapoints only and does not propose or implement Swarm
framework changes.

## Product value delivered

Promptly now tracks advisory inference stall state with `startedAt`,
`lastActivityAt`, and `isStalled`, and the response panel exposes retry, cancel,
and copy-partial controls when a stall is detected. The implementation is in
Promptly commit `82e3b3d`.

Promptly artifacts:

- `/Users/josecosta/dev/promptly-docs/tasks/042-inference-stall-recovery.md`
- `/Users/josecosta/dev/promptly-docs/reviews/042-inference-stall-recovery.md`
- `/Users/josecosta/dev/promptly-docs/specs/042-inference-stall-recovery/spec.md`
- `/Users/josecosta/dev/promptly-docs/change-plans/040-task-driven-reliability-ux-swarm-stress-test.md`

## Artifact usefulness

The task packet was useful because it prevented the worker from changing the
background request shape or adding persistence/history. The spec was useful for
the advisory nature of stall detection: slow model work must not be
auto-canceled.

## Skill and guide behavior

The worker reported reading Promptly `AGENTS.md`, the task, the spec, the
change plan, `implement-task`, and `empirical-proof`. The right implementation
guide triggered. The missing piece was not boot, but runtime evidence for a
hard-to-induce stalled WebLLM path.

## Worker behavior

Archimedes behaved like a Swarm-booted implementation worker in report form:
boot manifest, bounded changed paths, and check output. It also explicitly
recorded that runtime Chrome evidence was blocked. The shared worktree again
made attribution dependent on lead review rather than isolated patch handoff.

## Review evidence

Sufficient for code and component review:

```text
$ pnpm compile
$ tsc --noEmit
(exit 0)
```

```text
$ rg -n "isStalled|STALL_THRESHOLD_MS|lastActivityAt|startedAt" src/modules/selection/presentations/hooks/useInference.ts src/modules/selection/presentations/components/ResponseDisplay/ResponseDisplay.tsx src/modules/selection/presentations/views/PromptOverlay/PromptOverlay.tsx
src/modules/selection/presentations/views/PromptOverlay/PromptOverlay.tsx:319:            isStalled={inferenceState.isStalled}
src/modules/selection/presentations/components/ResponseDisplay/ResponseDisplay.tsx:26:  isStalled: boolean;
src/modules/selection/presentations/components/ResponseDisplay/ResponseDisplay.tsx:176:          {isStalled ? (
src/modules/selection/presentations/hooks/useInference.ts:25:  startedAt?: number;
src/modules/selection/presentations/hooks/useInference.ts:26:  lastActivityAt?: number;
src/modules/selection/presentations/hooks/useInference.ts:27:  isStalled: boolean;
src/modules/selection/presentations/hooks/useInference.ts:36:const STALL_THRESHOLD_MS = 30000;
(exit 0)
```

Blocked:

- No real stalled loading or streaming WebLLM path was induced.
- Retry, cancel, and copy-partial controls were reviewed in code but not
  observed under a real stall.
- Local Google Chrome extension registration remained blocked.

## Safety versus ceremony

Useful safety: the review template prevented code-review confidence from being
rounded up into runtime acceptance. Ceremony: without a deliberate stall
simulation hook or test seam, the task packet asked for runtime proof that the
current app cannot easily produce on demand.
