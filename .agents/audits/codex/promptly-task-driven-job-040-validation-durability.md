---
type: audit
id: AUDIT-codex-promptly-task-driven-job-040
title: Promptly task-driven job 040 - validation durability
status: closed
owner: codex
date: 2026-06-13
---

# Promptly Task-Driven Job 040 - Validation Durability

## Scope

This audit records Swarm usage for TASK-040 in the Promptly CHANGE-040 stress
test. It collects datapoints only and does not propose or implement Swarm
framework changes.

## Product value delivered

Promptly no longer tracks WXT-generated `.wxt/` files, and `.wxt/` is ignored.
After Promptly commit `82e3b3d`, `git ls-files .wxt` returns no files and
`git check-ignore .wxt/tsconfig.json` confirms the generated path is ignored.

Promptly artifacts:

- `/Users/josecosta/dev/promptly-docs/tasks/040-validation-durability.md`
- `/Users/josecosta/dev/promptly-docs/reviews/040-validation-durability.md`
- `/Users/josecosta/dev/promptly-docs/specs/040-validation-durability/spec.md`
- `/Users/josecosta/dev/promptly-docs/change-plans/040-task-driven-reliability-ux-swarm-stress-test.md`

## Artifact usefulness

The task file was enough for implementation because it named a narrow write
scope, explicit non-goals, and exact verification commands. The spec added
little beyond the task because this was mechanical repo hygiene, but it made
the success condition unambiguous: build/test/format must not dirty tracked
generated files.

## Skill and guide behavior

The worker reported reading Promptly `AGENTS.md`, the task, the spec, the
change plan, `implement-task`, and `empirical-proof` before editing. This was a
better Swarm boot than earlier Promptly field-test workers.

## Worker behavior

Dalton behaved like a mostly Swarm-booted task worker: it pasted a boot
manifest, stayed in the declared write scope, and reported command evidence.
The limitation was orchestration, not comprehension: the edit landed in the
shared Promptly worktree, so the lead had to separate staged TASK-040 changes
from concurrent TASK-041/TASK-042/TASK-043 work.

## Review evidence

Sufficient:

```text
$ git ls-files .wxt
(exit 0, no output)
```

```text
$ git check-ignore .wxt/tsconfig.json
.wxt/tsconfig.json
(exit 0)
```

```text
$ git status --short --untracked-files=all
(exit 0, no output after Promptly commit 82e3b3d)
```

Missing: none for TASK-040 after the final commit.

## Safety versus ceremony

Useful safety: task-first execution prevented runtime changes from creeping
into a generated-file policy task. Ceremony: a full spec/review chain was more
than this mechanical change needed, but the review packet was useful because it
forced post-commit cleanliness evidence.
