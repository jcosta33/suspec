# Proof Types and the `VERIFY BY` Binding

> Authoritative source: `.agents/specs/swarm/04-verification.md` §15.1 (the nine closed proof types) and §15.2 (the `VERIFY BY` binding grammar). This is a reference projection; where it and the spec disagree, the spec governs.

Swarm is markdown-only, provider-neutral, and has **no runtime**. Nothing here is shipped code: the linter, the `VERIFY BY` resolver, and the proof runner are all **contracts** a future tool builds against. A proof can *falsify* an obligation but may never silently amend its intent, and **schema-valid output is not a proof** — shape is not truth (the `CODE IS REALITY` invariant, §2).

A verdict is only as trustworthy as the proof behind it. `VERIFY BY` is the clause that attaches a proof to an obligation; the `<type>` it names is drawn from a **closed set of exactly nine proof types**.

## The nine proof types (closed)

`VERIFY BY` binds an obligation to **exactly one** of nine proof types. The set is closed: a conformant linter MUST reject any `<type>` outside it as `SOL-V009` (unknown-proof-type). This canonical set resolves the earlier 11-type and 7-type proposals into one.

| # | Proof type | One-line definition |
| --- | --- | --- |
| 1 | `static` | A non-executing analysis of source: type-check, lint, dependency-boundary check, schema validation of source. |
| 2 | `test` | An executable test that drives the system and asserts an observable outcome. |
| 3 | `contract` | A verification that a declared boundary (an `INTERFACE`) honours its `RETURNS`/`ACCEPTS`/`ERRORS` shape — a consumer/provider contract test, pact, or schema-conformance check at a boundary. |
| 4 | `property` | A generative/property-based check that asserts a universally-quantified property over many generated inputs. |
| 5 | `model` | Model-checking OR an economical proof of a property — **not** a full theorem per obligation. |
| 6 | `perf` | A measured performance/throughput/latency assertion against a threshold. |
| 7 | `security` | A security-specific oracle: SAST/DAST, secret scan, authz/authn test, dependency-vuln gate. |
| 8 | `manual` | A recorded human judgment against the obligation — the **honest escape hatch** when no executable oracle exists. |
| 9 | `monitor` | A runtime/production observation (logs, metrics, alerts, canary). Runtime evidence maps here. |

### Two normative notes

- **`unit`/`integration`/`e2e` are scope qualifiers under `test`, not separate types.** They are written `test:unit:`, `test:integration:`, `test:e2e:` in the binding. A conformant linter MUST treat `unit`, `integration`, or `e2e` appearing as a top-level `<type>` as `SOL-V009` (unknown-proof-type; use the qualifier form instead).
- **`runtime` maps to `monitor`.** There is no `runtime` proof type; any "verified in production / observed at runtime" claim binds as `monitor`.

## The `VERIFY BY` binding syntax

The surface clause is `VERIFY BY` — two words, uppercase (per the keyword convention, §5) — followed by a typed reference. The surface form is always `VERIFY BY`; `VERIFY_BY` is surface-illegal.

```ebnf
verify_line  = "VERIFY BY", ws, verify_ref, nl;
verify_ref   = typed_ref | bare_ref;
typed_ref    = proof_type, [ ":", test_scope ], ":", adapter, ":", artifact, [ "#", selector ];
proof_type   = "static" | "test" | "contract" | "property" | "model"
             | "perf" | "security" | "manual" | "monitor";
test_scope   = "unit" | "integration" | "e2e";   (* only legal when proof_type = "test" *)
bare_ref     = ? opaque proof reference with no proof_type segment;
               structurally valid, raises the §15 advisory untyped-binding smell ?;
adapter      = ident;            (* resolves through AGENTS.md > Commands *)
artifact     = path | ident | quoted_string;
selector     = ident | path-fragment;   (* a case/scenario/property name *)
```

Segment by segment:

- **`<type>`** is the closed, lint-typed, IR-typed dimension. For `test`, an optional scope qualifier (`unit`/`integration`/`e2e`) follows the type as its own segment — `test:<scope>:<adapter>:<artifact>`, e.g. `test:unit:cmdTest:...` — modelled by the grammar as `proof_type [: test_scope] : adapter : artifact`.
- **`<adapter>`** is a **project free-string** that resolves to a command slot in `AGENTS.md > Commands` (§15.3); the `cmd*` placeholder slots *are* the adapters.
- **`<artifact>`** is a **project free-string**: a file, test id, suite name, or contract file.
- **`<selector>`** (optional, after `#`) narrows the artifact to a single case, scenario, or property.

