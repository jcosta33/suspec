# Suspec

**A personal methodology harness for working with coding agents.**

Suspec helps one developer produce better code faster with agents: typed working memory
for the agent, an evidence gate (`suspec done`) that blocks instead of trusting, and a promotion path so
the durable residue — decisions, tests, issues, proof — lands where it already belongs.
Plain markdown, any agent, and your repos stay clean.

## The problem

Agents multiply code. They don't multiply your capacity to direct and check it. The mess
pools in five places: vague tickets pasted into chat, context re-explained every session,
agents drifting off-scope, "all tests pass" claims nobody verified, and lessons lost when
the session ends.

Suspec is not an agent. Your tool — Claude Code, Codex, Cursor, Aider, or a human — writes
the code. Suspec structures the work around it, and spends where the bottleneck is:
**generation outruns validation**. So the proof side gets the structure.

## The loop

```
write spec ──▶ work ──▶ evidence ──▶ done ──▶ promote
    │           │          │          │          │
  intent     worktree   machine-run  the gate  issue / ADR /
  becomes    + agent    proof per    + digest  test / PR
  a contract  launch    requirement  on the PR  digest
```

1. **write spec** — intent becomes a one-page contract: requirements with IDs and
   `Verify with:` lines, scaffolded into your store.
2. **work** — a fresh git worktree, project setup, your agent launched against the spec.
3. **evidence** — the harness runs each verify command itself and records the proof,
   mapped to the requirement it satisfies.
4. **done** — the gate (`suspec done`, enforced by the CLI): every requirement needs
   machine-captured, passing, non-stale evidence, or you accept the gap explicitly. The
   digest lands on the PR.
5. **promote** — a decision becomes an ADR, behavior becomes tests, a finding becomes a
   GitHub issue. The working files are disposable *because* the durable residue has left.

For a change too small for a spec, `suspec check-my-work` gates the current diff and
dispatches one adversarial reviewer. `suspec next` names the one thing to do next.
Command-level detail: [docs/reference/cli.md](docs/reference/cli.md).

## Sixty seconds

A requirement in a spec:

```markdown
### AC-001 — Expired refresh token redirects to login

When the refresh token is expired, the client must clear the local
session and redirect to `/login`.

Verify with: `pnpm test:run auth-refresh-expired-token`
```

What the gate reports at `suspec done`:

```text
AC-001  pnpm test:run auth-refresh-expired-token   exit 0   verified
AC-002  no cli-verified evidence                            missing
gate blocked — rerun `suspec evidence add` for AC-002, or accept explicitly
```

The digest is the point. You read which requirements passed **with captured proof** and
which didn't. A missing evidence entry means _Unverified_, never _Pass_ — and the gate
blocks on it instead of hoping. The review-by-exception idea, worked end to end:
[docs/examples/large-pr-review.md](docs/examples/large-pr-review.md).

## Where files live

- **Your repo** — the code, one `suspec.config.json`, and whatever you promote (ADRs,
  tests), plus any committed repo-specific agent guides. Nothing else.
- **Your store** — `~/.claude/state/<repo-name>/`: specs, runs, reviews, findings,
  evidence. Personal, transient, never committed to any repo.
- **Global** — the universal Suspec skill family, installed once at the user level.

Details: [where files live](docs/03-where-files-live.md).

## Two skill tiers

Universal Suspec skills (the methodology: authoring, reviewing, stances) install globally —
`npx skills add jcosta33/suspec-skills -g` — and update in one place. Repo-specific guides
(your commands, your conventions) stay committed in the repo they describe. The two tiers
never overlap, so a guide cannot skew against the methodology it rides on
(level: convention).

## Which repo do I want?

