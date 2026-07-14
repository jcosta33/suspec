# Checks fixtures — violations

_Advanced design note — maintainer rationale; not needed to use Suspec._

One minimal negative fixture per violation class. Each snippet must be flagged by a
checker applying [`../checks.yaml`](../checks.yaml) — or by a reviewer applying
[the checks reference](../../docs/reference/checks.md) by hand — with exactly the named
check at the named severity. A checker that stays silent on any of these is wrong; so is
one that reports a different check. Inert fixture data — nothing here runs.

---

## V1 — missing implementation evidence (C023 `task-evidence`, hard error)

A `review-ready` task packet's Verify section, every box checked, no output anywhere:

```markdown
## Verify

- [x] `npm test -- export-json.spec.ts` (AC-001)
- [x] `npm run lint` (AC-002)
```

**Expected:** C023 fires — the Verify section contains checked completion claims but no pasted
raw output with a numeric exit, a visible `CI:` or `CI link:` URL, or justified `n/a`. Bare claims do not satisfy the
artifact-level check. The same section at `ready` or `running` does not run C023.

A claim-only fence also fails even with a numeric exit:

````markdown
## Verify

- [x] `npm test`

  Exit status: 0

  ```text
  All tests passed.
  ```
````

**Expected:** C023 fires — after trimming, the entire fence body matches the claim-only predicate
`^(all )?(tests?|checks?) (pass(ed)?|succeeded)\.?$` case-insensitively. A real output line such as
`1 test passed` does not match that predicate and satisfies the fenced-output half when paired with
a numeric `Exit status:`.

A bare CI URL also fails:

```markdown
## Verify

- [x] https://example.test/pr/412/checks/88
```

**Expected:** C023 fires — CI evidence is machine-visible only when the URL follows `CI:` or
`CI link:`. `- CI: https://example.test/pr/412/checks/88` satisfies this evidence form.

---

## V2 — Supported with an empty Evidence cell (`supported-needs-evidence` / C016, hard error)

A review packet's coverage table:

```markdown
| ID     | Assessment | Evidence |
| ------ | ---------- | -------- |
| AC-001 | Supported  |          |
```

**Expected:** flagged — an empty Evidence cell means **Unverified**, never **Supported**.
The row's correct content is `Unverified` plus a Findings or Open decisions entry. Implemented as
**C016**: blocking at check time — a structural contradiction, not a judgment call; the human
owns what blocks a merge.

---

## V3 — `TBD` at `status: ready` (`no-tbd-at-ready` / C007, hard error)

A spec with frontmatter `status: ready` whose Requirements section reads:

```markdown
### AC-001 — Cached repeat queries

When the same query repeats within a session, the search service must return
the cached result.

Verify with: `search-cache.spec.ts`

### AC-002 — TBD (waiting on product)
```

