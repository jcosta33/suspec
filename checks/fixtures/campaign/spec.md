---
type: spec
id: SPEC-checkout-modernization
status: ready
sources:
  - SHOP-4012
---

## Intent

Modernize checkout without changing settled behavior.

## Requirements

### AC-001
- When: checkout work is complete
- Then: the current verification suite MUST pass
- Verify with: `pnpm test:run checkout`