| You want to…                                                                 | Go to                                                                                                                   |
| ---------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| **start using Suspec** — the harness in your repo                            | [suspec-cli](https://github.com/jcosta33/suspec-cli) — `suspec init`, then the loop                                     |
| **install the methodology** — the global skill family                        | [suspec-skills](https://github.com/jcosta33/suspec-skills) — `npx skills add jcosta33/suspec-skills -g`                 |
| **understand the method** — formats, the checks contract, the decision ledger | **this repo** — `docs/` (the numbered happy path), `docs/reference/`, `docs/adrs/`                                      |
| **see what the CLI seeds** — the template source                             | [suspec-starter-kit](https://github.com/jcosta33/suspec-starter-kit) — the thin seed `suspec init`/`update` draw from   |
| **delegate to subagents** — review / audit / spec-author worker definitions   | [suspec-agents](https://github.com/jcosta33/suspec-agents) — Claude Code agents, or Codex TOML via `suspec agents emit --codex` |

Most people run `suspec init`, install the skills, and never read this repo cover to cover.

## Works today

**Today** (markdown + your agent, nothing to install): the spec format, the artifact
formats, the skill family, the worked examples. Every step keeps a by-hand path — the
methodology needs no runtime.

**Toolable** (the reference CLI, [suspec-cli](https://github.com/jcosta33/suspec-cli)):
the store, the `work` launch spine, cli-verified evidence capture, the `done` gate, the PR
digest, promotion, and the [checks contract](docs/reference/checks.md) as artifact lint.
The gate is the CLI's teeth: only evidence the CLI captured itself counts, by default.
Full surface: [CLI reference](docs/reference/cli.md).

Suspec does **not** promise deterministic generation, automatic correctness, formal
verification, software compiled from specs, or the end of PR review. It promises better
inputs, bounded work, machine-captured evidence, and kept context.

## Is / is not

**Is:** a spec format agents work from · typed working memory for agent runs, kept outside
your repos · an evidence gate keyed to requirement IDs · a promotion path so decisions,
findings, and proof outlive the session · a global skill family · a findings convention
with a built-in death owner (promote, keep with expiry, or discard).

**Is not:** an agent or runtime · a compiler · a programming language · a Jira/Linear
replacement · a code generator · a replacement for PRs and CI · team governance — the
artifacts are yours; anything team-facing leaves via promotion · a guarantee that agent
output is correct.

**Take what you want.** Each part stands alone — adopt just the evidence discipline, or
just the spec format, and add the rest when the work calls for it. Plain markdown you own
outright: no lock-in, no walled garden.

**Who should not use Suspec.** If your changes are small enough to read whole and you
validate by reading, plan mode, an `AGENTS.md`, and your test suite already give you most
of what this harness offers, at zero ceremony. Suspec starts paying when the diff is
bigger than your attention, when "the agent says it passes" is not evidence you accept,
or when you keep re-explaining the same context every session. Until one of those is
true, don't adopt it — and if you only want the review discipline, install the
[skills](https://github.com/jcosta33/suspec-skills) alone and skip the rest.

Against its neighbors: spec-first scaffolds generate plans. Trackers hold tickets. AI
reviewers hunt bugs. An `AGENTS.md` alone carries standing facts, not per-change
contracts. Suspec's distinct piece is the **evidence gate keyed to requirement IDs**:
deterministic — no model in the loop; proof captured by the harness, not claimed by the
agent; verdict-free — it routes facts, and you own Pass/Fail. Around it sits one honesty
rule — anything a tool doesn't enforce says so.

## Initiation

1. In your repo: `suspec init` ([suspec-cli](https://github.com/jcosta33/suspec-cli)) —
   one config file, seeded agent instructions, nothing else lands in the repo.
2. Install the skill family: `npx skills add jcosta33/suspec-skills -g`.
3. `suspec write spec "<your next change>"`, fill the requirements, `suspec work` it.
4. New to the loop? **[Walk it once, hands-on](docs/tutorial/README.md)** — a guided
   build on one small change (still on the superseded layout — its banner and
   [docs/03-where-files-live.md](docs/03-where-files-live.md) tell you what changed).

Or hand your agent [docs/ADOPTING.md](docs/ADOPTING.md) and let it do the setup.

## Going deeper

[What is Suspec](docs/01-what-is-suspec.md) · [Basic workflow](docs/02-basic-workflow.md) · [Writing specs](docs/04-writing-specs.md) ·
[Reviewing output](docs/08-reviewing-output.md) · [Examples](docs/examples/) · [Reference](docs/reference/) ·
[Design decisions](docs/adrs/) · [Evidence](docs/research/sources.md)
