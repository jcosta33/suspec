# Rigor escalation — the ladder

> **Reference.** The doctrine is [ADR-0131](../adrs/0131-minimum-useful-rigor.md): default to the least
> rigor that still leaves enough proof, and add structure only where it changes execution quality or
> reviewability. This page is the how-to — the named rungs and when to climb. It prescribes no tool and
> gates nothing; it is a convention you read, not a check that runs.

Suspec scales to the work. The full loop is not the floor — it is the top of a ladder whose lower rungs
are the common case. Pick the lowest rung that leaves enough proof for the risk in front of you, and
climb only for a reason you can name.

## The rungs

| Rung | Shape | Adds over the rung below | Typical use |
| --- | --- | --- | --- |
| **L0** | Prompt only, or a one-line inline spec | — for a bare prompt; a single requirement sentence + a `Verify with:` line, kept in your own working note or the task dispatch, for a trivial fix | A throwaway, a spike, a question, or a fix small enough that a committed file would outweigh the change ([bug fix example](../examples/bug-fix.md)). No durable artifact. |
| **L1** | Lean spec | Intent + acceptance criteria + a Verify line each, in a committed `type: spec` file | A small, clear, single-concern change. **The default for most work.** |
| **L2** | Spec + task | A scoped, disposable task packet (write surface, scope) | The change wants an explicit hand-off — parallel work, a delegated worker, a scope worth pinning. |
| **L3** | + independent review | A non-implementer judges the diff against the spec | Anything that ships behavior. **The default whenever code changes** — the review is independent, its *formal packet* scales with risk. |
| **L4** | Revolver | A rotating pool of distinct stances, one reviewer at a time, fixing between rounds until it converges | A MAJOR-hunt: high diffusion, security-sensitive, or a large change one reviewer's partition would leave gaps in; runs on cheap varied models ([ADR-0132](../adrs/0132-revolver-rotating-refine-loop.md)). |
| **L5** | Orchestrated waves | Change plan, decomposed wave tasks, per-wave reviews | A migration, a rewrite, or a structural change across subsystems — a change plan drives the waves. |

**L1 or L3 is the default. The top rung is never the default.** L4 and L5 are for the change that earns
them, not a habit. Climbing a rung buys proof or reviewability; it also costs artifact, tokens, and
reader attention — so it must pay for itself against the risk, not against a sense that more process is
safer.

## What decides the rung

Read the risk off the change, not off "new vs old code." The discriminator is
[ADR-0094](../adrs/0094-decomposition-and-risk-weighted-review.md)'s axis:

- **Size** — a larger diff needs more scrutiny; defect detection is best on small, self-contained units.
- **Diffusion** — the more files, modules, or subsystems a change touches, the higher the risk it induces
  a failure.
- **Churn** — code that changes often carries more faults; fix-on-fix changes are especially defect-prone.
- **Change-type** — treat a refactor and a behavior change as separate units; once size and churn are
  controlled, "it's just a new feature" does not lower the risk.

Low on every axis → stay at L1/L3. High on diffusion or churn, or a security-sensitive surface → climb to
L4/L5. A one-line, single-file fix does not earn a Revolver run; a cross-subsystem migration does not
belong at L1.

## The floor that never moves

Minimum useful rigor lowers the *default rung*. It does not lower the floor that keeps a completion claim
honest. Two things hold at every rung where code ships:

- **Independent review is invariant** ([ADR-0119](../adrs/0119-independent-review-invariant.md)) — a
  non-implementer judges the work. What scales with risk is the *formal review packet*, not whether an
  independent look happens.
- **Evidence carries the claim** ([ADR-0121](../adrs/0121-evidence-gating-load-bearing-mechanic.md)) — a
  `Pass` needs real output, not confident prose.

These are the minimum, not the surplus. When you cut rigor, cut the unleveraged structure — never the
review or the evidence.

## Name the reason when you climb

Escalating to a heavy mode — a Revolver run, an orchestrated fan-out, a durable task brief on otherwise
1:1 work — should state the reason: the risk that warrants the cost. This is a one-line convention
resolved by review, not a machine-readable field. "L4: security-sensitive auth path, high diffusion" is
enough; the point is that the cost was a decision, not a default.

## Related

- [Minimum useful rigor](../adrs/0131-minimum-useful-rigor.md) — the doctrine this ladder serves
- [Decomposition and risk-weighted review](../adrs/0094-decomposition-and-risk-weighted-review.md) — the risk axis
- [Artifact formats](artifact-formats.md) — the change-plan shape the L5 waves run on
- [Basic workflow](../02-basic-workflow.md) — the L1/L3 common paths
- [Review stances](review-stances.md)
