# Memory

> **Superseded model — [ADR-0137](../adrs/0137-personal-harness-transient-artifacts.md).** This page still describes the committed
> workspace / board / `.suspec/` layout. Suspec artifacts are now transient personal working
> files under `~/.claude/state/<repo-name>/`, never committed to any repo; durable value is
> promoted to ADRs, tests, issues, and PR digests. Where this page conflicts with
> [ADR-0137](../adrs/0137-personal-harness-transient-artifacts.md), the ADR wins. Rewrite pending.


The basic memory system is:

```text
findings/
```

Save durable lessons there before closing work.

## When `findings/` is enough

Use plain findings while the team can still find relevant knowledge with search and the board.

Each finding needs:

- one claim
- evidence
- where it applies
- where it does not apply
- related specs, tasks, reviews, or files

## When to add structure

Add structure when:

- findings are duplicated
- agents relearn old facts
- terms drift
- readers cannot find relevant findings
- the same lesson appears in several tasks

## Suggested advanced layout

```text
findings/
  INDEX.md
  glossary.md
  patterns/
  retry-jitter.md
ledger/
  changes/
  merges/
  promotions/
```

## Load-when index

`INDEX.md` is a routing table.

Each row has:

- link
- short summary
- Load when condition

If a finding has no clear Load when, do not index it.

## Glossary

Use one term, one meaning.

If a task clarifies a term, promote that definition into the glossary.

## Patterns

Write a pattern only after at least two findings support it.

One observation is a finding, not a pattern.

## Promotion queue

Every discovery ends in one state:

| State | Meaning |
| --- | --- |
| `pending` | not resolved |
| `promoted` | saved in durable home |
| `deferred` | kept for later with reason |
| `rejected` | not durable, with reason |
| `blocked` | cannot decide yet |
| `validated` | corroborated before promotion |
| `quarantined` | suspicious, conflicting, unsupported, or sensitive — reason recorded, never retrieved as active |
| `rolled-back` | withdrawn with retraction |

(`quarantined` extends the accepted model per ADR-0123; like the advanced-tier `validated` and
`rolled-back` states, it is a convention — nothing enforces any of them.)

Do not close a task with `pending` discoveries.

## Validation

High-consequence findings need independent corroboration before promotion.

Rollback wrong findings with a retraction. Do not silently delete them.

## Ledger

Use a ledger when verbose task and review scratch can age out.

The ledger records:

- completed changes
- merge decisions
- promotion decisions

It adds no new evidence. It summarizes existing artifacts.

## Related

- [Saving findings](../09-saving-findings.md)
- [CLI reference](cli.md)
- [Drift](drift.md)
