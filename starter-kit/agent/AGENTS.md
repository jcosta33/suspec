# AGENTS.md

<!-- Keep this file short — aim for ~100 lines (Swarm's own convention: agents read
     it on every task, so every line spends always-loaded budget). Move procedures
     into the guides; keep only standing facts and commands here. -->

## Swarm startup

1. Read the task packet you were given first. Follow its scope.
2. Read the linked spec (and change plan, if any) before touching code.
3. Do not implement behavior outside the task's scope — if a requirement can't be
   met as written, stop and say why instead of improvising.
4. Run every item under the task's `## Verify` and paste the real output. A claim
   without output counts as unverified.
5. Before finishing, re-read your own diff as a skeptic, then leave a summary:
   changed files, commands run with output, and anything worth saving as a finding.

## Workspace

- Specs: `specs/<feature>/spec.md` · tasks: `tasks/` · reviews: `reviews/` ·
  findings: `findings/` · intake: `intake/` · decisions: `decisions/` · board: `status.md`
- Templates for every artifact: `templates/`
- {{For code repos: "Swarm workspace: <path-or-url>"}}

## Project facts

- {{stack, runtimes, package manager}}
- {{architecture rules an agent cannot infer}}
- {{house conventions that differ from defaults}}

## Commands

<!-- The commands an agent runs to verify work in this repo. Nothing executes them
     automatically today — you, your agent, CI, or the future CLI does. -->

| Slot | Command | Purpose |
|---|---|---|
| test | `{{npm test / pytest / …}}` | run the test suite |
| lint | `{{eslint / ruff / …}}` | static checks |
| build | `{{build command}}` | production build |
| typecheck | `{{tsc --noEmit / mypy}}` | types |

## Agent role

You are an implementation or review worker. Swarm organizes the work; you perform
the assigned task — and you never review your own implementation.
