---
type: review
id: post-rebuild-adversarial-review
status: pass
reviewed: commits 5f2404b + 10c238b + 6b7a734 (the full repositioning)
date: 2026-06-11
---

# Adversarial review — the rebuilt framework (six dimensions)

Six independent hostile reviewers (persona-skeptic + the adversarial-review discipline: claims
set aside, checks re-run by the reviewer, findings with severity + file:line + fix sketch), one
dimension each: plan coverage · format coherence · newcomer-path coherence · sources & citations ·
completeness & depth · voice & honesty. Raw reports preserved in the session; this file is the
consolidated record. **All BLOCKER and MAJOR findings were fixed in the follow-up commit; the
fix evidence is the re-run gate output below.**

## What held (reviewer-verified, their own runs)

- Voice: zero fresh-product violations in ~29 contextual hits judged; zero migration framing.
- Honesty framework: every enforcement-sounding statement leveled or inside the legend.
- Labels 27/27 → 28/28 (ADOPTING added); page budgets all inside limits; README at 120.
- 139 citations resolve at correct depth; zero rejected-source citations; METR/DORA caveats held.
- All three examples' artifact chains match the frozen templates (headers, frontmatter, ID chains).
- The nine exception triggers byte-identical across six homes.
- Depth: docs/04/05/08, the three kit guides, write-change-plan, checks.md, future-cli.md all
  passed the "could a newcomer do the job from this page alone" read.
- The ten-question cold-read test answered from the shipped pages (+ the inventory/change-plan
  question in under a minute).

## What broke and was fixed (2 BLOCKERs, ~20 MAJORs, ~30 MINORs)

1. **Task terminal status forked** (`done` in the conformance layer vs `closed` in the docs) —
   unified on `closed` across yaml, both oracles, and the kit example. [BLOCKER]
2. **REFLEXION misbound ×11**: the evidence-rule claims now cite EVIBOUND (the entry that
   actually measures hallucinated done-claims); REFLEXION retained only for its real finding.
   ORACLESWE's two-way comparison de-superlatived ×9 ("a runnable check measurably outperforms
   prose plans as task input (preliminary)"); the clarification→"process" generalization narrowed
   ×8 at its sources.md root and every echo; the one uncited empirical claim now cites a new
   verified-id IFSCALE entry. [BLOCKER + 3 MAJOR]
3. **Count registries**: cheatsheet and conformance/README now carry the identical eight rows;
   ghost sets (phases/edge types/task kinds) dropped; SOL block types corrected to the five the
   shipped notation defines. [MAJOR]
4. **Ready-gate fork**: one rule both surfaces — an open question blocks `status: ready` unless
   marked non-blocking (plain "(non-blocking)" ≡ SOL `[non-blocking]`). [MAJOR]
5. **Conformance contract vs its fixtures**: change-plan checks C010/C011 added to checks.md +
   yaml; intake + transformation fixtures registered; payment-5xx's `no-open-critical` pin
   corrected (blocked status satisfies the rule; counterfactual pinned); V3 rewritten as a spec
   fixture; C009 external-id carve-out; task-side `non-empty-paste` notes pinned. [4 MAJOR]
6. **The owner-dropped adversarial-review pair integrated**: kit copy rewritten to kit
   conventions (frontmatter `type:`, cmd* slots, packet vocabulary, kit paths), indexed in
   advanced/README + agent-guides + the manifest census, recorded as an ADR-0064 addendum,
   the dev↔kit pair registered in the propagation matrix, cross-linked from docs/08. [3 MAJOR]
7. **cmd\* adapter fork**: the kit AGENTS.md Commands slots renamed to `cmdTest/cmdLint/
   cmdBuild/cmdTypecheck` so the SOL `VERIFY BY` adapters and every fixture resolve. [MAJOR]
8. **Spec template's dangling pointer** re-aimed at the kit's own `advanced/sol-reference.md`;
   reserved machine-artifact names unified infix-free (ADR-0059 addendum) + the run-record
   sketch added to future-cli; propagation matrix cells filled with SHAs and an honest
   **Outstanding** register added (Increments 10–11). [3 MAJOR]
9. Minors: S-amendment stragglers (principles framing line, AGENTS.md-differentiation row,
   "independent" in the wedge phrase, fifth do-not-promise, spec ~100-line budget, infix
   compat note, PG-NNN rule in the one-model section, ADR context lines incl. the named
   drift counter-sources), glossary headwords (wave, preservation guarantee, workboard,
   watchlist), C004 "should not" ×3, spot-check in checks.md, board-row normalization,
   bug-fix example provenance, branch-grammar alignment, "Spec amend" rename, ADOPTING
   fallback alignment + label, README trimmed to 120, sources.md note hygiene
   (ASKORASSUME verified-note refresh, REACODER ablation caveat, REDEFO note left for a
   future sweep), voice fixes in write-inventory/threat-model.

## Accepted as-is (recorded, not fixed)

- 33 broken links inside immutable pre-repositioning ADR bodies (targets live in git history).
- "compiler" inside the two is-not denial lists (the gate token in allowed context).
- 34/57 bibliography entries uncited in the live tree (the ledger retains them; EVIBOUND,
  SWEMUT, IFSCALE now wired; the rest are ADR-era or held for future claims).
- Frozen template texts live verbatim only in `starter-kit/templates/` (ADRs describe them) —
  one verbatim home, deviation recorded in the matrix.
- Same-defect-different-severity between C004–C006 (warnings) and their SOL hard-error
  counterparts: scoped in checks.md as a shape-strictness difference of the SOL surface,
  not two rules.

## Outstanding (open increments — tracked in the propagation matrix)

- **Increment 10:** swarm-cli resync (kit copy, spec suite, `swarm spec check` against
  C001–C011 + `format: sol` + the new fixtures). Gate: pasted green run on both repos.
- **Increment 11:** cold re-adoption exercise + the ten-question test as a fresh-session run,
  keep/adjust calls for intake/examples/memory, and the pre-registered spec-first pilot
  (`.agents/plans/spec-first-pilot-protocol.md`).

## Re-run gate evidence (post-fix)

```
user-tier banned-token hits: 0
label problems: 0 (28/28 incl. ADOPTING)
broken links outside docs/adrs/: 0
citation anchor/path problems: 0
counts leakage outside the two homes: 0
README: 120 lines
```
