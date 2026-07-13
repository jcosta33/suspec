---
type: adr
id: adr-0148
status: accepted
created: 2026-07-12
updated: 2026-07-12
---

# ADR-0148 — Ordinary artifacts use an agent-neutral workspace

## Context

ADR-0141 kept transient Suspec artifacts outside repositories by placing them beside each
harness's native artifacts. That avoided a Suspec-managed store, but made the same plain Markdown
harder to continue from another vendor. Current first-party contracts expose named configuration,
memory, session, and context surfaces, not a generic capability granted to arbitrary neighboring
Markdown [[CLAUDE-FILES]](../research/sources.md#CLAUDE-FILES)
[[CODEX-FILES]](../research/sources.md#CODEX-FILES)
[[CURSOR-FILES]](../research/sources.md#CURSOR-FILES)
[[AIDER-FILES]](../research/sources.md#AIDER-FILES).

## Decision

1. **Ordinary artifacts use one neutral root.** Specs, reviews, audits, research, inspections,
   task packets, run notes, and evidence receipts live under
   `~/.agents/artifacts/<workspace>/`. Resolve `~` to the absolute home path, derive
   `<workspace>` from the repository or working-directory basename, and hand every consumer the
   resulting absolute path. Plan Mode, vendor-native plans, native memory, source code, build
   output, and harness-managed state remain native. _Level: convention._
2. **Conflicts stop for a human choice.** Never overwrite unrelated work. If the workspace name or
   target path is ambiguous, present structured choices for a distinct human-readable name. Do not
   hash paths or create an identity registry. _Level: convention._
3. **Portability does not justify fallback.** If the neutral root is unwritable, offer grant access
   and retry, another agent-neutral user directory, or cancel. Never fall back to vendor storage,
   the repository, or an OS temporary directory. _Level: convention._
4. **The directory remains passive.** No symlinks, config, resolver, CLI command, MCP tool,
   registry, lifecycle state, or automated cleanup is added. Tools continue to read only explicit
   paths. The fixed root improves human and cross-vendor discovery without becoming a managed
   Suspec store. _Level: convention._
5. **Promotion remains durable-only.** `promote` moves a transient whole document into a
   human-selected project-native durable channel. It does not relocate artifacts between transient
   roots. `remember` still writes durable lessons to native harness memory.

## Narrowed decisions

- [ADR-0141](./0141-artifacts-beside-native-artifacts.md): zero repository footprint, explicit
  paths, and retired store machinery stand; vendor-adjacent placement and the prohibition on a
  canonical passive root are replaced.
- [ADR-0147](./0147-artifact-promotion.md): stateless durable promotion stands; its references to
  native transient placement now mean the neutral transient workspace defined here.

## Consequences

- Any local agent can continue from the same ordinary artifact without copies or symlinks.
- Artifact creation remains outside adopter repositories.
- A sandbox may require one explicit permission before writing the neutral root.
- Transient cleanup remains the user's responsibility; Suspec owns no cleanup mechanism.

## Status

Accepted (2026-07-12). Narrows ADR-0141 and ADR-0147 without changing the CLI, MCP, or checks
contracts.
