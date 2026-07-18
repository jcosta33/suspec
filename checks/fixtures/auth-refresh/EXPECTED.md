<!-- checks fixture: expected results -->

# auth-refresh

The spec carries three requirement IDs and seeds one deterministic defect: AC-002 has no
verification command.

| Invocation target | Exit | Diagnostics |
| --- | --- | --- |
| `spec.md` | 2 | C003 on AC-002 |
| `task.md` | 0 | none |
| `review.md` with `spec.md` and `task.md` | 1 | C013 warning on Supported AC-001 and AC-003 rows carrying free-form evidence only |

The writing watchlist flags AC-003's "handle ... gracefully". That is a human
checklist result, not a deterministic diagnostic.
