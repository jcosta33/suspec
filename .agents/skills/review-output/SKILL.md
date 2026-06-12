---
name: review-output
type: agent-guide
description: >-
  Judge a change set in this repo before it lands: refute by default, re-run the
  checks yourself, paste your own evidence, route exceptions to a human. ALWAYS
  apply when asked to review changes, decide whether an edit to docs/,
  starter-kit/, or checks/ is ready to commit, or fill a review
  packet. Never mark Pass from the author's pasted output alone, leave a Pass
  with an empty Evidence cell, or review a change you authored. Skip for
  authoring the documents under review.
---

# Review output — dev guide for this repo

The shipped guide for this discipline is `starter-kit/.agents/skills/review-output/SKILL.md`; the review
packet format is `starter-kit/templates/review.md`. This copy carries the same rules plus the
specifics of reviewing **this repo** — a markdown-only workspace whose checks are greps, link
audits, and diff reads rather than a test suite. Everything below is a review checklist —
nothing in this repo enforces it.

## What a review judges here

A change set against its stated intent: the request or plan that scoped it, the ADRs it
propagates (`docs/adrs/`; status in `.agents/audits/repositioning-propagation.md`), and the
standing gates in `AGENTS.md`. The Commands table in this repo's `AGENTS.md` is empty by design;
evidence is still command output — the grep, the link check, the `git diff` — pasted verbatim.

## Rules

1. **Never review your own change.** If you wrote the diff, hand the review off. Adversarial
   self-review before handoff (the Skeptic stance turned on your own work, ADR-0056) yields fixes
   and a recorded critique — never a self-issued result.
2. **The author's paste is a claim; your run is evidence.** Re-run every check yourself and paste
   _your_ output. A check you could not run is Unverified, not Pass.
3. **One row per claim.** List what the change set claims to do — each intent item, each ADR row
   it propagates — and give each a result: Pass · Fail · Unverified · Blocked. A Pass needs
   pasted output (or, for a by-hand check, the named human's recorded observation). **An empty
   Evidence cell means Unverified, never Pass.** A claim with no row is
   a missing row, not a free pass.
4. **Run this repo's check set** (the reconciliation gate):
   - every relative link resolves; every `[[KEY]]` resolves to an anchor in
     `docs/research/sources.md`;
   - the banned-token greps, tier-scoped per the matrix;
   - counts appear only in the producer note (`checks/README.md`) and the cheatsheet
     appendix;
   - user-tier pages use user-tier vocabulary only;
   - a format change updates its fixtures, examples, and templates in the same commit;
   - a `docs/` rule change reached its derived copies (kit guides and cards, this dev subset).
5. **Spot-check at least one green row.** Open its evidence and read it: does the output actually
   exercise that claim, and does it say what the row says?
6. **Read what did not change.** Cross-references to renamed files, sibling pages stating the same
   rule, derived copies in the kit. The diff shows what changed, not what it orphaned. Treat
   "trivial", "mechanical", and "doc-only" in the author's summary as flags to check, not
   assurances.
7. **Route the exceptions.** A short list a human reads instead of the diff: failed or unverified
   claims · out-of-scope edits · vocabulary regressions · unresolved links · stale derived
   copies · new finding candidates · blocked questions. One line each: what, why it matters,
   suggested action. "No exceptions" is a valid — and reportable — outcome.
8. **The decision follows the table, not the summary's confidence.** Merge or commit only when
   every row is Pass and no exception is open; otherwise "Block until …", naming the specific
   rows or exceptions.
9. **Save finding candidates at close.** Anything durable the review surfaced routes per
   `../save-findings/SKILL.md`, linked from the packet.
10. **Keep the result honest.** Never soften a Fail to avoid blocking; never inflate a nit into a
    blocker.

## Refuses

| Red flag                                                   | Action                                                               |
| ---------------------------------------------------------- | -------------------------------------------------------------------- |
| "Checks pass" with no command, exit, or output             | Unverified; produce or demand the real run                           |
| Accepting the author's paste as final evidence             | Re-run it yourself; if you cannot, mark Unverified and say why       |
| Evidence that addresses a neighbouring claim, not this one | Unverified for this row — evidence must match the claim              |
| Well-formed output offered as correctness                  | Shape is not truth; check the value, not the format                  |
| Your run disagrees with the author's paste                 | The discrepancy is itself a finding — investigate, do not dismiss it |
| A vague concern ("reads rough")                            | Sharpen it to a file and line, or drop it                            |
| Fixing the documents mid-review                            | Review judges; the fix is a new task                                 |
| Reviewing a diff you authored                              | Hand it off; record that you did                                     |

## Self-review gate

Before recording the result:

- [ ] Every claimed item has a row; no Evidence cell is empty on a Pass.
- [ ] Every Pass rests on output you ran; you spot-checked at least one green row's evidence.
- [ ] You checked the unchanged surfaces (cross-references, derived copies), not just the diff.
- [ ] Each exception entry has what / why / suggested action; nothing on the trigger list was
      silently skipped.
- [ ] The decision follows strictly from the rows — no Fail, Unverified, or Blocked hiding
      behind a "Merge".
- [ ] Finding candidates are routed, not left in prose.
- [ ] You did not author the change you judged.
