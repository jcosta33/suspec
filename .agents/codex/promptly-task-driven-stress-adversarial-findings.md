---
type: adversarial-review
id: CODEX-PROMPTLY-TASK-DRIVEN-STRESS-ADVERSARIAL-FINDINGS
status: recorded
subject:
  - /Users/josecosta/dev/promptly@82e3b3d
  - /Users/josecosta/dev/promptly-docs@7a68632
date: 2026-06-13
reviewer: codex
stance: skeptic
---

# Promptly task-driven stress adversarial findings

## Scope

This is the skeptical consolidation for CHANGE-040. It reviews the Promptly
implementation, Promptly-docs artifacts, and Swarm task-file stress datapoints.
It records findings only; it does not change Swarm framework docs or templates.

## Findings

### P1 - TASK-042 is implemented but not runtime-complete

The stall recovery UI exists and typechecks, but no real stalled WebLLM loading
or streaming state was induced. The review correctly marks TASK-042 Blocked.
Future stress runs need task packets to include a simulation path for rare
runtime states, otherwise reviewers can only inspect code and refuse runtime
Pass.

Evidence:

```text
$ pnpm compile
$ tsc --noEmit
(exit 0)
```

```text
$ rg -n "isStalled|STALL_THRESHOLD_MS|lastActivityAt|startedAt" src/modules/selection/presentations/hooks/useInference.ts src/modules/selection/presentations/components/ResponseDisplay/ResponseDisplay.tsx src/modules/selection/presentations/views/PromptOverlay/PromptOverlay.tsx
src/modules/selection/presentations/views/PromptOverlay/PromptOverlay.tsx:319:            isStalled={inferenceState.isStalled}
src/modules/selection/presentations/components/ResponseDisplay/ResponseDisplay.tsx:176:          {isStalled ? (
src/modules/selection/presentations/hooks/useInference.ts:25:  startedAt?: number;
src/modules/selection/presentations/hooks/useInference.ts:26:  lastActivityAt?: number;
src/modules/selection/presentations/hooks/useInference.ts:27:  isStalled: boolean;
src/modules/selection/presentations/hooks/useInference.ts:36:const STALL_THRESHOLD_MS = 30000;
(exit 0)
```

### P2 - Local Google Chrome remains the runtime blocker

The new harness is useful because it makes the blocker precise: the default
local Chrome path does not register Promptly's `background.js`. Bundled
Chromium registers the same built extension and passes popup/content/overlay
smoke checks. This separates extension validity from local Chrome policy, but
the required local Chrome validation remains Blocked.

Evidence:

```text
$ pnpm validate:extension
[Blocked] extension service worker: Timed out waiting for Promptly service worker background.js; seen chrome-extension://fignfifoniblkonapihmkfakmlgkbkcf/service_worker.js; local Chrome may be blocking command-line extension loading, retry with PROMPTLY_BROWSER_CHANNEL=bundled to isolate browser policy from extension behavior
[ELIFECYCLE] Command failed with exit code 2.
(exit 2)
```

```text
$ PROMPTLY_BROWSER_CHANNEL=bundled pnpm validate:extension
[Pass] extension service worker: chrome-extension://dkpgmmfnlmmbcgahhfcldaplimofnheb/background.js
[Pass] popup smoke: Extension ON OFF Promptly enabled Appearance Theme Select an option System Light Dark Model Selection Extension Connected WebGPU Available Model Llama-3.2-1B-Instruct-q4f16_1-MLC Runtime Unloaded Model runtime No model loaded Load Unload Mo
[Pass] overlay escape close: Promptly overlay closed
(exit 0)
```

### P2 - Worker boot improved, but isolation did not

This run answers the user's earlier question about task files: yes, the
delegated workers read and used the task files this time. They also reported
Promptly `AGENTS.md`, linked specs, linked change plan, and required skills.
However, the workers wrote into the same Promptly working tree, which made
review attribution and staged-state management more fragile than a true
isolated-worker flow.

Evidence is recorded in:

- `/Users/josecosta/dev/promptly-docs/findings/040-task-file-boot-discipline.md`
- `/Users/josecosta/dev/swarm/.agents/audits/codex/promptly-task-driven-reliability-rollup.md`

### P3 - TASK-040 shows task overhead can be larger than the work

The `.wxt` durability job was a good verification target but a small mechanical
change. The task/spec/review chain was useful for evidence but heavier than the
implementation itself. This is acceptable in a stress test, but it should not
be mistaken for ideal day-to-day ceremony.

## Bottom line

CHANGE-040 produced real Promptly value and a cleaner Swarm datapoint than the
previous run. The best evidence is that task packets actually booted workers.
The remaining reliability problem is not task reading; it is isolated handoff
and runtime-state proof.
