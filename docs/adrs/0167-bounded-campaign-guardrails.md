---
type: adr
id: adr-0167
status: accepted
created: 2026-07-20
---

# ADR-0167 - Bounded campaign guardrails

## Context

ADR-0162 established campaign orchestration. ADR-0163 removed review theater from pull requests.
Later guardrails bounded pull-request size and review breadth so an agent could not turn ordinary
delivery into an endless ceremony.

The direction stands. A skeptical review found eight defects in its wording and boundaries:
mandatory third choices polluted binary decisions; retained dependencies could go stale; linked
worktrees were called isolated; prerequisite pull requests were called independently mergeable;
reviewers could miss governing authority; repairs could expose risks without creating them; every
finding was forced into a line-or-summary split; and final verification named no exact merged state.

Evidence supports small, coherent review units but supplies no universal line, file, option, or
reviewer optimum [[DIBIASE19]](../research/sources.md#DIBIASE19)
[[BOSU15]](../research/sources.md#BOSU15) [[CHOICEOVERLOAD]](../research/sources.md#CHOICEOVERLOAD).
Suspec therefore labels its numbers honestly: circuit breakers against runaway execution, not laws
of software quality.

## Decision

1. **Choices stay genuine.** Material ambiguity gets three options by default and two when genuinely
   binary. Recommendation and cost remain explicit. Inventing a third answer is not rigor.
2. **Lane reuse checks dependency identity.** Ignored dependencies survive only while the lockfile
   and toolchain match the next branch. A mismatch triggers refresh. Preliminary CI evidence
   illustrates both reuse gains and stale-state failures; it does not directly measure local
   worktree dependencies [[CICACHE]](../research/sources.md#CICACHE).
3. **Worktrees are separate, not isolated.** They remain reusable write lanes; Git's shared
   repository state is not hidden behind a false guarantee.
4. **Pull requests are independently reviewable.** They merge in declared dependency order. The
   500-reviewable-line and 15-handwritten-file limits remain default stop signals, never quality
   scores or universal thresholds.
5. **Fresh review does not erase authority.** Each reviewer receives governing requirements and
   accepted decisions. Prior reviewer prose and pull-request conversation remain hidden. Existing
   comments have not shown broad negative priming in controlled human review, so this separation is
   a method boundary, not an empirical claim [[REVIEWPRIMING]](../research/sources.md#REVIEWPRIMING).
6. **Risk discovery may follow repair.** A frozen stance pool grows only when a repair creates or
   exposes a material trust boundary, public contract, failure mode, or previously unknown risk.
7. **Comments follow defect scope.** Local defects use changed-line threads, file-wide defects use
   file comments, and cross-cutting defects use short review-body items. Repeated instances collapse
   only when one repair and owner can resolve them together.
8. **Final proof names merged state.** Campaign closure verifies acceptance conditions against every
   merged SHA. No Suspec manifest, registry, or duplicate completion record is added.

## Narrowed and upheld decisions

- [ADR-0145](./0145-attention-economy-and-decision-rails.md) and
  [ADR-0157](./0157-ruthless-skills-and-closed-artifact-authorship.md): the three-option default now
  admits genuinely binary choices.
- [ADR-0162](./0162-campaign-orchestration.md): reusable lanes, fixed repository pools, one writer,
  adaptive routing, sequential repair, immediate authorized merge, and native project state stand.
- [ADR-0163](./0163-conventional-campaign-pull-requests.md): internal stances, concise pull requests,
  actionable comments, implementation-owner repair, and in-place resolution stand.

## Consequences

- Campaign remains bounded without pretending its guardrails are scientific constants.
- Reused lanes keep their economy without trusting stale dependencies.
- Reviewers receive authority, not each other's narration.
- Pull-request discussion matches defect scope and closure proves the code that actually merged.

## Status

Accepted (2026-07-20). Narrows ADR-0145, ADR-0157, ADR-0162, and ADR-0163.
