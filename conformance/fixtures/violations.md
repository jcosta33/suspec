# Checks fixtures — violations

*Advanced design note — internal rationale; not needed to use Swarm.*

One minimal negative fixture per violation class. Each snippet must be flagged by a
checker applying [`../conformance.yaml`](../conformance.yaml) — or by a reviewer applying
[the checks reference](../../docs/reference/checks.md) by hand — with exactly the named
check at the named severity. A checker that stays silent on any of these is wrong; so is
one that reports a different check. Inert fixture data — nothing here runs.

---

## V1 — empty paste slot (`non-empty-paste`, hard error)

A task packet's Verify section, every box checked, no output anywhere:

```markdown
## Verify

- [x] `npm test -- export-json.spec.ts` (AC-001)
- [x] `npm run lint` (AC-002)
```

**Expected:** flagged — both items claim completion with no pasted output, no CI link,
and no `n/a` + reason. A claim without visible output is unverified; this is the
hallucinated-completion hole the rule exists to close.

---

## V2 — Pass with an empty Evidence cell (`pass-needs-evidence`, hard error)

A review packet's coverage table:

```markdown
| ID | Result | Evidence | Human attention |
|---|---|---|---|
| AC-001 | Pass |  | no |
```

**Expected:** flagged — an empty Evidence cell means **Unverified**, never **Pass**.
The row's correct content is `Unverified` plus a Human attention entry.

---

## V3 — `TBD` at `status: ready` (`no-tbd-at-ready` / C007, hard error)

A spec with frontmatter `status: ready` whose Requirements section reads:

```markdown
### AC-001 — Cached repeat queries
When the same query repeats within a session, the search service must return
the cached result.

Verify with: `search-cache.spec.ts`

### AC-002 — TBD (waiting on product)
```

**Expected:** flagged — C007 is a spec check: `ready` means tasks may be cut from this
spec, and a `TBD` requirement hands an agent an undecided behavior. At `status: draft`
the same line is fine. (A `TBD` inside a task packet is caught one step earlier — the
task's scope ids must resolve against the spec, and `AC-002` here resolves to nothing.)

---

## V4 — requirement without a `Verify with:` line (C003 `verify-with`, hard error)

A spec's Requirements section:

```markdown
### AC-003 — rate-limit responses

When a client exceeds 100 requests per minute, the API must return 429.
```

**Expected:** flagged — no `Verify with:` line (SOL form: no `VERIFY BY`). The
verification line is the highest-value line in a spec; without it the requirement can
only ever review as Unverified.

---

## V5 — duplicate requirement ID (C001 `unique-ids`, hard error)

One spec, two headings claiming the same ID:

```markdown
### AC-001 — accept the coupon code

### AC-001 — reject expired coupons
```

**Expected:** flagged — `AC-001` appears twice in one file. Tasks scope work and reviews
report coverage by requirement ID; a duplicated ID makes both ambiguous.

---

## V6 — open blocking question at `closed` (`no-open-critical`, hard error)

A task packet with frontmatter `status: closed` whose Findings section contains:

```markdown
## Findings

- Open question (blocking): should a refresh rotate the whole token family, or
  only the access token? Undecided — AC-002 implemented on a guess.
```

**Expected:** flagged — `closed` is terminal, and a blocking question is still open inside
the packet. The status must stay non-terminal (or the review go to `needs-human`) until
the question is resolved.

---

## V7 — out-of-scope change unflagged (`trigger-coverage`, warning)

A task whose Affected areas list `src/auth/refresh.ts`, reviewed by a packet that says:

```markdown
## Changed files

- `src/auth/refresh.ts`
- `src/billing/invoice.ts`

## Human attention

None — all requirements pass.
```

**Expected:** flagged — `src/billing/invoice.ts` is outside the task's Affected areas
and no Human attention entry routes it. An out-of-scope change is an exception trigger;
the packet must surface it even when every requirement row is green.
