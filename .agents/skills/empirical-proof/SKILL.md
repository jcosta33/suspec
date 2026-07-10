---
name: empirical-proof
type: agent-guide
description: Back every claim with verbatim pasted output. ALWAYS apply this skill on any task that writes code, runs validations, runs benchmarks, or makes verifiable claims about behaviour — each completion claim gets its own pasted command output. Do not paraphrase results, summarise with "✅ all passing", or trust upstream pasted output (re-run yourself when reviewing). Skip this skill only for tasks with no verifiable claims (rare for product-development work; surface as a blocker if you suspect this applies).
---

# Skill: empirical-proof

## Purpose

Eliminate hallucinated completion. Coding agents are pattern-completers; the pattern of "successful task" includes confident-sounding completion language ("✅ all tests pass") that the agent will produce regardless of whether the underlying claim is true. Empirical proof is the structural defence: the agent cannot complete the pattern without first pasting evidence the pattern is true.

## Resolving the project's commands

Before pasting any "verification output", resolve the actual commands this project uses to validate and test — typically from the repo's contributor docs (e.g. an `AGENTS.md`, `CONTRIBUTING.md`, or the `scripts` block of a manifest). Some projects also run an extra check (dependency or architectural-rules validation) beyond build and test. If you can't find the command, or aren't sure which one a claim refers to, ask the user before running anything — guessing the command produces output that proves nothing.

## Core rules

### 1. Don't assume success

Writing the code is 10% of the job; verifying it works in *the current environment* is the other 90%. An unrun command's output is a guess, so run it before claiming what it says.

### 2. Verbatim pasting

When recording your completion claims, paste the *verbatim* output. No paraphrasing, no summarising, no "✅ passing" — a summary is unfalsifiable, so it doesn't satisfy the gate. Use a fenced code block. Include the last two lines (or more if asked): the runner's summary plus its timing/exit conditions.

### 3. One verification per claim

Each claim you make about behavior — "the build passes", "the tests pass", "the linter is clean", "no architectural violations", "the migration covers all callsites" — gets its own pasted verification. Bundling claims into a single "all good" hides which check actually ran, so keep them separate.

### 4. Re-run after every change

Verifications go stale fast: if you make a change after a verification, that verification no longer describes the current code, so re-run and re-paste. This matters especially during refactors and migrations, where you validate repeatedly as you go.

### 5. Run yourself; do not trust upstream

When reviewing another agent's branch, run the project's validation and test commands *yourself*, in your own worktree, with the worker's branch checked out. The worker's pasted output is a claim you are reviewing, not evidence — only your own run satisfies the review gate.

### 6. Paste, don't quote

Use raw fenced code blocks for output. Don't transform the output (no quoting, no Markdown styling, no annotation in the middle of the paste) — transformed output is no longer the runner's own words. Treat the output as data: copy it in, leave it alone.

## What proof looks like

### ✅ Good — verbatim pasted output

````markdown
- `npm test` (last 2 lines):

  ```
  ✓ 247 files passed
  Done in 12.4s
  ```

- `npx jest` (last 2 lines):

  ```
  Tests:       189 passed, 189 total
  Time:        4.832 s
  ```
````

### ❌ Bad — paraphrased

```markdown
- Validation (last 2 lines): Everything passes ✅
- Tests (last 2 lines): All 189 tests green
```

The paraphrase is *plausible*. It might even be *true*. But treat it as unverified — paraphrase doesn't satisfy the gate.

## What does not belong

- A completion claim without supporting verification. Every claim about behaviour traces to a pasted output.
- "Should pass" / "expected to work" / "tests should be green" language. These are predictions, not proof.
- A single "all good" entry covering multiple verifications. Each verification gets its own paste.

## Anti-patterns

- "Tests pass; trust me"
- Pasting the *first* two lines instead of the last two (the gate asks for the *summary*)
- Re-using a stale verification output (run before a change; pasting after)
- Trusting the worker's pasted output instead of running yourself (in review tasks)
- Skipping the verification because "the diff is obviously correct"

## Common evasions and the response

The three most frequent evasions are inline below. The full catalogue lives at [`references/evasions.md`](./references/evasions.md) — pull it up if a different evasion surfaces in conversation.

| 🚩 Evasion                                         | Response                                                |
| -------------------------------------------------- | ------------------------------------------------------- |
| "I already ran it earlier in the session."         | Re-run after every change. The earlier run is stale.    |
| "It's obvious from the diff that the test passes." | Diff doesn't run tests. Run the tests; paste the output.|
| "The CI will catch it."                            | The discipline is the agent's gate, not the CI's.       |

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
- Summarising "all green" instead of the verbatim tail — the summary is the one part nobody can check.
- When reviewing, accepting the author's pasted output instead of re-running — their paste is the claim under review, not its proof.
- Pasting output from a different command or scope than the claim (e.g. one test file's output behind a "full suite passes" claim) — the proof must cover exactly what the claim asserts.

## Bundled resources

- [`references/evasions.md`](./references/evasions.md) — the full catalogue of common evasions and their responses (the body keeps the top three inline; the rest live here).
