<!-- checks fixture: expected results -->

# checkout

The spec carries three requirement IDs under `id: SPEC-checkout`.

| Invocation target | Exit | Diagnostics |
| --- | --- | --- |
| `spec.md` | 0 | none |
| `task.md` with `spec.md` | 0 | none |

AC-001 bundles validation, charging, and email. AC-002 and AC-003 share a write area. Those are human
review and task-splitting concerns; no deterministic check claims them.

The parser paths must expose AC-001, AC-002, and AC-003 with a non-empty named verification command
for each requirement.
