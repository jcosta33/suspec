# Suspec

**An opinionated methodology for working with coding agents — shipped as skills, backed
by a deterministic checker.**

Suspec structures agent-assisted coding around intent, review, and findings.
When work earns more structure, skills add scaffold such as a spec, a task split, an
inventory, or a change plan. The methodology installs as a global skill family; a small
CLI provides the honesty floor — deterministic checks a lazy or dishonest reviewer
cannot fake. Plain markdown works with any agent, and your repositories take nothing.

## The problem

Agents multiply code faster than they multiply your capacity to direct and check it.
The work products around the code stay unstructured: plans are freeform prose, scope
lives in chat, reviews are vibes, and "all tests pass" is a claim nobody verified.
Inconsistent inputs produce unreviewable outputs.

Suspec is not an agent, and it does not claim to make your agent smarter. Your tool —
Claude Code, Codex, Cursor, Aider, or a human — writes the code. Suspec imposes structure
and consistency on the artifacts around it, the way a formatter imposes structure on
source: describe intent explicitly, verify claims with evidence, and let a deterministic
check catch what discipline alone misses.

## What Suspec is

1. **The skill family is the product** — installed once, globally for your runner
   (`npx skills add jcosta33/suspec-skills -g -a codex` for Codex). Skills for authoring specs, splitting
   work, implementing against a spec, building review packets, and saving findings. A
   capable harness plus the skills is a complete install (level: convention).
2. **The checker reinforces the method** — [suspec-cli](https://github.com/jcosta33/suspec-cli).
   `suspec check` runs deterministic checks over the artifacts you hand it:
   every scoped requirement has a coverage row, every evidence command matches the spec's
   `Verify with:` line, every `Pass` carries evidence, every reference resolves — plus
   per-artifact lint (level: enforced — suspec-cli). Zero model cost, no judgment calls,
   nothing a reviewer can talk their way past.

Every step keeps a by-hand path; no step requires a tool (level: convention).

## Sixty seconds

Install the methodology for your runner (Codex shown). Add the checker when deterministic
reconciliation would help:

```bash
npx skills add jcosta33/suspec-skills -g -a codex    # the skill family
# checker: github.com/jcosta33/suspec-cli
```

Most changes stop right there: state the fix and its verify command inline, implement,
paste the output, done — no file, no packet, no check run. For work that earns more
structure, author a spec through the skill. A requirement looks like this:

```markdown
### AC-001 — CSV export honors the selected date range

The export endpoint must filter rows to the date range selected in the
UI before generating the CSV file.

Verify with: `pnpm test:run export-date-range-filter`
```

Check it:

```bash
suspec check <path>
```

Exit codes are the API: `0` clean, `1` warning, `2` blocking (level: enforced — suspec-cli). After implementation, the
review packet gets the full floor —
`suspec check <review-path> --spec <spec-path>` (add `--task <task-path>` when the spec
was split into one) —
and a `Pass` with an empty evidence cell, a command that does not match the spec, or a
silent coverage gap comes back as a fact, not an opinion (level: enforced — suspec-cli).

## Where files live

Place the file next to your own native artifacts — the same place you keep your plans,
notes, and memories for this work, in a folder named after the repo you are working on
(or wherever fits your harness best). You choose the exact spot; keep it out of the repo
unless the project's own governance says otherwise, and carry the file's full path
forward — every later step names artifacts by explicit path.

Details: [where files live](docs/03-where-files-live.md).

## Proportional rigor

The least structure that changes execution or reviewability. A trivial fix gets a
one-line inline intent and no file. A feature gets a lean spec — a small set of requirements,
non-goals, acceptance criteria. Large work extends the spec rather than padding it.
Intent, review, and findings are the keys — present on virtually every change, at
whatever weight it earns; the rest is scaffold, erected when the work earns it. No
step exists for ceremony's sake (level: convention).

Suspec coexists with your harness's native plan mode — it never modifies, replaces, or
races it. Native planning stays for the work that suits it; Suspec artifacts appear
alongside, when the work earns them (level: convention).

## Global skills, local guidance

Suspec skills install globally and update in one place. Repo-specific guides — commands,
architecture, and conventions — stay committed in the repo they describe. A local guide
describes its repository; it does not fork the methodology (level: convention).

## Which repo do I want?

| You want to…                                                                  | Go to                                                                                                    |
| ----------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| **install the methodology** — the global skill family                         | [suspec-skills](https://github.com/jcosta33/suspec-skills) — `npx skills add jcosta33/suspec-skills -g -a codex` (Codex) |
| **add the deterministic checks** — the reference checker                      | [suspec-cli](https://github.com/jcosta33/suspec-cli) — `suspec check`                                    |
| **understand the method** — formats, the checks contract, the decision ledger | **this repo** — `docs/` (the numbered happy path), `docs/reference/`, `docs/adrs/`                       |
| **delegate to subagents** — review / audit / spec-author worker definitions   | [suspec-agents](https://github.com/jcosta33/suspec-agents) — Claude Code agent definitions               |

Most people install the skills, add the CLI when its checks pay for themselves, and never
read this repo cover to cover.

## Is / is not

**Is:** a methodology shipped as skills · a spec format agents work from · proportional
rigor — structure scaled to the work, never below a one-liner, never padded ·
a deterministic honesty floor over review claims (`suspec check`) · a discipline for
saving durable lessons into your harness's own memory.

**Is not:** an agent or runtime · a claim that structured artifacts make model output
better — the honest claim is consistency and checkability · a replacement for your
harness's plan mode · a spec-as-source system — code stays king · a store or record —
artifacts are transient working files, and durable value lives in code, tests, ADRs,
issues, PRs, and native memory · a Jira/Linear replacement · a replacement for PRs and
CI · team governance — the artifacts are yours; anything team-facing goes through the
project's own channels · a guarantee that agent output is correct.

**Take what you want.** Each part stands alone — adopt just the review discipline, or
just the spec format, and add the rest when the work calls for it. Plain markdown you own
outright: no lock-in, no walled garden.

**Who should not use Suspec.** If your changes are small enough to read whole and you
validate by reading, native plan mode, an `AGENTS.md`, and your test suite already give
you most of what this offers, at zero ceremony. Suspec starts paying when the diff
outgrows your attention, when more than one person or agent touches the work, or when
someone must later reconstruct what was intended and what was proven. Until one of
those is true, don't adopt it.

Against its neighbors: spec-first scaffolds generate plans. Trackers hold tickets. AI
reviewers hunt bugs. An `AGENTS.md` alone carries standing facts, not per-change
contracts. Suspec's distinct piece is the **deterministic check keyed to requirement
IDs**: no model in the loop, facts and exit codes rather than review results — you own
Pass/Fail. Around it sits the honesty rule — anything a tool doesn't enforce says so.

## Going deeper

[What is Suspec](docs/01-what-is-suspec.md) · [Basic workflow](docs/02-basic-workflow.md) · [Writing specs](docs/04-writing-specs.md) ·
[Reviewing output](docs/08-reviewing-output.md) · [Adopting](docs/ADOPTING.md) · [Examples](docs/examples/) · [Reference](docs/reference/) ·
[Design decisions](docs/adrs/) · [Evidence](docs/research/sources.md)
