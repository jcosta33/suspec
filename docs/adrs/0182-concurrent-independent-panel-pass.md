---
type: adr
id: adr-0182
status: accepted
created: 2026-08-15
---

# ADR-0182 - Concurrent independent panel pass

## Context

ADR-0181 requires fresh panel participants to receive one fixed packet and remain blind until every
initial response lands. It does not state whether those independent analyses run sequentially or
concurrently. Sequential launch adds latency without improving isolation because no participant may
see earlier work.

## Decision

1. Launch the initial independent panel analyses concurrently.
2. Keep participant count adaptive under ADR-0181.
3. Run only the evidence-triggered follow-up sequentially after synthesis.

## Consequences

- Independent breadth costs wall-clock time once.
- Concurrency changes no evidence, authority, or participant-count rule.
- Follow-up remains bounded to one decisive conflict.

## Status

Accepted (2026-08-15). Narrows ADR-0181.
