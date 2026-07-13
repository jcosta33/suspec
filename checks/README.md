# Checks fixtures

_Advanced design note — maintainer rationale; not needed to use Suspec._

Test data for the machine contract in [`checks.yaml`](./checks.yaml), consumed by suspec-cli. The
[checks reference](../docs/reference/checks.md) explains that contract for humans. Every rule is a
claim about what a correct checker reports on a given file; this directory pins those reports as
fixtures, per the severity split
(hard error / warning). suspec-cli's `suspec check` is the reference consumer — an
explicit-path checker that reads exactly the files it is handed; its test suite pins the
contract table and a subset of these fixtures as oracles, conditional on a sibling canon
checkout — and a reviewer working by hand can use all of them the same way: apply the
checks, compare against the pinned expectation.

**Nothing in this directory runs.** It is data, not a runner: Suspec ships the contract
([`checks.yaml`](./checks.yaml)) and the fixtures that test it, never the checker.

## Evidence rules

Checklist level — review is expected to inspect both; `suspec check` on a review packet
(`suspec check <review-path> --spec <spec-path>`, adding `--task <task-path>` when the
review names a split task) flags the mechanical parts:

- **C023 `task-evidence`** — `ready` and `running` tasks require no evidence. At
  `review-ready` or `closed`, `## Verify` contains a numeric exit status plus non-empty fenced raw
  output, a CI link, or justified `n/a`; a claim-only fence fails only when its entire trimmed body
  matches the contract predicate, and placeholders fail
  [[EVIBOUND]](../docs/research/sources.md#EVIBOUND). In a review packet, an empty Evidence cell
  means **Unverified**, never **Supported**.
- **C024 `closed-task-resolved`** — a closed task has no non-empty `Blocked questions:`,
  `Blocking:`, or `Open question (blocking):` value; `none` and `n/a` are resolved values.
- **`no-open-critical`** — an accepted review carries no unresolved blocking decision.

## What is in this directory

| Path                                                                      | Holds                                                                                                                                                                                                                                                                                |
| ------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [`checks.yaml`](./checks.yaml)                                            | The checks contract as data: spec-form selector, core check list with severities, task and review packet schemas, the evidence rules, advisory command slots, placeholder namespaces.                                                                                                |
| [`fixtures/conformant-task.md`](./fixtures/conformant-task.md)            | A task packet that passes every task check — the positive oracle.                                                                                                                                                                                                                    |
| [`fixtures/violations.md`](./fixtures/violations.md)                      | One minimal negative fixture per violation class, each with the check it trips and the expected report.                                                                                                                                                                              |
| `fixtures/auth-refresh/` · `fixtures/payment-5xx/` · `fixtures/checkout/` | End-to-end scenarios: a spec in both forms, a task packet, a review packet, and an `EXPECTED.md` pinning the relevant checker and review facts. |
| [`fixtures/prose-fixtures/`](./fixtures/prose-fixtures/README.md)          | Labeled prose spans for evaluating an advisory writing-rules detector. |
| `fixtures/transformation/`                                                | A valid inventory + change-plan pair; its `EXPECTED.md` pins `C010 preserves-refs-resolve` and `C011 waves-present`.                                                                                                                                                                 |
| `fixtures/cross-folder-source/`                                           | A spec whose `sources:` points across folders; its `EXPECTED.md` pins `C009 broken-source-link` artifact-relative resolution.                                                                                                                                                        |
| `fixtures/attention-economy/`                                             | Minimal and deferred specs, assessed and waived reviews, human decision capture, and receipt-backed evidence.                                                                                                                                                                      |

The review reconciliation checks `C012 coverage` and `C013 verify-evidence-binding` are pinned as
negative fixtures in [`fixtures/violations.md`](./fixtures/violations.md). Their positive domain
oracles exercise clean coverage and consistent verify blocks. Comparing a live diff with `Do not
change` remains reviewer work because the checker receives no diff.

## Scenario fixtures and examples

Each fixture scenario covers related ground to a worked example in `docs/examples/`.
Examples teach the workflow; fixtures pin checker behavior rather than reproducing the
same artifact chain:

| Fixture domain           | Worked example                                                 |
| ------------------------ | -------------------------------------------------------------- |
| `fixtures/auth-refresh/` | [feature-from-ticket](../docs/examples/feature-from-ticket.md) |
| `fixtures/payment-5xx/`  | [bug-fix](../docs/examples/bug-fix.md)                         |
| `fixtures/checkout/`     | [large-pr-review](../docs/examples/large-pr-review.md)         |

## The equivalence pairs (the anti-fork proof)

A spec is written in plain structured markdown by default, or in the stricter SOL
notation per file via frontmatter `format: sol` — but both surfaces encode one and the
same requirement record, and every check keys on the record, never the surface
(see [structured requirements](../docs/reference/structured-requirements.md)). Each
domain therefore ships the **same spec in both forms**, and its `EXPECTED.md` pins that
a checker extracts the identical record set — same requirement IDs, same strength words,
same verification references — from either file. If the plain and SOL forms ever drift into
different check behavior, these pairs are the fixtures that catch it.

## Reference values (reconciliation) — producer note

This section is for maintainers of Suspec and of tools that consume it. It lists the
closed-set values the fixtures exercise, without keeping a separate count registry.
Adopter-facing pages list values only when the values help the reader. A change to any set
updates this producer note and the fixtures that exercise it in the same commit.

| Closed set                 | Values                                                                                                            |
| -------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| Block types (SOL form)     | `REQ`, `CONSTRAINT`, `INVARIANT`, `INTERFACE`, `QUESTION`                                                         |
| Strength words             | must, must not, should, should not, may (SOL form: the same words uppercase)                                      |
| Review assessments         | `Supported`, `Unsupported`, `Unverified`, `Blocked`                                                                           |
| Artifact types             | `spec`, `task`, `review`, `inventory`, `change-plan`, `audit`, `research`, `inspection` |
| Verification methods       | `static`, `test`, `contract`, `property`, `model`, `perf`, `security`, `manual`, `monitor`                        |
| Check layers               | S (structure), P (prose), M (cross-references), V (verification), O (splitting work) — code form `SOL-<LAYER>NNN` |

Reconciliation duties this note carries:

- The core check IDs and severities in [`checks.yaml`](./checks.yaml) match
  [the checks reference](../docs/reference/checks.md) row for row.
- The task and review section lists in [`checks.yaml`](./checks.yaml) are the core subset
  of [artifact formats](../docs/reference/artifact-formats.md). Conditional headings can
  appear when the work earns them; the contract lists only what checks read.
- Every fixture's pinned expectation agrees with both; a fixture that disagrees means
  the contract, the prose, or the fixture is wrong — find out which before shipping.

## How a checker uses this directory

1. Read the rules from [`checks.yaml`](./checks.yaml). The
   [checks reference](../docs/reference/checks.md) must agree over the core checks and packet schemas;
   the SOL catalogue is prose-only and lives in the reference).
2. Run over [`fixtures/conformant-task.md`](./fixtures/conformant-task.md): the expected
   report is empty.
3. Run over each snippet in [`fixtures/violations.md`](./fixtures/violations.md): each
   must produce exactly the named check at the named severity.
4. Run over each domain's artifacts and compare against its `EXPECTED.md` — including
   the equivalence pair, where both spec forms must yield the same record set.
5. Compare any writing-rules detector against the labels in
   [`fixtures/prose-fixtures/labeled.yaml`](./fixtures/prose-fixtures/labeled.yaml), reporting
   precision, recall, and mismatched codes without asserting an unevaluated target.
