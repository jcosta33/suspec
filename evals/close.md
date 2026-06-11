# Close — step rubric

*Advanced design note — internal rationale; not needed to use Swarm.*

> The bar for the Close step: everything durable the task discovered now lives as a finding, the
> workboard tells the truth about the new state, and nothing is left pending invisibly. Each
> predicate is a boolean a scorer decides by comparing the finished task's record against the
> workspace after close.

Close is where lessons either survive the session or evaporate with it. This rubric grades the
workspace state after the step, not the quality of the work that preceded it.

**Input artifact:** the finished task's record — the packet's Findings section, the run summary,
and the review packet.
**Output artifact:** the workspace after close — `findings/`, `status.md`, and any spec
amendment.

## Predicates

Each predicate must hold. Any single failing predicate fails the step.

| # | Predicate | Holds when | Fails when |
|---|---|---|---|
| C1 | **Durable discoveries became findings** | Every durable discovery in the task's record — a fact, a decision, a pattern, a gotcha — exists as a finding file. | A lesson that outlives the task survives only in a packet or a transcript, where the next session will never see it. |
| C2 | **Board updated** | `status.md` reflects the close: the task's state moved, the spec's state updated, and every "done" or "verified" claim on the board links its review packet. | The board still shows the task running, or carries a done claim with no packet behind it. |
| C3 | **Nothing pending** | No blocked question, open exception, or accepted-but-unapplied change is left dangling — each is resolved, or carried forward as a visible board item. | Close happens over a pending item that is now invisible to everyone. |

## Notes for the scorer

- C1 cuts both ways. Scan the task record for discovery-shaped statements ("turns out…", "we
  should always…", "X breaks when Y") and check each reached a finding — *and* check that what
  did reach `findings/` is durable: scratch notes, transient debugging, and one-off command
  output saved as findings pollute the set the next session loads.
- Where review feedback changed what a requirement should say, the spec is amended in place —
  the requirement edited under its existing AC id — rather than the disagreement closing
  unrecorded. An unamended spec the review contradicted is a C3 pending item.
- A finding states where it applies and where it does not ([template](../starter-kit/templates/finding.md));
  a finding with no limits quietly becomes a rule, which is exactly the drift C1 exists to fence.

## Cross-step predicates scored here

- **Re-parses clean** — every finding file reads as `type: finding` with the template's fields.
- **Drift surfaced** — a spec the review showed to be out of date is flagged on the board
  (stale), never left presenting itself as current intent.

## Not graded here

The merge decision itself — that was Review's gate, scored by [review.md](review.md). Close is
graded on what the workspace remembers afterwards.

## Related

- [Finding template](../starter-kit/templates/finding.md) and [status template](../starter-kit/templates/status.md) — the frozen formats this rubric reads against.
- [Saving findings](../docs/09-saving-findings.md) — the guide for the step under test.
- [Basic workflow](../docs/02-basic-workflow.md) — where Close ends the loop.
