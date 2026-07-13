# Lineage

Lineage makes each live handoff explicit without a store or discovery system.

```text
request/source -> working spec -> implementation -> review -> findings decision
                         \
                          -> split task(s), when decomposition is earned
```

## Relationships

- A spec names its upstream source in frontmatter.
- A task names its source spec and copies only assigned requirement IDs. When a change plan
  provides wave or preservation context, the task names it in addition to the spec.
- A review is checked against an explicitly passed spec. When it names a task, that task
  is also passed explicitly and narrows coverage scope.
- Execution and review evidence name the requirement and command they support.
- A durable finding names durable evidence and moves to native memory or a project channel.

IDs support reconciliation inside the live work; they do not create a global registry.
Requirement IDs are spec-scoped, so cross-spec references use `SPEC-id#AC-NNN`.

## Paths

Every producer states where it wrote an artifact. Every consumer receives its absolute path.
The checker reads only primary paths and companions it is handed, plus its documented
artifact-relative reference lookups.

## After close

The working chain can expire. Code, tests, project decisions, issues, PRs, maintained docs, and
supported native memory are the durable lineage. Suspec keeps no separate artifact record.
Explicit promotion moves a whole transient artifact into a project-owned durable destination; it
creates no registry or retained transient copy.

Related: [where files live](../03-where-files-live.md) · [CLI](cli.md)
