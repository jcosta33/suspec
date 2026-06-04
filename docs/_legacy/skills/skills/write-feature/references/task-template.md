# {{title}}

## Metadata

- Slug: {{slug}}
- Agent: {{agent}}
- Branch: {{branch}}
- Base: {{baseBranch}}
- Worktree: {{worktreePath}}
- Created: {{createdAt}}
- Status: active
- Type: feature

---

> ⚠️ **FEATURE SESSION** — Build exactly what the spec specifies. Halt on ambiguity. No opportunistic refactoring.
>
> **AGENTS.md:** `{{cmdValidate}}` / `{{cmdTest}}` / `{{cmdInstall}}` resolve from `AGENTS.md > Commands`. Non-contract values (`{{cmdBenchmark}}`, `{{cmdValidateDeps}}`, `{{cmdTypecheck}}`) — ask the user. If `AGENTS.md` is missing, ask before substituting.

---

## Objective

Implement the functionality detailed in the linked specification. One paragraph maximum.

---

## Linked docs

- Spec: `{{specFile}}`
- Related research (if any): `<path>`
- Related ADRs: `<path>`

---

## Constraints

- Work only inside this worktree
- Do not switch branches unless explicitly instructed
- Do not merge, rebase, or push unless explicitly instructed
- Run `{{cmdInstall}}` to install dependencies
- Run `{{cmdValidate}}` after every batch of changes
- Adhere strictly to the spec's acceptance criteria
- No opportunistic refactoring; promote findings to an audit
- Halt on ambiguity (do not invent requirements)
- **Proactively research and read related docs.** Browse `<your-specs-dir>/`, `<your-research-dir>/`, `<your-audits-dir>/`, `docs/`, `AGENTS.md`, and the project skills directory as needed.

---

## Plan

(Step-by-step, written before implementation begins.)

1.
2.
3.

---

## Progress checklist

- [ ] Spec read in full
- [ ] Pattern survey done (existing helpers consulted)
- [ ] Acceptance criteria mapped to implementation steps
- [ ] Implement core logic
- [ ] Add / update tests
- [ ] `{{cmdValidate}}` passes after each batch (paste output)
- [ ] `{{cmdTest}}` passes (paste output)
- [ ] `{{cmdValidateDeps}}` clean (or `n/a` documented)
- [ ] Findings promoted upstream (if any)
- [ ] Self-review: Verification outputs pasted
- [ ] Self-review: Spec adherence answered
- [ ] Self-review: Architecture answered
- [ ] Self-review: Conventions answered
- [ ] Self-review: Tests answered
- [ ] Self-review: Completeness answered

---

## Decisions

- ***

## Findings

(Codebase discoveries worth preserving. Promote durable findings to upstream docs before close.)

- ***

## Assumptions

- [pending]

---

## Blockers

- ***

## Next steps

(Concrete starting points if this session ends incomplete.)

- ***

## Self-review

Stop. A feature that diverges silently from the spec ships drift. Act as a senior engineer about to greenlight this branch for merge.

> **Hard gate.** The task is not complete until every question below has a written answer directly beneath it.

### Verification outputs (paste actual command output — do not paraphrase)

- `git status` →
- `{{cmdValidate}}` (last 2 lines):
- `{{cmdTest}}` (last 2 lines):
- `{{cmdValidateDeps}}` (last 2 lines, or `n/a`):

### Spec adherence

- Does every acceptance criterion in the spec map to a corresponding implementation that I can point at? Is anything in the spec missing?
  Answer:

### Architecture

- Did I introduce any new pattern that competes with an existing one? Did the architectural validation pass?
  Answer:

### Conventions

- Did I follow the codebase's idioms (file layout, naming, error handling, logging)?
  Answer:

### Tests

- Are tests added or updated for the new behaviour? Do they fail when the assertion is flipped?
  Answer:

### Completeness

- Anything stubbed, TODO'd, or half-implemented?
  Answer:

### Final Polish

- Did you ask yourself: "What did I leave behind? Did I actually run all the gates, or did I trust my memory?" Do not leave the work without this final adversarial pass.
  Answer:

Only when every answer above is written is this task complete.
