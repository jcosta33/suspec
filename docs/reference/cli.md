# The `suspec` CLI

`suspec-cli` is the reference harness — and it is optional. Every step of the loop keeps a
by-hand path (ADR-0134; level: convention); the CLI accelerates the mechanics and gives the
evidence side teeth.

The CLI prepares files, launches configured runners, captures evidence, gates on it, and
promotes what deserves to outlive the session. It does not write code, does not run a model
loop, and does not decide whether code is correct — the human owns the result.

Source: [suspec-cli](https://github.com/jcosta33/suspec-cli). `suspec help` prints the
command reference; `suspec <command> --help` prints per-command usage; `suspec` with no
arguments opens the dashboard. The daily reconcile flows (`init`, `check`, `worktree`,
`status`, `review`, `new`) also take `-i` for an interactive flow.

## The store

Artifacts — intake, spec, run, review, finding, evidence — are your typed working memory:
flat markdown files in a per-repo store **outside** the repo, never committed anywhere
(level: convention — the CLI never stages them, and `init` never touches the store).

- **Resolution.** `<state-root>/<repo-name>/`, where `<state-root>` defaults to
  `~/.claude/state` and is overridable via the `SUSPEC_STATE_DIR` environment variable or
  `state_root` in `suspec.config.json`. `<repo-name>` is the repo directory's basename; two
  different repo paths sharing a basename get distinct store dirs (a stable `-2`/`-3`
  suffix, matched by the recorded repo path — never by a basename guess).
- **Layout.** Flat files — `spec-<slug>.md`, `run-<slug>.md`, `review-<slug>.md`,
  `task-<slug>.md`, `change-plan-<slug>.md`, `finding-<NNN>.md`, `intake-<slug>.md` — plus
  raw evidence under `evidence/<run>/` and one lifecycle subfolder, `archive/`. No other
  tree.
- **Disposable by design.** Durable value leaves the store by promotion (issues, ADRs,
  tests, the PR digest); `suspec pull` records the ticket URL and `suspec fix #123` rebuilds
  a working launch from the GitHub issue, so a store wipe loses nothing promoted.
- Agents read and write the store directly by the absolute paths given in the launch
  prompt. Only the driving spec auto-loads into agent context.

## `suspec.config.json`

The one Suspec file in a repo. Every command works without it — defaults apply, and absence
of config is never an error (level: toolable — a missing runtime dependency such as `gh`
errors only on the command that needs it, naming it).

| Key | Meaning | Default |
| --- | --- | --- |
| `setup` | commands run in a fresh worktree before launch | lockfile autodetect (`pnpm-lock.yaml`, `package-lock.json`, `yarn.lock`, `Cargo.toml`, `uv.lock`/`requirements.txt`) |
| `setup_copy` | allowlisted gitignored files copied into the worktree (e.g. `.env.local`) | none |
| `verify` | the repo's verify commands — `check-my-work`'s gate | none |
| `runners` | runner adapters + `runners.default` | `claude` when on PATH |
| `risk_paths` | globs that trigger an advisory nudge in `check-my-work` and `done` | none |
| `wip_cap` | max active specs before `work` refuses (override with `--anyway`) | 3 |
| `retention_days` | age past which `store gc` / `clean` deletes archived artifacts | 30 |
| `state_root` | store root override | `~/.claude/state` |

```json
{
  "setup": ["pnpm install"],
  "setup_copy": [".env.local"],
  "verify": ["pnpm test:run", "pnpm lint"],
  "runners": { "default": "claude" },
  "risk_paths": ["src/auth/**"],
  "wip_cap": 3,
  "retention_days": 30
}
```

Built-in runners: `claude` (the reference adapter) and `codex` (whose template puts the
store root in the sandbox's writable roots — a sandboxed runner is the adapter's problem,
never architecture). A `custom` runner takes a raw command template with `{prompt}` /
`{cwd}` placeholders.

## The loop

```
write spec ──▶ work ──▶ evidence add ──▶ done ──▶ promote
```

1. **`write spec`** — scaffold a draft spec in the store from a one-line intent; you (or the
   spec-author skill via `--launch`) fill the requirements.
2. **`work`** — resolve the spec from the store, refuse it stale, create or reuse its
   worktree, run setup, launch the configured runner with a prompt that points at the store
   by absolute path.
3. **`evidence add`** — the CLI runs each verify command itself in the run worktree and
   records cli-verified evidence mapped to an AC.
4. **`done`** — the strict gate over the run, the digest on the PR, findings triage.
5. **`promote`** — a finding becomes a GitHub issue; the finding retires to `archive/`.

The middle tier, `check-my-work`, gates the current diff without a spec, a launch, or an
artifact. `next` names the single most actionable store item. `fix` turns a finding or a
GitHub issue into a launched fix-spec.

## Gate semantics

`suspec done` gates every AC in the driving spec on at least one **cli-verified, exit-0**
evidence entry (level: enforced by the CLI's own gate):

- **cli-verified** means the CLI ran the command itself via `evidence add` and captured
  exit + output. Evidence written any other way carries `provenance: agent` or `dev` and
  never satisfies the gate by default.
- **Stale evidence never satisfies.** Each evidence entry records a digest of the whole
  worktree state at capture (git status + diff + the HEAD sha); `done` re-hashes and
  rejects drifted evidence until re-run — committing after capture doesn't launder it.
- **Strict is the default.** Any failing or missing AC blocks (exit 1).
  `--accept-failing "<why>"` accepts explicitly — the reason lands in the digest and the
  run file. `--allow-agent-evidence` lets agent-provenance evidence count, labeled in the
  digest.
- **The digest** — per AC: verify command, exit code, evidence ref, plus any
  accepted-failing reasons — prints to stdout and, when the run's branch has an open PR,
  upserts one marker-tagged PR comment (edited in place on re-run). Raw output never leaves
  the store.
- **Findings triage** closes a finished run — it runs only when the gate passed or was
  explicitly accepted; a blocked gate exits 1 before triage. Promote (GitHub issue) ·
  keep (expiry stamped) · discard (the default for non-critical). A critical finding is
  never silently discarded. Non-interactive mode defers untriaged findings with an
  expiry stamp.

## Exit codes

One contract across the surface:

- `0` — clean / gate satisfied (or explicitly accepted)
- `1` — actionable gap: warnings, behind, gate blocked, a failed verify command
- `2` — usage error or hard failure

Per-command specifics are noted in the usage below.

## Commands

The usage blocks below are the CLI's own (`suspec <command> --help`).

### Seed and update

#### `suspec init`

Seed this repo for the personal harness — config, AGENTS.md, skills dirs.

```text
suspec init
  (no flag)                   write suspec.config.json (defaults + detected setup), seed AGENTS.md
                              if absent, create .agents/skills/ + the .claude/skills symlink,
                              gitignore .worktrees/ — nothing else lands in the repo
  --yes                       also link CLAUDE.md → AGENTS.md (accept every offer)
  --json · -i                 machine output · interactive flow (prompts for the CLAUDE.md link)
  artifacts live in your personal store, outside the repo; the store is never touched here
```

#### `suspec update`

Check kit drift, or refresh kit-managed templates (conflict-safe).

```text
suspec update [--check | --write]
  --check (default)           compare .agents/.suspec-version to the kit VERSION; writes nothing
  --write | --apply           refresh the kit-owned templates (per the kit manifest) + re-stamp the pin
  --on-conflict backup|overwrite|skip   handle a customized kit file (default: backup → *.suspec-bak)
  --from <path|url>           kit source (default: the suspec-starter-kit on GitHub)
  --json                      machine output
  --check: exit 0 up-to-date · 1 behind · 2 error · --write: 1 if files need reconciling
  skills are not refreshed here — they install globally (npx skills add jcosta33/suspec-skills -g)
```

### Author

#### `suspec write`

Scaffold a draft store spec from a one-line intent — optionally dispatch the spec author.

```text
suspec write spec "<one-line intent>"
  "<intent>"                  seeds spec-<slug>.md in the store: status draft, base_sha = repo HEAD,
                              one empty AC + a Verify placeholder — the CLI authors NO requirements
  --launch                    dispatch the spec-author prompt (a pointer at the store spec) to the runner
  --runner <name>             the runner from suspec.config.json runners (built-ins: claude, codex)
  --json                      machine output
  then: suspec work <SPEC-id>
```

#### `suspec new`

Cut a store task slice from a store spec, or scaffold a change plan.

```text
suspec new <task|change-plan>
  task --from <SPEC> [--scope AC-001,AC-002] [--id <TASK-id>]   cut a slice into the store (scope never invented)
  change-plan <slug>                              scaffold a draft change plan (migrations/rewrites)
  --id <TASK-id>                                  name a 2nd+ task from one spec (else TASK-<spec-slug>)
  --force                                         re-cut over an existing task slice (e.g. to add --scope)
  --json · -i                                     machine output · interactive flow
  specs scaffold via `suspec write spec "<intent>"` (the one store scaffold)
```

#### `suspec pull`

Snapshot a ticket into the store — verbatim capture only, never a spec.

```text
suspec pull <ref>
  <ref>                       a gh issue (number/owner-repo#N/URL — fetched via gh), or any tracker ref
  --force                     overwrite an existing intake-<slug>.md (else no-clobber)
  --json                      machine output
  writes one store intake snapshot (paste placeholder when no fetch); the recorded url
  makes it re-pullable after a store wipe. Capture only — `suspec fix #N` scaffolds + launches
```

### Launch

#### `suspec work`

Work a store spec: create/reuse its worktree, set up, launch a runner pointed at the store
(no verdict).

```text
suspec work <SPEC>
  <SPEC>                      a spec id/slug, resolved against the store (spec-*.md)
  --runner <name>             the runner from suspec.config.json runners (built-ins: claude, codex)
  --base <branch>             the worktree base (else the current branch)
  --anyway                    launch despite recorded spec staleness
  --attach                    a live run: print the runner-native attach hint (dispatches nothing)
  --second-worktree           a live run: launch in a suffixed worktree with its own run file
  --dry-run                   resolve + print the plan and prompt; launch nothing, write nothing
  --json                      machine output
  by hand (no CLI): create the worktree, cd in, run your agent against the store spec
```

Setup runs in the worktree before launch: the config's `setup` commands (else the lockfile
autodetect), plus the `setup_copy` allowlist. When the driving spec's `Verify with:` lines
name runtime commands, a failed setup blocks the launch (exit 1); otherwise it warns. A spec
whose recorded `base_sha` has drifted against its affected areas refuses to launch unless
`--anyway`, printing what drifted. A second `work` on a live run refuses while its
heartbeat is fresh, offering `--attach` and `--second-worktree`; a dead heartbeat is
reported reclaimable. `work` also refuses past `wip_cap` active specs unless `--anyway`.

#### `suspec fix`

Scaffold a store fix-spec from a finding or gh issue, then launch it via the work pipeline.

```text
suspec fix <FIND-id | #issue>
  <FIND-id>                   a finding id / store filename (archive/ included)
  #<issue>                    a GitHub issue number, fetched via gh (survives a store wipe)
  --no-launch                 scaffold spec-fix-<slug>.md only; print its path
  --runner <name> · --base <branch> · --anyway · --json   forwarded to the work pipeline
  scaffolds base_sha = repo HEAD (+ affected_areas from the finding), then hands off to `work`
```

#### `suspec worktree`

Create / list / remove / prune isolated task worktrees.

```text
suspec worktree <create|list|remove|prune> [slug]
  create <slug> [--task <t>] [--base <branch>]   worktree on suspec/<slug>[/<task>]
  remove <slug> [--task <t>] [--force]           tear one down
  list · prune                                   show / clear stale worktrees
  --json · -i                                    machine output · interactive flow
```

### Evidence and the gate

#### `suspec evidence`

Capture cli-verified evidence: run a verify command in the run worktree, record it in the
store.

```text
suspec evidence add <RUN> --ac <AC-id> -- <command…>
  add <RUN>                   the store run the evidence belongs to (run-<RUN>.md)
  --ac <AC-id>                the acceptance criterion the evidence maps to (e.g. AC-003)
  -- <command…>               the command to run (in the run worktree; bare binary + args, no shell)
  --json                      machine output
  exit mirrors the command (0/1) — the record is written either way; raw output stays in the store
```

#### `suspec done`

The strict gate: lint the run artifacts, gate every AC on cli-verified evidence, digest +
triage.

```text
suspec done <RUN>
  <RUN>                       the store run to close (run-<RUN>.md)
  --accept-failing "<why>"    accept gate gaps explicitly — the reason lands in the digest + run file
  --allow-agent-evidence      let provenance: agent evidence count (labeled in the digest)
  --discard-critical <id>     allow triage to discard the named critical finding
  --json                      machine output (defers findings triage with an expiry stamp)
  exit 0 gate satisfied/accepted · 1 gate blocked (gaps listed) · 2 usage / lint hard-error
```

#### `suspec review`

Reconcile a store run against its spec — artifact lint + evidence per AC (no verdict).

```text
suspec review <RUN>
  <RUN>                       a store run slug (run-<RUN>.md)
  lint: the run record, its driving spec, its review packet, every evidence record
  reconcile: each spec AC against the evidence (verified / stale / failing / missing)
  --json · -i                 machine output · interactive flow
  surfaces facts + routes; the human owns the result — `suspec done` closes the gate
```

#### `suspec check`

Validate one artifact by its type, or lint the store's artifacts for this repo.

```text
suspec check [file]
  (no file)                   lint the store's artifacts — runs, specs, reviews, evidence records
  <file>                      validate by frontmatter type: spec, review (C012/C013), or change-plan (C010/C011); exit 0 clean · 1 warnings · 2 error
  --staleness                 advisory: which snapshotted specs drifted since their snapshot SHA
  --json · -i                 machine output · interactive flow
```

The checks are artifact lint — per-artifact facts with per-check severity, never a
whole-store verdict. The contract is [checks](checks.md) (`checks/checks.yaml` in this
repo).

#### `suspec check-my-work`

The middle tier: gate the current repo diff (config `verify`) + dispatch one adversarial
reviewer.

```text
suspec check-my-work "<one-line intent>"
  "<intent>"                  what the reviewer reviews the current diff against
  (diff base)                 merge-base with the default branch; staged+unstaged when already on it
  --save                      record a check run + evidence records in the store (else artifact-free)
  --no-review                 gate only — no reviewer dispatched
  --dry-run                   print the plan + reviewer prompt; run nothing, write nothing
  --runner <name>             the reviewer runner (else runners.default) · --json
  exit mirrors the gate: 0 verify passed/none declared · 1 a verify command failed · 2 usage/launch failure
```

#### `suspec stamp`

Stamp a spec snapshot SHA (enables `check --staleness`).

```text
suspec stamp <ref>
  <spec id|slug>              write snapshot: HEAD (enables `check --staleness`)
  --repo <path>               stamp against a separate code repo · --json
```

### Promotion

#### `suspec promote`

Promote a store finding to a GitHub issue (evidence digest + provenance), then archive it.

```text
suspec promote <FIND>
  <FIND>                      a finding id (frontmatter `id:`) or store filename (finding-*.md)
  --json                      machine output
  the issue body carries the finding + the run evidence digest + the provenance label;
  the issue number is stamped into the finding, which then retires to archive/
  exit 0 promoted · 1 gh missing/failing (named; nothing changed) · 2 unknown finding
```

### Store and attention

#### `suspec status`

The store summary — runs, specs, and what needs attention.

```text
suspec status
  (no flag)                   active + archived store artifacts, plus the attention ranking
  --json · -i                 machine output · interactive view
```

#### `suspec next`

The single most actionable store item — live runs, gate gaps, triage debt, ready specs.

```text
suspec next
  (no flag)                   print THE top item (+ the ambient decay line)
  --json                      the full ranking, machine-readable
  reads only the store + local git state — zero network, zero gh; writes nothing
```

`work`, `next`, and `status` print one ambient decay line when the store holds items past
expiry or stale runs (`N stale — suspec store doctor`).

#### `suspec store`

Store maintenance — doctor (reconcile), list, gc (retention), purge (whole store), migrate.

```text
suspec store <doctor|list|gc|purge|migrate>
  doctor                      archive spec/run artifacts whose branch merged, worktree vanished,
                              or PR closed (git/GitHub truth; never deletes; orphans listed; exit 0)
  list                        active + archived artifacts with per-artifact age
  gc                          delete ONLY archive/ items past retention_days (default 30)
  purge [--force]             delete the repo’s whole store — type the repo name, or --force
  migrate                     upgrade artifacts to the current grammar_version (never downgrades)
  --json                      machine output
```

Terminal states derive from git/GitHub truth — `doctor` is a reconciler, never a judge.

#### `suspec clean`

Store hygiene — delete archived artifacts past retention (= `store gc`).

```text
suspec clean
  (no flag)                   delete ONLY archive/ items past retention_days (default 30)
  --json                      machine output
```

### Projection

#### `suspec show`

Project a parsed store artifact as JSON — spec, run, review, task, finding, intake, or the checks contract (read-only).

```text
suspec show <spec|run|review|task|finding|intake|checks> [id|slug]
  spec <id|slug>              the parsed spec (frontmatter, requirements + verify commands)
  run <slug>                  the run record (frontmatter + body)
  review <id|slug>            the parsed review packet (status, coverage rows, verify blocks)
  task <id|slug>              the parsed task packet (scope, affected areas, claimed changes)
  finding <id>                the finding (severity, run, affected areas, body)
  intake <slug>               the intake snapshot (frontmatter + body)
  checks                      the checks contract (version + the core checks)
  <path.md>                   a repo file directly (kind inferred from frontmatter type)
  refs resolve from the store (archive/ included); --json machine output; renders no verdict
```

#### `suspec agents`

Project Claude Code agent definitions into another runner (Codex TOML).

```text
suspec agents emit --codex [--from <dir>]
  emit --codex                generate .codex/agents/*.toml from the agent definitions
  --from <dir>                the agent *.md defs (default: ./.claude/agents, else ../suspec-agents/agents)
  --force                     overwrite existing generated .toml files (they regenerate)
  --json                      machine output
  prose discipline only — tool-scoping + hooks are Claude-Code-only and do NOT travel
```

#### `suspec help`

Show the command reference.

```text
suspec help
suspec --help · suspec --version
```

## Boundary

| CLI owns | You / your agent own |
| --- | --- |
| store scaffolds and intake snapshots | requirement content |
| worktrees and setup | the coding loop |
| the launch envelope | model reasoning and edits |
| evidence capture (cli-verified) | what the evidence proves |
| artifact lint and reconciliation | provider credentials |
| the gate, digest, and triage mechanics | the result — Pass/Fail is yours |
| promotion mechanics (`gh`) | what deserves to be durable |

## Non-goals

The CLI does not provide:

- code generation or an agent runtime
- verdicts — it surfaces facts and routes; the human owns the result
- runner session supervision — a live run gets the runner-native attach hint, nothing more
- cross-machine sync — the store is plain files; syncing it is a recipe, not a feature
- team governance — artifacts are personal; anything team-facing leaves via promotion

`suspec-mcp` exposes CLI data over MCP. It shells out to the CLI `--json` contract.

## Related

- [Checks](checks.md)
- [Structured requirements](structured-requirements.md)
- [Advanced lifecycle](advanced-lifecycle.md)
- [Memory](memory.md)
