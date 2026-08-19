# Review

A non-implementer judges the result. Open the native diff. Rerun the requirement command. Do not
write a Suspec review file.

```text
npm run test:integration -- expired-session
Tests: 3 passed, 3 total
```

The implementer cannot accept this work. The checker reports facts on the spec (and the task, when
one exists). It does not render the verdict.

```bash
suspec check ~/.agents/artifacts/shop-api/checkout-expiry-spec.md
```

Empty or stale evidence is unverified. The human accepts, requests changes, or defers on the PR.

Next: [close](04-close.md).
