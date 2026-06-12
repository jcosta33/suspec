---
type: adr
id: adr-0072
status: accepted
created: 2026-06-12
updated: 2026-06-12
---

# ADR-0072 — The run summary digest and the DX format amendments

## Context

An eleven-persona DX audit (`.agents/audits/dx-audit-2026-06-12.md`) converged on format
defects in the kit's frozen artifacts, the strongest being that the run summary — demanded by
every surface and called the raw material of the review packet's Evidence column — had no home
in any format (9 of 11 personas, 7 MAJOR). `SPEC-dx-remediation` lifted the verified register
into requirements; a four-lens challenge round (surveyor · architect · economist ·
canon-coherence) reshaped the fixes and resolved the three open format questions. This ADR
records the amendments; `CHANGE-dx-formats` sequences the landing.

## Decision

1. **The run summary lives in the task packet, as a digest.** `templates/task.md` gains a
   `## Run summary` section the implementing agent fills at the end of the run: changed
   files, a one-line per-command result digest **citing** the Verify items' pasted output,
   out-of-scope edits, blocked questions, finding-candidate notes. The Verify section stays
   the single home of pasted evidence — the summary cites, never duplicates (two paste homes
   is the Contradicted-evidence class). This **supersedes the run-record clause of
   ADR-0060's addendum** ("the worker's run record folds into the review packet"): the review
   packet is the reviewer's document and does not exist at handoff; the run record belongs to
   the packet that travels with the work.
2. **Waivers are records plus a packet status — never a row result (Q1).** The coverage-row
   result enum stays closed at Pass · Fail · Unverified · Blocked. A reviewer who waives a
   non-Pass row records **who waived · which rows · why · expiry** in the packet, and the
   review status enum gains one additive terminal value, **`waived`** (merged with a recorded
   waiver). Expiry semantics stay reference-tier (the advanced lifecycle's Waived annotation);
   the glossary maps the tiers. The gate-honesty bar reads "no merge suggestion past a Fail or
   unrouted Unverified *without a recorded waiver*".
3. **Blocked is board vocabulary, not a task status (Q2).** The status board's task-row
   vocabulary gains `blocked`, extending the precedent the board template already draws for
   specs ("in-progress / done / stale are board states"); the task frontmatter enum stays
   ready / running / review-ready / closed, and the contract declares exactly those four. The
   board also seeds a review example row, so a blocked review is visible as itself.
4. **Multi-context Commands resolve by sub-table, not by slot grammar (Q3).** A monorepo with
   a root dispatcher keeps single slots (the documented first option). Where contexts truly
   diverge, the Commands table repeats once per context under a named sub-heading — slot
   names stay canonical, the context lives in the heading, and a task resolves slots against
   the sub-table its Affected areas name. Suffix-minted slot names (`cmdTest:web`,
   `cmdTestIos`) are rejected: the colon collides with the SOL adapter grammar and the
   placeholder namespaces, and any suffix grammar would force an open-ended minting rule into
   the contract. The kit table also gains one pointer line naming the remaining contract
   slots (registry: checks.yaml) — no empty placeholder rows.
5. **The Pass-evidence rule admits manual evidence, amended once.** The canonical sentence
   becomes: *"A Pass needs pasted output, a CI link, or, for a manual Verify method, a named
   human's recorded observation (who judged, what they saw)."* Every restating surface
   carries the amended form in one sweep — a partial patch would fork the bar.
6. **Smaller format amendments, all additive:** the review template gains `reviewer:`
   (template-carried, not contract-required) and a `Spot-checked:` trace line; intake source
   examples gain `gh-pr` and an informal channel; the finding `from:` hint accepts `AUDIT-*`
   and `INV-*`; the shipped board carries a comment-only example row; the seed ADR states the
   amended evidence rule; the board's upkeep is assigned to the sessions at each transition
   (the finishing agent flips its row; the human reads the board).
7. **checks.yaml v0.4.0** — the enumerated deltas: (a) `Run summary` joins the task's
   required sections; (b) the task status enum is declared (the existing four values);
   (c) the review status enum gains `waived`; (d) the `pass-needs-evidence` rule carries the
   amended sentence (a relaxation — old packets still conform); (e) comments: the shadow
   claim scoped to the core checks, frontmatter lists are minimum-required (extra keys
   legal), and the run summary cites — never replaces — the Verify evidence. An old task
   packet fails v0.4.0 only on the missing Run summary section; old review packets do not
   fail at all.

## Alternatives considered

- **Run summary as a ninth template or sibling file** — rejected: the template set stays
  eight; the digest travels with the work order.
- **Waived as a fifth row result** — rejected: forks the four-core-results registry against
  the lifecycle's annotation model and drops the required fields.
- **Pure waive-by-convention with no status value** — rejected: a decided packet would dangle
  at `needs-human` forever, the audit's verified defect.
- **`blocked` in the task frontmatter enum** — rejected: the truth lives in the review
  packet's status; a frontmatter value adds contract churn for a state the board can carry.
- **Suffix-qualified slot names** — rejected on grammar collision (see Decision 4).

## Consequences

Accepted. Partially supersedes ADR-0060 (the addendum's run-record clause; the task/review
packet formats amended additively); refines ADR-0064 (kit AGENTS.md content), ADR-0066/0070
(checks contract, v0.4.0), ADR-0063 (the manual-evidence clause is the honesty framework
applied to the evidence rule). SPEC-dx-remediation's open questions close; the spec flips to
`ready`; `CHANGE-dx-formats` waves 2–5 land the amendments.

## Propagation

templates (task, review, status, intake, finding, spec note), kit AGENTS.md + board + seed
ADR + example chain, checks/ (yaml, fixtures, README), docs 01/02/06/07/08/09 + reference
pages, all three examples, kit + library guides, dev mirrors — per CHANGE-dx-formats.
