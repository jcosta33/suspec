<!-- checks fixture: expected results -->

# checkout

The spec carries three requirement IDs under `id: SPEC-checkout`.

| Invocation target | Exit | Diagnostics |
| --- | --- | --- |
| `spec.md` | 0 | none |
| `task.md` with `spec.md` | 0 | none |
| `review.md` with `spec.md` and `task.md` | 1 | C013 warning on Supported AC-001 and AC-002 rows carrying free-form evidence only |

AC-001 bundles validation, charging, and email. AC-002 and AC-003 share a write area. Those are human
review and task-splitting concerns; no deterministic check claims them.

The parser paths must expose AC-001, AC-002, and AC-003 with a non-empty named verification command
for each requirement.
