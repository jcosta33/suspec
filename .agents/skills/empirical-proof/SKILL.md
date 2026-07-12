---
name: empirical-proof
type: agent-guide
description: Back every command-verifiable completion claim with verbatim pasted output. ALWAYS apply this skill on any task that writes code, runs validations, runs benchmarks, or makes verifiable claims about behaviour. For CI-only, manual, or source-inspection evidence, cite the exact durable evidence and state what you could not run; never fabricate a command-shaped substitute. Do not paraphrase results or trust upstream pasted output when you can rerun it. Skip only tasks with no verifiable claims.
---

# Skill: empirical-proof

## Purpose

Eliminate hallucinated completion. Coding agents are pattern-completers; the pattern of a successful
task includes confident completion language that can appear whether or not the underlying claim is
true. Empirical proof is the structural defence: the agent cannot complete that pattern without
first pasting evidence the claim is true.

## Resolving the project's commands

Before pasting any "verification output", resolve the actual commands this project uses to validate and test — typically from the repo's contributor docs (e.g. an `AGENTS.md`, `CONTRIBUTING.md`, or the `scripts` block of a manifest). Some projects also run an extra check (dependency or architectural-rules validation) beyond build and test. If you can't find the command, or aren't sure which one a claim refers to, ask the user before running anything — guessing the command produces output that proves nothing.

## Core rules

### 1. Don't assume success

Writing code does not establish how it behaves in *the current environment*. An unrun command's
output is a guess, so run it before claiming what it says.

### 2. Verbatim pasting

When recording command-backed completion claims, paste the *verbatim* output. An agent-written
paraphrase is unfalsifiable, so it does not satisfy the gate. Use a fenced code block. Include the
runner's own summary plus its timing or exit conditions.

### 3. One verification per claim

Each command-verifiable behavior claim — "the build passes", "the tests pass", "the linter is
clean", "no architectural violations", "the migration covers all callsites" — gets its own pasted
verification. Bundling claims into a single "all good" hides which check actually ran, so keep them
separate.

### Evidence that is not a local command

Some requirements are verified by a completed CI run, a named human observation, or direct source
inspection. Preserve that evidence in its native form: cite the CI URL, job, and commit; name who
performed the manual check and what they observed; or cite the exact file and line inspected. Never
invent command output for a non-command check. If the required evidence is unavailable, state the gap
and do not make the completion claim.

### 4. Re-run after every relevant change

Verifications go stale when a later change can affect the claim they support. Re-run and re-paste
those checks after the relevant edit. Unrelated evidence stays valid: a prose-only edit does not
invalidate an already-recorded binary benchmark, while an implementation edit does invalidate its
test and build results.

### 5. Run yourself; do not trust upstream

When reviewing another agent's branch, run the project's runnable validation and test commands
*yourself*, in your own worktree, with the worker's branch checked out. The worker's pasted output is
a claim you are reviewing. For a CI-only, manual, or source-inspection check, inspect the named durable
evidence directly; if you cannot, route the evidence gap to the human.

### 6. Paste, don't quote

Use raw fenced code blocks for output. Don't transform the output (no quoting, no Markdown styling, no annotation in the middle of the paste) — transformed output is no longer the runner's own words. Treat the output as data: copy it in, leave it alone.

## What proof looks like

### Good — verbatim pasted output

````markdown
- `npm test`:

  ```
  Test suites: all passed
  Done in 12.4s
  ```

  Exit: `0`

- `npx jest`:

  ```
  Tests:       all passed
  Time:        4.832 s
  ```

  Exit: `0`
````

### Bad — paraphrased

```markdown
- Validation: Everything passes
- Tests: All tests are green
```

The paraphrase is *plausible*. It might even be *true*. But treat it as unverified — paraphrase doesn't satisfy the gate.

## What does not belong

- A completion claim without supporting verification. Every command-verifiable behavior claim traces
  to pasted output; every non-command claim traces to its exact durable evidence.
- "Should pass" / "expected to work" / "tests should be green" language. These are predictions, not proof.
- A single "all good" entry covering multiple verifications. Each verification gets its own evidence.

## Anti-patterns

- "Tests pass; trust me"
- Pasting a startup banner while omitting the runner summary and recorded exit status
- Re-using a stale verification output (run before a change; pasting after)
- Trusting the worker's command output instead of rerunning a runnable check
- Skipping the verification because "the diff is obviously correct"

## Common evasions and the response

Common evasions are inline below. The larger catalogue lives at
[`references/evasions.md`](./references/evasions.md) — pull it up when another evasion surfaces.

| Evasion                                            | Response                                                             |
| -------------------------------------------------- | -------------------------------------------------------------------- |
| "I already ran it earlier in the session."         | Re-run if a later change can affect that result.                      |
| "It's obvious from the diff that the test passes." | Diff doesn't run tests. Run the tests; paste the output.              |
| "The CI will catch it."                            | Future CI is not evidence; cite a completed run or run it locally.   |

## Type-specific applications

The empirical-proof discipline is universal, but each kind of work emphasises different proofs:

- **Refactor:** per-checkpoint validation output as you go.
- **Migration:** per-wave validation and test output.
- **Performance:** baseline + target benchmark output under the *same* protocol.
- **Bug report:** the bug actually firing (reproduction output).
- **Testing:** test pass + assertion-flip proof.
- **Documentation:** every code example actually run.

## Gotchas

- Pasting a pre-edit run as if it were current — re-run after the last edit, or the paste describes code that no longer exists.
- Summarising "all green" instead of pasting the runner's own summary and recorded exit status.
- When reviewing, accepting the author's pasted output instead of re-running a runnable check — their
  paste is the claim under review. Inspect non-command evidence directly.
- Pasting output from a different command or scope than the claim (e.g. one test file's output behind a "full suite passes" claim) — the proof must cover exactly what the claim asserts.

## Bundled resources

- [`references/evasions.md`](./references/evasions.md) — the larger catalogue of common evasions
  and their responses.
