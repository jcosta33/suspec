# AGENTS.md

> **First action:** read your task file at `.agents/tasks/<your-slug>.md`. It links your source doc, lists the skills worth loading, names a suggested persona, and binds the verification commands you'll need. Then proceed.

This file is the entry point every agent CLI looks for (per the open [agents.md](https://agents.md/) standard, stewarded by the Agentic AI Foundation under the Linux Foundation). It carries only **persistent project context** — the facts, conventions, and commands every agent in this repo needs. Multi-step *procedures* live in `.agents/skills/` and load on demand when their `description` matches the work; they are not duplicated here.

> **Why the split.** Skills are loaded on demand and cost context every time; persistent facts (your stack, your commands) belong in a file that's always available. A "skill" authored to load on every task is the wrong primitive — its content belongs here.

---

## Project conventions

> **TODO:** fill in your project's specifics.

- **Language:** TODO (e.g., TypeScript ≥ 5.5)
- **Runtime:** TODO (e.g., Node.js LTS)
- **Test runner:** TODO (e.g., vitest)
- **Package manager:** TODO (e.g., pnpm ≥ 9)

---

## Commands

This is the **command contract**. Skills reference these entries by name in prose (e.g. "run the project's validation command, `AGENTS.md > Commands > Validation`") and degrade gracefully — if an entry is missing they ask you before running anything. Launchers bind the `{{cmd*}}` placeholders in `.agents/templates/` and skill `references/task-template.md` files from the same entries. Replace each `TODO` with your project's command.

**Required** — skills rely on these being filled in:

| Command (referenced as `Commands > …`) | Template placeholder | Bind to                                | Notes                                   |
| -------------------------------------- | -------------------- | -------------------------------------- | --------------------------------------- |
| `Validation`                           | `{{cmdValidate}}`    | TODO: `<typecheck + lint command>`     | e.g., `pnpm typecheck && pnpm lint`     |
| `Test`                                 | `{{cmdTest}}`        | TODO: `<test command>`                 | e.g., `pnpm test`                       |
| `Format`                               | `{{cmdFormat}}`      | TODO: `<formatter command>`            | e.g., `pnpm format`                     |

**Extended** — bound when the relevant work occurs; mark `n/a` (with a one-line reason) if your project has none. Out-of-contract values a skill asks you for at run time:

| Command          | Template placeholder   | Bind to / `n/a`                  | Used by                                 |
| ---------------- | ---------------------- | -------------------------------- | --------------------------------------- |
| `Install`        | `{{cmdInstall}}`       | TODO                             | most code tasks (worktree setup)        |
| `Typecheck`      | `{{cmdTypecheck}}`     | TODO _or_ `n/a`                  | refactor, standalone type checks        |
| `Build`          | `{{cmdBuild}}`         | TODO _or_ `n/a`                  | upgrade                                 |
| `ValidateDeps`   | `{{cmdValidateDeps}}`  | TODO _or_ `n/a`                  | refactor / migration / review (arch boundary check) |
| `Benchmark`      | `{{cmdBenchmark}}`     | TODO _or_ `n/a`                  | performance                             |

> Skills never invent commands. If a value isn't here, they ask you and proceed once told. If you find yourself answering the same question every session, add the binding above rather than letting skills guess.

---

## Skills

Skills live in `.agents/skills/<name>/SKILL.md` and **self-activate**: each carries a directive `description` ("ALWAYS apply this skill when … Do not … Skip this skill for …") and loads when its triggers match the task you're doing. There is **no always-loaded skill** — install/keep only the skills your work needs, and let each one fire on its own description.

- **Workflow skills** carry the discipline for a kind of work: `write-{spec,audit,research,bug-report,feature,fix,refactor,rewrite,migration,performance,testing,documentation}`, plus `fix-flaky-test`.
- **Quality gates** are cross-cutting disciplines that surface inside whatever task is in play: `empirical-proof`, `adversarial-review`, `distillation-discipline`.
- **Personas** condition mindset for role-shaped work: `persona-{architect,auditor,janitor,migrator,performance-surgeon,skeptic,surveyor}`. Load the one whose description matches the task; they have no dependency on each other or any other skill.

Project-specific skills under `.agents/skills/domain/` self-activate the same way when their `description` matches. See `.agents/templates/skill.md` (the skill meta-template) for how skills are authored and why.

---

## Repo structure

> **TODO:** adapt to your repo's layout.

- `src/` — source code
- `tests/` — tests
- `.agents/` — agent skills / templates / source docs
- `.agents/tasks/` — worktree-local task files (gitignored; never committed)
- `docs/` — user-facing documentation (if any)

---

## Constitution

> **TODO (optional):** if you maintain a project-wide non-negotiable-baselines doc:

The project's non-negotiable baselines live in `.agents/constitution.md`. Every spec, audit, and ADR operates within its constraints. (Delete this section if you don't maintain a constitution.)

---

## ADRs

> **TODO (optional):** if you maintain ADRs:

Architecturally significant decisions are recorded under `.agents/adrs/`. New ADRs are authored during `spec-writing` tasks when a structural decision warrants its own immutable record.

---

## Routing (recommended, not enforced)

Swarm's flow graph maps a source document to a task type to a suggested persona and the skills worth loading (`docs/agents/05-flow-graph.md`). It is **recommended routing**: a launcher (the Swarm CLI or any compatible tool) may apply it deterministically when scaffolding a task file, and the directive skill `description`s reproduce it inside a session. The agent is not forced — when the task in front of you doesn't match the suggested default, load the skill whose `description` fits and record the divergence in your task file's `## Decisions`.

---

## Subagent strategy

- **Read-side parallelism is permitted** via subagents. Research, audit, and review work runs effectively in subagents (separate context windows reporting back digests).
- **Write-side work is single-threaded.** Implementation tasks (feature, fix, refactor, migration, etc.) run in the main thread; parallel writers serialise through a single-threaded merge protocol with disjoint file scopes.

See `docs/agents/05-flow-graph.md` for the routing rules.

---

## Override semantics

This file is repo-root. In monorepos, subdirectories may have their own `AGENTS.md` (or `AGENTS.override.md`) for path-specific conventions. The closest file in the directory tree wins.

> **TODO (monorepo only):** list workspace-specific AGENTS.md files here for discoverability.

---

## See also

- `docs/agents/01-process.md` — the documentation-first workflow
- `docs/agents/02-file-types.md` — what each document type contains
- `docs/agents/03-workflow.md` — step-by-step session flow
- `docs/agents/04-standards.md` — writing and execution standards
- `docs/agents/05-flow-graph.md` — the recommended routing graph (source-doc → task → suggested persona → skills → verification)
- `.agents/skills/` — the shipped skills (workflow, quality-gate, persona)
- `.agents/templates/` — the source-doc templates and the shared task skeleton
