---
type: spec
id: SPEC-multi-repo-workspace
title: Name the multi-repo workspace and finish its conventions
status: ready
owner: José Costa
sources:
  - self — owner direction (2026-06-12): the scaffolding must work well for both the
    co-located and the central-orchestration shapes; family case = swarm canon /
    starter-kit / skills / cli / website; general case = features spanning
    frontend + backend repos
---

# Name the multi-repo workspace and finish its conventions

## Intent

A dedicated workspace repo governing several code repos already is Swarm's "central
orchestration" shape (ADR-0050/0060/0062) — but the docs sell it in two shy paragraphs under a
label ("External") used nowhere else, and three conventions it needs are unstated. This spec
gives the shape one canonical user-tier name — the **multi-repo workspace** — states the
placement decision rule with both recorded arms, and lands the missing conventions. No new
architecture: the format wave already built the mechanics (per-context Commands sub-tables,
the context carve-out, the run-summary custody relay, the session-maintained board). A
two-lens challenge round (architect · canon-coherence) reshaped every naming AC: no
hub/spoke vocabulary anywhere — one name, glossary-mapped.

## Non-goals

- No new artifact types, templates (one comment in the task template only), or checks-contract
  change (checks.yaml gains one *comment* line, the ADR-0072(e) precedent).
