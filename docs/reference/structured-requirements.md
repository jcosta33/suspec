# Structured requirements (SOL)

> **Experimental annex.** SOL is shipped and parsed (`format: sol`), but it sits outside the
> recommended path: controlled requirement syntax (EARS-style clauses) is an established
> convention elsewhere ([[KIRO]](../research/sources.md#KIRO)), and design rationale — not a
> measured result — is why SOL exists, and it has **no measured LLM-side result** of its own.
> Use it if your risk profile wants it; nothing else in Suspec depends on it.

SOL is the stricter spec form.

Use it by adding this frontmatter:

```yaml
format: sol
```

Plain markdown is the default. SOL is useful for high-risk specs or specs you want a parser to read.

## Shared model across plain and SOL surfaces

Plain specs and SOL specs produce the same requirement record:

```text
{ id, strength, statement, verify_refs[], kind, edges[] }
```

Shared rules:

- IDs are unique within a file.
- Requirement IDs are spec-scoped.
- Cross-spec references use `SPEC-id#AC-NNN`.
- Every requirement needs verification.
- Review consumes the same assessments: `Supported`, `Unsupported`, `Unverified`, `Blocked`.

## Selector

The frontmatter field is the selector. Filename suffixes carry no Suspec meaning.

```yaml
---
type: spec
id: SPEC-auth-refresh
status: draft
format: sol
---
```

## Block rules

- Header is flush-left: `REQ AC-001:`.
- Body runs until the next block header or heading — a blank line does not end it.
- Keywords are uppercase and case-sensitive.
- Condition text is opaque. No expression syntax.
- Do not put blank lines inside a block: the parser folds whatever follows into the
  same body instead of stopping, so stray text gets absorbed silently.

## Block types

| Block | ID prefix | Use |
| --- | --- | --- |
| `REQ` | `AC-` | required behavior |
| `CONSTRAINT` | `C-` | solution boundary |
| `INVARIANT` | `I-` | always-held property |
| `INTERFACE` | `IF-` | declared boundary |
| `QUESTION` | `Q-` | unresolved ambiguity |

## REQ

```sol
REQ AC-001:
WHEN the user submits the signup form
AND the email field is empty
THE client MUST show "Email is required"
AND THE client MUST NOT send a signup request
VERIFY BY test:cmdTest:signup-empty-email
DEPENDS ON AC-000
WRITES src/signup/**
RISK medium
```

Rules:

- Conditions use `WHERE`, `WHILE`, `WHEN`, or `IF`.
- `THE <actor> <STRENGTH> <response>` is required.
- `AND THE ...` adds another consequence under the same condition.
- `SHOULD` and `SHOULD NOT` need `BECAUSE` or `EXCEPT`.
- `VERIFY BY` is required.

## CONSTRAINT

```sol
CONSTRAINT C-001:
THE auth client MUST NOT import from `server/*`
BECAUSE the client bundle must not embed server-only secrets
VERIFY BY static:cmdLint:dependency-boundary-check
AFFECTS src/auth/**
```

Use constraints for how requirements may be satisfied.

## INVARIANT

```sol
INVARIANT I-001:
A user MUST NOT have more than one active refresh token family
VERIFY BY property:cmdTest:token-family-invariant
```

Use invariants for properties that must hold across states.

## INTERFACE

```sol
INTERFACE IF-001:
`refreshSession` RETURNS `Session | AuthExpired`
ACCEPTS:
  - `refreshToken: string`
ERRORS:
  - network-timeout
  - invalid-refresh-token
OWNED BY auth-client
VERIFY BY contract:cmdContract:refresh-session-contract
```

Interfaces use contract verification.

## QUESTION

```sol
QUESTION Q-001 [blocking]:
Should expired sessions redirect to `/login` or show inline re-auth?
AFFECTS AC-001
```

The header marker is required and exact: lowercase `[blocking]` or `[non-blocking]`, followed
immediately by `:`. Missing markers, different casing, and every other marker are malformed
headers (SOL-S007). A spec with a blocking question stays `draft`.

## Strength words

| Word | Meaning |
| --- | --- |
| `MUST` | required |
| `MUST NOT` | forbidden |
| `SHOULD` | default; needs reason or exception |
| `SHOULD NOT` | default prohibition; needs reason or exception |
| `MAY` | permitted |

Do not use `SHALL` as a strength word.

## VERIFY BY

```text
VERIFY BY <method>[:<scope>]:<adapter>:<artifact>[#<selector>]
```

Methods:

- `static`
- `test`
- `contract`
- `property`
- `model`
- `perf`
- `security`
- `manual`
- `monitor`

For `test`, scope may be `unit`, `integration`, or `e2e`.

Adapters name commands the project itself defines — its own test, lint, or contract
runners. Suspec resolves nothing; the adapter label tells the reader which project command
proves the requirement.

## Metadata

| Clause | Use |
| --- | --- |
| `DEPENDS ON` | ordering |
| `WRITES` | write surface |
| `READS` | read surface |
| `AFFECTS` | impacted IDs or paths |
| `RISK` | `low`, `medium`, `high`, or `critical` |

Metadata informs splitting and review. It does not add behavior.

## Check status

Core checks apply to SOL specs.

SOL-specific checks are the contract in [checks](checks.md).

Treat them as checklist items unless the checks contract (`suspec check --contract`) lists
them as implemented.

## Versioning

SOL is unversioned. `format: sol` is the parser hook.

## Related

- [Writing specs](../04-writing-specs.md)
- [Checks](checks.md)
- [Artifact formats](artifact-formats.md)
- [Reviewing output](../08-reviewing-output.md)
- [CLI reference](cli.md)
