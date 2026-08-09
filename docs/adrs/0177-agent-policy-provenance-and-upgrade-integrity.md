---
type: adr
id: adr-0177
status: accepted
created: 2026-08-09
---

# ADR-0177 - Agent policy provenance and upgrade integrity

## Context

Setup marks an installed agent-policy block with a policy version, canonical digest, installed-content
digest, and original-file state. Policy regeneration retained only the current canonical digest.
A legitimate block became unrecognized as soon as the payload changed, blocking both upgrade and
removal. A matching installed-content digest also proved only self-consistency, not canonical bytes.

## Decision

1. **Retain canonical predecessors.** A canon-owned manifest lists recognized predecessor
   version/digest pairs. Generation appends the current pair and refuses a payload change until the
   old current pair enters the manifest.
2. **Bind markers to bytes.** Setup verifies both the installed-content digest and the canonical
   policy digest after normalizing line endings and restoring the canonical terminal newline.
3. **Upgrade what Suspec wrote.** An intact recognized predecessor may be replaced by the current
   payload or removed to restore the exact original bytes.
4. **Reject imitation.** Unknown pairs, modified bodies, forged content digests, malformed markers,
   foreign text, and ambiguous targets still fail closed.
5. **Stay narrow.** Retained provenance lives in canon and generated source. Setup gains no runtime
   registry, history lookup, network dependency, project mutation, or MCP surface.
6. **Close the lineage.** ADR-0176's advisory delivery rule narrows ADR-0171's global interaction
   policy. Project systems enforce delivery transitions; harness permissions isolate worker authority.

## Narrowed decisions

- [ADR-0171](./0171-global-interaction-economy.md): the global policy may route delivery while
  remaining advisory.
- [ADR-0172](./0172-reversible-harness-economy-setup.md): retained recognized pairs now survive
  regeneration and exact canonical-byte verification.
- [ADR-0175](./0175-single-context-gateway.md): one generated policy still serves every harness.
- [ADR-0176](./0176-native-delivery-control-contract.md): delivery ownership and its ADR-0171 lineage
  are explicit.

## Consequences

- Payload changes no longer strand intact prior installations.
- A valid-looking marker cannot legitimize arbitrary body bytes.
- Setup remains reversible, local, and separate from checking and MCP.

## Status

Accepted (2026-08-09). Narrows ADR-0171, ADR-0172, ADR-0175, and ADR-0176.
