---
type: spec
id: SPEC-dx-remediation
title: Close the convergent defects from the eleven-persona DX audit
status: ready
owner: José Costa
sources:
  - .agents/audits/dx-audit-2026-06-12.md
---

# Close the convergent defects from the eleven-persona DX audit

## Intent

The DX audit's eleven personas converged on real defects — a load-bearing artifact with no
home, an evidence model that assumes CLI-runnable checks, and missing paths for common work
shapes. This spec turns every verified register finding into a checkable requirement or a
recorded drop. It is a wide, shallow catalogue (one line of behavior per finding), so it runs
long deliberately; the frozen-format subset is sequenced by `CHANGE-dx-formats`. Every
executable `Verify with:` gate fails against the baseline tree — pre-flighted in the authoring
session and re-flighted after the challenge round — so none can read green before its fix
lands. A four-lens challenge round (surveyor · architect · economist · canon-coherence)
reshaped fourteen requirements and added nine; the reshapes are in place under their original
ids.

## Non-goals

- No runtime, enforcement, or swarm-cli features — every fix is markdown.
- No new artifact types and no ninth template — the run summary becomes a section, not a file.
- No template-repo split, no SOL grammar/catalogue changes (the shadow *claim* is scoped
  instead — AC-040), no rescoring of the audit itself.
- No new coverage-row result values: Pass · Fail · Unverified · Blocked is closed (waivers are
  recorded, never written into a row's Result — AC-014).
- No cross-workspace board aggregation and no portfolio-placement guidance (recorded drop).

## Requirements

<!-- Importance order: the 9-of-11 finding first, the evidence-model cluster second,
     work-shape paths third, then packet/board/commands formats, adoption honesty,
     discoverability, surface-consistency sweeps, and the challenge-round additions.
     One behavior per AC. -->

### AC-001 — The run summary has a home, as a digest

The task packet format must carry a `## Run summary` section the implementing agent fills as
the **handoff digest** — changed files, a one-line per-command result digest that cites the
Verify items' pasted output blocks, out-of-scope edits, blocked questions, finding-candidate
notes. The Verify section stays the single home of pasted evidence; the summary cites it,
never duplicates it (two paste homes is the Contradicted-evidence class).

Verify with: `grep -q '^## Run summary' starter-kit/templates/task.md`

### AC-002 — Every surface that demands the run summary names its home

Every surface that *instructs* an agent to produce a run summary must name the task packet's
Run summary section as its location. The instructing surfaces, enumerated: docs/02 (step 4),
docs/07, docs/08 (the consumer side), `starter-kit/templates/task.md`,
`starter-kit/AGENTS.md` (instruction 5), both implement-task guides and their `.agents/skills`
mirrors, the three docs/examples walkthroughs, and
`starter-kit/examples/feature-from-ticket/task.md`. Reference-tier *descriptive* mentions
(glossary, step-bars, future-cli) are covered once by the glossary entry naming the home —
they do not each restate it.

Verify with: `grep -LiE '## Run summary|Run summary section' docs/02-basic-workflow.md docs/07-running-agents.md docs/08-reviewing-output.md starter-kit/templates/task.md starter-kit/AGENTS.md starter-kit/.agents/skills/implement-task/SKILL.md docs/library/code-skills/implement-task/SKILL.md docs/examples/feature-from-jira.md docs/examples/bug-fix.md docs/examples/large-pr-review.md starter-kit/examples/feature-from-ticket/task.md — returns nothing`

### AC-003 — The Pass-evidence rule admits manual evidence, amended once and swept everywhere

The canonical sentence is amended in one form — "A Pass needs pasted output, a CI link, or,
for a manual Verify method, a named human's recorded observation (who judged, what they
saw)" — and **every** surface restating the old two-option form carries the amended form:
docs/02, docs/06, docs/08 (both sites), the review template comment, checks.yaml's
`pass-needs-evidence` rule, the cheatsheet (both sites), artifact-formats, principles,
step-bars (both sites), the kit checks-reference card, the kit review-output guide, the seed
ADR, and the large-pr-review example. A three-surface patch would fork the bar against the
other ten — the defect class AC-043 exists to close.

Verify with: `grep -rln 'or a CI link' docs starter-kit checks --include='*.md' --include='*.yaml' | grep -v 'docs/adrs/' | xargs grep -LiE 'named human|manual' — returns nothing`

