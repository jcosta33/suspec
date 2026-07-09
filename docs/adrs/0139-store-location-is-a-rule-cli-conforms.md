---
type: adr
id: adr-0139
status: accepted
created: 2026-07-09
updated: 2026-07-09
---

# ADR-0139 — The store location is a deterministic rule; the CLI conforms to it, it does not own it

## Context

[ADR-0137](./0137-personal-harness-transient-artifacts.md) put per-change artifacts in a per-repo
store outside the repo, and [ADR-0134](./0134-self-contained-spine.md) Decision 3 made every
canonical step keep a by-hand path that needs none of {CLI, MCP, skills, agent catalog}. Those two
decisions have a consequence that was not made explicit and got violated in the implementation: if
an actor cannot find the store **without the CLI**, the CLI is no longer an optional accelerator —
it is load-bearing, and the by-hand spine is broken.

The shipped implementation ([SPEC-suspec-v2](../../../corpus-works/specs/suspec-v2/spec.md) AC-001,
`corpus-cli` `resolveStoreDir.ts`) keyed the store on `basename(repo)`. Because basenames collide
(`corpus`, `corpus-works`, and every `*-works` sibling on one machine), it needed a `-2`/`-3`
suffix arbitrated by a `.repo-path` marker and an atomic-claim race. That arbitration is **not
reproducible by hand or by a self-started agent** — it requires reading marker files and winning a
write race. So the store location silently became a thing only the CLI could compute, and:

- A self-started agent (no launch prompt, no CLI call) following the skills' "without the CLI"
  fallback misresolves in two real cases — inside a `.worktrees/<slug>` checkout (keys on the
  worktree name) and on a basename collision (no marker scan → writes into another repo's store, or
  finds nothing) — with **no error at any point** (`findStoreSpec`/`listEvidenceRecords` ingest by
  filename with zero ownership check).
- ADR-0137 Decision 2's prose — "beside the agent's own scaffold", citing `~/.codex` as a co-equal
  precedent — reads as *per-runner* placement. A self-started Codex agent deriving the store from
  that prose lands in `~/.codex/state/<repo>`, a directory the CLI never resolves to. Two disjoint
  stores, no shared marker, no error.

The root fault is a **bad key that forced CLI-ownership of the location**, and an authority arrow
pointing the wrong way: the CLI computing the truth and everyone else querying it, rather than a
rule any actor computes and the CLI conforming to it.

## Decision

1. **The store location is a rule, not a service.** It is a deterministic function of
   `(repo, env, config)` alone — never of which runner executes or which document the reader
   consulted. The rule is stated in canon and in the methodology skills, and a human, any agent
   (any runner), and the CLI all compute the same path from it. _Level: convention._

2. **The key is the repo's absolute path, not its basename.** Absolute paths are unique, so the
   collision-suffix, the `.repo-path` marker, and the atomic-claim race are all **retired** — there
   is nothing to arbitrate. The store dir name is an **injective, hand-followable encoding** of the
   repo's absolute path (so two different repos can never collide, and no lookup is needed to tell
   which store belongs to which repo). Worktrees key on the **main** repo root — from a
   `.worktrees/<slug>` checkout that is the parent of `git rev-parse --git-common-dir`, a
   documentable git command, not internal magic. _Level: toolable._

   > The exact encoding (a literal escaped-dash mirror of the absolute path, matching the
   > `~/.claude/projects/-Users-name-dir` convention — escape `-`→`--` then `/`→`-` so the
   > transform stays injective; versus a readable `<basename>-<short-hash-of-abs-path>` slug that is
   > compact but not head-computable) is an **open encoding sub-choice** deferred to the owner and
   > recorded in the SPEC-suspec-v2 AC-001 amendment; either satisfies this decision. The
   > escaped-dash mirror is recommended for zero-tooling hand-followability.

3. **The state-root is vendor-neutral.** The default store root is not named after any one runner.
   It is overridable via `SUSPEC_STATE_DIR` (env) and `state_root` (`suspec.config.json`) as before;
   only the built-in default changes from `~/.claude/state` to a neutral home (recorded in the
   AC-001 amendment). _Level: convention._

4. **The CLI conforms and anticipates; it never owns.** `resolve_store_dir` computes the *same*
   rule every other actor computes — it is not a privileged authority. Being tooling, it adds
   robustness the rule alone can't: it reroots worktrees, and it **anticipates near-miss locations**
   (a naive `basename` dir, a legacy `~/.claude/state` dir, a worktree-keyed dir a lazy agent wrote)
   and reconciles or migrates them, surfacing what it did. This is additive — the CLI is still an
   optional accelerator ([ADR-0134](./0134-self-contained-spine.md) D3), now honestly so, because
   the by-hand actor computes the identical path unaided. _Level: toolable._

