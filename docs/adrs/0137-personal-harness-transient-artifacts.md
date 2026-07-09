---
type: adr
id: adr-0137
status: accepted
created: 2026-07-09
updated: 2026-07-09
---

# ADR-0137 — Suspec is a personal harness: transient artifacts, repo-root execution, durability by promotion

## Context

Suspec has been positioned as a team-facing spec-and-review discipline with a durable home of its
own: a committed workspace ([ADR-0060](./0060-suspec-workspace.md)), optionally a dedicated works
repo governing several code repos ([ADR-0073](./0073-multi-repo-workspace.md),
[ADR-0074](./0074-repo-family-split.md)), a hand-edited `status.md` board, and a gitignored
`.suspec/` state dir inside code repos ([ADR-0062](./0062-code-repo-adapter.md),
[ADR-0100](./0100-spec-external-ops-local-mode.md)). [ADR-0104](./0104-ephemeral-by-default.md)
already pulled the flow artifacts out of git; the durable set (spec, findings, decisions, board)
stayed committed.

Four evidence lines broke that model:

1. **Agent discovery is repo-rooted.** Skills and instructions load from the launched process's
   repo root and the user level — never across repos. A workspace repo that governs code repos
   cannot deliver methodology into them; every bridge tried (couriers, materialization, outboxes)
   was ceremony. Subagents inherit the parent's root and reach user-level skills; they do not
   cross-load another repo's.
2. **Industry practice keeps run/session state user-level** (`~/.claude/projects`, `~/.claude/plans`,
   `~/.codex`) **and durable records in the layers that already own them** — code, tests, ADRs,
   issues, PRs, contract repos. No major workflow commits per-change agent artifacts as a system
   of record.
3. **A placement decision-trial and a 20-aspect DX simulation** scored the user-level store above
   gitignored-in-repo and committed alternatives, and root-caused artifact rot as a lifecycle-design
   failure: no death owner, no consumption pressure, creation cheaper than disposal.
4. **The owner repositioned the product.** Suspec is a personal methodology harness: it helps one
   developer produce better code faster with agents. Its artifacts are relevant to *you*, not to
   your team. Durable value for others is what gets promoted into the shared record.

## Decision

1. **Suspec owns no record.** The artifacts — intake, spec, run, review, finding — are the agent's
   typed working memory: markdown + frontmatter, linted by the deterministic checks contract,
   transient, and **never committed to any repo**. The committed workspace, the dedicated works
   repo as reference model, and the board are retired. _Level: convention._

