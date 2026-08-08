---
type: adr
id: adr-0172
status: accepted
created: 2026-08-08
---

# ADR-0172 - Reversible harness economy setup

## Context

Skills load on demand. They cannot govern routine chat before activation. Codex, Claude Code, and
OpenCode each expose user-level instruction files, but their paths and precedence differ
[[CODEXGLOBAL]](../research/sources.md#CODEXGLOBAL)
[[CLAUDEDIR]](../research/sources.md#CLAUDEDIR)
[[OPENCODERULES]](../research/sources.md#OPENCODERULES). `npx skills` installs skills; it does not
install a global interaction policy.

The CLI currently has one read-only verb. Global setup therefore requires a deliberate boundary
change, not mutation hidden inside package or skill installation.

## Decision

1. **Add explicit setup plumbing.** `suspec setup <harness>...` installs, checks, previews, or removes
   the economy policy for explicit `codex`, `claude-code`, and `opencode` targets. It never detects or
   guesses targets and never reads stdin.
2. **Human authority survives convenience.** Detection, dry-run, and check are non-mutating. Install
   and removal require target-specific owner approval plus `--yes`.
3. **One canonical payload, generated runtime bytes.** `corpus/policy/economy.md` owns the contract.
   The CLI checks in a generated module with the current bytes, source digest, version, and retained
   recognized version/hash pairs. Source and packaged binaries consume the same generated module.
4. **Own fragments, not files.** Setup mutates only marked Suspec spans in documented user-level
   instruction files. It refuses drift, links, special files, foreign owners, unsafe paths, ambiguous
   precedence, and unrecognized payloads. Removal restores the exact original bytes.
5. **Be honest about enforcement.** `--check` proves user-level installation and unambiguous documented
   precedence. Project, managed, and separately combined instructions can override it. Setup never
   claims hard enforcement or adversarial same-user filesystem security.
6. **Keep checking separate.** `suspec check`, its contract, and its exit meanings do not change.
   Setup has its own versioned JSON envelope. MCP exposes no setup, storage, or mutation surface.
7. **Touch no repository.** Setup resolves only fixed user-level locations under the home directory.
   It adds no registry, daemon, telemetry, hook, output style, project file, or cleanup service.

## Narrowed decisions

- [ADR-0140](./0140-skills-are-the-product-tools-reinforce.md): skills remain the workflow product;
  setup is non-authoritative communication-policy installation, not a method carrier.
- [ADR-0143](./0143-path-agnostic-check-cli-contract.md) and
  [ADR-0165](./0165-checker-invocation-architecture.md): `check` remains path-explicit and read-only;
  the CLI gains one isolated user-setup verb.
- [ADR-0151](./0151-skill-agent-artifact-economy.md): setup creates no agent, role, projection, or
  artifact.
- [ADR-0169](./0169-minimum-sufficient-skill-control.md) and
  [ADR-0170](./0170-proportional-design-and-executable-oracles.md): the no-runtime default stands for
  methods; witnessed global waste justifies this narrow installer.

## Consequences

- Full local installation has three explicit parts: CLI, skills, and economy setup.
- The checker contract and MCP remain boring. Good.
- Unsupported or ambiguous harness states fail closed instead of receiving a confident lie.

## Status

Accepted (2026-08-08). Narrows ADR-0140, ADR-0143, ADR-0151, ADR-0165, ADR-0169, and ADR-0170.
