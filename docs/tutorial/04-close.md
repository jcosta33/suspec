# Close

The review exposed one durable lesson. Preserve it through supported native memory:

```markdown
## Expired checkout sessions return 409, not a 5xx

Verified by `test/integration/expired-session.test.ts` and
`npm run test:integration -- expired-session`.

Applies to: checkout session expiry.
Does not apply to: other checkout validation failures or non-checkout sessions.
```

Without native memory, use the project's issue, decision, test, or maintained documentation. Saving
nothing is valid.

After the final consumer finishes, present one choice for the spec, review, and sidecars:

1. **Delete:** remove exhausted transient work.
2. **Leave:** keep files required by a known continuation.
3. **Promote:** sanitize and move durable project truth, repair references, and validate.

The picker may expose `Other` to split the files across those actions.

The human chooses. Silence is not Leave, and a forgotten directory is not a retention policy.
Promotion never pushes or creates lifecycle state.

This run needed no task, inventory, or change plan. Structural work follows
[inventories and change plans](../05-brownfield-and-change-plans.md).
