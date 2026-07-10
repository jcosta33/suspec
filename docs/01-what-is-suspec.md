# What is Suspec?

Suspec is an opinionated methodology for working with coding agents, shipped as a
globally installed skill family.

The skills structure the agent's working artifacts — the spec that states intent, the
optional task split, the review packet that reconciles the result, the findings worth
keeping — so that plans stop being freeform prose and review claims stop being vibes.
A small CLI reinforces the discipline with deterministic checks. Your agent writes the
code; Suspec shapes the work around it.

It gives you:

- specs with requirements and acceptance criteria, sized to the work
- optional task packets when one spec splits into parallel slices
- review packets that reconcile evidence against the spec, requirement by requirement
- a discipline for saving durable lessons where your harness actually reads them
- a deterministic checker — `suspec check` — over any of these artifacts

It does not replace your agent, your harness's plan mode, your issue tracker, PRs, CI,
or your docs site.

## Proportional rigor

The least structure that changes execution or reviewability — this rule is existential,
not decorative (level: convention):

- A **trivial fix** gets a one-line inline spec and no file at all.
- A **feature** gets a lean spec: a handful of requirements with IDs and `Verify with:`
  lines, non-goals, acceptance criteria.
- **Large work** extends the spec — inventory, change plan, task slices — rather than
  padding it.

How you entered the work (a ticket, a chat message, your own idea) never sets the
ceremony level. The work does.

## Coexists with native planning

Suspec never modifies, replaces, or races your harness's own plan mode. If lightweight
native planning serves the change, use it and stop there. Suspec artifacts are produced
alongside, by skills, when the work earns them — a contract the agent implements against
and a reviewer reconciles against, not a second planner.

## The honesty floor

Review claims are where agent work goes wrong quietly. The deterministic checks exist so
the load-bearing claims cannot be faked:

- every scoped requirement has a coverage row (nothing dropped silently)
- every evidence command matches the spec's `Verify with:` line
- every `Pass` carries evidence — an empty evidence cell can never read as `Pass`
- every reference resolves

plus per-artifact lint on specs, change plans, tasks, and review packets. The checker is
`suspec check <path>` — facts and exit codes, no model in the loop, no review result
rendered (level: enforced — suspec-cli). Every step also keeps a by-hand path; no step
requires a tool (level: convention).

## Code is king

Suspec artifacts are transient working files. They are never committed to the repos you
work on, and nothing durable is supposed to live in them: a decision becomes an ADR,
behavior becomes tests, a lesson becomes a native harness memory, the discussion lives
on the PR. The durable record stays in the layers that already own it.

## Who should not use it

If you work alone, in a codebase you know, on changes small enough to read whole — native
plan mode, an `AGENTS.md`, and your test suite already cover most of this, at zero
ceremony. On tractable, clearly-specified work a capable agent tends to reach the same
result with or without the structure, so the structure mostly adds process rather than
catching problems your existing tools miss. Suspec starts paying when the diff outgrows
your attention, when more than one person or agent touches the work, or when someone must
later reconstruct what was intended and what was proven. Until one of those is true,
don't adopt it.

## Start here

1. Read [the basic workflow](02-basic-workflow.md).
2. Check [where files live](03-where-files-live.md).
3. Walk [the tutorial](tutorial/README.md).

## Related

Next: [The basic workflow](02-basic-workflow.md)