The IR field name for this clause is `verify_by[]` (snake_case — §12), normalized to `{type, adapter, ref, selector, gate}`.

### Worked examples

```sol
REQ AC-001:
WHEN the refresh token is expired
THE client MUST clear the local session
VERIFY BY test:unit:cmdTest:auth-refresh-expired-token#clears_session
```

```sol
CONSTRAINT C-001:
THE auth client MUST NOT import from `server/*`
VERIFY BY static:cmdLint:dependency-boundary#no-server-imports
```

```sol
INTERFACE IF-001:
`refreshSession` RETURNS `Session | AuthExpired`
ERRORS:
  - network-timeout
  - invalid-refresh-token
OWNED BY auth-client
VERIFY BY contract:cmdContract:refresh-session.pact#refreshSession
```

### Bare (untyped) references

A bare `VERIFY BY <ref>` with no `type:` segment is **structurally valid** but raises an advisory untyped-binding smell (`SOL-V`-family). The typed `type:adapter:artifact` form is REQUIRED wherever a type-driven rule fires:

- an `INTERFACE` binding, which MUST be `contract` (`SOL-V006`);
- an `INVARIANT` type-preference (`SOL-V003`);
- an obligation entering a `CONTRADICTED` proof-strength tie-break (§17);
- a per-task default-suite check (§15.8).

A migration importing legacy specs MAY carry bare refs; `improve`/`NORMALIZE` upgrades them to typed bindings.

## Why the boundary matters (design rationale)

The taxonomy is deliberately *closed* so that a future linter can reason about it: the `<type>` is analyzable, while `<adapter>` and `<artifact>` stay free strings (kept in `AGENTS.md`) so the same spec ports across repos. (Cross-reference: the two-layer obligation/adapter model is §15.3, outside this projection's scope.)

The closed set tracks the **test-oracle problem**: when a precise oracle is unavailable, a single concrete example cannot stand in for an obligation's predicate, and property-based / metamorphic pseudo-oracles are the principled response [ORACLE]. This is why `property` and `model` are first-class types rather than scope notes under `test`, and why `manual` is named honestly rather than disguised as a passing test. A binding that resolves only to "schema-valid output" or a bare "tests passed" is not a proof and yields `UNVERIFIED`, not `PASS` (the *what is NOT a proof* floor, §15.9; oracle-adequacy motivation [SWEBENCH-ADQ], [UTBOOST]).

A bound proof produces exactly one CORE verdict — `PASS`, `FAIL`, `BLOCKED`, or `UNVERIFIED` (§14.1) — and the lifecycle decorators (`WAIVED`/`STALE`/`CONTRADICTED`) annotate that result; the full seven-value verdict model and the merge gate live in §14, outside this projection.

## Preserved / Dropped / Still-uncertain

**Preserved (this projection's job).** The full closed list of nine proof types with their one-line definitions; the two normative notes (`test`-scope qualifiers; `runtime` → `monitor`); the complete `VERIFY BY` EBNF grammar; the segment semantics (`<type>`/`<adapter>`/`<artifact>`/`<selector>`); all three worked examples verbatim; the bare-reference rule and its four type-driven triggers; the `verify_by[]` IR normalization; the `SOL-V009` closed-set enforcement.

**Dropped / left to the spec.** The two-layer obligation/adapter resolution and the default proof-type → `cmd*` slot mapping (§15.3); type-selection rules per block type (§15.4); the meaning of `model` "not a theorem per obligation" in depth (§15.5); the proof-strength order (§15.6); one-VERDICT-per-binding (§15.7); per-task-type default suites (§15.8); the full *what is NOT a proof* list and oracle-adequacy record / `SOL-V011` (§15.9–§15.10); the seven-value verdict model, verdict-line grammar, and merge gate (§14). These are referenced only as cross-links, not restated.

**Still-uncertain.** Nothing in §15.1/§15.2 is marked open here. Forward-looking directions that *touch* this clause — e.g. FRETish-style temporal-logic binding to proofs and the future `monitor`/temporal direction — are deferrals tracked by the spec (sources.md, deferral D1), not commitments of this reference.
