---
type: campaign
id: CAMPAIGN-checkout-modernization
status: ready
ledger: ./ledger.md
sources:
  - ./spec.md
---

# Checkout modernization

## Objective

Modernize checkout through reviewable pull requests without changing settled behavior.

## Completion contract

- Every source obligation is implemented and verified on current main.
- Every campaign pull request is merged or explicitly deferred in the ledger.
- Every campaign-owned lane is clean and reusable.

## Authorities

- Requirements: `./spec.md`
- Progress: `./ledger.md`
- Delivery transitions: project commands named by the ledger.

## Operating loop

Read every authority, reconcile live state, repair ledger drift, continue the highest-priority
dependency-ready work through project gates, record durable progress, and repeat.

## Stops

Stop only when the completion contract passes or a named human decision blocks dependent work.
