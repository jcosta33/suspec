---
type: adr
id: adr-0162
status: accepted
created: 2026-07-15
---

# ADR-0162 - Campaign orchestration through native delivery systems

## Context

Suspec removed implementation skills and custom agents so native harnesses could execute ordinary
work. Large goals still need a control method: independent tasks collide, disposable worktrees waste
setup, private reviewer prose destroys traceability, and the orchestrator can become an unreviewed
super-implementer.

The answer is coordination, not another artifact store or runtime.

## Decision

1. **`campaign` joins the universal catalog.** It activates for one delivery goal containing
   multiple dependency-aware, write-disjoint implementation streams and multiple pull requests. It
   creates no Suspec artifact.
2. **Project systems carry state.** One issue or issue-backed epic is the campaign ledger. Branches,
   pull requests, review events, CI, and merge controls remain repository-native. Milestones group
   work; they do not replace the ledger.
3. **Worktrees form a reusable lane pool.** The orchestrator sizes one global campaign budget and
   partitions it by repository. Each stable worktree has one branch and one implementation owner at
   a time. Clean lanes are recycled across tasks instead of recreated after every pull request.
4. **Parallelism must be proven.** Dependency-ready, write-disjoint work may run concurrently.
   Shared contracts, generated surfaces, unknown scope, and overlapping files force sequencing.
5. **Model routing is adaptive.** Deterministic checks run first and after relevant edits. The
   cheapest proven-adequate model executes the current step. Architecture, security, migrations,
   conflicting evidence, and disputed severe findings earn stronger reasoning. Escalation targets
   the blocked step, then ends.
6. **Implementation owners repair their work.** They edit, test, commit, push, and answer review in
   their lane. The campaign orchestrator schedules, routes, records verified findings on the pull
   request, messages the owner, checks the repair, and closes the review item. It does not silently
   patch an owner's branch.
7. **Pull-request review is sequential and visible.** Every target-justified stance receives one
   fresh reviewer against the current head. Each stance has a repository-native review event. Every
   supported item is fixed and verified before the next stance starts. Unverified, blocked, or human
   decisions stop dependent work.
8. **Humans and project policy retain authority.** They own material decisions, irreversible
   cleanup, acceptance, approval, and merge. Head or base drift resets affected checks and review.

## Narrowed decisions

- [ADR-0151](./0151-skill-agent-artifact-economy.md): the closed universal catalog gains
  `campaign`; implementation and custom-agent catalogs remain retired.
- [ADR-0157](./0157-ruthless-skills-and-closed-artifact-authorship.md): closed Suspec artifact
  authorship stands; campaign state lives in project-native systems.
- [ADR-0099](./0099-review-orchestration-and-role-routing.md): no custom Suspec agent catalog
  returns; fresh harness-native agents fill campaign roles.

## Consequences

- Large delivery remains visible through ordinary issues, pull requests, review threads, and CI.
- Worktree setup is paid once per lane, not once per task.
- Review findings return to their implementation owner instead of becoming private orchestrator
  edits.
- Suspec gains orchestration doctrine without a scheduler, registry, service, or new CLI/MCP surface.

## Status

Accepted (2026-07-15). Narrows ADR-0099, ADR-0151, and ADR-0157.
