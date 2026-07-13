# Checks fixtures

This directory holds data for [`checks.yaml`](./checks.yaml). It runs nothing. `suspec-cli` is the
reference consumer; [checks reference](../docs/reference/checks.md) is the human contract.

## Evidence rules

- C023 requires no evidence at `ready` or `running`. At `review-ready` or `closed`, `## Verify`
  needs either numeric exit status plus non-empty fenced raw output, a visible CI URL, or justified
  `n/a`.
  Exact claim-only and placeholder output fails
  [[EVIBOUND]](../docs/research/sources.md#EVIBOUND).
- C024 rejects unresolved canonical blocking fields in a closed task. `none` and `n/a` resolve them.
- Accepted reviews cannot retain an open critical decision.
- Empty review evidence is `Unverified`, never `Supported`.

## Contents

| Path                                                           | Purpose                                                           |
| -------------------------------------------------------------- | ----------------------------------------------------------------- |
| [`checks.yaml`](./checks.yaml)                                 | machine contract                                                  |
| [`fixtures/conformant-task.md`](./fixtures/conformant-task.md) | positive task oracle                                              |
| [`fixtures/violations.md`](./fixtures/violations.md)           | minimal negative cases                                            |
| `fixtures/auth-refresh/`                                       | plain/SOL spec, task, review, and expected result                 |
| `fixtures/payment-5xx/`                                        | plain/SOL spec, task, review, and expected result                 |
| `fixtures/checkout/`                                           | plain/SOL spec, task, review, and expected result                 |
| `fixtures/transformation/`                                     | inventory, change plan, C010, and C011                            |
| `fixtures/cross-folder-source/`                                | artifact-relative C009                                            |
| `fixtures/attention-economy/`                                  | minimal/deferred specs, reviews, waivers, decisions, and receipts |

C012 and C013 negative cases live in `fixtures/violations.md`; domain scenarios provide positive
coverage. Live `Do not change` comparison remains reviewer work because the checker receives no diff.

Related examples:

| Fixture        | Example                                                        |
| -------------- | -------------------------------------------------------------- |
| `auth-refresh` | [feature from ticket](../docs/examples/feature-from-ticket.md) |
| `payment-5xx`  | [bug fix](../docs/examples/bug-fix.md)                         |
| `checkout`     | [large PR review](../docs/examples/large-pr-review.md)         |

Plain and `format: sol` specs must produce equivalent structural records and implemented diagnostics.
The fixtures claim no unimplemented semantic parsing.

## Closed values

| Set            | Values                                                                    |
| -------------- | ------------------------------------------------------------------------- |
| SOL blocks     | `REQ`, `CONSTRAINT`, `INVARIANT`, `INTERFACE`, `QUESTION`                 |
| strength words | must, must not, should, should not, may; uppercase in SOL                 |
| assessments    | `Supported`, `Unsupported`, `Unverified`, `Blocked`                       |
| artifact types | `spec`, `task`, `review`, `inventory`, `change-plan`, `audit`, `research` |

## Maintainer contract

- Core IDs and severities match [checks reference](../docs/reference/checks.md) row for row.
- Task and review schemas match the checked subset of
  [artifact formats](../docs/reference/artifact-formats.md).
- Every pinned expectation agrees with contract and prose.
- `conformant-task.md` returns no diagnostic.
- Each violation snippet returns exactly its named check and severity.
- Domain artifacts match their `EXPECTED.md`.
