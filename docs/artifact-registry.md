# Artifact index

The current Suspec agents, skills, and MCP tools live across the repo family. This index
lists the public surfaces with their source homes and status (ADR-0114: `active` ·
`retired` · `relocated` — a name whose status is not `active` names its replacement
below). Every entry in the tables is `active`; the non-active names live in the Retired
and relocated section at the end.

## Agents

Source: [`../suspec-agents/agents/`](https://github.com/jcosta33/suspec-agents).

| Name                   | Home             | Use it when                                              |
|------------------------|------------------|----------------------------------------------------------|
| `suspec-reviewer`      | suspec-agents    | Reviewing a finished task/PR; proof-first mode reruns Verify and pastes evidence. |
| `suspec-auditor`       | suspec-agents    | Recording the present state of a code area.              |
| `suspec-challenger`    | suspec-agents    | Pressure-testing a not-yet-built proposal/spec/plan.     |
| `suspec-spec-author`   | suspec-agents    | Authoring or revising specs.                             |
| `suspec-documentarian` | suspec-agents    | Drafting product or reference documentation.             |
| `suspec-researcher`    | suspec-agents    | Investigating one decision-informing question.           |

For code-location work, use the runner's built-in code exploration agent together with the
`codebase-exploration` skill.

## Skills

Source: [`../suspec-skills/skills/`](https://github.com/jcosta33/suspec-skills). One
catalog, installed globally (`npx skills add jcosta33/suspec-skills -g`): the methodology
disciplines and the conditioning skills together.

The methodology disciplines:

| Name                  | Home           | Use it when                          |
|-----------------------|----------------|--------------------------------------|
| `write-spec`          | suspec-skills  | Authoring or revising a spec.        |
| `spec-check`          | suspec-skills  | Checking a spec against core rules.  |
| `split-work`          | suspec-skills  | Splitting a spec or plan into tasks. |
| `implement-task`      | suspec-skills  | Implementing a Suspec task packet.   |
| `review-output`       | suspec-skills  | Building a review packet.            |
| `save-findings`       | suspec-skills  | Routing durable lessons into native memory. |
| `write-prd`           | suspec-skills  | Authoring a PRD.                     |
| `write-rfc`           | suspec-skills  | Authoring an RFC.                    |
| `write-research`      | suspec-skills  | Authoring a research note.           |
| `write-audit`         | suspec-skills  | Authoring an audit.                  |
| `write-bug-report`    | suspec-skills  | Authoring a diagnosis-only bug report. |
| `write-inventory`     | suspec-skills  | Authoring an inventory.              |
| `write-change-plan`   | suspec-skills  | Authoring a change plan.             |
| `write-documentation` | suspec-skills  | Authoring documentation.             |
| `write-feature`       | suspec-skills  | Implementing a feature.              |
| `write-fix`           | suspec-skills  | Implementing a fix.                  |
| `write-refactor`      | suspec-skills  | Implementing a refactor.             |
| `write-rewrite`       | suspec-skills  | Implementing a rewrite.              |
| `write-migration`     | suspec-skills  | Implementing a migration.            |
| `write-performance`   | suspec-skills  | Implementing a performance change.   |
| `write-testing`       | suspec-skills  | Implementing tests.                  |

The conditioning skills:

| Name                   | Home           | Use it when                                      |
|------------------------|----------------|--------------------------------------------------|
| `codebase-exploration` | suspec-skills  | Mapping an unfamiliar codebase before changing it. |
| `concise-output`       | suspec-skills  | Producing terse, evidence-first output.          |
| `debugging`            | suspec-skills  | Finding a live defect's root cause from runtime evidence. |
| `empirical-proof`      | suspec-skills  | Binding completion claims to verbatim output.    |
| `fix-flaky-test`       | suspec-skills  | Stabilizing a non-deterministic test.            |
| `git-pr`               | suspec-skills  | Committing, pushing, opening PRs, and closing CI/review loops. |
| `market-research`      | suspec-skills  | Synthesizing market, customer, competitor, and UX-pattern evidence. |
| `persona-challenger`   | suspec-skills  | Pressure-testing a live idea before it is built. |
| `planning-spec`        | suspec-skills  | Planning a non-trivial change before fan-out.    |
| `security-review`      | suspec-skills  | Reviewing trust-boundary and data-flow risks.    |
| `bulletproof`          | suspec-skills  | Hardening a claim, decision, spec, or plan — evidence-gated critique with kill criteria. |
| `revolver-review`      | suspec-skills  | Driving a substantial change to a clean state — a rotating pool of ≥6 distinct stances, one reviewer at a time, fixing between rounds until it converges. |

## MCP Tools

Source: [`../suspec-mcp/src/tools.ts`](https://github.com/jcosta33/suspec-mcp). The
server adapts the `suspec check` surface for shell-less runners — path-explicit, with
companions as explicit parameters, shelling out to the CLI (ADR-0085, ADR-0143).

| Name                | Home        | Use it when                                                    |
|---------------------|-------------|-----------------------------------------------------------------|
| `suspec_check_file` | suspec-mcp  | Checking one artifact by full path; spec/task companions as explicit parameters. |
| `suspec_get_checks` | suspec-mcp  | Reading the checks contract (the `--contract` face).           |

## CLI

Source: [`../suspec-cli`](https://github.com/jcosta33/suspec-cli). The surface is one
command: `suspec check` (ADR-0143). Reference: [reference/cli.md](reference/cli.md).

## Retired and relocated

Names an author might still meet in older text. Do not cite them as current; use the replacement.

| Name                | Status    | Replacement                                                        |
|---------------------|-----------|--------------------------------------------------------------------|
| `adversarial-review` | retired   | The refute-by-default review discipline now lives in `revolver-review`, which consumed it (ADR-0132). |
| `persona-skeptic`   | retired   | The refute-by-default review discipline, now carried by `revolver-review`.   |
| `suspec-explorer`   | retired   | The runner's built-in exploration agent + the `codebase-exploration` skill. |
| `suspec-starter-kit` (repo, as a skills home) | relocated | Its skills relocated to the `suspec-skills` catalog (ADR-0138, ADR-0140); adopter repos take no seed. |
| `suspec-cli` (multi-verb surface) | relocated | The CLI contract collapsed into `suspec check` (ADR-0143) — the former verbs (`init`, `work`, `evidence`, `done`, `promote`, `pull`, `fix`, `new`, `write`, `review`, `show`, `next`, `status`, `store` with `doctor`/`gc`/`purge`, `clean`, `stamp`, `update`, `worktree`, `check-my-work`, `agents`) have no successor commands: authoring is the skills' job, placement is the developer's (ADR-0141), durable findings go to native memory or project channels (ADR-0142). |
| `--staleness` | retired | The reviewer owns staleness by reading the diff (ADR-0143). |
| `suspec.config.json` (with `SUSPEC_STATE_DIR` and `state_root`) | relocated | Nothing to configure — the CLI reads only the paths it is handed (ADR-0141, ADR-0143). |
| the personal store (`~/.claude/state/<repo-name>/`) | relocated | Placement is the agent's choice, beside its native artifacts, per `docs/03-where-files-live.md` (ADR-0141). |
| `finding` (the artifact, with its triage flow) | relocated | A durable lesson becomes a native harness memory; team-facing residue goes through project channels (ADR-0142). |
| `status.md` (the board) | relocated | No owned work-state projection; paths flow explicitly (ADR-0141). |
| `docs/reference/advanced-lifecycle.md` | retired | Proportional rigor and the loop live in `docs/01-what-is-suspec.md` and `docs/02-basic-workflow.md`. |
| `docs/reference/step-bars.md` | retired | Rigor guidance lives in the workflow pages (`docs/02-basic-workflow.md`, `docs/05-brownfield-and-change-plans.md`). |
| `suspec-mcp` (store-facing tool surface) | relocated | The surface collapsed into `suspec_check_file` + `suspec_get_checks`, adapting `suspec check` only (ADR-0143). |
| `suspec agents emit` (Codex emitter) | relocated | Maintenance moved to hand-edited committed Codex projections (ADR-0143). |
| `write-documentation` (catalog vs. kit split) | relocated | One home: the `suspec-skills` catalog. |
| `implement-task` (catalog vs. kit split) | relocated | One home: the `suspec-skills` catalog; the suspec repo keeps a byte-identical dev mirror. |
