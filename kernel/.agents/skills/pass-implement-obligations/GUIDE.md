---
type: pass-guide
name: pass-implement-obligations
pass: implement
activates_for_task_kind:
  - feature
  - fix
  - refactor
  - rewrite
  - migration
  - upgrade
  - performance
  - testing
  - documentation
description: >-
  How to run an `implement` pass: produce the change for the assigned
  obligations only, record TRACE claims, and gather pasted proof. Load this
  guide when a `task.md` names `pass: implement` and one of the nine
  implementation `task_kind`s. The procedure branches by `task_kind`; load only
  the section matching the task's kind. This guide describes HOW to run the
  pass; it never defines what a verdict, modality, or proof means — those live
  in the SOL/IR language references.
---

# Pass guide: implement (obligations)

## Purpose

Produce the change for **the assigned obligations only**, record what was
changed as `TRACE` claims, and gather re-runnable proof — so the downstream
`verify` and `review` passes have evidence to judge. This is the most-run pass
of the nine (`author → lint → improve → lower → decompose → implement → verify
→ review → promote`), and the one whose carrier profile is selected **by task
kind** rather than fixed (docs/passes/implement.md; spec §9.3, §9.4).

This guide is SOFT control (Invariant 2). It tells you *how* to run the pass; it
does **not** define modality, authority order, verification semantics, the
verdict values, the proof taxonomy, or any other load-bearing meaning. Those are
owned only by SOL and the IR. Where this guide and the spec disagree, the spec
governs.

## Consumes

- One `task.md` — the lowered work packet for this single pass (spec §21.3).
  `implement` works against the packet `decompose` handed it, **not** the surface
  spec or the IR (spec §9.3.1). You read, in particular:
  - the `task_kind` frontmatter enum — it selects which section of this guide
    and which carrier profile apply (spec §28);
  - `assigned_obligations`, `constraints`, `invariants`, `interfaces` — the SOL
    blocks pasted verbatim in the body, which fix scope;
  - `write_surfaces` — your **owned paths**, the only files you may touch;
  - `verification_bindings` — the proofs each obligation demands.
- Optionally, a heuristic profile the task names (spec §26.4) — for this pass,
  one of the six by-kind carriers: Janitor, Migrator, Performance-Surgeon,
  Builder, Test-Author, Documentarian (docs/passes/implement.md; spec §27.3). A
  profile sharpens *what you look for and refuse*; it never changes the
  procedure or decides a verdict.
- Project command slots resolved via the consuming repo's `AGENTS.md`
  (`cmdTest`, `cmdValidate`, `cmdBenchmark`, `cmdFormat`, etc.). If `AGENTS.md`
  is missing or a slot is undefined, ask the user which command to run before
  proceeding — do not guess.

## Produces

- Code, docs, and/or test changes within the declared write surfaces.
- A `trace.md` (`*.swarm.trace.md` when emitted under `generated/`) recording
  the `TRACE` claims against obligations and binding them to evidence (spec
  §21.4). Its `## Provenance` section carries the per-binding §16 / G11 fields
  the staleness join depends on.

The `task.md` body sections you fill as you work: `## Implementation or pass
trace`, `## Verification matrix`, `## Promotion queue`, `## Self-review` (spec
§21.3).

## Preserves

- **Only the assigned obligations.** Any change not traceable to an assigned
  obligation becomes an `## Unassigned changes` row in the trace (with a reason
  + authorizing ID, or `none`), to be judged at `review` (spec §9.3, §21.4).
- **Only the declared write surfaces.** Owned paths MUST stay a subset of the
  union of the assigned obligations' `WRITES` surfaces — the **§11.3 owned-path
  rule** (G7, **R-OWNED-SUBSET**). A path that touches a file outside any
  assigned obligation's declared write surface is lint code **`SOL-O005`**
  ("owned path outside declared write surface"). This is the property that keeps
  parallel `implement` packets write-disjoint (spec §11.3, §18).

  ```text
  AC-001 WRITES src/auth/**
  task-packet owns: src/auth/session.ts    -> OK (subset)
  task-packet owns: src/billing/charge.ts  -> SOL-O005 (outside declared WRITES)
  ```

