# `.agents/skills/` — the dev subset (manifest)

`.agents/skills/` is **not** the shipped catalogue. It is the small set of guides for working
**on this repo** — implementing changes to the docs and the checks contract. The shipped
surfaces are the starter kit's guides
([suspec-starter-kit](https://github.com/jcosta33/suspec-starter-kit) — the core loop plus the
workspace authoring guides), the optional catalog
([suspec-skills](https://github.com/jcosta33/suspec-skills) — market/review methods and
universal review/quality disciplines), and the reference pages under `docs/reference/`. The private family
workspace plans and reviews changes to this repo.

## Single-sourcing

A rule lands in `docs/` first (with an ADR under `docs/adrs/`), then the kit repo, the catalog,
and every derived surface. Never change a rule only here; this subset must not become a
competing authority.

## Census — included, and why

| Guide             | Counterpart                                                                    | Why it is here                                                                                                                     |
| ----------------- | ------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------- |
| `implement-task`  | mirror of the kit's `.agents/skills/implement-task/` (suspec-starter-kit repo) | Tasks cut in the private family workspace are implemented in this repo; the implementing session loads the core guide here.             |
| `empirical-proof` | the catalog's `empirical-proof` (repo-adapted copy)                            | The evidence rules in standalone form: a completion claim binds to pasted output; without it the result is Unverified, never Pass. |

## Census — omitted, and why

| Guide                                                                                                                                                              | Why not here                                                                                                                                                                                  |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `write-spec`, `review-output`, and the workspace authoring guides (`write-audit`, `write-research`, `write-rfc`, …)                                                | Authoring, review, and Close-step work runs from the private family workspace; its `.agents/skills/` carries them.                                                                                 |
| The market/review methods (`market-research`, `persona-challenger`, and `revolver-review`)                                                                      | They live in the suspec-skills catalog (the universal set); install into whichever workspace needs them.                                                                                       |
| The per-change-shape implementation guides (the `write-*` family)                                                                                                  | They live in the suspec-starter-kit (the kit's `.agents/skills/`), per [ADR-0112](../docs/adrs/0112-two-tier-skills.md); install into whichever workspace needs them. (`implement-task`'s canonical copy lives there too — the included row above is its byte-identical mirror.) |
| The documentarian discipline                                                                                                                                        | The kit's `write-documentation` guide carries it; install that guide from the kit when writing this repo's human-facing pages.                                                                    |

Templates are not skills: the frozen formats ship in the kit repo's `templates/` and
`advanced/` — link to them, never restate them.

Keep `implement-task` byte-identical to the kit repo's copy — the kit is where it is edited;
a drift here is a defect.
