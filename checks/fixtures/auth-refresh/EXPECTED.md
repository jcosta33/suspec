<!-- checks fixture: expected results -->

# auth-refresh

The plain and SOL specs represent the same three requirement IDs. Both seed one deterministic
defect: AC-002 has no verification command. Check each spec separately because they intentionally
share `id: SPEC-auth-refresh`.

| Invocation target | Exit | Diagnostics |
| --- | --- | --- |
| `spec.md` | 2 | C003 on AC-002 |
| `spec.sol.md` | 2 | C003 on AC-002 |
| `task.md` | 0 | none |
| `review.md` with `spec.md` and `task.md` | 1 | C013 warning on Supported AC-001 and AC-003 rows carrying free-form evidence only |

The writing watchlist flags AC-003's "handle ... gracefully" in both forms. That is a human
checklist result, not a deterministic diagnostic.

The parser paths must expose the same IDs and named verification commands:

| ID | Plain | SOL |
| --- | --- | --- |
| AC-001 | `auth-refresh.spec.ts#replays-after-refresh` | `test:cmdTest:auth-refresh.spec.ts#replays-after-refresh` |
| AC-002 | none | none |
| AC-003 | `auth-refresh.spec.ts#timeout` | `test:cmdTest:auth-refresh.spec.ts#timeout` |