- **Intent.** Constraints, invariants, and non-goals are preserved, not
  relaxed. Changing an obligation's intent is an amendment decision at `improve`
  (spec §10 R-IMPROVE), never an `implement` action.
- **Drift provenance.** Record the §16 fields per binding so a later PASS can
  flip to `STALE` when source or a surface drifts.

## Rejects

- A `task.md` whose COVERAGE gate is unsatisfied. `implement` is gated at the
  `LOWER → EXECUTE` boundary: every lowered obligation node MUST be covered by
  exactly one `implement` packet (uncovered = `SOL-O007`; double-owned =
  `SOL-O008`), and every TRACE/`verified_by` target MUST resolve to a real node
  in `nodes[]` (unbound = `SOL-M003`) (spec §11.6.2). This is a contract
  checkable by review today, not enforced by shipped tooling.
- A completion claim with no re-runnable proof. A `PROOF` line MUST reference
  **real output**; an unqualified "tests passed" is not admissible (spec §15,
  §17). A schema-valid trace shape is not a proof.
- An `IMPLEMENTS` claim with zero `PROOF` lines — the trace grammar makes
  `PROOF` mandatory, so a no-`PROOF` trace is a structural parse error
  (`SOL-S014`), not a soft lint (spec §21.4).
- Scope creep: a fix that bundles unrelated cleanup, a refactor that changes
  behavior, a feature implemented past the spec. Out-of-scope findings are
  **promoted** (see `## Promotion queue`), not silently fixed.

## Procedure

The pass has a common spine and a `task_kind`-specific middle. Run the spine for
every kind; run **only** the one branch matching the task's `task_kind`.

### Spine (every kind)

1. **Read the packet, not the spec.** Read the full `task.md`: parent contract,
   scope (In/Out), the assigned obligations pasted verbatim, the constraints and
   invariants to preserve. Resolve project commands from `AGENTS.md`; ask if any
   slot is undefined.
2. **Confirm the owned paths.** Verify `write_surfaces` is a subset of the
   assigned obligations' `WRITES` surfaces (§11.3). If you need to touch a file
   outside it, stop — that is `SOL-O005`; either the file belongs to another
   packet, or the obligation's write surface needs amending upstream.
3. **Halt on ambiguity.** If an assigned obligation is unclear or contradictory,
   stop and surface it — do not invent the requirement. Resolving an ambiguity
   silently is an amendment you are not authorized to make at `implement`.
4. **Do the kind-specific work** (the branch below). Run the project's
   validation command after each batch of changes, not only at the end; paste
   the output as you go.
5. **Write the TRACE claims.** For each assigned obligation, emit a `TRACE`
   block: `IMPLEMENTS` the `REQ` ids satisfied; `PRESERVES` the
   `CONSTRAINT`/`INVARIANT` ids held; `CHANGED` the modified surfaces; and at
   least one `PROOF` line naming a verification reference plus its observed
   `proof_result` (`passed | failed | blocked | unverified`). Paste the proof
   output verbatim — last lines in a fenced block, unmodified. (`proof_result`
   is the *observed run outcome*; the uppercase verdict it maps to is decided
   downstream at `verify`/`review`, not here — see Output contract.)
6. **Record provenance.** Fill the `## Provenance` fields per binding (spec
   §16.1 / G11): `source_hash`, `per_surface_hash[]`, `adapter`, `verdict`,
   `tier`, `origin_obligations[]`, `origin_traces[]`.
7. **Resolve the promotion queue.** Every discovery outside scope gets a
   `## Promotion queue` / `## Promotion items` row with a target + status. All
   MUST be resolved before the task closes (spec §21.3, §23).
8. **Self-review** (see `## Self-review delta`).