### AC-004 — The seed ADR does not foreclose manual evidence

The kit's seed ADR (`decisions/0001-adopt-swarm.md`) must state the evidence rule in the
amended AC-003 form, so an adopting HIL/embedded team does not formally decide its primary
verification mode can never produce a Pass.

Verify with: `grep -qiE 'named human|manual check' starter-kit/decisions/0001-adopt-swarm.md`

### AC-005 — Flaky suites cannot buy a Pass with one green run

docs/08 must state that a single green run of a known-flaky check is not Pass-grade evidence
and must point at the fix-flaky-test discipline (loop-N reproduction).

Verify with: `grep -qi 'flaky' docs/08-reviewing-output.md`

### AC-006 — Execution-restricted runs have a stated path

Both implement-task guides (kit and library) must state what an agent does when a Verify
command exists but cannot execute in its environment: produce a CI link or delegate the run,
otherwise record Blocked — never paste predicted output.

Verify with: `grep -LiE 'cannot execute|delegate the run|predicted output' starter-kit/.agents/skills/implement-task/SKILL.md docs/library/code-skills/implement-task/SKILL.md — returns nothing`

### AC-007 — Stochastic checks are protocol-pinned

docs/04's writing rules must state that a `Verify with:` over stochastic output pins its
protocol (same seed or fixed dataset, metric, threshold).

Verify with: `grep -qiE 'stochastic|same seed' docs/04-writing-specs.md`

### AC-008 — Performance discipline names its model-quality delta

The write-performance guide's trigger gains an eval-gated model-quality clause, and the guide
gains one scoped paragraph stating the stochastic delta (pinned seed/dataset, variance budget,
eval-run link as evidence) that points at docs/04's protocol rule (AC-007). The nine rules and
the Skip list stay systems-shaped — the guide stays focused per ADR-0064.

Verify with: `grep -qiE 'model quality|eval metric' docs/library/code-skills/write-performance/SKILL.md`

### AC-009 — Post-merge evidence has a documented pattern, inside the existing taxonomy

The advanced lifecycle page must document the pattern for requirements whose only honest
evidence is producible after merge (infra applies, soak metrics) using the taxonomy it already
has: the row records **Blocked**; the human routes it as an exception and records the waiver
(who · why · expiry) per the existing required fields; the merge proceeds on the waiver; a
follow-up review row supplies the Pass and lapses the waiver. Merged packets are never edited
— closure is a new row, not a mutation.

Verify with: `grep -qiE 'post-merge|soak' docs/reference/advanced-lifecycle.md`

### AC-010 — Work that arrives as code has a documented flow

docs/08 must carry the post-hoc flow for work with no upstream artifacts (an external PR, an
unspecced bug): snapshot the code-shaped work as intake, write the spec as an acceptance bar,
the reviewer produces all evidence.

Verify with: `grep -qiE 'arrives as code|post-hoc|without a task packet' docs/08-reviewing-output.md`

### AC-011 — Intake recognizes code-shaped and informal sources

The intake template's source examples must include a pull request shape and an informal
channel (email / DM) alongside tracker shapes.

Verify with: `grep -qE 'gh-pr|pull-request' starter-kit/templates/intake.md && grep -qiE 'email|dm' starter-kit/templates/intake.md`

### AC-012 — One spec, many platforms is legal, on every restating surface

The assigned-to-exactly-one-task coverage rule must carve out the platform case — the same
requirement id may be scoped to N platform tasks when each task verifies it on its own
platform — on **all three** surfaces that state the rule: the split-work guide, the advanced
lifecycle's decompose bar restatement, and step-bars. The carve-out states the coverage
semantics: a requirement reads green at spec level only when every platform task's packet
shows Pass; per-platform results never substitute for each other.

Verify with: `grep -qi 'platform' starter-kit/advanced/split-work/SKILL.md && grep -qi 'platform' docs/reference/advanced-lifecycle.md && grep -qi 'platform' docs/reference/step-bars.md`

### AC-013 — Solo adopters get the same independence rule, stated

docs/08 must state the solo default with "party" pinned at the actor of the diff: whoever
produced the diff — human hand or agent session — does not fill the packet. Agent implements →
the human reviews; human implements → a fresh agent session reviews. Self-review stays
mandatory and verdict-free (ADR-0056); the phrasing mirrors AC-030's team rule.

