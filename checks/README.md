# Checks fixtures

This directory holds oracle data for [`checks.yaml`](./checks.yaml). It runs nothing and decides
nothing. `suspec-cli` is the reference consumer; [checks reference](../docs/reference/checks.md) is
the human contract.

## Evidence rules

- C023 requires no evidence at `ready` or `running`. At `review-ready` or `closed`, `## Verify`
  needs either numeric exit status plus non-empty fenced raw output, a visible CI URL, or justified
  `n/a`.
  Exact claim-only and placeholder output fails
  [[EVIBOUND]](../docs/research/sources.md#EVIBOUND).
- C024 rejects unresolved canonical blocking fields in a closed task. `none` and `n/a` resolve them.
- C025 rejects specs with missing identity, status, required sections, or requirements.
- C028 rejects missing, duplicated, misordered, or escaped requirement fields.
- C029 rejects malformed campaign identity, status, authority, or required sections.
- C030 rejects broken campaign authorities and copied task-list state.
- C031 rejects unresolved blocking state in a ready campaign.

C012, C013, C016, C020, C026, and C027 are RESERVED. Never reuse.

## Contents

| Path | Role |
| --- | --- |
| [`checks.yaml`](./checks.yaml) | machine contract |
| [`fixtures/conformant-task.md`](./fixtures/conformant-task.md) | positive task oracle |
| [`fixtures/violations.md`](./fixtures/violations.md) | minimal negative cases |
| `fixtures/auth-refresh/` | spec, task, and expected result |
| `fixtures/payment-5xx/` | spec, task, and expected result |
| `fixtures/checkout/` | spec, task, and expected result |
| `fixtures/transformation/` | inventory, change plan, C010, and C011 |
| `fixtures/cross-folder-source/` | artifact-relative C009 |
| `fixtures/attention-economy/` | minimal and deferred specs |
| `fixtures/campaign/` | restartable goal, native ledger, and governing source |

Live `Do not change` comparison remains reviewer work because the checker receives no diff.

Related examples:

| Fixture | Example |
| --- | --- |
| `auth-refresh` | [feature from ticket](../docs/examples/feature-from-ticket.md) |
| `payment-5xx` | [bug fix](../docs/examples/bug-fix.md) |
| `checkout` | [large PR review](../docs/examples/large-pr-review.md) |

## Closed values

| Family | Values |
| --- | --- |
| strength words | `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, `MAY` |
| artifact types | `spec`, `task`, `inventory`, `change-plan`, `audit`, `research`, `campaign`, `panel` |

Checked types: `spec`, `task`, `change-plan`, `campaign`.

## Maintainer contract

- Core IDs and severities match [checks reference](../docs/reference/checks.md) row for row.
- Task schemas match the checked subset of
  [artifact formats](../docs/reference/artifact-formats.md).
- Every pinned expectation agrees with contract and prose. A fixture is evidence, not decoration.
- `conformant-task.md` returns no diagnostic.
- Each violation snippet returns exactly its named check and severity.
- Domain artifacts match their `EXPECTED.md`.
