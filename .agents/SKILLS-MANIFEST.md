# `.agents/skills/` — the dev subset (manifest)

`.agents/skills/` is **not** the shipped catalogue. It is the small set of guides for working
**on this repo** — implementing changes to the docs and the checks contract. The shipped
surfaces are the global skill family
([suspec-skills](https://github.com/jcosta33/suspec-skills) — the core loop, the authoring
guides, and the market/review methods and universal review/quality disciplines) and the
reference pages under `docs/reference/`. The private family
workspace plans and reviews changes to this repo.

## Single-sourcing

A rule lands in `docs/` first (with an ADR under `docs/adrs/`), then the catalog and every
derived surface. Never change a rule only here; this subset must not become a
competing authority.

## Census — included, and why

| Guide             | Counterpart                                                                    | Why it is here                                                                                                                     |
| ----------------- | ------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------- |
| `implement-task`  | mirror of the catalog's `implement-task` (suspec-skills repo)                  | Tasks cut in the private family workspace are implemented in this repo; the implementing session loads the core guide here.             |
| `empirical-proof` | the catalog's `empirical-proof` (repo-adapted copy)                            | The evidence rules in standalone form: a completion claim binds to pasted output; without it the result is Unverified, never Pass. |

## Census — omitted, and why

| Guide                                                                                                                                                              | Why not here                                                                                                                                                                                  |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `write-spec`, `review-output`, and the workspace authoring guides (`write-audit`, `write-research`, `write-rfc`, …)                                                | Authoring, review, and Close-step work runs from the private family workspace; its `.agents/skills/` carries them.                                                                                 |
| The market/review methods (`market-research`, `persona-challenger`, and `revolver-review`)                                                                      | They live in the suspec-skills catalog (the universal set); install into whichever workspace needs them.                                                                                       |
| The per-change-shape implementation guides (the `write-*` family)                                                                                                  | They live in the suspec-skills catalog (the universal set), per [ADR-0112](../docs/adrs/0112-two-tier-skills.md); install globally. (`implement-task`'s canonical copy lives there too — the included row above is its byte-identical mirror.) |
| The documentarian discipline                                                                                                                                        | The catalog's `write-documentation` guide carries it; install it from suspec-skills when writing this repo's human-facing pages.                                                                    |

Templates are not skills: the frozen formats live in
[artifact formats](../docs/reference/artifact-formats.md) and materialize via the CLI's
built-in scaffolds — link, never restate.

Keep `implement-task` byte-identical to the catalog's copy — suspec-skills is where it is
edited; a drift here is a defect.
