---
type: review
id: REVIEW-checkout
task: TASK-checkout
pr: https://example.test/pr/507
decision: pending
---

# Cart submission and checkout

## Changed files

- `api/src/checkout/submit.ts`
- `db/orders/0007_add_inventory_ledger.sql`

## Requirement coverage

| ID | Assessment | Evidence |
|---|---|---|
| AC-001 | Supported | `submit ✓` — PR run #133 |
| AC-002 | Supported | `writes-order ✓` — PR run #133 |
| AC-003 | Unverified | Inventory verification did not run. |

## Open decisions

- Run AC-003 verification and decide the migration's write-area placement.
