<!-- checks fixture — expected results pinned in EXPECTED.md (this file) -->

# cross-folder-source — expected check results

Checks fixture for [the check catalogue](../../../docs/reference/checks.md), pinning **C009
(`broken-source-link`) artifact-relative resolution across folders** — a spec at
`specs/triage/spec.md` cites a ticket captured under a distant `sources/` folder by writing the
relative path **from its own directory**.

Resolution is artifact-relative (the checker reads exactly the files it is handed and infers no
root): a ref resolves when it exists relative to the spec's own directory, and only such a ref
resolves. A distant file is cited as `../../sources/sup-204.md`; a bare `sources/sup-204.md` written
from `specs/triage/spec.md` would be a broken link, because no surrounding tree is ever consulted.

## Layout

```
cross-folder-source/
  sources/sup-204.md         <- the captured ticket, two levels up from the spec
  specs/triage/spec.md       <- sources: [../../sources/sup-204.md]   (spec-relative path)
```

## Expected results — `suspec check specs/triage/spec.md`

| Check                     | Where                              | Expected result                                                                                                                                                              | Severity                |
| ------------------------- | ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------- |
| C009 `broken-source-link` | `sources: ../../sources/sup-204.md` | **resolves** — the ref exists relative to the spec's own directory (`specs/triage/../../sources/sup-204.md` -> `sources/sup-204.md`), so C009 is clean across the folder distance. | hard error (not raised) |
| C001 `unique-ids`         | AC-001..AC-003                     | unique → clean                                                                                                                                                                   | hard error              |
| C003 `verify-with`        | every AC                           | each carries a `Verify with:` line → clean                                                                                                                                       | hard error              |
| C004 `one-strength-word`  | every AC                           | exactly one strength word each → clean                                                                                                                                           | warning                 |
| C008 `sources-named`      | frontmatter                        | names a source → clean                                                                                                                                                           | warning                 |

**Net:** `✓ clean` (exit 0). A genuinely-missing ref (e.g. `../../sources/nope.md`) still fails
C009, as does a ref written as if some root would resolve it (`sources/sup-204.md`).

> Toolable — `suspec check` implements exactly this. Until the tool runs on a given file set,
> reviewers read this table as the checklist.