Verify with: `grep -qi 'solo' docs/08-reviewing-output.md`

### AC-014 — Waive-and-merge is representable, without touching row results

The review packet must record a waiver as **who waived · which rows · why · expiry**, with the
row's Result staying what the evidence says (the result enum is untouched), a terminal packet
status for the merged-with-waiver outcome (per Q1's recommended resolution), and the gate
honesty bar amended where it is stated (docs/08, step-bars V4) to read "no merge suggestion
past a Fail or unrouted Unverified **without a recorded waiver**". The template comment points
at the advanced lifecycle for expiry semantics; the glossary maps the user-tier phrase to the
reference-tier Waived annotation.

Verify with: `grep -qiE 'who waived|waived by' starter-kit/templates/review.md && grep -qi 'expiry' starter-kit/templates/review.md`

### AC-015 — The review packet names its reviewer

The review template's frontmatter must carry a `reviewer:` field, so the high-oversight band's
named-human requirement has a place to land.

Verify with: `grep -qE '^reviewer:' starter-kit/templates/review.md`

### AC-016 — Non-requirement Verify items keep one evidence home

The review template must state where non-AC Verify results (full suite, typecheck) live: their
pasted output stays under their Verify items in the task packet, the Run summary digests them,
and a failed, stale, or skipped suite routes through Human attention under the existing
missing-test-output trigger. The coverage table stays requirement-keyed — no generic rows.

Verify with: `grep -qi 'suite' starter-kit/templates/review.md`

### AC-017 — A blocked task is visible on the board, as board vocabulary

The status board's task-row vocabulary must include a blocked state as **board-only**
vocabulary, extending the precedent the template's own comment already draws for specs
("in-progress / done / stale are board states"); the task frontmatter enum is untouched. The
template additionally seeds a review example row, so a blocked review is visible as itself.

Verify with: `grep -E 'review-ready' starter-kit/templates/status.md | grep -qi 'blocked' && grep -qi 'REVIEW-' starter-kit/templates/status.md`

### AC-018 — The shipped board carries no template residue

`starter-kit/status.md` (the live board instance) must contain no `{{placeholder}}` rows —
it ships empty except a comment-only example row (a fictional-but-real-looking row is lorem
ipsum that doesn't look like lorem ipsum).

Verify with: `! grep -q '{{' starter-kit/status.md`

### AC-019 — The Commands table documents multi-context slots, contract-neutrally

The kit `AGENTS.md` Commands block must document the multi-context convention in two steps:
first, a monorepo with a root dispatcher (`turbo run test`, `make test`) keeps single slots;
where contexts truly diverge, the Commands table repeats once per context under a named
sub-heading — slot names stay the canonical set, the context lives in the heading, and one
line states resolution (a task resolves slots against the sub-table its Affected areas name).
No new slot-name grammar; the `cmd` prefix rules in checks.yaml are untouched.

Verify with: `grep -qiE 'per-repo|polyglot|dispatcher' starter-kit/AGENTS.md`

### AC-020 — The full slot set is discoverable from the kit

The kit `AGENTS.md` Commands block keeps its four starter rows and gains one line naming the
remaining contract slots (cmdInstall, cmdFormat, cmdValidate, cmdBenchmark, cmdSecurity) with
checks.yaml as their registry — "add a row when your estate has one". No empty placeholder
rows.

Verify with: `grep -q 'cmdSecurity' starter-kit/AGENTS.md`

### AC-021 — Adoption does not claim two minutes

docs/ADOPTING.md must state an honest time for path 1 — consistent with the measured range
(roughly 10–25 minutes across the audit's stopwatches, ~15 typical) — or no number.

Verify with: `! grep -qi 'two minutes' docs/ADOPTING.md`

### AC-022 — The copy-out pointer is its own step

docs/ADOPTING.md must state the For-code-repos copy-out as its own numbered step, not a
mid-sentence aside.

Verify with: `grep -qE '^[0-9]+\..*For code repos' docs/ADOPTING.md`

### AC-023 — The dedicated-repo path ends in a commit

docs/ADOPTING.md's dedicated-repo path must include the first commit, not stop at `git init`.

Verify with: `grep -qi 'git commit' docs/ADOPTING.md`

### AC-024 — The adopter is told the board is theirs to seed

docs/ADOPTING.md's fill step must name `status.md` as the adopter's board to seed — "replace
the example row with your first spec/task rows" — without claiming it carries placeholders
(AC-018 makes that claim false).

Verify with: `grep -A4 'Fill the' docs/ADOPTING.md | grep -q 'status.md'`

### AC-025 — The advanced tier is not under-enumerated

docs/ADOPTING.md must not carry a partial enumeration of the advanced tier's guides; it points
at the tier's own index instead.

Verify with: `! grep -q 'plus guides for the audit' docs/ADOPTING.md`

### AC-026 — Windows adopters are warned about symlinks

docs/ADOPTING.md or docs/10 must state what a default Windows clone does to the kit's symlinks
and the fallback (copy instead of symlink).

Verify with: `grep -qri 'windows' docs/ADOPTING.md docs/10-integrations.md`

### AC-027 — The integrations table covers Copilot

docs/10's per-tool table must carry a GitHub Copilot row (verified against Copilot's current
custom-instructions mechanism at write time — no guessed behavior).

Verify with: `grep -qi 'copilot' docs/10-integrations.md`

### AC-028 — The Cursor row pins the stable facts, links the rest

docs/10's Cursor row must state the durable shape — one guide → one `.mdc` rule file, manual
conversion, scope with globs rather than always-on — and link Cursor's own rules documentation
for the current frontmatter schema rather than transcribing it (a transcribed third-party
schema is a decay magnet).

Verify with: `grep -qi '\.mdc' docs/10-integrations.md`

### AC-029 — The implementation-guide library is discoverable from the user tier

docs/06 or docs/07 must point at `docs/library/code-skills/` for per-kind execution guides.

Verify with: `grep -ql 'library/code-skills' docs/06-creating-tasks.md docs/07-running-agents.md`

### AC-030 — Teams get a role note

docs/ADOPTING.md or docs/02 must state team defaults: who writes specs, who reviews, and that
the implementing agent's session never fills its own review packet.

Verify with: `grep -qiE 'who writes|who reviews|never fills its own' docs/ADOPTING.md docs/02-basic-workflow.md`

### AC-031 — "Worktree" is glossed at first user-tier use

The first user-tier use of "worktree" (README or docs/02) must carry a one-clause gloss.

Verify with: `grep -qiE 'worktree \(|worktrees? \(' README.md docs/02-basic-workflow.md`

### AC-032 — The glossary defines worktree

docs/reference/glossary.md must carry a worktree entry.

Verify with: `grep -qi 'worktree' docs/reference/glossary.md`

### AC-033 — Finding candidates have one staging path, shown not narrated

docs/09, the task template, and all three examples must agree that finding candidates stage in
the task packet's Findings section — the **only** staging surface (no sanctioned mirror; a
mirror is a second home with a courtesy title). The examples demonstrate the section itself,
not prose about it.

Verify with: `( for f in docs/examples/feature-from-jira.md docs/examples/bug-fix.md docs/examples/large-pr-review.md; do grep -A4 '^## Findings' "$f" | grep -qE '^- [A-Za-z]' || exit 1; done ) && grep -qi 'Findings section' docs/09-saving-findings.md — each example demonstrates a filled Findings section, not a bare heading`

### AC-034 — Performance work finds its flow

docs/02 must connect performance-shaped work to its flow — as a table row or in the
under-table note where Spec-amend, Audit, and Research are already glossed — stating the
baseline-first discipline and pointing at the write-performance guide.

Verify with: `grep -qi 'performance' docs/02-basic-workflow.md`

### AC-035 — Findings can originate from audits and inventories

The finding template's origin hint must accept `AUDIT-*` and `INV-*` ids alongside task and
review ids.

Verify with: `grep -qE 'AUDIT-|INV-' starter-kit/templates/finding.md`

### AC-036 — The risky-files examples include infrastructure

docs/08's **risky-files trigger examples** gain the infrastructure classes (IAM policies,
security groups, state moves, destroys) — explicitly no new trigger class and no edit to the
review template comment or checks.yaml, so the class list stays identical across all three
restating surfaces.

