# Artifact index

> **Superseded model — [ADR-0137](adrs/0137-personal-harness-transient-artifacts.md).** This page still describes the committed
> workspace / board / `.suspec/` layout. Suspec artifacts are now transient personal working
> files under `~/.claude/state/<repo-name>/`, never committed to any repo; durable value is
> promoted to ADRs, tests, issues, and PR digests. Where this page conflicts with
> [ADR-0137](adrs/0137-personal-harness-transient-artifacts.md), the ADR wins. Rewrite pending.


The current Suspec agents, skills, and MCP tools live across the repo family. This index lists the
public surfaces with their source homes and status (ADR-0114: `active` · `retired` · `relocated` —
a name whose status is not `active` names its replacement below). Every entry in the tables is
`active`; the non-active names live in the Retired and relocated section at the end.

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

## Universal Skills

Source: [`../suspec-skills/skills/`](https://github.com/jcosta33/suspec-skills).

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

## Kit Guides

Source: [`../suspec-starter-kit/.agents/skills/`](https://github.com/jcosta33/suspec-starter-kit).

| Name                  | Home                | Use it when                         |
|-----------------------|---------------------|-------------------------------------|
| `implement-task`      | suspec-starter-kit  | Implementing a Suspec task packet.  |
| `review-output`       | suspec-starter-kit  | Building a review packet.           |
| `save-findings`       | suspec-starter-kit  | Routing durable discoveries home.   |
| `spec-check`          | suspec-starter-kit  | Checking a spec against core rules. |
| `split-work`          | suspec-starter-kit  | Splitting a spec or plan into tasks. |
| `write-spec`          | suspec-starter-kit  | Authoring or revising a spec.       |
| `write-prd`           | suspec-starter-kit  | Authoring a PRD.                    |
| `write-rfc`           | suspec-starter-kit  | Authoring an RFC.                   |
| `write-research`      | suspec-starter-kit  | Authoring a research note.          |
| `write-audit`         | suspec-starter-kit  | Authoring an audit.                 |
| `write-bug-report`    | suspec-starter-kit  | Authoring a diagnosis-only bug report. |
| `write-inventory`     | suspec-starter-kit  | Authoring an inventory.             |
| `write-change-plan`   | suspec-starter-kit  | Authoring a change plan.            |
| `write-documentation` | suspec-starter-kit  | Authoring documentation.            |
| `write-feature`       | suspec-starter-kit  | Implementing a feature.             |
| `write-fix`           | suspec-starter-kit  | Implementing a fix.                 |
| `write-refactor`      | suspec-starter-kit  | Implementing a refactor.            |
| `write-rewrite`       | suspec-starter-kit  | Implementing a rewrite.             |
| `write-migration`     | suspec-starter-kit  | Implementing a migration.           |
| `write-performance`   | suspec-starter-kit  | Implementing a performance change.  |
| `write-testing`       | suspec-starter-kit  | Implementing tests.                 |

## MCP Tools

Source: [`../suspec-mcp/src/tools.ts`](https://github.com/jcosta33/suspec-mcp).

| Name                      | Home        | Use it when                         |
|---------------------------|-------------|-------------------------------------|
| `suspec_get_status`       | suspec-mcp  | Reading workspace status.           |
| `suspec_check_workspace`  | suspec-mcp  | Running workspace checks.           |
| `suspec_check_file`       | suspec-mcp  | Checking a single file.             |
| `suspec_get_task`         | suspec-mcp  | Reading a task packet.              |
| `suspec_get_spec`         | suspec-mcp  | Reading a spec.                     |
| `suspec_get_review`       | suspec-mcp  | Reading a review packet.            |
| `suspec_get_checks`       | suspec-mcp  | Reading the checks contract.        |
| `suspec_reconcile`        | suspec-mcp  | Reconciling workspace/board state.  |
| `suspec_list`             | suspec-mcp  | Listing workspace artifacts.        |
| `suspec_scaffold_spec`    | suspec-mcp  | Scaffolding a spec.                 |
| `suspec_split_task`       | suspec-mcp  | Scaffolding split task packets.     |
| `suspec_scaffold_finding` | suspec-mcp  | Scaffolding a finding candidate.    |

## Retired and relocated

Names an author might still meet in older text. Do not cite them as current; use the replacement.

| Name                | Status    | Replacement                                                        |
|---------------------|-----------|--------------------------------------------------------------------|
| `adversarial-review` | retired   | The refute-by-default review discipline now lives in `revolver-review`, which consumed it (ADR-0132). |
| `persona-skeptic`   | retired   | The refute-by-default review discipline, now carried by `revolver-review`.   |
| `suspec-explorer`   | retired   | The runner's built-in exploration agent + the `codebase-exploration` skill. |
| `write-documentation` (catalog) | relocated | Ships in the kit (`suspec-starter-kit/.agents/skills/`), not the catalog. |
| `implement-task` (catalog)      | relocated | Ships in the kit; the suspec repo keeps a byte-identical dev mirror. |
