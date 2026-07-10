# Cheatsheet

## The loop

```text
Spec ──▶ (Task) ──▶ Implement ──▶ Review ──▶ Close
```

Task is optional — cut task packets only when the work splits or wants an explicit
hand-off. Close saves what the work taught: durable lessons become native memories
([memory](memory.md)).

## Proportional rigor

Use the least structure that changes execution or reviewability: a trivial fix gets a
one-line inline spec and no file; a feature gets a lean spec with requirements and
acceptance criteria; large work extends rather than pads. The rungs and when to climb:
[rigor ladder](rigor-escalation.md).

## Artifacts

| Kind | Carries |
| --- | --- |
| spec | intent, non-goals, requirements (`AC-NNN` + `Verify with:`), open questions |
| task packet | one scoped slice of a spec, for hand-off |
| review packet | requirement coverage, evidence, human attention |
| change plan | baseline, target, preservation guarantees, verified waves |
| finding | one lesson; a durable one becomes a native memory |

Shapes: [artifact formats](artifact-formats.md).

## Where files go

Place the file next to your own native artifacts — the same place you keep your plans,
notes, and memories for this work, in a folder named after the repo you are working on (or
wherever fits your harness best). You choose the exact spot; keep it out of the repo unless
the project's own governance says otherwise, and carry the file's full path forward — every
later step names artifacts by explicit path.

## Requirement

```markdown
### AC-001 - Short name

The system must do one observable thing.

Verify with: `command`
```

Rules:

- one behavior
- at least one binding word (more than one flags a split candidate)
- one verify line
- uncertainty goes to Open questions

## Results

| Result | Meaning |
| --- | --- |
| Pass | evidence shows the requirement is met |
| Fail | evidence shows the requirement is not met |
| Unverified | evidence is missing or insufficient |
| Blocked | cannot judge yet |

Empty evidence means `Unverified`. A prior `Pass` whose requirement text, verify command,
or exercised code has changed is stale — re-verify ([drift](drift.md)).

## Evidence

Valid:

- pasted command output
- CI link
- named manual observation

Invalid:

- `tests passed`
- a worker summary alone
- an unsupported screenshot

## Review triggers

Route to Human attention:

- Fail, Unverified, Blocked
- out-of-scope edits
- `Do not change` touched
- risky files
- public interface changes
- migrations
- security-sensitive changes
- missing test output
- candidate findings
- blocked questions

## Checks

```bash
suspec check <path>                                                # spec or change plan
suspec check <review-path> --spec <spec-path> --task <task-path>   # review packet
suspec check --contract                                            # the checks contract as JSON
```

Exit `0` clean · `1` warning · `2` blocking. A review checked without a required companion
is a blocking error (exit 2). The checker reports facts, never verdicts — the human owns
the result. Full reference: [CLI](cli.md) · the contract: [checks](checks.md).
