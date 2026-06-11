---
name: save-findings
type: agent-guide
description: >-
  The Close-step rule for this repo: before closing any task, route every
  durable discovery to its durable home — a docs/ rule with its ADR, a dev
  audit, a finding file, a glossary entry — and update the propagation matrix
  when a derived surface changed. ALWAYS apply when finishing work that
  surfaced a durable fact, decision, gotcha, or terminology problem — even one
  that seems too small. Do not close with a discovery left only in the session,
  save a finding without evidence, or generalize a pattern from one witness.
  Skip for the review judgment itself (review-output) and for authoring the
  artifacts findings route into.
---

# Save findings — dev guide for this repo

Lessons that live only in a session transcript die with it. The kit's convention is one rule at
Close — _record anything durable as a finding_ (`starter-kit/templates/finding.md`) — plus a
status board. This repo is the producer, so a discovery's durable home is usually a framework
surface, not only a finding file. This is a convention — nothing in this repo enforces it.

## Route each discovery

| Discovery                                              | Durable home                                                                                                                                                              |
| ------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| A rule, format, or vocabulary change for the framework | `docs/` first, with an ADR under `docs/adrs/` — then the kit, then this dev subset (the single-sourcing order; track it in `.agents/audits/repositioning-propagation.md`) |
| A decision with alternatives and trade-offs            | An ADR in `docs/adrs/`, with its ledger row in `docs/adrs/README.md`                                                                                                      |
| Present-state risk, debt, or drift in this repo        | A dev audit under `.agents/audits/` — append to the living audit that owns the area, or start one with `../write-audit/SKILL.md`                                          |
| A reusable working-on-this-repo fact                   | A finding file in the kit template's shape under `.agents/audits/`, or an appended observation in the relevant living audit                                               |
| A terminology clash or drifted term                    | `docs/reference/glossary.md` — one term, one definition; split a contested term, never overload it                                                                        |
| A new empirical source behind a claim                  | `docs/research/sources.md`, web-verified (venue + finding) first — the evidence discipline in `AGENTS.md`                                                                 |
| A purely session-local detail                          | Nowhere — leave it in the session; not every observation is durable                                                                                                       |

## Rules

1. **Sweep before closing.** Walk the session once for durable facts, decisions, gotchas, and
   terminology problems. Judging a detail "not durable" is fine; never judging it is the failure.
2. **A finding is one claim with its evidence and its limits.** The template's sections — What we
   learned · Evidence · Where it applies · Where it does not apply · Future guidance. A finding
   without evidence is an opinion on file; one without limits gets applied where it does not hold.
3. **No pattern from one witness.** One observation is a finding. A "pattern" needs a second,
   corroborating case it can cite — otherwise it is a finding wearing a hat.
4. **A finding informs a rule; it never silently weakens one.** If a discovery suggests an
   existing rule is wrong, that is a `docs/` change with an ADR — a deliberate authoring act —
   never a note that contradicts the rule from below.
5. **Route, then link.** When a review packet or audit raised the discovery, link the saved
   finding from it so the chain stays walkable.

## Heavier machinery

The load-when index, promotion statuses, and pattern model live at `docs/reference/memory.md` —
the advanced tier for teams that outgrow the core findings convention. This repo uses the core
convention plus the routing table above; introducing the advanced machinery here would need its
own ADR.

## Before you finish

- [ ] The session was swept; every durable discovery is routed (or consciously judged local).
- [ ] Each saved finding carries claim + evidence + applicability limits.
- [ ] No rule was weakened "as a note" — rule changes went to `docs/` + an ADR.
- [ ] Any new source was verified before entering `docs/research/sources.md`.
- [ ] The propagation matrix row is updated where the discovery changed a derived surface.