- No change plan: every edit is additive doc/guide content (docs/05's skip rule applies).
- No hub-side orchestration contracts in future-cli — composition of the existing per-repo
  contracts is stated; cross-repo fan-out commands wait for their own ADR.
- No cross-workspace board aggregation (the recorded DX-audit drop stands — a multi-repo
  workspace is ONE workspace with one board, not an aggregator over many).
- No fourth flagship example (ADR-0065 stands); the flow extension lives in docs/03's
  existing paragraphs.

## Requirements

### AC-001 — The multi-repo workspace is the named shape, replacing the orphan label

docs/03's placement section must present the dedicated workspace repo under the name the rest
of the product already uses ("dedicated workspace repo" — README, ADOPTING, the kit), name its
governs-several-code-repos use the **multi-repo workspace** (the same kit in its own repo,
governing several code repos), and retire the "External" label. The flow extension is one or
two sentences in the existing code-repos paragraph (spec in the workspace → repo-scoped
tasks → each code repo's PR links its workspace review packet) — no standalone sketch block.

Verify with: `grep -qi 'multi-repo workspace' docs/03-where-files-live.md && ! grep -qE '^\- \*\*External' docs/03-where-files-live.md`

### AC-002 — The placement decision rule is stated, with both recorded arms

docs/03 must state the rule: co-located while features live in one repo and the same people
shape specs and merge code; the multi-repo workspace when features routinely span repos — a
spec inside repo A is invisible to repo B's developers and drifts unowned — or when the
people shaping specs are not the people merging code. The existing drift-cost note stays
adjacent.

Verify with: `grep -qiE 'routinely span' docs/03-where-files-live.md && grep -qi 'drift' docs/03-where-files-live.md`

### AC-003 — The context carve-out covers repos, with its entry condition

The one-requirement-N-tasks carve-out must read as a **context** carve-out — platform *or
repo* — on all three restating surfaces (the split-work guide, step-bars' decompose bar, the
advanced lifecycle's coverage checkpoint), and each must state the entry condition: the repo
case applies only when the requirement is **independently verifiable in each repo** (the
contract-test shape — an API honored on both sides). A behavior that only exists when both
repos meet decomposes into per-repo requirements instead; the carve-out never covers a
requirement no single task verifies.

Verify with: `grep -qiE 'platform or repo' starter-kit/advanced/split-work/SKILL.md docs/reference/step-bars.md docs/reference/advanced-lifecycle.md | wc -l → 3, and grep -qi 'independently verifiable' starter-kit/advanced/split-work/SKILL.md`

### AC-004 — Affected areas can carry a context prefix, stated completely

The task template's Affected-areas comment and docs/06 must state the convention whole: an
entry may carry a context prefix that is exactly a Commands sub-heading's context name
(`### Commands (web)` → `web: src/checkout/…`); a task's entries name **at most one
context** — entries spanning contexts are the signal to split per the AC-003 carve-out or
ordinary decomposition; the prefix is task-body content owned by the workspace, distinct from
the placeholder namespaces (one clause in docs/06); and checks.yaml gains one comment noting
matchers compare the path part of a prefixed entry (comment only — the contract is untouched).

Verify with: `grep -qi 'context prefix' starter-kit/templates/task.md && grep -qi 'context prefix' docs/06-creating-tasks.md && grep -qi 'context prefix' checks/checks.yaml`

### AC-005 — The code-repo footprint's internal term is glossary-mapped, not promoted

docs/reference/glossary.md must map ADR-0062's internal term — code-repo adapter ↔ the
everyday noun (the workspace pointer + gitignore lines a code repo carries; today, nothing
else) — in the reverse-map table. The user tier keeps its plain nouns and its strongest line
("a code repo needs nothing") unbranded.

Verify with: `grep -qi 'code-repo adapter' docs/reference/glossary.md && ! grep -qi 'code-repo adapter' docs/03-where-files-live.md`

### AC-006 — The future CLI states multi-repo as composition, not a mode

docs/reference/future-cli.md must note, at its config section, that several code repos may
each point their `.swarm/config.yaml` at the same workspace — one workspace governing several
code repos composes from the per-repo contracts as written; orchestration *across* governed
repos from the workspace side is explicitly outside the current command contracts and waits
for its own ADR. No "hub mode" or other coined term.

Verify with: `grep -qi 'governs several code repos' docs/reference/future-cli.md`

### AC-007 — The kit names the governs-several case on its existing line

starter-kit/README's dedicated-repo copy line gains one clause — "for one project, or
governing several code repos" — no third destination bullet; the two-placement model stands.

Verify with: `grep -qiE 'several code repos' starter-kit/README.md`

### AC-008 — The glossary defines the multi-repo workspace

docs/reference/glossary.md must carry a multi-repo workspace entry (alphabetical, main table).

Verify with: `grep -qi 'multi-repo workspace' docs/reference/glossary.md`

### AC-009 — One name, swept

User-tier surfaces use "dedicated workspace repo" for the placement and "multi-repo workspace"
for the governs-several shape: docs/03's "External" label is gone (AC-001's negative gate) and
docs/07's custody line says "a dedicated workspace repo" rather than "an external workspace".
No surface coins synonyms (hub, spoke, hub mode, external workspace) as labels.

Verify with: `! grep -qi 'an external workspace' docs/07-running-agents.md && [ -z "$(grep -rliE 'hub-and-spoke|hub mode|hub workspace' docs starter-kit --include='*.md' | grep -v 'docs/adrs/')" ] — ADR bodies may name the rejected vocabulary`

### AC-010 — SOL adapter resolution knows about sub-tables

docs/reference/structured-requirements.md's adapter-resolution sentence must state that in a
workspace with per-context Commands sub-tables, the adapter resolves against the sub-table the
task's Affected areas name (falling back to the single table otherwise).

Verify with: `grep -qi 'sub-table' docs/reference/structured-requirements.md`

## Open questions

None blocking. One recorded decision: the Swarm family's own multi-repo workspace (a
`swarm-workspace` repo for canon/kit/skills/cli/website) is an owner action outside this
spec — this spec makes the shape first-class for any adopter. Derived-content repos
(starter-kit, skills) get no install; code repos get the existing three-line footprint.

## Affected areas

- `docs/03-where-files-live.md`, `docs/06-creating-tasks.md`, `docs/07-running-agents.md`
- `docs/reference/{glossary,step-bars,advanced-lifecycle,future-cli,structured-requirements}.md`
- `starter-kit/templates/task.md` (comment only), `starter-kit/README.md`,
  `starter-kit/advanced/split-work/SKILL.md`
- `checks/checks.yaml` (comment only)
- `docs/adrs/0073-*.md` (new) + ledger row

## Dropped from sources

- Per-repo full installs for derived-content repos (starter-kit, skills) — the owner direction
  itself rejects them: their intent lives upstream; a workspace inside the kit would govern
  itself with a copy of itself.
- A spoke-side scaffold beyond the existing footprint — the footprint is three lines and
  ADOPTING already carries them; packaging would add ceremony to the lightest surface in the
  product.
- "Hub-and-spoke" as product vocabulary — challenge-round kill: the metaphor minted six
  lexemes for things the product already names; the descriptive name does all the work.
- A standalone end-to-end sketch block in docs/03 — half-duplicates the page's existing flow
  spine; collapsed into the code-repos paragraph (challenge round, architect lens).
