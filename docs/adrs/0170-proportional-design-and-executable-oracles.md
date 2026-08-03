---
type: adr
id: adr-0170
status: accepted
created: 2026-08-03
---

# ADR-0170 - Proportional design and executable oracles

## Context

ADR-0169 routes every agent-originated question through structured selection. Real runs still leak
bare clarification because selection begins only after the agent classifies a prompt as ambiguity.
The trigger must be the required user response itself.

Consequential work also needs design alignment before requirements harden. Clear reversible work
does not need a brainstorming ceremony; open behavior needs viable approaches and a human choice.
First-party Superpowers practice supports the direction but proves no universal workflow
[[SUPERPOWERS]](../research/sources.md#SUPERPOWERS).

Test-first evidence is mixed. Industrial TDD studies report lower defect density at higher initial
cost [[TDDINDUSTRY]](../research/sources.md#TDDINDUSTRY). Agent studies instead isolate the value in
the oracle: valid tests distinguish the original defect from its repair, human-written reproduction
tests outperform generated ones, and merely inducing more agent-written tests does not improve final
outcomes [[SWTBENCH]](../research/sources.md#SWTBENCH)
[[TDFLOW]](../research/sources.md#TDFLOW)
[[AGENTTESTS]](../research/sources.md#AGENTTESTS). Suspec should demand trustworthy executable proof,
not a universal development ritual.

Campaign worktrees need the same honesty. Linked worktrees separate writes; they do not confer
ownership or safe cleanup. Existing native lanes, the current branch, dirty state, and provenance
must be known before allocation.

## Decision

1. **A required user response triggers structured selection.** After discoverable facts and
   reversible conventions are exhausted, every clarification, confirmation, permission, preference,
   approval, waiver, decision, or other blocking answer uses explicit options, a recommendation,
   tradeoffs, and `Other`. Direct factual answers remain direct.
2. **Design effort follows consequence.** Precise reversible work stays direct. When consequential
   behavior remains open, present distinct viable approaches and a recommendation before writing
   requirements. The selected behavior becomes the spec. Suspec adds no brainstorming ritual or
   artifact.
3. **Behavior changes require the best available oracle.** Define the highest-fidelity observable
   check before editing when one can be known. Bug fixes reproduce the original failure. A new
   regression test earns authority only when it fails for the expected reason on the original state,
   passes on the repair, exercises production behavior, and invents no requirement. Never weaken an
   oracle to admit a patch.
4. **Evidence names its state.** Carry command, working directory, commit or stable snapshot,
   environment when material, exit status, and decisive output. Re-run after relevant code, input,
   environment, command, or requirement changes. Project tests, approved acceptance criteria, and
   verified external contracts outrank generated tests.
5. **Campaigns prove worktree authority.** Inspect the current worktree and existing native lanes
   before allocation. Main-branch implementation requires project or human authority. Record lane
   path, branch, owner, origin, and state in the project ledger. Clean only known campaign-created
   lanes after merge or closure and under authority; preserve dirty, unknown, and externally owned
   worktrees.
6. **Control follows witnessed failure.** Retire synthetic prompt matrices, repetition quotas,
   harness-model grids, token measurements, and trace archives from the skills repository. Keep
   deterministic gates for deterministic contracts. Add behavioral control only for a witnessed
   Suspec failure or bounded external finding.
7. **Native development remains native.** Suspec adds no generic implementation, debugging,
   testing, TDD, worktree, or brainstorming skill; no registry, artifact, CLI command, or MCP tool.
   Campaign keeps its existing pull-request and review breakers, implementation-owner repair,
   scoped re-review, and merged-state proof.

## Narrowed decisions

- [ADR-0161](./0161-semantic-skill-contracts-and-evidence.md): maintained design evidence stands;
  synthetic composition testing retires.
- [ADR-0162](./0162-campaign-orchestration.md),
  [ADR-0163](./0163-conventional-campaign-pull-requests.md), and
  [ADR-0167](./0167-bounded-campaign-guardrails.md): campaign boundaries and review discipline stand;
  worktree authority, oracle handoff, and scoped re-review tighten.
- [ADR-0169](./0169-minimum-sufficient-skill-control.md): minimum sufficient control and universal
  structured questions stand; live failures replace the synthetic behavior-evaluation program.

## Consequences

- Questions are intercepted by observable need, not an ambiguity label.
- Requirements follow selected behavior without taxing obvious work.
- Tests prove behavior only when their own authority is proven.
- Campaigns reuse lanes without claiming ownership they do not have.
- Skill maintenance follows failures from real work, not prompt theater.

## Status

Accepted (2026-08-03). Narrows ADR-0161, ADR-0162, ADR-0163, ADR-0167, and ADR-0169.
