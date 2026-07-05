---
type: adr
id: adr-0136
status: accepted
created: 2026-07-05
updated: 2026-07-05
---

# ADR-0136 — The launcher boundary: suspec-cli automates the loop, it is not the agent

## Context

[ADR-0077](./0077-suspec-cli-reconcile-only-harness.md) Decision 8 drew suspec-cli's hard line:
never own the model/reasoning loop, the chat UI, file-editing mechanics, provider auth, the MCP
runtime, the sandbox/container runtime, or the review verdict — "absorbing any of these would make
suspec-cli a coding agent."

That line has been read two ways, and the maximal reading strands the tool. Under the strict reading,
the CLI may not run project setup, may not generate a launch prompt, and may not capture a check's
output — because each "runs something" or "touches the agent's context." But suspec-cli **already**
spawns the external agent, `git`, and `gh` as subprocesses ([SPEC-suspec-cli-run](../../../corpus-works/specs/suspec-cli-run/spec.md));
it is already a Suspec-shaped launcher. The strict reading confuses *automating the boring parts of
the loop* with *becoming the agent*.

The owner resolved the ambiguity: the boundary is that Suspec **is not the agent itself**. It is not a
ban on deterministic quality-of-life automation around the loop, and the CLI is allowed to be deeply
Suspec-shaped (it knows specs, tasks, reviews, findings — it is not a generic runner).

## Decision

**The line is "not the agent," not "no automation."** _Level: convention (clarifies [ADR-0077](./0077-suspec-cli-reconcile-only-harness.md) Decision 8; the banned items there are unchanged)._

1. **What suspec-cli MAY automate.** Any deterministic, mechanical step around the loop: create or
   reuse a worktree, run project-declared setup (install/build), generate a lean launch prompt, launch
   the adapter, record the run, and reconcile facts. Doing these does not make it the agent — it preps
   and fires the agent, which does the reasoning. _Level: convention._

2. **What makes it the agent (the actual line).** suspec-cli becomes a coding agent only if it: runs
   the model/reasoning loop; authors the Pass/Fail verdict; semantically rewrites a Suspec artifact
   (mechanical edits — a digest rebuild, a moved-path re-resolution — are fine; judgment edits are
   not); or owns multi-agent orchestration-and-merge. These stay out. _Level: convention (the hard
   line, restated)._

3. **Prompt generation is templating, not reasoning — allowed, but lean and transient.** A generated
   launch prompt is a **pointer** (role + artifact paths: "work on `<SPEC>`, read the spec at
   `<path>`, run its Verify items"), never a summarized or reasoned-over plan. It is **transient
   gitignored scratch, never a committed artifact** — Markdown stays the only Suspec artifact
   ([ADR-0077](./0077-suspec-cli-reconcile-only-harness.md) Decision 6). _Level: convention._

4. **The verdict boundary is unchanged.** suspec-cli records facts — a command ran, its exit status —
   and the human owns Pass/Fail/Unverified/Blocked ([ADR-0077](./0077-suspec-cli-reconcile-only-harness.md)
   Decision 8, [ADR-0107](./0107-fast-track-staleness-detection.md)). When evidence capture maps an
   exit code, it writes a **verify-block `result=` fact**, never the coverage **Result** column (the
   human's verdict). _Level: toolable._

5. **The CLI stays an additive accelerator.** Every canonical `spec → run → close` step keeps a
   self-contained by-hand path — write the spec, make a worktree, run your agent — that needs no CLI,
   MCP, or skill ([ADR-0134](./0134-self-contained-spine.md) Decision 3). A launcher command (`work`,
   `fix`) accelerates that path; it never becomes required. _Level: convention._

6. **What stays out, explicitly.** Owning the sandbox/container runtime (it is a substrate the adapter
   *selects*, unchanged from D8); owning a detached background-session lifecycle (attach/logs/stop
   supervision belongs to the runner, whose native commands the CLI may record but not reimplement);
   and CLI-owned review fanout/merge (that is the `revolver-review` **skill**, [ADR-0132](./0132-revolver-rotating-refine-loop.md),
   not a CLI strategy). _Level: convention._

## Alternatives considered

| Alternative | Why rejected |
|---|---|
| Keep the maximal reading of D8 (the CLI may not run setup or generate a prompt) | Strands the launcher — `suspec run` already spawns the agent/git/gh; the reading confuses automating the loop with becoming the agent, and would forbid the very QOL the tool exists to give. |
| Amend ADR-0077 Decision 8 in place | ADRs are immutable once accepted; the clarification is layered as this ADR with a forward-note on D8, not a rewrite of accepted canon. |
| Let the generated prompt be a rich, reasoned plan committed as an artifact | Crosses two lines at once — reasoning (Decision 2) and a machine artifact (ADR-0077 D6). The prompt stays a lean transient pointer. |

## Consequences

- Positive: unblocks `suspec work` ([SPEC-suspec-cli-work](../../../corpus-works/specs/suspec-cli-work/spec.md)) — a spec-first `prepare → setup → prompt → launch → record` pipeline — and clears the setup executor, lean prompt generation, and the richer run record as in-scope.
- Negative: the CLI's surface grows and stays Suspec-shaped; the "not the agent" line now has to be judged per feature rather than read off a fixed banned-verb list.
- Neutral: a forward-note is added to [ADR-0077](./0077-suspec-cli-reconcile-only-harness.md) Decision 8; the banned items there do not change.

## Status

Accepted (2026-07-05). Clarifies [ADR-0077](./0077-suspec-cli-reconcile-only-harness.md) Decision 8;
upholds [ADR-0077](./0077-suspec-cli-reconcile-only-harness.md) Decision 6, [ADR-0107](./0107-fast-track-staleness-detection.md),
[ADR-0132](./0132-revolver-rotating-refine-loop.md), [ADR-0134](./0134-self-contained-spine.md) Decision 3.

## Propagation

- [ADR-0077](./0077-suspec-cli-reconcile-only-harness.md) Decision 8 — forward-note pointing here.
- `docs/reference/cli.md` — add the `work` command surface when [SPEC-suspec-cli-work](../../../corpus-works/specs/suspec-cli-work/spec.md) lands.
- `docs/adrs/README.md` — ledger row.
