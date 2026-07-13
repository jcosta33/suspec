# Cheatsheet

```text
intent -> spec -> implement -> review -> check -> findings
```

Use the least structure that changes execution or reviewability. Everything else is rent. See
[proportional rigor](rigor-escalation.md).

## Artifacts

| Kind        | Carries                                                    |
| ----------- | ---------------------------------------------------------- |
| spec        | intent and verifiable requirements                         |
| task        | one scoped source slice                                    |
| review      | requirement assessments and evidence                       |
| inventory   | observed structure, behavior, tests, constraints, unknowns |
| change plan | baseline, target, preservation, waves, rollback            |
| audit       | evidenced present-state risks                              |
| research    | evidence for one decision-informing question               |

Evidence receipts and run notes are untyped sidecars. Findings are not a type. Exact shapes:
[artifact formats](artifact-formats.md).

## Requirement

```markdown
### AC-001 - Short name

The system must do one observable thing.

Verify with: `command`
```

Use one behavior, at least one binding word, one verification, and no unresolved uncertainty.

## Assessments

| Assessment  | Meaning                               |
| ----------- | ------------------------------------- |
| Supported   | evidence demonstrates the requirement |
| Unsupported | evidence demonstrates failure         |
| Unverified  | evidence is missing or insufficient   |
| Blocked     | a dependency prevents judgment        |

Reverify after requirement text, commands, or exercised code changes.

## Evidence

Use pasted command output, a visible labeled CI URL, or a named manual observation. `tests passed`
proves only that someone typed `tests passed`.

## Review attention

Expose unsupported, unverified, or blocked requirements; scope drift; excluded-area edits; risky or
public interfaces; migrations; security-sensitive changes; missing output; findings; and blocked
questions.

## Check

```bash
suspec check <artifact> [<artifact>...]
suspec check <review-path> --spec <spec-path>
suspec check <review-path> --spec <spec-path> --task <task-path>
suspec check --contract
```

Multi-path checks add C002 duplicate-ID reconciliation. Exit `0` is clean, `1` warning, and `2`
blocking. Multi-report `--json` output is JSON Lines. The checker reports facts; humans decide.
