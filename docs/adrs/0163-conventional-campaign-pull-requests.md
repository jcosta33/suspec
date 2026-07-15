---
type: adr
id: adr-0163
status: accepted
created: 2026-07-15
---

# ADR-0163 - Conventional campaign pull requests

## Context

ADR-0162 required one repository-native review event per stance, including quiet stances and
refutations, plus a follow-up event after repair. This preserved the review process by dumping it
into the pull request. The result was traceable noise: empty review events, stale threads, repeated
head narration, inflated severity, and implementation history written for agents instead of humans.

Project-native delivery means using pull requests as humans use them. It does not make every internal
review step public.

## Decision

1. **Pull requests describe the change.** Follow the project template and title convention. Without
   one, use an imperative title, Summary, and Verification. Add dependencies or risks only when
   material. Link the campaign ledger once.
2. **Pull requests are not journals.** Rewrite stale body text. Exclude agent identity, transient
   artifact handling, internal review mechanics, head diaries, repeated evidence, and chronological
   narration.
3. **Stances stay internal.** Publish only deduplicated, verified, actionable findings. Quiet stances,
   refutations, speculative findings, and private reviewer reasoning produce no GitHub event.
4. **Use ordinary review primitives.** Batch one stance's surviving findings into one draft review
   and submit only nonempty reviews. Put a finding in a resolvable line thread when possible; use a
   numbered review-body item only when no line owns it.
5. **Every comment earns permanence.** Write one terse paragraph: defect, consequence, required
   outcome. Use project severity. Without one, label only merge blockers. Omit greetings, summaries,
   praise, process, stance labels, reviewer identity, speculative fix essays, and evidence already
   visible in the diff or linked check.
6. **Resolve in place.** The implementation owner receives thread links, fixes the code, and replies
   once with the commit and decisive proof. The review orchestrator verifies the current head and
   resolves the thread. It posts no follow-up review event or completion recap.
7. **Sequential repair stands.** The next stance starts only after the current stance's published
   findings resolve. A quiet rotation produces no comment. Project policy and humans still own
   required approval and merge.
8. **Commit history follows project policy.** Fixup commits may exist during review; fold them before
   merge when the repository allows.

## Narrowed decisions

- [ADR-0162](./0162-campaign-orchestration.md): reusable lanes, implementation-owner repair,
  sequential review, native pull requests, and human authority stand. Decision 7's mandatory visible
  event per stance retires in favor of the publication rules above.
- [ADR-0157](./0157-ruthless-skills-and-closed-artifact-authorship.md): ruthless economy now governs
  campaign pull-request bodies, comments, replies, and review events.

## Consequences

- GitHub records defects and resolutions, not the agent's review transcript.
- Review remains exhaustive without making the pull request exhausting.
- Stale threads close instead of accumulating as archaeological layers.
- Human reviewers can scan the change, open blockers, proof, and approval state without decoding the
  orchestration.

## Status

Accepted (2026-07-15). Narrows ADR-0162 and ADR-0157.
