---
type: adr
id: 0034-unified-lint-namespace
status: accepted
created: 2026-06-02
updated: 2026-06-02
supersedes:
superseded_by:
---

# ADR-0034: The unified SOL-<LAYER><NNN> lint namespace

## Context

Before the kernel, diagnostics accreted into several disjoint vocabularies: an `APS-*` family for prose smells (`APS-A001`, `APS-O001`, …), flat legacy research codes (`SOL101`/`SOL201`/`SOL301`), and a separate `SOL-L###` prose-lint family. A reviewer meeting a defect had to know *which* vocabulary owned it, and a code's identifier said nothing about which pass raised it or which repair closed it. The same defect class could carry two unrelated codes; nothing tied a code to a pipeline phase; and "APS" was simultaneously the name of the prose standard and a code prefix, conflating a standard with its diagnostics (§8.1, §8.5).

## Decision

Every Swarm diagnostic uses one namespace: `SOL-<LAYER><NNN>` — the literal prefix `SOL`, one uppercase **layer letter**, and a three-digit number. There are exactly five layers, each mirroring a compiler pass 1:1: `S` (SYNTAX), `P` (PROSE, the former APS layer, which absorbs the old `SOL-L`), `M` (SEMANTIC), `V` (VERIFICATION), `O` (ORCHESTRATION). The letter alone tells a reader the phase a code belongs to and which repair guides it. The `APS-` prefix is **retired as a code prefix**; "APS" survives only as the *name* of the prose standard (ADR-0028, §7) and MUST NOT appear in any diagnostic code. Every legacy `APS-*`, flat `SOL101`-style, and `SOL-L###` code is remapped into the unified namespace; the legacy codes persist as non-normative migration aliases only. The full specification — per-layer 100-blocks, append-only-with-tombstoning, the diagnostic-record shape, and the legacy translation table — is §8 (catalogue in Appendix B).

## Alternatives considered

| Alternative | Why rejected |
|---|---|
| Keep `APS-*` as a live code prefix alongside `SOL-*` | Keeps two vocabularies for one tool; conflates the prose *standard* with its *diagnostics*, the exact ambiguity §8.5 removes. |
| Keep the flat `SOL101`/`SOL201`/`SOL301` numbering | The number alone carries no layer/phase signal, so a code cannot be filtered by pass or routed to a repair without an external lookup (§8.1.1). |
| Per-layer prefixes (e.g. `SYN-`, `PRO-`, `SEM-`) | Loses the single greppable namespace; the contract requires one prefix so any conformant tool and any author search one pattern (§8.1.1 rationale). |
| Reuse numbers after a code is retired | Breaks stable identity across versions; §8.1.1 mandates append-only with tombstoning so a retired number is never reused. |
| More or fewer than five layers | The five layers mirror the compiler passes 1:1 (§9); a sixth layer or a merge would break the code-letter-to-phase invariant. |

## Consequences

### Positive

- One greppable namespace: any conformant tool, author, or downstream agent matches a single `SOL-<LAYER>` pattern instead of a union of legacy families.
- The layer letter is self-describing — it names the phase that raises the code and the repair family that closes it — with no external table lookup.
- "APS" cleanly denotes the prose standard and nothing else, ending the standard-versus-code conflation.

### Negative

- Existing material that cited `APS-*` or `SOL-L###` codes is now stale; the contract requires citing only unified codes, so legacy references must be remapped via Appendix B.
- Append-only-with-tombstoning means the catalogue only grows and carries dead-but-reserved numbers forever.

### Neutral / tradeoffs

- Legacy codes are retained as non-normative aliases purely for migration; they have no force, so they are a bounded compatibility cost rather than a parallel vocabulary.
- The five-layer count is fixed to the pass model: changing the passes (ADR for the 9-pass model) is the only thing that could change the layer set.

## Status

Accepted (v0.1).

## Affected obligations / constraints

- Adds: the `SOL-<LAYER><NNN>` namespace contract — one prefix, five layers (`S`/`P`/`M`/`V`/`O`), three-digit 100-blocks, append-only with tombstoning (§8.1.1).
- Adds: the diagnostic-record shape `{ code, severity, layer, span, message, suggest }` as the checker-emit/surface contract (§8.1.2).
- Supersedes: the `APS-*` code prefix, the flat `SOL101`/`SOL201`/`SOL301` codes, and the `SOL-L###` family — all remapped to `SOL-<LAYER><NNN>` and retained only as non-normative migration aliases (§8.5).
