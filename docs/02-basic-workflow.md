# The basic workflow

## The trivial path first

Most changes are small. For a trivial fix the whole intent is one line, stated inline —
in the conversation, not in a file:

```text
Fix: expired refresh tokens must redirect to /login, not 500.
Verify with: pnpm test:run auth-refresh-expired-token
```

Implement, run the verify command, paste the output. Done. No file, no packet, no check
run. Proportional rigor means the structure below exists for the work that earns it —
never as a toll on the work that doesn't (level: convention). Even at this weight the
keys are present: intent is the one-line fix, review is you reading the pasted
output, findings is the deliberate call that nothing durable was learned.

## The full loop

When the change is big enough to need a contract:

```text
intent -> spec -> implement -> review packet -> check -> findings
```

1. **Spec** — `sus-spec` turns intent into a lean spec: intent plus requirements
   with `AC-NNN` ids and `Verify with:` lines. Add other sections only when they carry
   information. Place the file in the [agent-neutral workspace](03-where-files-live.md),
   carry its absolute path forward, and lint it: `suspec check <path>`.
2. **Implement** — a native harness worker or human works from the spec by explicit
   path, runs every verify command, and pastes real output into the spec's
   `## Execution` section. `Tests passed` without output is not evidence.
3. **Review packet** — `sus-review` runs in an independent context and reconciles the
   result against the spec: one coverage row per scoped requirement, evidence per row,
   exceptions routed to a human.
4. **Check** — the deterministic floor:
   `suspec check <review-path> --spec <spec-path>` (add `--task <task-path>` when the
   spec was split into one) — coverage complete, commands match, every `Supported` evidenced,
   references resolve. Exit codes:
   `0` clean, `1` warning, `2` blocking (level: enforced — suspec-cli). The human owns
   the review decision; the check owns the facts.
5. **Findings** — ephemeral findings ride the review packet and die with it. `remember` routes a
   verified durable lesson to native harness memory or a project channel — see
   [saving findings](09-saving-findings.md).

Every step above keeps a by-hand path; no step requires a tool (level: convention).

## The keys

The loop's keys — **intent**, **review**, **findings** — are present on
virtually every change, at whatever weight the change earns:

- **Intent** — every change starts by stating what must become true, even when the next
  step is straight to code. At minimum ceremony it is one sentence folded inline; when
  the work earns structure it graduates into a spec.
- **Review** — nearly every change ends with a judgment of the result against the
  intent. At minimum ceremony it is the owner reading the diff and the pasted output;
  the formal packet scales with risk.
- **Findings** — every change closes with a decision about what it taught, even when
  that decision is a deliberate "nothing durable learned". A durable lesson becomes a
  native memory.

The trivial path above is not an exception to the loop — it is the keys at their
lightest weight, with zero scaffold around them.

## The scaffold

The scaffold is what Suspec erects around the keys when the work earns it — pulled in
proportionally, never a station to pass through. The spec (the structured form intent
graduates into) and the deterministic check are the scaffold the full loop above already
shows; the rest:

- **Task** — `sus-task` cuts one only when a spec has separately dispatchable parallel/context slices, or a
  change plan defines separately dispatchable sequenced waves. Size alone does not create a
  task; the common 1:1 case works directly from the source. See
  [creating tasks](06-creating-tasks.md).
- **Inventory** — `sus-inventory` maps existing code before brownfield work: observed modules,
  interfaces, tests, unknowns, with file references. Skip when the code is understood.
- **Change plan** — `sus-change-plan` handles migrations, rewrites, schema changes, and high-risk refactors:
  preservation guarantees, waves, verification per wave, rollback. See
  [brownfield work and change plans](05-brownfield-and-change-plans.md).
Implementation is neither key nor scaffold — it is the work itself, the thing the loop
exists to serve. No key depends on scaffold (level: convention).

## Common paths

| Work | Path |
| --- | --- |
| Trivial fix | one-line intent -> implement -> verify -> done |
| Small feature | spec -> implement -> review -> check |
| Bug fix | state the intended correction -> implement -> verify -> review |
| Brownfield change | inventory -> spec -> implement -> review -> check |
| Migration or rewrite | inventory -> spec -> change plan -> wave tasks -> reviews |
| PR that already exists | write the acceptance bar as a spec -> review against it |

Match the ceremony to the risk, not the reverse: pick the row above that fits the change,
and let heavier forms stay reserved for the change that earns them.

## What not to skip

For code-changing work, keep:

- verification output — real, pasted, per requirement
- independent review — a non-implementer judges it; on the trivial path this is the owner
  reading the pasted output, not a separate step, and the formal packet scales with risk
- evidence for every `Supported` — empty evidence means `Unverified`, never `Supported`
- a visible record of blocked or unverified work

## Related

- Next: [Where files live](03-where-files-live.md)
- Previous: [What is Suspec?](01-what-is-suspec.md)
