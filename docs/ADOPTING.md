# Adopting Swarm

Swarm is files, not software. Adoption is copying a handful of templates and filling
in one bootloader. Three paths, in order of preference.

## 1. Manual adoption (five minutes)

In the repo that will hold your specs and reviews — a dedicated workspace repo, or
your project repo for a co-located setup ([where files live](03-where-files-live.md)):

1. Copy `starter-kit/templates/` → `templates/` (8 files: spec, task, review,
   finding, status, intake, inventory, change-plan).
2. Copy `starter-kit/agent/` → the directory your agent CLI scans for skills
   (`.claude/skills/` for Claude Code; otherwise `.agents/skills/`). It contains
   `AGENTS.md` plus three guides: `write-spec`, `implement-task`, `review-output`.
3. Move that `AGENTS.md` to your repo **root** and fill its `{{placeholders}}` —
   your test/lint/build commands and standing project facts. Add `CLAUDE.md` and
   `GEMINI.md` as symlinks to it (`ln -s AGENTS.md CLAUDE.md`) — one bootloader,
   many agent tools, never a copy that can drift.
4. Copy `starter-kit/decisions/` → `decisions/` and append
   `starter-kit/.gitignore.additions` to your `.gitignore`.
5. Create `specs/`, `intake/`, `tasks/`, `reviews/`, `findings/`, and a `status.md`
   from the template. Write one spec for your next non-trivial change.

Optional, when you need them: copy pieces of `starter-kit/advanced/` (audit,
research, bug, ADR, RFC, PRD templates and their guides). The advanced audit
template is the recommended first taste for brownfield teams.

## 2. Agent-assisted adoption

Hand your coding agent this prompt:

> Adopt the Swarm framework into this repository. Read
> `https://github.com/jcosta33/swarm` — specifically `docs/ADOPTING.md` and
> `starter-kit/README.md` — then perform the manual-adoption steps above for me:
> copy the templates and agent guides, place `AGENTS.md` at the repo root with
> `CLAUDE.md`/`GEMINI.md` symlinks, fill its Commands table from my real
> test/lint/build setup (read package.json/Makefile/CI and confirm with me),
> create the workspace folders, and append the gitignore additions. This is
> additive — do not delete or overwrite my files; stop and ask on any conflict.

## 3. Future CLI adoption

`swarm init` will do the above mechanically. It does not exist yet — the contract
is [reference/future-cli.md](reference/future-cli.md).

## Code repos

A code repo that implements against your specs needs **nothing**. At most:

- a one-line pointer in its `AGENTS.md`: _"Swarm workspace: `<path-or-url>` — read
  the task packet you are given before coding"_;
- the `implement-task` guide copied into its skills directory;
- the `.gitignore.additions` lines.

The agent works from the task packet; the PR links the workspace review packet.
Specs, reviews, and findings never live in the code repo (convention — nothing
enforces it; that's the point of keeping the workspace authoritative).

## Upgrading

Re-copy `starter-kit/templates/` and `starter-kit/agent/` from a newer checkout.
Your specs, tasks, reviews, findings, decisions, and `AGENTS.md` are yours — the
kit never touches them.
