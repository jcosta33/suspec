---
type: adr
id: adr-0164
status: accepted
created: 2026-07-18
---

# ADR-0164 - One spec format; the format selector retires

## Context

ADR-0058 gave the spec two surfaces: plain structured markdown (the default) and SOL, a stricter
flush-left obligation grammar selected per file by frontmatter `format: sol`. Both parsed to one
requirement record, so `format:` never unlocked a distinct check — it only chose a surface. SOL's
one contribution over the markdown form was the block-type distinction (`REQ`/`CONSTRAINT`/
`INVARIANT`/`INTERFACE`).

Two facts decided it. SOL had zero adoption — including in this project; its only instances were
paired parser-conformance fixtures. And `format:` is a second discriminator layered on `type:`,
which [ADR-0059](./0059-frontmatter-type-is-the-discriminator.md) already made the single one. Every
other artifact has exactly one structured shape implied by its type; the spec was the lone exception
carrying a format flag and a second surface.

## Decision

1. **A spec has one form: structured markdown.** Each requirement is a `### AC-NNN` heading carrying
   one obligation, one strength word (`MUST`/`MUST NOT`/`SHOULD`/`SHOULD NOT`/`MAY`), observable
   behavior, and one `Verify with:` line. Structure is inherent to `type: spec`, not selected.
2. **The `format:` frontmatter key retires.** It is not read, validated, or recognized. The spec
   frontmatter is `type, id, title, status, owner, sources[]`.
3. **The SOL surface retires with it.** The flush-left `REQ`/`CONSTRAINT`/`INVARIANT`/`INTERFACE`
   openers, the `QUESTION Q-NNN [blocking]:` header, and the `VERIFY BY` keyword are no longer
   parsed; `### AC-NNN` + `Verify with:` is the only requirement grammar. The block-type distinction
   is not carried; a spec states behaviors. A machine-precise interface contract, if it ever earns
   its cost, returns through evidence, not a standing second surface.
4. **C004 loses its SOL conditioning.** It counts strength words over the whole requirement
   statement; the SOL trigger/response narrowing and the `IF-` interface exemption retire.
5. **The contract advances to `0.22.0`.** This is a reduction — a surface, a selector, and a parser
   branch leave. No check ID is added, removed, renamed, or reused.

## Superseded and narrowed decisions

- [ADR-0058](./0058-two-tier-spec-format.md) is **superseded**. Decision 1 (the markdown spec form)
  stands as the sole form; Decisions 2-3 (the SOL surface, the two-surface record, the anti-fork
  fixture pairs) retire — with one surface there is nothing to fork.
- [ADR-0027](./0027-sol-is-the-obligation-language.md) is **narrowed**: its obligation semantics
  survive as the markdown form's uppercase-modal convention; SOL as a distinct notation and surface
  retires.
- [ADR-0059](./0059-frontmatter-type-is-the-discriminator.md) is **upheld and extended**: `type:`
  is the sole discriminator; the redundant `format:` axis is removed.

## Alternatives considered

| Alternative | Why rejected |
|---|---|
| Keep the two-tier split | A format selector redundant with `type:`, gating a surface nobody adopted; teaches vocabulary an adopter cannot decode. |
| Make SOL the one mandatory format | Imposes the exact flush-left grammar that failed to gain use, migrates every existing spec, and breaks the lightweight inline path. |
| Keep the block types as native markdown headings (`### IF-NNN`, `### C-NNN`) | More surface to teach, parse, and maintain for a niche with zero current usage; reintroduce a type only when a real interface-heavy spec demands it, on evidence. |

## Consequences

- The spec is written one way; there is no format to choose or flag.
- The checker parses one requirement grammar; the SOL branch, the `format` field, and C004's SOL
  conditioning leave the reference implementation.
- Existing specs are unaffected — all real specs already use the markdown form.
- A spec that still carries `format: sol` loses its flush-left requirements silently (they no longer
  parse as `### AC-NNN`) and fails on absent requirements; there are none in practice.

## Status

Accepted (2026-07-18). Supersedes [ADR-0058](./0058-two-tier-spec-format.md); narrows
[ADR-0027](./0027-sol-is-the-obligation-language.md); upholds
[ADR-0059](./0059-frontmatter-type-is-the-discriminator.md). Contract `0.22.0`.

## Propagation

- `checks/checks.yaml` — version `0.22.0`; `spec_form` drops the selector, `format` scalar, and
  `format_enum`; C004 drops the SOL IF- exemption note; the `VERIFY BY` verify alternative retires.
- corpus-cli — `parse_spec_record` drops the SOL branch and the `format` field; `checksContract`
  drops the SOL trigger/response narrowing, the IF- exemption, and `VERIFY BY`; `CONTRACT_VERSION`
  `0.22.0`; SOL tests retire.
- corpus-mcp — `SUPPORTED_CONTRACT_VERSION` `0.22.0`; fixtures refreshed.
- Canon: `docs/reference/structured-requirements.md` retires; `docs/reference/checks.md`,
  `artifact-formats.md`, `glossary.md`, `docs/04-writing-specs.md`, `checks/README.md`, and the
  domain fixtures drop the SOL surface and the `spec.sol.md` pairs.
- corpus-skills: `sus-spec`/`sus-task` already teach only the markdown form (no format flag).
- corpus-website: canon mirror repins; no site copy names `format: sol`.
