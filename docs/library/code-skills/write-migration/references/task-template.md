# Run notes: {{title}}

- Task packet: `tasks/{{TASK-slug}}.md`
- Change plan (waves, baseline, rollback): `change-plans/{{slug}}.md`
- Worktree / branch: {{branch}}
- Created: {{YYYY-MM-DD}} · Status: active

> **Migration task** — move the implementation from API A to API B while the surface callers
> observe holds. Green after every wave; each file migrated individually (no bulk codemods);
> old-API callsites tracked to zero across the whole codebase; every shim carries a removal
> criterion.
>
> **Commands** resolve from the code repo's `AGENTS.md` Commands table; the test and check
> commands run together after every wave. For any command you need that is undefined, ask the
> user — do not guess.
>
> **Behavior changing?** If the new API is *meant* to behave differently, that is a rewrite —
> relabel the task and load that guide.

## Scope (from the task packet)

- From: {{API / framework / version being replaced}}
- To: {{API / framework / version replacing it}}
- Preserve: the ACs the packet lists as held behavior.
- Do not change: {{areas the packet rules out}}; "while I'm migrating" tweaks go to Findings.

## Equivalence check (captured before touching code)

How preservation is proven — the check that would *fail* if behavior changed: differential against
the old path behind a shim, golden-output, or property-based. If the existing suite is the only
check, state why it suffices for this migration.

-

## Callsite tracker

Total old-API callsites at start (grep the *whole* codebase, not just scoped modules): {{count}}

| Wave (from the change plan) | Callsites in scope | Migrated | Remaining |
|---|---|---|---|
| 1 | | | |

> Done only when **Remaining, outside documented shims, is zero** — proven by a pasted search.

## Compatibility shims

Record each shim *before* introducing it. A shim with no removable-when criterion is permanent.

| Shim path | Forwards to | Removable when (verifiable) |
|---|---|---|
| | | e.g. `git grep -c '<old-API>' src/` = 0 |

## Beyond-the-grep audit

The references a text search of the call syntax cannot reach. Audit each; paste the result.

- [ ] Dynamic-dispatch sites (interface impls, virtual methods):
- [ ] String-based references (registry lookups, DI-by-name):
- [ ] Generated code (build outputs, codegen templates):
- [ ] Test fixtures, snapshots, reflection:

## Progress checklist

- [ ] Packet and change plan read; from/to recorded above
- [ ] Equivalence check captured; suite green before any change
- [ ] Old-API callsites counted across the whole codebase; tracker filled
- [ ] Wave 1 executed one file at a time — test + check output pasted
- [ ] Each next wave begun only after the previous wave's checks passed
- [ ] Every shim documented with a verifiable removal criterion
- [ ] Beyond-the-grep audit completed and pasted
- [ ] Old API gone outside tracked shims — final search pasted
- [ ] Findings recorded; self-review answered

## Evidence (paste actual command output — never paraphrase)

- Per-wave test + check output (each wave):
- Final test + check output (last lines + exit):
- Final old-API search showing zero callsites outside documented shims:
- Equivalence check output (or the recorded sufficiency justification):

## Decisions

-

## Findings

Behavior changes the new API tempts, neighboring cleanup, missing tests — candidates for the
workspace's `findings/` at Close.

-

## Blocked questions

-

## Next steps

Most migrations span sessions — leave the next wave's concrete starting point.

-

## Self-review

Answer in writing, evidence pasted. Migrations fail two ways — a wave that left the codebase
half-migrated, and a "completion" that left old-API callsites lurking.

- **Wave integrity:** did every wave end green, outputs pasted per wave — or did checking slip to
  the end?
- **Callsite coverage:** whole codebase grepped, tracker accurate, zero remaining outside
  documented shims — search pasted?
- **Beyond the grep:** dynamic dispatch, string lookups, generated code, fixtures, reflection —
  each audited and pasted?
- **Shims:** every shim carries a verifiable removal criterion; none that should have been removed
  in this migration survives?
- **Preservation:** would the equivalence check fail if behavior changed, and did it pass? Any
  drift recorded as a finding rather than shipped?
- **Scope:** no semantic tweaks rode along; nothing outside the packet's areas; no review result
  issued on your own work.