### Branch: `feature`

Carrier: **Builder**. (Source: write-feature.)

1. Read the spec/obligations in full and map **every acceptance criterion to an
   implementation step before coding**.
2. Survey existing patterns before introducing a new helper, type, or pattern —
   reuse over reinvention; if existing patterns don't fit, say so with reasoning
   in the trace.
3. No opportunistic refactoring — promote architectural debt you spot, don't fix
   it inline.
4. Tests are part of the deliverable: every acceptance criterion has a
   corresponding test (or a noted `testing` follow-up task).
5. Honour each criterion's check binding: for every criterion list the check the
   spec named (`test` / `command` / `manual`) and the pasted result. A
   `test`-bound criterion is covered only when its oracle is shown valid (fails
   when the criterion is violated, passes when satisfied — prove it by flipping
   the assertion). A green toolchain suite is not coverage.

### Branch: `fix`

Carrier: **Builder**; the **Skeptic** profile is the natural sharpener.
(Source: write-fix.)

1. **Reproduce in your worktree before patching.** Re-run the bug report's
   reproduction; confirm the bug fires; paste the output. If you can't
   reproduce, do not patch — investigate the environment discrepancy first.
2. Patch the **root cause**, not the symptom (the bug report cites it at
   `file:line`).
3. **Regression test fires before the fix and passes after:** patch out the fix
   → test fails (proves it exercises the bug); restore the fix → test passes.
   Paste both transitions.
4. No scope creep — neighbouring bugs are promoted to follow-up bug-reports or
   audits, not bundled.
5. Run the full test suite after the patch; paste the output.

> For a **flaky / non-deterministic** test, also apply the `fix-flaky-test`
> branch below — a flake is a `fix` whose oracle is a loop-run.

### Branch: `fix` — flaky test

Carrier: **Builder**; **Skeptic** sharpens. (Source: fix-flaky-test.)

1. **Reproduce the flake before claiming you understand it.** Loop the test
   (typically 100×, often 500×–1000× for low-frequency flakes) until it fires.
   A flake that won't reproduce is *un-isolated*, not *unreal* — broaden
   conditions (CI, load, seed, parallel siblings). Ask the user how the project
   loops a single test; do not guess the loop-runner.
2. **Categorise the source** (timing/ordering, shared state, network/external,
   randomness, time, resource exhaustion, environment). Record the category;
   split mixed-category flakes into separate fixes.
3. Find the root cause in production code or test setup, **not in the
   assertion**. Modifying the assertion to accommodate nondeterminism hides the
   bug.
4. Reject "add a sleep" / "increase the timeout" as the fix unless timing is a
   documented contract. Reject quarantine (`.skip`, `.fail`, `it.if`) as the
   resolution.
5. **Verify by loop-running 100×–1000×** under the conditions in which the flake
   reproduced, all passing; paste the output.
6. Document the cause inline (a one-liner in the test or production code). If the
   root cause is in production code, hand off a downstream production fix; this
   work produces the diagnosis and the now-stable test.

### Branch: `refactor`

Carrier: **Janitor**. (Source: write-refactor.)

1. **Behaviour preservation is non-negotiable** — proven by an *equivalence
   check that would fail if behaviour changed*, not merely a green suite. Pick
   the strongest available: property-based, differential (keep the pre-refactor
   path reachable behind a shim until the diff is clean), or golden-output. If
   none is available, record explicitly in self-review *why* the existing suite
   is a sufficient oracle for this change (e.g. exhaustive named-test coverage,
   shown).
2. Each file modified individually — no bulk codemods, no `sed` over hundreds of
   files in one commit.
3. **Document every shim:** path, forward target, and a verifiable
   removable-when criterion (e.g. `git grep -c '<old-API>' src/` returns 0). A
   shim without a removal criterion is permanent debt.
4. **Prove deletion safety:** for every deleted symbol, `git grep -n '<symbol>'
   src/ tests/` shows zero callers; check dynamic-dispatch / string-form lookups
   separately. Paste the grep output.
