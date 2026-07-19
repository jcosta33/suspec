<!-- checks fixture: expected results -->

# auth-refresh

The spec carries three requirement IDs and seeds one deterministic defect: AC-002 has no
verification command.

| Invocation target | Exit | Diagnostics |
| --- | --- | --- |
| `spec.md` | 2 | C003 on AC-002 |
| `task.md` with `spec.md` | 2 | usage error: spec companion fails C003 |
| `review.md` with `spec.md` and `task.md` | 2 | usage error: spec companion fails C003 |

The writing watchlist flags AC-003's "handle ... gracefully". That is a human
checklist result, not a deterministic diagnostic.
