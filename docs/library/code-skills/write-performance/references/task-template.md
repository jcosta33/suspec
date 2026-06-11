# Run notes: {{title}}

- Task packet: `tasks/{{TASK-slug}}.md`
- Change plan (target, rollback ceiling): `change-plans/{{slug}}.md`
- Worktree / branch: {{branch}}
- Created: {{YYYY-MM-DD}} · Status: active

> **Performance task** — numbers, not vibes. Baseline before any edit; identical measurement
> protocol on both sides; one benchmarked change at a time; full suite green after every change.
>
> **Commands** resolve from the code repo's `AGENTS.md` Commands table. The **benchmark command**
> is what the evidence is measured with — if it is undefined, ask the user before establishing the
> baseline. A guessed invocation produces a baseline the final figure cannot honestly be compared
> against.

## Scope (from the task packet)

- Optimize: {{what, on what input, under what conditions}}
- Preserve: correctness — the ACs the speedup must not trade away.
- Do not change: {{areas the packet rules out}}; a second bottleneck goes to Findings.

## Target

Pulled from the requirement — a number under named conditions. "Make X faster" is not a target;
raise a blocked question and get the number first.

- **Metric:** {{p95 latency / throughput / allocations / …}}
- **Target value:** {{number under named conditions}}
- **Rollback ceiling:** {{the regression threshold on any other metric that rolls the change back
  regardless of the primary gain — from the change plan}}

## Measurement protocol

Identical before and after — record once, reuse verbatim. Different conditions give different
numbers and the comparison is void.

- Warmup runs: · Sample count: · Aggregate (mean / median / p95 / p99):
- Hardware / environment:
- Input shape / load profile / cache state:

## Baseline (before any code change)

**Benchmark command:** `{{command}}`

```text
{{paste baseline output here — captured before any edit}}
```

## Hypothesis

The bottleneck you believe in, stated so a measurement could disprove it — and the profile that
confirmed it before optimizing.

-

## Change ledger (one benchmarked change at a time)

| # | Change | Benchmark (same protocol) | Suite result | Keep / roll back |
|---|---|---|---|---|
| 1 | | | | |

## Progress checklist

- [ ] Packet and change plan read; target is a number; ceiling recorded
- [ ] Protocol fixed and recorded above
- [ ] Baseline measured and pasted before any edit
- [ ] Hypothesis stated; bottleneck profiled
- [ ] Each change benchmarked individually under the same protocol; suite run after each
- [ ] Final benchmark meets the target under the baseline's protocol
- [ ] Readability costs annotated at the call site
- [ ] Findings recorded; self-review answered

## Evidence (paste actual command output — never paraphrase)

- Baseline benchmark output:
- Final benchmark output (identical protocol):
- Full test suite after the final change (last lines + exit):
- Check command (last lines + exit):

## Decisions

Choices the requirements did not constrain — including why a readability trade was accepted.
("The optimization worked" is evidence, not a decision; it goes above.)

-

## Findings

Second bottlenecks, allocations on hot paths, N+1 patterns — candidates for the workspace's
`findings/` at Close.

-

## Blocked questions

A target stated only as a direction, an unclear correctness requirement.

-

## Next steps

-

## Self-review

Answer in writing, evidence pasted. Performance work fails two ways — a number that improved on
the benchmark but not in production, and a speedup that quietly broke correctness.

- **Baseline and target:** measured before any edit; final figure hits the numeric target under
  the same conditions; both pasted?
- **Protocol identity:** warmup, samples, aggregate, host, input, cache state provably identical
  on both sides; figure stable, not noise?
- **Attribution:** each change benchmarked individually — can you point at which change moved the
  number?
- **Correctness:** full suite green after every change, output pasted; any path the benchmark
  exercises that the suite does not cover?
- **Conditions and ceiling:** the conditions under which the gain holds are recorded; no other
  metric breached the rollback ceiling?
- **Scope:** no behavior change under the perf label; second bottlenecks recorded as findings; no
  review result issued on your own work.
