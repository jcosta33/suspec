---
type: adr
id: adr-0153
status: accepted
created: 2026-07-13
updated: 2026-07-13
---

# ADR-0153 - MCP parity and compatibility

## Context

The MCP check tool accepted one primary path, so it could not expose the CLI's cross-file checks.
It trusted CLI JSON without complete runtime validation and repeated verdict disclaimers in every
response even though the data model already contains no verdict.

## Decision

1. **MCP accepts a path set.** `suspec_check` takes a non-empty `paths` array of absolute primary
   artifact paths, passes the set through one CLI invocation, and preserves input order.
2. **Review companions stay explicit.** `specPath` and `taskPath` may accompany one review target.
   Multiple review targets with shared companions are rejected as ambiguous.
3. **Compatibility is exact.** The adapter validates every success and error payload at runtime and
   requires checks-contract version `0.18.0`. A malformed payload or incompatible version fails
   structurally.
4. **The envelope is lean.** Responses contain `ok`, `source`, `data`, optional `note`, and
   `responseFormat`. No verdict flag or repeated no-verdict prose ships.
5. **The boundary stays narrow.** MCP retains the artifact check, checks-contract tool, and
   checks-contract resource. It adds no storage, discovery, orchestration, promotion, lifecycle,
   or artifact-management surface.

## Narrowed decisions

- [ADR-0085](./0085-suspec-mcp-adapts-the-json-contract.md): shell-out architecture stands; runtime
  validation and exact contract compatibility are mandatory.
- [ADR-0143](./0143-path-agnostic-check-cli-contract.md): explicit primary paths and review
  companions stand; MCP now preserves multi-path CLI behavior.

## Consequences

- MCP-capable runners receive the same cross-file facts as CLI users.
- Contract drift fails immediately.
- Responses spend no fields restating the absence of acceptance authority.

## Status

Accepted (2026-07-13).