5. **The skills state the rule, not a deferral to the CLI.** A methodology skill tells a
   self-started agent the location *rule* directly (the encoding + the main-repo-root refooting +
   the neutral default), so it can write correctly with no CLI. `suspec store path` remains a
   convenience that prints the resolved dir; it is not a precondition for finding the store.
   _Level: convention._

## Superseded and narrowed decisions

- **Narrows [ADR-0137](./0137-personal-harness-transient-artifacts.md) Decision 2.** "Beside the
  agent's own scaffold" is re-read as a *placement heuristic* (user-level, discoverable, encoded the
  same way the agent scaffold at `~/.claude/projects` already encodes repo dirs), **not** a
  per-runner ownership claim. The store is one-per-repo, runner-independent; the basename key,
  suffix, and `.repo-path` marker in that decision's shipped mechanics are retired.
- **Supersedes the resolution mechanics of [SPEC-suspec-v2](../../../corpus-works/specs/suspec-v2/spec.md)
  AC-001** (basename + `-2`/`-3` suffix + marker) — re-keyed onto the absolute path by an AC-001
  amendment; the env/config override precedence and the "distinct repos resolve to distinct stores,
  stable across calls" invariant stand (now satisfied structurally, not by arbitration).
- **Restores [ADR-0134](./0134-self-contained-spine.md) Decision 3** for the store: the by-hand path
  is honest again because the location rule is hand-computable end to end.

## Alternatives considered

| Alternative | Why rejected |
|---|---|
| Keep basename keying, make the CLI the sole authority for the location (query via `suspec store path`) | Makes the CLI load-bearing — you cannot find your own artifacts without it — directly violating ADR-0134 D3. The collision arbitration is the *symptom*; CLI-ownership was treating the symptom. |
| Keep basename + suffix, fix only the skills' wording | The suffix arbitration is unreproducible by hand at all; no wording makes a self-started agent able to compute the `-2`/`-3` a race decided. The key itself has to change. |
| Build real per-runner store branching (make ADR-0137's prose literally true) | Breaks every cross-runner handoff by construction — a spec authored in a Claude session must be found by a `done` run from a Codex-driven CLI. The CLI already points a launched Codex at the shared store (`runnerAdapters.ts`), treating runner and store as orthogonal; per-runner keying would break that deliberately. |
| Hash-only key (`sha256(abs path)`) | Unique and injective, but opaque — a human can't eyeball which store is which, and it's not head-computable. Fails the hand-followability goal that motivates the whole change. |

## Consequences

- Positive: the by-hand spine is genuinely restored — any actor computes the store location
  unaided; the suffix/marker/race subsystem is deleted (less code, no race); silent commingling on
  basename collision is structurally impossible; the store is runner-agnostic and vendor-neutral;
  the CLI becomes a conforming-and-forgiving participant, not an authority.
- Negative: a re-key migration — existing `~/.claude/state/<basename>` stores must be reconciled to
  the new location (the CLI's anticipate/migrate path, Decision 4, does this); every doc/skill that
  named the old key or default is a coordinated edit; deeper store dir names (the abs-path mirror)
  are less pretty than a bare basename.
- Neutral: the encoding sub-choice (Decision 2 note) stays open for the owner; the architecture
  holds either way.

## Status

Accepted (2026-07-09). Narrows [ADR-0137](./0137-personal-harness-transient-artifacts.md) D2;
supersedes the AC-001 resolution mechanics; restores [ADR-0134](./0134-self-contained-spine.md) D3;
upholds [ADR-0121](./0121-evidence-gating-load-bearing-mechanic.md) (the capture ledger is a pure
function of the resolved store dir — re-keying moves it coherently, no new integrity gap).

## Propagation

- `docs/adrs/README.md` — ledger row; narrow-note on ADR-0137's row.
- SPEC-suspec-v2 AC-001 — amendment: re-key to the absolute path, name the neutral default, record
  the open encoding sub-choice.
- corpus-cli: re-key `resolveStoreDir.ts` (delete suffix/marker/race; abs-path encoding;
  vendor-neutral default), add the anticipate/migrate path, update the ledger path derivation and
  all tests; the skills' rule statement in corpus-skills; the doc ripple in `cli.md`,
  `03-where-files-live.md`, `artifact-formats.md`, both `AGENTS.md` bootloaders.