5. Run the project's architectural/dependency-validation command at the audit's
   chosen checkpoint frequency (e.g. every 10 files), not only at the end.
6. Promote out-of-scope findings to the audit.

### Branch: `rewrite`

Carrier: **Builder**. (Source: write-rewrite.)

1. **Make the behaviour delta explicit before coding** — a before/after table of
   every aspect that changes. Anything not in the delta MUST be preserved; the
   table is the contract.
2. Acceptance criteria cover both the *new* behaviour (the delta) and the
   *preserved* behaviour (the non-delta, explicitly stated).
3. Verify the two surfaces differently: the **delta** gets acceptance-criteria
   coverage per its check binding (assertion-flip proof for `test`-bound
   criteria); the **non-delta** gets a behaviour-preservation equivalence check
   that would fail if anything outside the delta changed.
4. Identify all affected callers for each changed behaviour; update each, or
   verify it still works under the preserved behaviour.
5. **Halt and amend on emergent changes:** if you find a behaviour change *not*
   in the delta, stop and amend the spec to authorize it (or revise to keep the
   original) — never ship a silent emergent change.

### Branch: `migration` / `upgrade`

Carrier: **Migrator**. (Source: write-migration.)

1. **Surface-level behaviour is preserved** — the implementation moves from API
   A to API B, the contract does not — proven by an equivalence check that would
   fail if behaviour changed (property-based / differential / golden-output;
   differential is the natural fit behind a migration shim). Record the
   sufficient-oracle reason if no stronger check exists.
2. **Plan in waves.** A wave is the smallest atomic change that leaves the
   codebase compiling and passing tests. Document the waves up front.
3. Validate (test + project validation) after **every wave** — never let two
   waves' breakage accumulate.
4. Each file migrated individually — no bulk codemods.
5. **Track callsite coverage explicitly:** count old-API callsites up front;
   track migrated vs remaining per wave; done only when remaining (outside
   tracked shims) is zero — across the *whole codebase*, not just the scoped
   modules.
6. **Document every shim** (path, forward target, verifiable removable-when
   criterion).
7. **Search beyond grep:** audit dynamic-dispatch sites, string-based references,
   generated code, and test fixtures/snapshots; paste the audit results.
8. Promote out-of-scope behavioural changes to an audit.

### Branch: `performance`

Carrier: **Performance-Surgeon**. (Source: write-performance.)

1. **Measure first** — establish a baseline benchmark in your worktree before
   changing code. Without a baseline, "improvement" has no meaning. Ask the user
   for the benchmark command if no slot is defined; record it in the measurement
   protocol.