Verify with: `grep -qiE 'IAM|security group' docs/08-reviewing-output.md`

### AC-037 — One citation for the evidence rule

checks/README.md must cite the same source as docs/reference/checks.md for the
non-empty-paste rule (EVIBOUND, not REFLEXION).

Verify with: `! grep -q 'REFLEXION' checks/README.md`

### AC-038 — The contract declares the task status enum

checks.yaml's task_file must declare the task status enum as the four values
artifact-formats.md already defines — ready / running / review-ready / closed — with no Q2
dependency. Any future fifth value enters via an ADR amending artifact-formats first.

Verify with: `grep -qE 'ready.*running.*review-ready.*closed' checks/checks.yaml`

### AC-039 — No cmd-prefixed name is called non-contract

The adversarial-review task template must not describe any `cmd*`-prefixed value as
non-contract (the contract reserves the prefix): `cmdBenchmark` joins the resolvable slot
list, and the non-contract example moves into the consumer namespace (`project:*`).

Verify with: `! grep -qiE 'non-contract[^.]*cmd[A-Z]' starter-kit/advanced/adversarial-review/references/task-template.md`

### AC-040 — The shadow claim is scoped on both its surfaces

checks.yaml's header must scope its machine-readable-shadow claim to the **core checks** and
packet schemas it actually carries, and checks/README.md's "implement the checks reference
directly — they must agree" claim must gain the same scope (the SOL catalogue is prose-only).
Same commit, both surfaces, the existing term "core checks" — no third name for the set.

