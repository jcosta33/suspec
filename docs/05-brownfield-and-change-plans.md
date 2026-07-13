# Inventories and change plans

```text
inventory -> spec -> change plan -> task split when needed -> implement -> review
```

Add only the structure the work needs. `sus-inventory` records present reality.
`sus-change-plan` defines a behavior-preserving transformation. Both use the
[agent-neutral artifact location](03-where-files-live.md).

## Inventory

Use an inventory when ownership, behavior, tests, interfaces, dependencies, or constraints remain
unclear. Record:

- relevant files and modules;
- observed behavior and public interfaces;
- existing tests;
- constraints and dependencies;
- unknowns;
- file or line evidence for every structural claim.

Inventory observes. It does not prescribe. The CLI recognizes inventory but does not check it; review
it by hand.

## Change plan

Use a change plan for migrations, rewrites, schema changes, broad refactors, dependency upgrades, or
staged performance work. It adds:

- baseline and target state;
- preservation guarantees;
- ordered waves;
- verification per wave;
- cutover and rollback.

The source spec owns product requirements. The plan owns transformation order and preservation
context.

Prefer existing requirement references:

```yaml
preserves:
  - SPEC-checkout#AC-001
```

Use `PG-NNN` only for plan-local guarantees. Put lasting behavior in tests, public contracts, or
project decisions.

Each wave must leave the codebase usable and verifiable. When a wave becomes a task, that task still
names the source spec and its scoped requirement IDs.

`suspec check <path>` validates preservation references and wave structure.

## Live drift

When code or evidence contradicts the working spec, stop. Update the spec if intent changed; fix code
if implementation drifted; record any lasting decision through the project's own channel. After
close, start later work from current code and durable records, not old transient artifacts.

Skip both documents for local work whose behavior, ownership, and tests are already clear.

Next: [tasks](06-creating-tasks.md). Previous: [specs](04-writing-specs.md).
