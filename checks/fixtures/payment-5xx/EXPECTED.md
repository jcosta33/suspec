<!-- checks fixture: expected results -->

# payment-5xx

The spec carries three requirement IDs and one blocking question, seeding one deterministic
defect: the spec is `ready` while that question remains open.

| Invocation target | Exit | Diagnostics |
| --- | --- | --- |
| `spec.md` | 2 | C007 blocking question at `status: ready` |
| `task.md` with `spec.md` | 2 | usage error: spec companion fails C007 |
| `review.md` with `spec.md` and `task.md` | 2 | usage error: spec companion fails C007 |

AC-002 requires a retry while AC-003 forbids it under the same condition. The checker does not
detect that contradiction or reject task creation after a blocking question; both remain human
review defects.

The parser paths must expose AC-001, AC-002, and AC-003 with a non-empty named verification command
for each requirement.