Verify with: `grep -qiE 'shadows? (only )?the core' checks/checks.yaml && grep -qiE 'SOL.*prose-only|prose-only.*SOL' checks/README.md`

### AC-041 — The threat-model template has no duplicated cross-reference

`starter-kit/advanced/threat-model.md` must not repeat the sol-reference cross-reference on
one line.

Verify with: `! grep -qE 'sol-reference.*sol-reference' starter-kit/advanced/threat-model.md`

### AC-042 — The spec template's notation note is current

`templates/spec.md` must not instruct adopters to "copy it in" for a card that already ships
inside the copied workspace.

Verify with: `! grep -qi 'copy it in' starter-kit/templates/spec.md`

### AC-043 — One evidence bar, kit and docs

The kit review-output guide and docs/08 must state the same rule for trusting the worker's
pasted output (re-run what you can; spot-check at least one green row) — no stricter shadow
bar in the kit.

Verify with: `manual — side-by-side read of the two rules, recorded with who judged in the review packet`

### AC-044 — The session maintains the board, the human reads it

The board's upkeep moves to the agent sessions that exist at each transition: the kit
`AGENTS.md` closing instruction gains the clause that the finishing agent flips its task's
board row (to review-ready, with the packet link at close), the review-output guide's closing
checklist gains the review-ready → closed flip, and docs/02/09 state that the session does the
edit while the human reads the board. Convention level; no new artifact. This is the only
transformation that attacks the audit's unanimous sustainability floor (11/11 predicted the
hand-edited board dies first).

Verify with: `grep -qiE 'board row|update the board|updates the board' starter-kit/AGENTS.md`

### AC-045 — The spot-check leaves a trace

The review template carries one line — `Spot-checked: {{which green row you re-ran}}` —
template-carried, not contract-required (the AC-015 envelope), so a rubber-stamped packet and
a spot-checked packet are no longer byte-identical. AC-043's rule text points at it.

Verify with: `grep -q 'Spot-checked:' starter-kit/templates/review.md`

### AC-046 — The run summary has a custody path when the agent can't write the workspace

docs/07 must state who writes the Run summary section in an external-workspace or sandboxed
topology: the runner or human relays the agent's emitted summary into the task packet at
handoff.

Verify with: `grep -qiE 'cannot write|relays? the' docs/07-running-agents.md`

### AC-047 — Tracker-owned task state gets an honest board exit

docs/02's skip rules gain the tracker clause: when a tracker (Jira/Linear) owns task state,
the board is optional — keep the review-packet links in the tracker rows instead.

Verify with: `grep -qiE 'tracker.*board|board.*tracker' docs/02-basic-workflow.md`

### AC-048 — The contract states its frontmatter-list semantics

checks.yaml must state in one line whether its frontmatter lists are minimum-required (extra
keys legal) or exhaustive — decided deliberately, so the kit's own `reviewer:` field (AC-015)
cannot read as non-conformant against the contract.

Verify with: `grep -qiE 'extra keys' checks/checks.yaml`

### AC-049 — The AUDIT- prefix is registered

docs/reference/artifact-formats.md's ID-conventions line must register `AUDIT-*` (two shipped
templates already use it; AC-035 widens its reach).

Verify with: `grep -q 'AUDIT-' docs/reference/artifact-formats.md`