**Expected:** flagged — C007 is a spec check: `ready` means tasks may be cut from this
spec, and a `TBD` requirement hands an agent an undecided behavior. At `status: draft`
the same line is fine. (A `TBD` inside a task packet is caught one step earlier — the
task's scope ids must resolve against the spec, and `AC-002` here resolves to nothing.)

---

## V4 — requirement without a `Verify with:` line (C003 `verify-with`, hard error)

A spec's Requirements section:

```markdown
### AC-003 — rate-limit responses

When a client exceeds 100 requests per minute, the API must return 429.
```

**Expected:** flagged — no `Verify with:` line (SOL form: no `VERIFY BY`). The
verification line is the highest-value line in a spec; without it the requirement can
only ever review as Unverified.

---

## V4b — missing intent (C021 `intent-present`, hard error)

A spec with requirements but no non-empty `## Intent` section:

```markdown
---
type: spec
id: SPEC-no-intent
title: Missing intent
status: draft
owner: test
sources: [ISSUE-1]
---

## Requirements

### AC-001 - Observable behavior

The command must return one record.

Verify with: `npm test -- one-record`
```

**Expected:** C021 fires. Requirements without intent do not state why the contract exists.

---

## V4c — empty spec shape (C025 `spec-shape`, hard error)

```markdown
---
type: spec
id: SPEC-empty-requirements
status: draft
sources: [ISSUE-1]
---

## Intent

Define one observable behavior.

## Requirements
```

**Expected:** C025 fires because `Requirements` contains no parsed requirement. C021 does not fire;
the intent is present. The same check rejects a missing ID or status and duplicate or missing
`Intent` or `Requirements` sections.

---

## V5 — duplicate requirement ID (C001 `unique-ids`, hard error)

One spec, two headings claiming the same ID:

```markdown
### AC-001 — accept the coupon code

### AC-001 — reject expired coupons
```

**Expected:** flagged — `AC-001` appears twice in one file. Tasks scope work and reviews
report coverage by requirement ID; a duplicated ID makes both ambiguous.

---

## V6 — open blocking question at `closed` (C024 `closed-task-resolved`, hard error)

A task packet with frontmatter `status: closed` whose Findings section contains any one of these
canonical labels with a substantive value:

```markdown
## Findings

* Open question (blocking): should a refresh rotate the whole token family, or
  only the access token? Undecided — AC-002 implemented on a guess.

1. Blocking: token-family rotation remains undecided.

+ Blocked questions: should refresh rotate the whole token family?
```

**Expected:** flagged — `closed` is terminal, and a blocking question is still open inside
the packet. The status must stay non-terminal until the question is resolved. C024 recognizes the
labels after unordered (`-`, `*`, `+`) and ordered (`N.`) list markers. The canonical labels with
`none` or `n/a` instead are resolved sentinels and do not fire C024.

---

## V23 — invalid review structure (unnumbered review contract, hard error)

Each packet below violates the deterministic review schema without minting a C-code:

```markdown
---
type: review
id: ""
spec: SPEC-invalid
reviewer: fixture-reviewer
decision: approved
waivers: [AC-001]
---

## Requirement coverage
```

```markdown
---
type: review
id: REVIEW-invalid-acceptance
spec: SPEC-invalid
reviewer: fixture-reviewer
decision: accepted
waivers: [AC-001, AC-001]
---

## Requirement coverage

| ID | Assessment | Evidence |
|---|---|---|
| AC-001 | Unsupported | failing output |
| AC-002 | Blocked | dependency unavailable |
| AC-003 | Partially supported | incomplete output |

## Open decisions

- Decide whether to accept AC-001.
```

**Expected:** the first packet fails for an empty ID, an invalid decision option, and an empty required
coverage section; waivers are forbidden before acceptance. The second fails because accepted
waivers contain a duplicate, and an accepted review cannot retain a non-empty Open decisions
section or a `Blocked` assessment. `Partially supported` is outside the assessment enum; `Blocked`
is valid before acceptance but cannot be waived or retained at acceptance.

The same blocking option-value error applies to spec `status` outside `draft | ready`, optional
spec `format` outside `sol`, and task `status` outside `ready | running | review-ready | closed`.

A present Change-plan coverage table uses the same three columns and assessment options:

```markdown
## Change-plan coverage

| ID | Assessment | Evidence |
|---|---|---|
| PG-001 | Supported | |
| PG-002 | Partially supported | incomplete output |
| PG-003 | Blocked | dependency unavailable |
```

**Expected:** the table is parsed. C016 fires for PG-001, the invalid assessment is blocking, and
every non-Supported preservation row blocks `decision: accepted`. C012, C013, and requirement-waiver
reconciliation ignore all three rows.

---

## V24 — inexact SOL QUESTION marker (blocking parse error)

Each header is malformed:

```sol
QUESTION Q-001:
QUESTION Q-002 [Blocking]:
QUESTION Q-003 [deferred]:
```

**Expected:** parsing fails. The only accepted headers use exact lowercase `[blocking]` or
`[non-blocking]`, followed immediately by `:`. No separate SOL check code is emitted.

---

## V7 — out-of-scope change (review checklist)

A task whose Affected areas list `src/auth/refresh.ts`, reviewed by a packet that says:

```markdown
## Changed files

- `src/auth/refresh.ts`
- `src/billing/invoice.ts`

## Findings

None — all requirements pass.
```

**Expected:** the reviewer flags `src/billing/invoice.ts` because it is outside the task's Affected
areas and no Findings or Open decisions entry routes it. The deterministic checker receives no diff
and does not claim this result.

---

## V8 — duplicate `id:` across files (C002 `duplicate-id`, hard error)

Two spec files checked in the same invocation, both claiming the same frontmatter id:

```markdown
## <!-- specs/checkout/spec.md -->

type: spec
id: SPEC-checkout

---

## <!-- specs/checkout-v2/spec.md -->

type: spec
id: SPEC-checkout

---
```

**Expected:** flagged — two files claim `SPEC-checkout`, so every cross-reference to that
id is ambiguous. Requirement ids are spec-scoped: `AC-NNN` may recur freely in
another spec (a cross-spec reference qualifies as `SPEC-x#AC-NNN`); a duplicated id inside one
file is C001, not C002.

---

## V9 — two strength words in one requirement (C004 `one-strength-word`, warning)

```markdown
### AC-002 — Expired session response

When the session is expired, the API must return 409 and should log the
session id.

Verify with: `npx jest sessions/expired`
```

**Expected:** flagged as a split-candidate advisory — "must … and should …" in one requirement.
Two strength words usually means two requirements; the report recommends a split, it does not
perform one, and it never demands "exactly one"; the requirement needs at least one.

---

## V12 — empty `sources:` (C008 `sources-named`, warning)

```markdown
---
type: spec
id: SPEC-export-json
title: JSON export
status: draft
owner: data-team
sources: []
---
```

**Expected:** flagged — the frontmatter names no origin. A spec with no named source
cannot be checked for fidelity against what was asked.

---

## V13 — named source does not resolve (C009 `broken-source-link`, hard error)

```markdown
---
type: spec
id: SPEC-export-json
sources: [sources/export-json.md]
---
```

…where `sources/export-json.md` does not exist relative to the spec's own directory
(resolution is artifact-relative).

**Expected:** flagged — a path-shaped ref in `sources:` resolves to nothing. A bare
external tracker id (`JIRA-123`) is exempt — naming one at all is C008 territory.

---

## V14 — preserved id resolves nowhere (C010 `preserves-refs-resolve`, hard error)

A change plan whose frontmatter preserves a requirement its source spec never declared:

```markdown
---
type: change-plan
id: CHANGE-sessions-merge
kind: refactor
sources: [SPEC-checkout]
preserves: [SPEC-checkout#AC-099]
---
```

…where `SPEC-checkout` has no `AC-099`, and the plan's guarantee table declares no
`PG-099` either.

**Expected:** flagged — every entry in `preserves:` and the guarantee table must resolve
to a real requirement ID or an explicit plan-local `PG-NNN`. A guarantee pointing at
nothing protects nothing.

---

## V15 — migration plan with no waves (C011 `waves-present`, warning)

A change plan with `kind: migration` whose Transformation waves section is empty:

```markdown
---
type: change-plan
id: CHANGE-api-v2
kind: migration
---

## Transformation waves

(to be planned)
```

**Expected:** flagged — a migration, rewrite, or schema-change plan needs a non-empty
waves section, each wave naming its verify step. A placeholder is not a wave; an
unsequenced migration is the half-migrated codebase waiting to happen.

---

## V16 — run summary missing at `closed` (C022 `task-shape`, hard error)

A task packet with frontmatter `status: closed` whose sections end at
`## Findings` — no `## Run summary` anywhere in the file.

**Expected:** flagged — `Run summary` is a required section of the task packet
(checks.yaml `required_sections`). A closed task with no handoff digest leaves
the review packet nothing to read; the Verify pastes hold the evidence, the
summary indexes it.

---

## V18 — coverage gaps against a ready spec (C012 `coverage`, warning)

A ready spec `SPEC-x` defining `AC-001`, `AC-002`, `AC-003`; a task whose
`scope` is `[AC-001, AC-002, AC-003]`; reviewed by a packet whose coverage table omits `AC-003`
and adds a row for `AC-009` (an id the source spec does not define):

```markdown
## Requirement coverage

| ID     | Assessment | Evidence |
| ------ | ---------- | -------- |
| AC-001 | Supported  | pasted   |
| AC-002 | Supported  | pasted   |
| AC-009 | Supported  | pasted   |
```

**Expected:** flagged — `AC-003` is in scope but has no coverage row (**uncovered**), and `AC-009`
names an id absent from the source spec (**orphan**). Review requires the source spec to be exactly
`ready`; draft, missing, and unknown statuses fail before C012. Surfaces facts, never a verdict.

---

## V19 — a verify block's cmd disagrees with the named command (C013 `verify-evidence-binding`, hard error)

A ready spec whose `AC-001` carries `` Verify with: `npm test -- auth-refresh.spec.ts` ``, reviewed
by a packet whose `AC-001` Supported row carries a structured `verify` block (a fenced sibling, info-string
`id=AC-001 cmd="npm test -- other.spec.ts" result=pass`) recording a **different** command.

**Expected:** flagged `cmd-mismatch` as a hard error — the block's recorded `cmd` does not
match the requirement's named Verify command. The comparison normalizes away surrounding backticks,
a trailing `(parenthetical)` note,
and whitespace, so the canon's own backtick-wrapped Verify-with form does **not** false-fire;
only a genuine disagreement trips it. A block whose `cmd` matches and reads `result=pass` is
consistent → no finding; a Supported row with only the free-form Evidence cell stays a warning, never
machine-rejected. A consistency fact, never a verdict.

---

## V20 — a dangling inline citation (C015 `citation-resolves`, warning)

A spec whose frontmatter `sources:` names a `sources.md` (resolved against the spec's own
directory), whose `AC-001` makes an empirical claim citing `[[FAROS2025]]` — a `[[KEY]]` whose key
has no `<a id="FAROS2025">` anchor in that `sources.md`:

```markdown
---
type: spec
id: SPEC-citation-dangle
status: ready
sources:
  - ../../docs/research/sources.md
---

### AC-001 — survey-grounded recommendation

The reviewer must apply the survey's recommended ordering, per [[FAROS2025]].

Verify with: a test.
```

…where the named `../../docs/research/sources.md` declares anchors for `GOOGLESA`, `MAST`,
`SMELLS`, … but **no** `<a id="FAROS2025">`.

**Expected:** flagged — `[[FAROS2025]]` resolves to no `<a id>` anchor in the named `sources.md`.
This is the "citations are contextual" discipline made toolable: a load-bearing claim must cite a
verified entry whose anchor exists. Skip-guarded — a spec that names no resolvable `sources.md`, or
cites nothing, is never flagged; the dangle fires only when a `sources.md` is resolvable **and** a
`[[KEY]]` has no matching anchor (v0 = dangling-anchor only). A `[[KEY]]` that resolves (e.g.
`[[GOOGLESA]]` above) is consistent → no finding. Surfaces a fact, never a verdict.

---

## V21 — a letter-suffixed requirement id (C019 `malformed-requirement-heading`, warning)

A spec heading shaped like a requirement id, but with a letter suffix:

```markdown
### AC-004a — the split half of a requirement

When the token expires, the client must refresh it.
Verify with: `npm test -- refresh`
```

**Expected:** flagged — `AC-004a` is not a legal requirement id (`AC-NNN` is digits-only), so the parser
reads the heading as plain prose: the requirement silently vanishes from scope and coverage, and a
checker would report "clean" while an AC is invisible. The warning makes the disappearance visible.
The fix is a digits-only id — a split requirement gets its own number (`AC-007`), not a suffix.

---

## V22 — a review's `task:` does not match the handed task packet (C020 `unresolvable-ref`, hard-error)

A review packet whose frontmatter `task:` names a task id, checked against a task packet that
identifies as a different task:

```markdown
---
type: review
id: REVIEW-checkout-expiry
spec: SPEC-checkout
task: TASK-checkout-expiry-typo
reviewer: fixture-reviewer
decision: pending
---

## Requirement coverage

| ID     | Assessment | Evidence |
| ------ | ---------- | -------- |
| AC-001 | Supported  | pasted   |
```

…checked as `suspec check review.md --spec spec.md --task task.md`, where `task.md`'s frontmatter
`id:` is not `TASK-checkout-expiry-typo`.

**Expected:** flagged `unresolvable-ref` (hard-error) — the review's `task:` does not resolve to the
task packet it was handed, so C012/C013/C016 would key on the wrong slice; without it a
typo'd/renamed task ref silently bypasses the honesty checks. Blocking (structural, like C016).
Deliberately narrow — C020 keys on the `task:` ref only; C027 separately binds `spec:`. A task-less
review (no `task:` frontmatter) is out of C020's scope entirely and reconciles spec-keyed, with no
`--task`. (A review
that names a task but is checked with no `--task` never reaches this check: the missing flag is
itself a blocking usage error.)

---

## V25 — a review evidence link resolves nowhere (C026 `evidence-receipt-resolves`, hard error)

```markdown
| ID | Assessment | Evidence |
| --- | --- | --- |
| AC-001 | Supported | [E-001](./evidence-missing.md#E-001) |
```

**Expected:** C026 fires when `evidence-missing.md` is absent beside the review or lacks
`<a id="E-001"></a>`. It checks explicit local path and anchor wiring, not evidence truth or age.

---

## V26 — a review names the wrong spec (C027 `review-spec-ref`, hard error)

```yaml
type: review
id: REVIEW-checkout
spec: SPEC-checkout-v2
reviewer: fixture-reviewer
decision: pending
```

Checked with `--spec spec.md`, where `spec.md` identifies as `SPEC-checkout`.

**Expected:** C027 fires. Coverage against the wrong requirement authority is structurally invalid,
including when either side omits its spec ID.
