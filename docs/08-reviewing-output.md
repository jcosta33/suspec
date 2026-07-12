# Reviewing output

Review checks the worker's output against the **spec** — the task, when one exists,
scopes which requirements and indexes the evidence, but the spec is what the code is
judged against.

The reviewer's posture is refute-by-default: the worker's paste is a claim, not
evidence, and every green row is a candidate for disproof until the reviewer has
grounded it.

Do not read a large diff from line 1. Start with:

- requirement coverage
- failed, unverified, or blocked rows
- human-attention items
- changed files

Then open the diff where the packet points.

## Reviewer rule

The implementer does not render the review result. The reviewer is not the implementer — but the spec or task author may review, as long as they did not implement the change.

Use a fresh session, another agent, or a human reviewer.

The independent judgment is the invariant; the formal packet scales with risk. A substantial or high-diffusion change gets the full packet below; a trivial change the owner verified needs the judgment, not the paperwork.

When the change warrants more than one pass, escalate to a **rotating (Revolver) review**.
The lead derives distinct stances from the target's actual requirements, trust boundaries,
failure modes, and changed surfaces — never from a default menu. Run one reviewer at a
time, apply legitimate fixes between rounds, and make each next reviewer inspect the
revised change. A reviewer returns findings and evidence only; the lead reconciles them,
and the human owns the decision.

## Review packet

The reviewer writes the packet beside their own native artifacts, per the
[placement rule](03-where-files-live.md). The packet is checked against the spec passed explicitly
through `--spec`; it names only `task:` when split work exists. An agent reviewer drafts findings and evidence with the
coverage Result cells empty and `status: draft`; the human reviewer fills the results,
status, waivers, and suggested decision. [Artifact formats](reference/artifact-formats.md)
defines the core packet and the conditional sections earned by a change plan, multi-pass
review, open decision, or split task.

## Coverage table

One row per scoped requirement. This is a human-finalized row; an agent draft leaves the
Result cell empty:

```markdown
| ID | Result | Evidence | Human attention |
| --- | --- | --- | --- |
| AC-001 | Pass | `npm test -- expired-session` -> `3 passed` | yes |
```

Results:

- `Pass`: evidence shows the requirement is met.
- `Fail`: evidence shows the requirement is not met.
- `Unverified`: evidence is missing or insufficient.
- `Blocked`: the requirement cannot be judged yet.

Empty evidence means `Unverified`, never `Pass`.

## Evidence

Valid evidence:

- pasted command output
- CI link with the relevant job
- named manual observation

Invalid evidence:

- `tests passed`
- the worker's summary alone
- a screenshot with no stated check
- a claim that a command was run, without output or link

The worker's paste is a claim, not evidence: the independent reviewer re-runs the checks and
pastes their own output. Staleness is the reviewer's to own the same way — read the diff and
confirm the evidence was produced against the code being judged, not an earlier state. An agent
records those facts; the human assigns the Result.

## The deterministic check

When the human has finalized the packet, run the floor:

```bash
suspec check <review-path> --spec <spec-path>
suspec check <review-path> --spec <spec-path> --task <task-path>
```

Companions are explicit: the checker reads exactly the files it is handed, and a review
packet checked without a required companion is a blocking error (exit 2) — the floor
never silently degrades into a shallower check (level: enforced — suspec-cli).

What it verifies are structural and binding facts: every scoped requirement has a coverage
row, every `Pass` row backed by a structured `verify` block
has its command machine-matched against the spec's `Verify with:` line (a `Pass` row
backed only by the free-form Evidence cell draws an advisory warning instead — routed to
human attention, not machine-verified for command correctness), every `Pass` carries
evidence, every supported reference resolves — plus the packet's lint.
Exit codes: `0` clean, `1` warning, `2` blocking. It reports facts; it never renders the
review result. What no tool covers — whether the evidence actually demonstrates the
requirement — is the reviewer's own run and the human's review result.

## Human attention

Route anything a reviewer must inspect:

- failed, unverified, or blocked requirements
- out-of-scope edits
- changed `Do not change` paths
- risky files
- public interface changes
- migrations
- security-sensitive changes
- missing or weak test output
- candidate findings
- unresolved questions
- missing or unconvincing worker-boot provenance for a delegated task

If no trigger applies, say `None`.

## Rerun evidence

Rerun every applicable Verify item against the code being judged. When a command cannot
be rerun, name the reason and leave the row `Unverified` unless a directly inspectable CI
run or named manual observation supplies the evidence. Record each rerun:

```markdown
Reran AC-001: `npm test -- expired-session`; output matched the evidence row.
```

## Suggested decision

Use the table:

| State | Decision |
| --- | --- |
| All scoped rows Pass, exceptions routed | Merge |
| Any Fail | Do not merge |
| Any Unverified without waiver | Do not merge |
| Any Blocked | Do not merge |
| Fail or Unverified waived by owner | Merge with waiver |

Only the human reviewer writes the suggested decision. No packet, check, or agent merges
anything.

Waivers name:

- who accepted it
- which rows it covers
- why
- expiry or follow-up

## Review status

Use:

- `draft`
- `pass`
- `waived`
- `blocked`
- `needs-human`

The status is about the review packet, not the PR platform state. Agent-authored drafts stay
`draft`; a human reviewer sets every other value.

## App-run evidence

An agent driving the app can produce evidence: actions taken, screen state, logs, or screenshots.

It does not produce the review result. A reviewer still judges the evidence against the requirement.

## Related

- Next: [Saving findings](09-saving-findings.md)
- Previous: [Running agents](07-running-agents.md)