2. State the **target as a number under conditions** (e.g. "p95 of `getQuote()`
   under 1k RPS sustained: 240 ms → ≤ 80 ms"), and the **hypothesis as a
   falsifiable claim** (what measurement would disprove it).
3. **Same protocol before and after** — identical warmup, sample count,
   aggregate (mean/median/p95/p99), hardware, environment. Different conditions
   make the comparison meaningless.
4. **Benchmark every change** individually (change → re-run → compare); don't
   batch optimisations.
5. Run the **full test suite after every change** — a speedup that broke
   correctness is a bug in performance clothing.
6. Document the conditions the speedup holds under; if readability suffered,
   justify the tradeoff and comment the call site. Define a **hard ceiling**
   (the regression threshold below which the change is rolled back).

### Branch: `testing`

Carrier: **Test-Author**. (Source: write-testing.)

1. **Test behaviour, not implementation** — exercise the public surface; do not
   reach into private methods or internal state.
2. **One test, one reason to fail** — split bundled unrelated assertions.
3. **Flip the assertion** (or comment out the production path) after writing each
   test → it must fail; restore → it must pass. Paste a representative
   failing-then-passing transition. A test that passes when flipped tests
   nothing.
4. For a test that is the oracle of a `test`-bound acceptance criterion, prove
   *two separate things*: the flip proves the test fires; the criterion mapping
   proves it fires for the right reason (it asserts the behaviour the criterion
   describes, in the criterion's own terms). If you cannot construct a test that
   fails when the *criterion* is violated, that is a finding for the spec author
   (the binding should be `command`/`manual`), not licence to ship a passing
   tautology.
5. Place tests per project convention; keep tests deterministic; make failure
   messages useful. Do not modify production code to make tests easier unless the
   spec authorizes it (otherwise promote the testability concern).

### Branch: `documentation`

Carrier: **Documentarian**. (Source: write-documentation.) `documentation` is
an `implement` kind — it changes a surface (docs) and is traced and verified
like any other change (spec §28.2).

1. Lead with what the reader needs to do; the first ~100 words contain the
   action.
2. **Pick one Diátaxis frame and do not mix** (tutorial / how-to / reference /
   explanation). If you switch modes mid-doc, split it.
3. **Every code example runs as written** — run it, capture the output, confirm
   it is self-contained. An unrun example is a hypothesis, not an example.
4. **Every behaviour claim cites `file:line`** and is cross-referenced against
   the code.
5. No hedging ("should" / "might" / "could") — state the behaviour, or state the
   condition under which it holds.
6. Update existing docs when their world changes; grep for related docs that may
   now contradict the change and reconcile them. Run the project's format /
   doc-lint command before close.

## Output contract

The `trace.md` and the filled `task.md` together satisfy the spec contracts;
this guide does not redefine them.

- The `trace.md` MUST carry: frontmatter (`type: trace`, `id`, `source_task`,
  `source_spec`, `created`); `## Claimed implementation` (the `TRACE` blocks);
  `## Provenance` (the seven per-binding §16.1 / G11 fields); `## Verification
  matrix` (ID → required proof → actual proof → status); `## Unassigned
  changes` (each with reason + authorizing ID, or `none`); `## Promotion items`
  (target + status) (spec §21.4).
- Each `TRACE` that claims `IMPLEMENTS` MUST carry at least one `PROOF` line; a
  no-`PROOF` trace is `SOL-S014`. An `IMPLEMENTS`/`PRESERVES` naming an unknown
  obligation is `SOL-M003` (spec §21.4).
- The observed `proof_result` maps **1:1** to the downstream core verdict
  value: `passed → PASS`, `failed → FAIL`, `blocked → BLOCKED`, `unverified →
  UNVERIFIED`. **`implement` only ever records this core observation.** The
  verdict has 7 values total — 4 core plus the 3 lifecycle decorators
  (`WAIVED` / `STALE` / `CONTRADICTED`) — but the lifecycle decorators are
  applied later at `review`, and the PASS decision is made by the
  profile-independent `verify` pass, never here (spec §14, §9.3.1). A profile may
  influence which proofs are *demanded*; it never decides whether a run PASSes.

## Self-review delta

Before closing, confirm — and where a check applies, paste the evidence into the
`task.md` `## Self-review` block:

- **Did I do only this pass?** Every change is traceable to an assigned
  obligation, or it is an `## Unassigned changes` row with a reason + authorizing
  ID or `none`.
- **Did I stay inside the owned paths?** No file outside the union of assigned
  `WRITES` surfaces was touched (§11.3 / no `SOL-O005`).
- **Did I preserve semantics?** Constraints, invariants, and non-goals are held,
  not weakened (the kind-specific equivalence/preservation evidence is pasted
  where the branch demanded it).
- **Does every claim map to evidence?** Every `IMPLEMENTS` claim has at least one
  `PROOF` line referencing real, re-runnable output (no "tests passed" without
  output; no schema-valid-shape-as-proof).
- **Are all promotion items resolved?** No discovery is left unpromoted.

When a profile is active (e.g. Skeptic on a `fix`), also run that profile's own
`## Self-review delta` — it adds checks, it does not replace these.
