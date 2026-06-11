---
name: write-migration
type: agent-guide
description: >-
  Implement a migration or upgrade task: move the code from API A to API B —
  framework/library bump or API replacement — surface preserved, green after
  every wave, old-API callsites grepped to zero. ALWAYS apply when a task
  packet migrates, upgrades, ports, or adopts a breaking change while behavior
  holds. Never bulk-codemod, skip per-wave checks, finish with old-API
  callsites surviving, or leave a shim without a removal criterion. Skip
  same-API refactors, deliberate behavior changes (rewrite), and net-new
  features at the new version.
---

# Implement a migration

A migration moves the implementation from API A to API B — a framework upgrade, a version bump, a
library replacement, an internal API sunset — while the behavior callers observe holds. The
implementation moves; the contract does not. Migrations fail in two ways, both producing a diff
that looks finished: the **permanent half-migration** (some callsites on the old API, some on the
new, indefinitely) and the **phantom completion** (old-API callsites still alive in dynamic
dispatch, registries, or generated code that a text search of the call syntax never reached). This
guide adds the migration discipline on top of the base `implement-task` rules. These are
conventions the review packet inspects — nothing enforces them at edit time.

Plan the transformation first — the workspace's change plan covers baseline, waves, and rollback;
this guide is the execution half. One discipline covers both kinds: an internal API replacement and
a framework/language/library upgrade differ only in trigger, not method. If the new API is _meant_
to behave differently, that is a rewrite — relabel before proceeding.

## Rules

1. **Behavior is preserved — prove it, don't assume it.** Use an equivalence check that would fail
   if behavior changed: differential is the natural fit (keep the old path reachable behind a shim
   and diff old vs new until clean), else golden-output or property-based. A green suite covers
   only what was already tested. If a test fails after a wave, investigate before "fixing" it —
   adapting a test to a new result is how a migration silently becomes a rewrite. If the suite is
   the only oracle, record why it suffices for this migration.
2. **Execute wave by wave; the codebase is green after every wave.** A wave is the smallest atomic
   change that leaves the code compiling and passing checks. Run the test and check commands at the
   end of each wave and paste both before starting the next — per-wave checks localize a break to
   the wave that introduced it; final-only checking lets the breakage tangle into the permanent
   half-migration.
3. **Each file migrated individually — no bulk codemods.** No `sed`, codemod, or shell loop across
   hundreds of files in one commit: the fixed substitution silently breaks the one callsite using
   the API in an unusual way, and the green-looking global edit is exactly the misleading signal to
   distrust. Read, migrate, and check each file deliberately.
4. **Track callsites to zero, across the whole codebase.** Count old-API callsites up front; track
   per wave how many moved and how many remain. Done means **zero old-API callsites outside
   explicitly tracked shims**, counted over the whole codebase, not just the modules the work was
   scoped to — and proven by a pasted search, not asserted. "Mostly gone" is unfinished.
5. **Search beyond the call syntax.** After the grep, audit explicitly and paste the results:
   dynamic-dispatch sites, string-based references (registry lookups, DI-by-name), generated code,
   test fixtures and snapshots, reflection. The phantom completion lives precisely where a text
   search of the call syntax cannot see.
6. **Every shim gets a verifiable removal criterion before it is introduced**: path, forward
   target, and a mechanically checkable removable-when condition (e.g.
   `git grep -c '<old-API>' src/` returns 0). Without one, "temporary" means forever.
7. **No semantic improvements ride along.** "While I'm migrating" tweaks destroy the work's
   reviewability as a mechanical change — note them as finding candidates.
8. **Paste real output; resolve commands from `AGENTS.md`; ask when one is undefined.** And never
   write a review result on your own work.

## Refuses

| Temptation                                                    | Do instead                                                         |
| ------------------------------------------------------------- | ------------------------------------------------------------------ |
| "I'll sed this across all 200 files in one step"              | One file at a time; the sweep buries the outlier                   |
| "Wave checks are optional; it's all the same change"          | Check after every wave; paste the output                           |
| "The shim is temporary, no need to document removal"          | Path + forward target + removable-when check, or no shim           |
| "Old API is mostly gone; I'll handle the rest in a follow-up" | Enumerate and convert the rest, or track each exception explicitly |
| "Behavior drifted slightly but the tests still pass"          | Surface it; a migration moves surface, not semantics               |
| "No remaining callers" with no pasted search                  | Grep source, tests, and the string form; paste it                  |
| "I'll improve the API's behavior while I'm in here"           | Finding candidate; a behavior change is a different task           |
| Adapting a failing test to the new API's output               | Investigate first — that is a behavior change in disguise          |

## Self-review gate

Before declaring the task done:

- [ ] Every wave ended green — test + check output pasted per wave, not only at the end.
- [ ] The callsite count is proven zero outside tracked shims by a pasted whole-codebase search.
- [ ] The beyond-the-grep audit (dynamic dispatch, string references, generated code, fixtures,
      reflection) is done and pasted.
- [ ] Every shim has a documented, verifiable removal criterion — and none that should have been
      removed in _this_ migration survives.
- [ ] The equivalence check (or recorded sufficient-oracle justification) is pasted; behavior held.
- [ ] No half-migrated files, TODOs, or stub-shimmed modules left behind; ride-along discoveries
      are finding candidates.
- [ ] You issued no review result on your own work.

## Bundled resources

- `references/task-template.md` — a working-notes scaffold for the run (callsite tracker, shim
  table, per-wave evidence slots, beyond-the-grep audit, self-review). The task packet itself uses
  the kit's task template; the wave plan itself lives in the change plan.