### AC-050 — The flagship demo points at the uncooperative case

docs/examples/large-pr-review.md must acknowledge the uncooperative variant (no packet, silent
author) and point at the AC-010 post-hoc flow — the demo's "main use case" claim currently
shows only the cooperative implementer.

Verify with: `grep -qiE 'post-hoc|uncooperative|without a task packet|arrives as code' docs/examples/large-pr-review.md`

### AC-051 — The Bug flow names its no-spec exit

docs/02's flow notes must state where a bug with no covering spec goes — the AC-010 post-hoc
flow — at the surface where the week-one reader dead-ends ("Spec amend" presupposes a spec).

Verify with: `grep -qiE 'no covering spec|without a spec' docs/02-basic-workflow.md`

### AC-052 — The packet author is a fresh party, at the rule's own site

docs/08's packet-author line ("you or your agent fills the template") must name a fresh
session or second party — never the implementing session — mirroring AC-013/AC-030's
invariant at the site where a junior actually reads it.

Verify with: `grep -qiE 'fresh (agent )?session|second agent' docs/08-reviewing-output.md`

## Open questions

None blocking — Q1–Q3 closed by [ADR-0072](../../../docs/adrs/0072-run-summary-and-format-amendments.md)
(2026-06-12), in the challenge round's recommended forms:

- Q1 → waiver = record (who · which rows · why · expiry) + one additive terminal review
  status `waived`; row results closed at four. (resolved)
- Q2 → blocked is board-only vocabulary; task frontmatter and contract enums stay the four
  values. (resolved)
- Q3 → root-dispatcher single slots first; per-context Commands sub-tables where contexts
  diverge; no new slot-name grammar. (resolved)

Decisions already made (recorded, closed): the run summary lives **in the task packet** as a
digest section (Verify keeps the evidence; the contract's prose notes the summary cites,
never replaces — coherence's drift guard). The retrofit flow lands in **docs/08** plus the
intake template's source shapes (no new page). The reviewer field (AC-015) and spot-check
line (AC-045) are template-carried but **not** contract-required. ADR-0072 must record
partial supersession of ADR-0060's addendum ("the worker's run record folds into the review
packet") — AC-001 reverses that clause.

## Affected areas

- `starter-kit/templates/{task,status,intake,review,finding,spec}.md`, `starter-kit/AGENTS.md`,
  `starter-kit/status.md`, `starter-kit/decisions/0001-adopt-swarm.md`,
  `starter-kit/examples/feature-from-ticket/`,
  `starter-kit/advanced/{split-work/,threat-model.md,adversarial-review/,checks-reference.md}`
  — sequenced by `CHANGE-dx-formats`
- `checks/checks.yaml`, `checks/fixtures/`, `checks/README.md`
- `docs/02, 04, 06, 07, 08, 09, ADOPTING, 10`, `docs/reference/{glossary,advanced-lifecycle,
  artifact-formats,cheatsheet,step-bars,principles}.md`, `docs/01` (evidence-sentence sweep)
- `starter-kit/.agents/skills/{implement-task,review-output}/`,
  `docs/library/code-skills/{implement-task,write-performance}/`
- `docs/examples/` (all three)
- one new ADR recording the format amendments, the Q1–Q3 resolutions, and the ADR-0060
  addendum supersession

## Dropped from sources

<!-- Every register finding not covered by an AC above, with the reason. -->

- Elena docs/03:54, both halves — cross-workspace board aggregation **and** per-engagement
  portfolio placement guidance: deferred together to the swarm-cli `swarm status` design;
  placement advice without the aggregation answer would promise what the board cannot deliver.
- Priya advanced/README:26 — save-findings ships in the optional tier though Close is core:
  deliberate for now; the Close rule itself is taught in core docs (02/09) and the kit
  AGENTS.md instruction 5, and the kit's core stays three guides (ADR-0064). Revisit if pilot
  evidence shows the Close step skipped because the guide was missing.
- Sofia spec-template Affected-areas — authoring guidance for non-coders: deferred; the field
  is legitimately engineer-filled and a PM-facing variant needs its own design pass.
- Marco docs/03:47 — flat-vs-folder naming tiebreaker: deliberate optionality stands; revisit
  only on evidence of the two schemes colliding inside one workspace.
- The audit's methodology limitations (score uniformity, enacted products) — about the audit
  instrument, not the product.
