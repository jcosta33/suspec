# The basic workflow

## The trivial path first

Most changes are small. For a trivial fix the whole spec is one line, stated inline —
in the conversation, not in a file:

```text
Fix: expired refresh tokens must redirect to /login, not 500.
Verify with: pnpm test:run auth-refresh-expired-token
```

Implement, run the verify command, paste the output. Done. No file, no packet, no check
run. Proportional rigor means the structure below exists for the work that earns it —
never as a toll on the work that doesn't (level: convention).

## The full loop

When the change is big enough to need a contract:

```text
intent -> spec -> implement -> review packet -> check -> findings
```

1. **Spec** — the authoring skill turns intent into a lean spec: requirements with
   `AC-NNN` ids and `Verify with:` lines, non-goals, open questions. Place the file next
   to your own native artifacts (see [where files live](03-where-files-live.md)) and
   carry its full path forward. Lint it: `suspec check <path>`.
2. **Implement** — the implementer (your agent, or you) works from the spec by explicit
   path, runs every verify command, and pastes real output into the spec's
   `## Execution` section. `Tests passed` without output is not evidence.
3. **Review packet** — an independent reviewer (never the implementer) reconciles the
   result against the spec: one coverage row per scoped requirement, evidence per row,
   exceptions routed to human attention.
4. **Check** — the deterministic floor:
   `suspec check <review-path> --spec <spec-path> --task <task-path>` — coverage
   complete, commands match, every `Pass` evidenced, references resolve. Exit codes:
   `0` clean, `1` warning, `2` blocking (level: enforced — suspec-cli). The human owns
   the verdict; the check owns the facts.
5. **Findings** — ephemeral findings ride the review packet and die with it. A durable
   lesson becomes a native harness memory — see [saving findings](09-saving-findings.md).

## The optional layers

- **Inventory** — map existing code before brownfield work: observed modules,
  interfaces, tests, unknowns, with file references. Skip when the code is understood.
- **Change plan** — for migrations, rewrites, schema changes, high-risk refactors:
  preservation guarantees, waves, verification per wave, rollback. See
  [brownfield work and change plans](05-brownfield-and-change-plans.md).
- **Task** — cut only when one spec splits into **parallel slices**. The common 1:1
  case has no task file: the implementer works from the spec. See
  [creating tasks](06-creating-tasks.md).
- **Intake** — capture the upstream ask verbatim when work starts from a ticket or
  thread and you want the original preserved. Otherwise the spec names its source
  directly (a URL, an issue, or `self`).

## Common paths

| Work | Path |
| --- | --- |
| Trivial fix | one-line inline spec -> implement -> verify -> done |
| Small feature | spec -> implement -> review -> check |
| Bug fix | amend the spec -> implement -> review -> check |
| Brownfield change | inventory -> spec -> implement -> review -> check |
| Migration or rewrite | inventory -> spec -> change plan -> wave tasks -> reviews |
| PR that already exists | write the acceptance bar as a spec -> review against it |

Match the ceremony to the risk, not the reverse: most work sits at a lean spec plus
independent review, and heavier forms are for the change that earns them.

## What not to skip

For code-changing work, keep:

- verification output — real, pasted, per requirement
- independent review — a non-implementer judges it; the formal packet scales with risk
- evidence for every `Pass` — empty evidence means `Unverified`, never `Pass`
- a visible record of blocked or unverified work

## Related

- Next: [Where files live](03-where-files-live.md)
- Previous: [What is Suspec?](01-what-is-suspec.md)
