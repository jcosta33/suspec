# Implement

This example has one requirement and one worker, so it does not earn a task split. The
worker implements directly from the spec and records run evidence in that working file.

## 1. Dispatch by explicit path

Hand the spec to a native harness worker or implement it directly:

```text
Read ~/.agents/artifacts/shop-api/checkout-expiry-spec.md and implement AC-001.
Run its Verify command, paste the real output under ## Execution, and report any blocked
question before changing the requirement or its non-goals.
```

The path is part of the handoff. Nothing discovers the spec.

## 2. Implement and capture evidence

The worker adds run notes to the spec after the final edit:

```markdown
## Execution

- Changed files: `src/checkout/expiry.ts`, `src/api/errors.ts`,
  `test/integration/expired-session.test.ts`
- Verify: `npm run test:integration -- expired-session`

      Test Suites: 1 passed, 1 total
      Tests:       3 passed, 3 total

- Out-of-scope edits: none
- Blocked questions: none
- Findings: expired checkout sessions are an expected client case, not an
  outage signal
```

For the fictional `shop-api`, this output is illustrative. In a real run, execute the
command after the final edit and paste its exact output.

## 3. Check the handoff

Before review, confirm:

- changed files are explicit
- the named Verify command ran after the final edit
- output is pasted rather than summarized
- scope drift and blocked questions are visible
- findings remain claims for the reviewer to examine

When one spec actually splits into parallel slices, use
[creating tasks](../06-creating-tasks.md) and place each task in the agent-neutral workspace.
This example does not need that scaffold.

Next: [Review](03-review.md).
