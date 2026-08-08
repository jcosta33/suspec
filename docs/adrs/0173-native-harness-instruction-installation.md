---
type: adr
id: adr-0173
status: accepted
created: 2026-08-09
---

# ADR-0173 - Native harness instruction installation

## Context

ADR-0172 introduced reversible user-level economy setup. Its shared
`~/.agents/suspec/economy.md` payload made one Claude Code import convenient, but no cross-harness
standard defines that location. Codex and OpenCode already received inline policy bytes. Claude Code
supports imports, but expands imported content into context; the indirection saves no model tokens
[[CLAUDEDIR]](../research/sources.md#CLAUDEDIR).

Harnesses define their own user instruction files and precedence rules
[[CODEXGLOBAL]](../research/sources.md#CODEXGLOBAL)
[[CLAUDEDIR]](../research/sources.md#CLAUDEDIR)
[[OPENCODERULES]](../research/sources.md#OPENCODERULES). The open `AGENTS.md` convention provides a
predictable instruction file, not a universal branded user-state directory
[[AGENTSMD-CONV]](../research/sources.md#AGENTSMD-CONV).

## Decision

1. **Install into native files.** Target selection remains explicit. Setup resolves the effective
   documented user instruction file for each named harness, updates it when present, and creates the
   file when its native configuration directory exists.
2. **Inline one neutral block.** Every target receives the canonical economy policy bytes inside
   `agent-output-economy` markers. Setup targets contain no Suspec-branded path, marker, import, or
   symlink.
3. **Persist no installer payload.** The generated CLI module carries the canonical bytes, version,
   digest, and recognized predecessors. Setup creates no shared payload, directory, registry, or
   resolver.
4. **Preserve native precedence.** Setup uses documented harness configuration and existing effective
   scaffolding. It targets a non-empty Codex global override because Codex reads it instead of the
   ordinary global file. Unprovable precedence still fails closed.
5. **Keep reversal exact.** Neutral markers retain policy and content digests plus whether the target
   existed before setup. Update touches only that block. Removal restores exact preceding bytes or
   removes an otherwise empty CLI-created file.
6. **Version the changed envelope.** Setup JSON version `2` reports only native target paths. Check,
   preview, mutation approval, exit meanings, repository isolation, and the absent MCP surface do not
   change.

## Narrowed decisions

- [ADR-0172](./0172-reversible-harness-economy-setup.md): the reversible setup boundary survives;
  shared payload installation and Suspec-branded spans retire.
- [ADR-0171](./0171-global-interaction-economy.md): `policy/economy.md` remains canonical without
  becoming user-home scaffolding.
- [ADR-0137](./0137-personal-harness-transient-artifacts.md): the agent-neutral artifact root remains
  artifact storage only, not a home for global policy state.

## Consequences

- Users see the rule where their harness already reads global instructions.
- One short policy is duplicated on disk. The model received those bytes either way.
- Setup stays reversible without branding the installed scaffolding.

## Status

Accepted (2026-08-09). Narrows ADR-0137, ADR-0171, and ADR-0172.
