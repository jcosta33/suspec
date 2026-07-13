# Workflow

## Trivial work

State the correction and proof inline:

```text
Fix: expired refresh tokens must redirect to /login, not 500.
Verify with: pnpm test:run auth-refresh-expired-token
```

Implement, run the command, preserve the output, and review the result. Do not manufacture a file to
prove a process happened.

## Structured work

```text
intent -> spec -> implement -> review -> check -> findings
```

1. **Spec:** `sus-spec` writes intent and requirements with stable IDs and `Verify with:` lines.
   Set `status: ready` before dispatch or review.
2. **Implement:** a native worker or human follows the spec by absolute path, runs every verification,
   and records real output under `## Execution`.
3. **Review:** `sus-review` independently assesses every scoped requirement and routes exceptions to
   the human.
4. **Check:** `suspec check` catches coverage, command-binding, evidence, and reference defects.
5. **Findings:** discard transient observations; route verified durable lessons through
   [memory or project records](09-saving-findings.md).

Every step has a by-hand path. The CLI backs the method; it never gets custody of it.

## Escalation

| Signal                                               | Add                       |
| ---------------------------------------------------- | ------------------------- |
| intent exceeds one precise sentence                  | spec                      |
| current behavior or ownership is unclear             | inventory                 |
| structural work must preserve behavior across stages | change plan               |
| one source has separately dispatchable slices        | task                      |
| risk exceeds direct inspection                       | formal independent review |

A task narrows a source spec; it never adds requirements. A change plan adds transformation order and
preservation context; it never replaces the spec.

## Proof, not claims

- Preserve fresh output for every verification claim.
- Treat empty evidence as `Unverified`, never `Supported`.
- Expose blocked and unverified work.
- Keep acceptance human-owned.

Next: [artifact location and close](03-where-files-live.md). Previous:
[what Suspec is](01-what-is-suspec.md).
