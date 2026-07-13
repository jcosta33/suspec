# Implement

One requirement and one worker do not justify a task. There is nothing to split. Dispatch the spec
directly:

```text
Read ~/.agents/artifacts/shop-api/checkout-expiry-spec.md and implement AC-001.
Run its Verify command, paste real output under ## Execution, and stop before changing
the requirement or non-goals.
```

After the final edit, append:

```markdown
## Execution

- Changed files: `src/checkout/expiry.ts`, `src/api/errors.ts`,
  `test/integration/expired-session.test.ts`
- Verify: `npm run test:integration -- expired-session`

      Test Suites: 1 passed, 1 total
      Tests:       3 passed, 3 total

- Out-of-scope edits: none
- Blocked questions: none
- Findings: expired checkout sessions are an expected client case, not an outage signal
```

The output is illustrative. A real run preserves exact output after the final edit. Yesterday's green
run is not today's evidence.

Before review, confirm changed files, fresh output, scope drift, blockers, and findings are explicit.
When one spec truly splits, follow [task creation](../06-creating-tasks.md).

Next: [review](03-review.md).
