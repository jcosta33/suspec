---
type: research
id: spec-first-pilot-protocol
status: pre-registered
created: 2026-06-11
---

# Pre-registered pilot: spec-first vs direct prompting (dogfooding A/B)

Pre-registered BEFORE any pair runs (the perception trap is the known failure: builders
believe they are faster while measuring slower — see [METR] in docs/research/sources.md).
Moves to the swarm-cli backlog at resync; results inform whether Spec stays the default
step for non-trivial work.

## Design

- **Site:** swarm-cli development (real backlog); optional second site: promptly.
- **Unit:** 10–15 pre-registered matched pairs of medium tasks (~30–60 min agent work) —
  the contested boundary zone. Pairs registered here before condition assignment.
- **Conditions (randomized within pair, same human, same model/CLI/worktree discipline):**
  A = direct prompting (ticket text + ad-hoc chat) · B = spec-first (the kit's 1–2-page
  spec template; authoring time hard-capped at 15 min; agent receives only the spec).
- **Metrics per task:** first-pass gate (review packet passes without a follow-up task) ·
  follow-up iterations · human minutes split (authoring / prompting / review) ·
  out-of-scope diff hunks · defects surfaced within 7 days · predicted-better condition
  recorded BEFORE outcomes.
- **Decision rule:** B must win on (review minutes + scope drift) or first-pass rate
  without losing on total human minutes for medium tasks; otherwise Spec is demoted from
  default-for-non-trivial to recommended-optional and docs/02 is reworded.
- **Threats (recorded, not hidden):** n too small for significance — report directions +
  the raw table, treat as a decision-informing pilot; same-human/no-blinding; pair-matching
  subjectivity (pairs registered before assignment); learning effects (alternate order);
  authoring time counted in total cost.

## Pair register

| # | Task A (prompt-only) | Task B (spec-first) | Registered | Run |
|---|---|---|---|---|
| 1 | {{tbd at swarm-cli resync}} | {{tbd}} | — | — |
