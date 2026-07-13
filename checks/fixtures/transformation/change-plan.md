---
# checks fixture — expected results pinned in EXPECTED.md
type: change-plan
id: CHANGE-inventory-ledger
title: Move the inventory ledger out of db/orders
status: draft
kind: schema-change
owner: checkout-team
sources: [INV-checkout-storage, SPEC-checkout]
preserves: [SPEC-checkout#AC-002, SPEC-checkout#AC-003]
created: 2026-06-11
---

# Change Plan: Move the inventory ledger out of db/orders

## Intent

Move the inventory ledger from `db/orders` into its own `db/inventory` schema, so order
work and ledger work stop sharing one write area.

## Why this change is needed

INV-checkout-storage shows that the ledger lives inside the orders schema and that both
checkout paths write the same area, so parallel changes would conflict.

## Baseline

- `db/orders` holds both `orders` and `inventory_ledger`; `appendLedger` and the nightly
  reconciliation job target it directly (per INV-checkout-storage).

## Target state

- `db/inventory.ledger` owns ledger rows; `db/orders` keeps only order data; the
  reconciliation job reads the new schema. What a ledger entry contains stays unchanged.

## Preservation guarantees

| ID | Behavior | Verify with |
|---|---|---|
| SPEC-checkout#AC-002 | A successful charge still writes the order record | `npm test -- order-record.spec.ts` |
| SPEC-checkout#AC-003 | A successful charge still appends the ledger entry | `npm test -- inventory.spec.ts` |
| PG-001 | The nightly reconciliation job returns the same rows before and after | `npm test -- reconcile.spec.ts` (new) |

PG-001 is plan-local because the reconciliation behavior is not part of the working
checkout spec. If it must become a durable public contract, encode it in the project layer
that owns that behavior.

## Non-goals

- Changing what a ledger entry contains.
- The cart service and the payment provider integration.

## Affected surfaces

| Surface | Intended change |
|---|---|
| `db/inventory` | New schema and `ledger` table (wave 1) |
| `api/src/checkout/ledger.ts` | Write to the new schema |
| `jobs/reconcile.sql` | Read from the new schema (wave 2) |
| `db/orders` | Drop `inventory_ledger` (wave 3) |

## Risk areas

- The reconciliation job's join — the one consumer with no test today, and the inventory's
  open unknown (anything else reading `inventory_ledger` directly).

## Transformation waves

1. Create `db/inventory.ledger`; dual-write old and new from `appendLedger`. Green check:
   `npm test -- inventory.spec.ts` plus the new dual-write assertion.
2. Backfill historical rows; cut the reconciliation job's reads over to `db/inventory`.
   Green check: `npm test -- reconcile.spec.ts` and a manual diff of nightly job output
   before/after.
3. Stop dual-writing; drop `db/orders.inventory_ledger`. Green check: the full suite.

## Cutover conditions

- The wave-2 job-output diff is empty for two consecutive nightly runs.

## Rollback criteria

- Any non-empty reconciliation diff after wave 2 — point reads back at `db/orders`
  (dual-write keeps it current until wave 3 lands).

## Verification strategy

- [ ] `npm test -- order-record.spec.ts inventory.spec.ts reconcile.spec.ts`
- [ ] Manual: nightly job-output diff, waves 2–3

## Review focus

- Wave 2: any direct reader of `inventory_ledger` outside the reconciliation job.
- Wave 3 is irreversible — confirm the cutover condition held before it merges.

## Task split

| Task | Wave | Scope (guarantee/requirement ids) |
|---|---|---|
| TASK-ledger-w1 | 1 | SPEC-checkout#AC-003 |
| TASK-ledger-w2 | 2 | SPEC-checkout#AC-003, PG-001 |
| TASK-ledger-w3 | 3 | SPEC-checkout#AC-002, SPEC-checkout#AC-003, PG-001 |
