---
type: audit
id: post-pivot-adoption-review
status: complete
date: 2026-06-12
---

# Post-pivot adoption review (Increment 11)

Two fresh-session agents with zero conversation context exercised the shipped product only:
one performed the **literal manual adoption** in a scratch workspace (every command typed,
one full spec→task→review→finding loop on an invented feature), one ran the **eleven-question
cold read** under a ~10-minute newcomer attention budget.

## Cold adoption (friction log: 0 BLOCKER · 4 MAJOR · 7 MINOR — all fixed same day)

Verdict: *"Yes, with an asterisk"* — every step completed; steps 1–5 ≈ 5–8 minutes as typed
commands (the kit README's claim holds for the copy surface); the first full loop ≈ 43 minutes
total. The four MAJORs were instruction seams, each a one-sentence fix, all applied:
broken leftover symlinks after the AGENTS.md move (ADOPTING now moves the trio together, with
literal commands), the silent-failure skills-copy ambiguity (literal `cp` lines), the gitignore
step contradicting its own file header (moved to the code-repo section), and the code-repo-shaped
Commands table in a workspace checklist (template comment added). The seven MINORs (naming/slug
conventions, `pr:` for PR-less reviews, the Unverified-merge rule unified, board-vs-spec status
vocabulary, `sources: self`, seeded board rows, the optional sol-reference pointer) are fixed.

## Cold read (11 questions: 10 clear · 1 had-to-dig · 0 unanswerable)

All answers correct from the shipped pages, most from page 1–3; "what is optional/advanced"
required assembling footnotes from four pages — fixed with a single optional/advanced box in
docs/01. The five confusion items (Spec-amend terminology slip, undefined Audit/Research at
first table use, the spike flow vs the six-step arithmetic, "measurably…(preliminary)" wanting
it both ways) are fixed. Two observations accepted as-is:
- *The name vs the advice* ("Swarm" vs the honest few-parallel-streams ceiling) — recorded,
  not acted on; product naming is the owner's call.
- *"Nothing enforces anything" on every page* — by design (the honesty framework); the cure is
  the CLI, not softer prose.

Most convincing to the skeptic: the evidence rules + spot-check discipline in docs/08.
Least convincing: the memory story (willpower in markdown) — addressed below.
Adoption posture: would trial the middle slice (spec → task → review packet) on the next
agent-built feature; would defer workspace/intake/findings/board — consistent with the
designed skip-paths and the core-four framing now stated in docs/01.

## The three keep/adjust calls (the externally-unverifiable decisions)

| Decision | Call | Ground |
|---|---|---|
| **D6 intake** | **KEEP** (recommended-not-required, thin verbatim snapshot) | Cold reader classified it correctly as optional from page 3; adopter friction was zero once `sources: self` existed for self-originated work. No evidence for promoting or demoting it. |
| **D10 three examples** | **KEEP** (three; large-pr-review as demo) | The cold reader answered the spec and review-packet questions **without opening the examples** — README's sixty-seconds section carried them; examples are confirmatory depth, not a gap. No fourth example warranted. |
| **D14 light memory** | **KEEP, adjusted** | The skeptic's "least convincing" verdict is accepted as true: a hand-edited board + findings folder is unenforced habit. Adjustment shipped: docs/09 now names the weakness outright and points at the two structural prompts that do exist (the packet's finding-candidates exception class; the guides' closing instruction), with `swarm close` as the future automation. The heavier memory model stays demoted. |

## Outstanding after this increment

Only the deferred swarm-cli work (Increment 10 + the pilot's pair register), per the owner's
instruction. Everything else in the repositioning plan is executed, reviewed, and closed.
