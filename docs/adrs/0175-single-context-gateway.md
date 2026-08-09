---
type: adr
id: adr-0175
status: accepted
created: 2026-08-09
---

# ADR-0175 - Single context gateway across harnesses

## Context

The installed global policy governs conversation but leaves tool routing to unrelated vendor blocks.
Codex and Claude Code therefore carry duplicated prose, imported RTK sidecars, and different lean-ctx
rules. Kimi Code and ZCode receive neither context gateway. The result is drift, not choice.

RTK rewrites shell commands and does not intercept native reads or MCP tools
[[RTKHOOKS]](../research/sources.md#RTKHOOKS). lean-ctx owns MCP reads, search, maps, shell dispatch,
security, and recovery [[LEANCTX]](../research/sources.md#LEANCTX). Claude Code runs matching hooks in
parallel, so independent shell rewriters cannot form a dependable pipeline
[[CLAUDEHOOKS]](../research/sources.md#CLAUDEHOOKS).

Kimi Code defines a user-level `AGENTS.md` and user-level MCP configuration
[[KIMICODE]](../research/sources.md#KIMICODE). ZCode defines `~/.zcode/AGENTS.md` as its user-global
instruction file [[ZCODE]](../research/sources.md#ZCODE).

## Decision

1. **Install one agent policy.** `policy/agent.md` owns interaction economy, durable finding placement,
   and context-tool routing. Setup installs its exact bytes inside one neutral `agent-policy` block.
2. **Use one gateway.** When available, lean-ctx owns reads, search, code maps, and shell dispatch.
   RTK-supported commands run through `ctx_shell` with `raw=true`; lean-ctx does not recompress them.
   Unsupported commands use ordinary `ctx_shell` compression. Exact evidence bypasses filtering.
3. **Keep a native fallback.** Without `ctx_*` tools, agents use native tools and RTK for supported
   shell commands.
4. **Forbid competing glue.** Installed policy uses no RTK import, sidecar, symlink, or second shell
   rewrite hook. External binaries, MCP registration, and vendor hooks remain outside Suspec setup.
5. **Cover current harnesses.** Explicit setup targets are `codex`, `claude-code`, `kimi-code`,
   `zcode`, and `opencode`. Each maps to its ordinary native global instruction file.
6. **Keep setup narrow.** Setup writes only the named native instruction files. It does not install,
   configure, update, or remove RTK, lean-ctx, MCP servers, skills, or vendor runtime state.

## Narrowed decisions

- [ADR-0171](./0171-global-interaction-economy.md): economy survives inside the broader agent policy.
- [ADR-0172](./0172-reversible-harness-economy-setup.md): explicit reversible setup survives; the
  payload and supported target set expand.
- [ADR-0173](./0173-native-harness-instruction-installation.md): one native inline block survives;
  the economy-only marker retires.
- [ADR-0174](./0174-fixed-native-instruction-targets.md): fixed ordinary targets and fail-closed
  shadowing survive.

## Consequences

- Every supported harness receives the same behavior bytes.
- One output has one compressor. Installed tools cooperate instead of racing.
- Suspec owns policy, not third-party installation.

## Status

Accepted (2026-08-09). Narrows ADR-0171 through ADR-0174.
