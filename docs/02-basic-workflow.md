# Workflow

## Trivial work

State the correction and proof inline:

```text
Fix: expired refresh tokens must redirect to /login, not 500.
Verify with: pnpm test:run auth-refresh-expired-token
```

Implement, run the command, and preserve the output. A non-implementer reviews the final diff and
output in the project's native PR, CI, or conversation surface. Do not manufacture a file to prove a
process happened.

## Structured work

```text
intent -> spec -> implement -> review -> check -> findings
```

1. **Spec:** `sus-spec` writes intent and requirements with stable IDs and `Verify with:` lines.
   Set `status: ready` before dispatch or review.
2. **Implement:** a native worker or human follows the spec by absolute path, runs every verification,
   and records real output under `## Execution`.
3. **Review:** a non-implementer judges the result. Use `sus-review` when risk or later
   reconstruction earns a formal packet.
4. **Check:** use `suspec check` when deterministic coverage, command-binding, evidence, or reference
   reconciliation pays for itself.
5. **Findings:** discard transient observations; route verified durable lessons through
   [memory or project records](09-saving-findings.md).

Every step has a by-hand path. A fresh human or agent may review without `sus-review`; the
implementer may not call self-review independent. Work that earns independent review stays blocked
until a non-implementer can judge it. The CLI backs the method; it never gets custody of it.

## Escalation

Escalate only when the [signal earns the rigor](reference/rigor-escalation.md).

A task narrows a source spec; it never adds requirements. A change plan adds transformation order and
preservation context; it never replaces the spec.

## Proof, not claims

- Preserve fresh output for every verification claim.
- Treat empty evidence as `Unverified`, never `Supported`.
- Expose blocked and unverified work.
- Keep acceptance human-owned.

Next: [artifact location and close](03-where-files-live.md). Previous:
[what Suspec is](01-what-is-suspec.md).
