# `.agents/skills/` — the dev subset (manifest)

`.agents/skills/` is **not** the shipped catalogue. It is the curated set of guides for working
**on this repo** — itself a docs/spec workspace, not a typical adopter. The shipped surfaces are
the kit's core guides (`starter-kit/.agents/skills/`), the optional tier (`starter-kit/advanced/`), and the
reference pages under `docs/reference/`.

## Single-sourcing

A rule lands in `docs/` first (with an ADR under `docs/adrs/`), then the kit, then — for the
guides mirrored here — this subset. Never change a rule only here; this subset must not become a
competing authority. Derivation order and per-ADR status:
`.agents/audits/repositioning-propagation.md`.

## Census — included, and why

| Guide                                              | Counterpart                                                                                                   | Why it is here                                                                                                                                                             |
| -------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `adversarial-review`                               | `starter-kit/advanced/adversarial-review/`                                                                     | Deep hostile re-review of a branch (six adversarial questions, run-it-yourself). Keep the pair in sync (propagation matrix).                                               |
| `review-output`                                    | `starter-kit/.agents/skills/review-output/`                                                                            | This repo's own merge discipline: judging a change set against its stated intent with pasted evidence. Carries the dev specifics (grep gates, link audits, no test suite). |
| `save-findings`                                    | the kit finding convention (`starter-kit/templates/finding.md`); advanced model at `docs/reference/memory.md` | The Close-step rule — route durable discoveries before closing. Dev routing targets: `docs/` + ADR, `.agents/audits/`, the glossary, the sources bibliography.             |
| `empirical-proof`                                  | folded into the kit's three core guides                                                                       | The evidence rules in standalone form: a completion claim binds to pasted output; without it the result is Unverified, never Pass.                                         |
| `write-audit` (+ `references/task-template.md`)    | `starter-kit/advanced/write-audit/`                                                                           | Dev audits under `.agents/audits/` are this repo's main self-assessment instrument.                                                                                        |
| `write-research` (+ `references/task-template.md`) | `starter-kit/advanced/write-research/`                                                                        | Evidence surveys feed this repo's ADRs (e.g. the plan-validation work).                                                                                                    |
| `write-rfc`                                        | template `starter-kit/advanced/rfc.md`                                                                        | Pre-decision proposals whose accepted form lands as an ADR in `docs/adrs/`.                                                                                                |
| `persona-surveyor`                                 | `starter-kit/advanced/persona-surveyor/`                                                                      | Synced with the kit's guide; the breadth-survey evidence discipline.                                                                                                       |
| `persona-skeptic`                                  | folded into the kit's `review-output`                                                                         | Kept standalone here: the review stance plus the adversarial self-review at completion (ADR-0056).                                                                         |
| `persona-architect`                                | folded into the kit's `write-spec`                                                                            | Dev stance for shaping specs and reference pages: intent not implementation; survey before inventing.                                                                      |
| `persona-auditor`                                  | folded into the kit's `write-audit`                                                                           | Dev stance for `.agents/audits/` work: observation-only, file:line per finding, severity by blast radius.                                                                  |
| `persona-researcher`                               | folded into the kit's `write-research`                                                                        | Dev stance for depth research against primary sources — the `docs/research/sources.md` discipline.                                                                         |
| `persona-documentarian`                            | none shipped (docs are this repo's product)                                                                   | Dev stance for human-facing pages: one frame throughout, every example run, every claim cited.                                                                             |

## Census — omitted, and why

| Kit guide                                                                                           | Why not here                                                                                                               |
| --------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| `write-spec`, `implement-task`                                                                      | This repo is developed by editing the framework docs directly; it does not run the spec → task → implement loop on itself. |
| `write-bug-report`, `write-prd`, `write-change-plan`, `write-inventory`, `spec-check`, `split-work` | Optional-tier guides for adopter work shapes this repo does not perform; available in the kit when needed.                 |

Templates are not skills: the frozen formats live at `starter-kit/templates/` and
`starter-kit/advanced/` — link to them, never restate them.

## Intentional divergence (not drift to reconcile)

Two differences from the kit are by design — never to be "resynced":

1. **Pointers.** The kit is self-contained: its guides reference only kit files. The copies here
   may point at `docs/` (the canonical references) and at this repo's own homes
   (`.agents/audits/`, `docs/adrs/`), because this repo carries the full framework.
2. **Standalone stances.** The kit folds the architect/skeptic/auditor disciplines into its three
   core guides and ships only `persona-surveyor` standalone (ADR-0064). The dev subset keeps the
   stances as separate guides, loaded individually for this repo's own review and authoring work.

A diff against the kit showing only pointer-target or packaging differences is expected. The
load-bearing rules track `docs/` and the kit.

3. **Kit-skill surfacing (known consequence of ADR-0069).** The kit ships
   `starter-kit/.claude/skills → ../.agents/skills`, so Claude sessions in THIS repo also
   discover the kit's three adopter-facing guides (`write-spec`, `implement-task`,
   `review-output`). They are kit content, not dev guidance — do not apply them to work on
   this repo. The kit `review-output` shares its name with the dev copy; which one a session
   surfaces is harness-dependent and not guaranteed. The dev set remains `.agents/skills/`.

