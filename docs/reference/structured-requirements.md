# Structured requirements (SOL)

> **Experimental annex.** SOL is parsed through `format: sol`, but plain Markdown is the
> recommended spec form. SOL has no measured LLM-side result of its own. Use it only when its
> stricter visual notation helps the work.

SOL changes requirement openers. It does not create a second check catalog.

## Select SOL

```yaml
---
type: spec
id: SPEC-auth-refresh
status: draft
format: sol
sources: [ISSUE-123]
---
```

The `format` value is exact and case-sensitive. Filename suffixes carry no meaning.

## Parsed syntax

The checker recognizes these flush-left openers only when `format: sol` is present:

```text
REQ AC-001:
CONSTRAINT C-001:
INVARIANT I-001:
INTERFACE IF-001:
```

The opener keyword is exact and uppercase. The ID shape is uppercase letters or digits, a hyphen,
then digits. Use `AC-`, `C-`, `I-`, and `IF-` as shown; the parser does not enforce keyword-to-prefix
matching.

The body continues until another recognized SOL opener or a Markdown heading at level 1-3. Blank
lines do not close it. Fenced examples are ignored as structure and evidence.

A non-empty line beginning with `VERIFY BY` supplies the same verification-command field that plain
specs supply with `Verify with:`:

```sol
REQ AC-001:
WHEN the user submits an empty email
THE client MUST show "Email is required"
VERIFY BY npm test -- signup-empty-email
```

The checker treats the remaining body as text. It does not parse a method grammar, metadata clauses,
dependency edges, actors, triggers, contradictions, or task splits.

## Questions

Question headers are exact:

```sol
QUESTION Q-001 [blocking]:
Should expired sessions redirect or show inline re-auth?

QUESTION Q-002 [non-blocking]:
Which telemetry label should be preferred?
```

Only lowercase `[blocking]` and `[non-blocking]` are accepted. Any other line beginning with
`QUESTION` is a parse error. A blocking question prevents `status: ready` through C007.

Questions are not requirement records and do not enter review coverage.

## Authoring convention

The parser does not enforce these clauses, but this compact shape keeps SOL readable:

```sol
CONSTRAINT C-001:
THE auth client MUST NOT import from server-only modules
BECAUSE client bundles cannot contain server secrets
VERIFY BY pnpm lint

INVARIANT I-001:
A user MUST NOT have more than one active refresh-token family
VERIFY BY pnpm test -- token-family

INTERFACE IF-001:
refreshSession accepts a refresh token and returns Session or AuthExpired
VERIFY BY pnpm test -- refresh-session-contract
```

Use `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, or `MAY` for obligations. Keep one behavior per
requirement. State optional dependency, affected-area, or risk notes as ordinary body text only when
they help a human reader.

## Checks

SOL and plain requirements enter the same structural check record: ID, source line, body, and named
verification command. The implemented [core checks](checks.md#core-checks) then apply to both forms.

SOL adds one parser error for malformed `QUESTION` headers. No `SOL-S`, `SOL-P`, `SOL-M`, `SOL-V`, or
`SOL-O` checker codes are implemented or published as contract.

## Related

- [Writing specs](../04-writing-specs.md)
- [Checks](checks.md)
- [Artifact formats](artifact-formats.md)
- [Reviewing output](../08-reviewing-output.md)
- [CLI reference](cli.md)