2. **The store.** Artifacts live beside the agent's own scaffold, outside every repo: default
   `~/.claude/state/<repo-name>/` (a sibling of the agent's `plans/`), root configurable. Flat
   artifact files plus a single `archive/` subfolder; a repo-name collision gets a directory
   suffix. Agents read and write the store **directly via absolute paths given in the launch
   prompt** — no materialization step, no outbox, no in-worktree copies. A sandbox-restricted
   runner (e.g. Codex `workspace-write`) is the adapter's problem — its writable-roots
   configuration — never architecture. _Level: toolable (`suspec store`)._

3. **Durability only by promotion.** Decisions → ADRs (which predate AI and will outlast it).
   Behavior → tests. Findings → GitHub issues (`suspec promote`). The evidence digest → a living
   PR comment (`suspec done`). Cross-repo contracts → their own repos (the Stripe/Google/Azure
   pattern). The store is disposable *because* the durable residue has already left it; promotion
   is mechanical, not discipline. _Level: toolable._

4. **Repo-root execution.** An implementing agent always launches as a fresh process rooted in the
   target repo's worktree (`.worktrees/`, never wiped while dirty). The prompt is a pointer: the
   store spec and run file by absolute path, nothing summarized. _Level: convention._

5. **The methodology is a globally installed skill family.** Universal Suspec skills install at
   `~/.claude/skills` + `~/.agents/skills`; repo-specific guides stay committed in their repo; the
   two tiers never overlap — that kills guide-version skew structurally
   (sharpens [ADR-0111](./0111-kit-skill-scope.md)/[ADR-0112](./0112-two-tier-skills.md)).
   _Level: convention._

6. **Anti-rot is structural, not janitorial.** Terminal states are **derived from git/GitHub
   truth** — branch merged, worktree gone, PR closed ⇒ auto-archive; `store doctor` is a
   reconciler, never a judge. Findings are triaged inside `done` (promote / keep-with-expiry /
   discard-by-default; a critical finding is never silently deleted). Staleness is checked at
   read time (spec base-SHA vs affected areas at launch; evidence touched-files hash at `done` —
   the shipped staleness/digest machinery re-aimed at the store). Only the driving spec auto-loads
   into agent context. Provenance classes dev / agent / cli-verified, with agent-authored content
   quarantined; a WIP cap bounds active specs. _Level: toolable._

7. **Naming.** No directory is named after the tool — a folder of React components is not named
   `react/`; Suspec is the framework, it merely invents the scaffold. Sole exception:
   `suspec.config.json` at the repo root, a tool's own config file (the `.eslintrc` case). The
   in-repo `.suspec/` directory is retired. _Level: convention._

## Superseded and narrowed decisions

**Superseded** (decision premised on the committed workspace / works repo / board / committed
artifacts): [ADR-0049](./0049-minimal-install-no-mount-no-imposed-workspace.md) (its in-repo
`.agents/` workspace half; the install-next-to-your-skills principle survives, re-aimed at the
global tier by Decision 5), [ADR-0050](./0050-suspec-is-a-spec-repo-discipline.md),
[ADR-0051](./0051-complete-the-spec-repo-pivot.md), [ADR-0052](./0052-per-feature-spec-folders.md),
[ADR-0060](./0060-suspec-workspace.md), [ADR-0067](./0067-memory-tiering.md),
[ADR-0069](./0069-workspace-shaped-starter-kit.md), [ADR-0073](./0073-multi-repo-workspace.md),
[ADR-0074](./0074-repo-family-split.md), [ADR-0075](./0075-starter-kit-template-repo.md)
(the copy-a-whole-workspace face; the kit repo survives as a thin repo-seed),
[ADR-0100](./0100-spec-external-ops-local-mode.md),
[ADR-0104](./0104-ephemeral-by-default.md) (extended to its logical end: the "durable committed
set" — spec, findings, board — becomes transient too; only promoted residue is durable).

**Narrowed** (core survives; the workspace-premised mechanics are retired):
- [ADR-0062](./0062-code-repo-adapter.md) — "adopting never dirties a product repo" stands;
  the gitignored `.suspec/` state dir is retired in favor of the store + `suspec.config.json`.
- [ADR-0084](./0084-boundary-safe-prepare-verbs.md) — prepare verbs (`pull`, `promote`) stand,
  re-aimed at the store and GitHub; the board-write prohibition is moot (no board).
- [ADR-0103](./0103-spec-as-living-form-task-on-demand.md) — the spec as the unit of work with an
  append-only `## Execution`, task only as split slice: stands verbatim; the living form now lives
  in the store.
- [ADR-0116](./0116-shipped-spec-invariant.md) — spec-status ↔ `## Execution` coherence stands;
  the board-signal half is retired.
- [ADR-0077](./0077-suspec-cli-reconcile-only-harness.md) — reconcile-only, markdown-only,
  verdict-free: stands; `.suspec/config.yaml` and the board read-model are retired
  (config = `suspec.config.json`, state = the store).
- [ADR-0096](./0096-artifact-lifecycle.md) — supersede/status semantics stand; the committed
  retention/git-archive lifecycle is replaced by Decision 6.
- [ADR-0106](./0106-keep-clean-tooling.md) — promotion-or-die and `gc` stand, re-aimed at the store.
- [ADR-0135](./0135-kit-declares-layout-cli-reads-manifest.md) — manifest-declared layout stands
  for what the kit still ships; the copied-workspace update path is retired.
- Lighter same-shape narrowings (workspace-stamp/copied-kit mechanics retired, core kept):
  [ADR-0015](./0015-versioning-scheme.md), [ADR-0041](./0041-two-axis-versioning.md),
  [ADR-0046](./0046-isolation-axis-model.md), [ADR-0053](./0053-structured-spec-and-review-system.md),
  [ADR-0061](./0061-intake-artifact.md), [ADR-0064](./0064-minimal-kit-tiering.md),
  [ADR-0065](./0065-three-flagship-examples.md), [ADR-0066](./0066-checks-redefinition.md),
  [ADR-0068](./0068-inventory-and-change-plan.md), [ADR-0072](./0072-run-summary-and-format-amendments.md),
  [ADR-0076](./0076-worker-provenance-and-adoption-conventions.md), [ADR-0081](./0081-kit-provenance-stamp.md),
  [ADR-0091](./0091-suspec-update-check.md), [ADR-0115](./0115-synced-catalogs-links-or-gated.md),
  [ADR-0120](./0120-re-baselining-reconcile-drift.md).

**Retired CLI use-cases:** `deriveBoard` (no board); `checkWorkspace`'s workspace-verdict face
(checks become artifact lint on the store); `pullIntake` reshaped to issue-refs;
`cutPacket` reshaped to store-resident task slices; `reconcileReview` reshaped to run-vs-spec
reconciliation.

**Upheld, load-bearing in v2:** [ADR-0121](./0121-evidence-gating-load-bearing-mechanic.md)
(the evidence gate is v2's core mechanic), [ADR-0134](./0134-self-contained-spine.md) (every step
keeps a by-hand path), [ADR-0136](./0136-launcher-boundary-automate-not-agent.md) (the `work`
spine), [ADR-0132](./0132-revolver-rotating-refine-loop.md) (revolver stays a skill),
[ADR-0111](./0111-kit-skill-scope.md)/[ADR-0112](./0112-two-tier-skills.md) (two-tier skills,
sharpened by Decision 5), [ADR-0092](./0092-suspec-agents-member.md)/[ADR-0098](./0098-codex-emitter-and-universal-layer.md)
(global catalogs).

## Alternatives considered

| Alternative | Why rejected |
|---|---|
| Keep the committed workspace (status quo) | Repo-rooted discovery makes the governing workspace unreachable from the governed repo; every bridge is ceremony; the artifacts rot with no death owner; the record duplicates truth that code/tests/ADRs/issues already own. |
| Gitignored `.suspec/` store inside each repo | Names a directory after the tool; invisible to worktrees (needs materialization anyway); the DX trial scored it below the user-level store; still leaks tool scaffold into every repo. |
| Commit specs, keep the rest transient (ADR-0104 line) | Committed specs still skew against evolving methodology, still demand the workspace apparatus (board, retention, checks-on-commit) that generates the rot; the spec's durable content is exactly what promotion moves to ADRs/tests/PRs. |
| One Suspec mega-skill riding plan mode | Plan-mode output is constrained prose, not a parseable, lintable artifact; the methodology cannot collapse to one skill; typed working memory needs types. |
| Store under `~/.local/state/suspec/<repo>/` | XDG-correct but tool-named and apart from where agents already keep their scaffold; the store belongs beside the agent's `plans/` — one place the developer already looks. |

## Consequences

- Positive: zero suspec footprint in repos beyond `suspec.config.json` + committed repo-specific
  guides; no version skew (global family updates atomically); no courier/materialization ceremony;
  rot handled structurally; the shipped `work` spine, checks engine (as artifact lint), reconcile
  engine, and staleness/digest machinery all survive re-aimed at the store.
- Negative: a public-product docs debt — every doc teaching the workspace model needs a banner now
  and a rewrite as touched; per-change artifacts are invisible to teammates unless promoted
  (that is the point, but it is a behavior change).
- Neutral: a dedicated works repo remains one developer's private choice; it is simply no longer
  the reference model. Cross-machine continuity is a documented sync recipe, not a feature.

## Status

Accepted (2026-07-09). Supersedes/narrows the ADRs listed above; upholds
[ADR-0121](./0121-evidence-gating-load-bearing-mechanic.md),
[ADR-0134](./0134-self-contained-spine.md), [ADR-0136](./0136-launcher-boundary-automate-not-agent.md),
[ADR-0132](./0132-revolver-rotating-refine-loop.md).

## Propagation

- `docs/adrs/README.md` — ledger row + disposition flips for every ADR named above.
- Supersession banners, same sweep as this ADR: `README.md`, `AGENTS.md`, `docs/README.md`,
  `docs/01-what-is-suspec.md`, `docs/02-basic-workflow.md`, `docs/03-where-files-live.md`,
  `docs/05-brownfield-and-change-plans.md`, `docs/09-saving-findings.md`, `docs/10-integrations.md`,
  `docs/ADOPTING.md`, `docs/artifact-registry.md`, `docs/reference/cli.md`,
  `docs/reference/artifact-formats.md`, `docs/reference/checks.md`, `docs/reference/agent-guides.md`,
  `docs/reference/cheatsheet.md`, `docs/reference/glossary.md`, `docs/reference/advanced-lifecycle.md`,
  `docs/reference/drift.md`, `docs/reference/memory.md`, `docs/reference/step-bars.md`,
  `docs/tutorial/` (all), `docs/examples/` (all), `checks/README.md`.
- SPEC-suspec-v2 (the store, flow, gate v2, anti-rot, CLI surface) before any code.
- corpus-cli: the store module + reshaped verbs; corpus-starter-kit: thin repo-seed;
  corpus-skills: global-install packaging.
