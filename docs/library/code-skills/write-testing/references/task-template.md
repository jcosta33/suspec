# Run notes: {{title}}

- Task packet: `tasks/{{TASK-slug}}.md`
- Driving doc (spec / audit / bug report, if any): `{{path}}`
- Worktree / branch: {{branch}}
- Created: {{YYYY-MM-DD}} · Status: active

> **Testing task** — tests are the deliverable. Test behavior, not implementation. Each test fails
> for one reason. Flip every assertion and prove the test means something. Coverage is a map, not
> a score.
>
> **Commands** resolve from the code repo's `AGENTS.md` Commands table. A coverage report and a
> single-test / flip-and-rerun runner are often project-specific — for any command you need that is
> undefined, ask the user; do not guess.

## Scope (from the task packet)

- Test: the behavior the listed ACs name — nothing another task owns.
- Do not change: production code (unless the packet says so); an existing flaky test (its own
  task); a production bug the tests expose (a finding, fixed in its own task).

## Coverage gap

The behavior currently untested or undertested — stated as behavior a caller depends on, not a
percentage. Which module, which behavior, which conditions.

-

## Test cases

One test per row, one reason to fail per test.

| Behavior under test | Inputs / setup | Expected outcome | Why this test exists | AC (if it verifies one) |
|---|---|---|---|---|
| | | | | |

## Test placement

Per the project's conventions — file naming, directory, runner. A test in the wrong place never
runs.

| Test case | File path | Runner |
|---|---|---|
| | | |

## Progress checklist

- [ ] Packet and driving doc read; coverage gap named as behavior
- [ ] Test cases enumerated; placement decided per project convention
- [ ] Each test written against the public surface, one reason to fail
- [ ] Each test flipped → fails → restored → passes (transition pasted below)
- [ ] Each AC-bound test confirmed to fail when *its* requirement is violated, not an adjacent
      condition
- [ ] High-stakes requirements / invariants carry a strengthened check (property, metamorphic,
      mutation) with a note of what it exercised
- [ ] Whole suite green after the final edit (output pasted)
- [ ] Findings recorded (bugs exposed, hard-to-test designs); self-review answered

## Evidence (paste actual command output — never paraphrase)

- Test command, whole suite (last lines + exit):
- Check command (last lines + exit):
- Flip transition per new test (fails flipped → passes restored) — representative sample:

## Decisions

Test-design choices the requirements did not constrain — placement convention, check type chosen
for a high-stakes requirement. An AC you could *not* build a fail-when-violated test for goes to
Blocked questions, not here.

-

## Findings

A real bug a test exposed, production code too coupled to test cleanly, a missing AC — candidates
for the workspace's `findings/` at Close.

-

## Blocked questions

An AC with no buildable fail-when-violated test (ask the spec owner to rebind it to a command or
manual check); a missing runner; production code that must change to be testable.

-

## Next steps

-

## Self-review

Answer in writing, evidence pasted. A test that passes when the code is commented out, asserts on
internals, or bundles behaviors is net-negative — it costs maintenance and catches nothing.

- **Flips:** did every new test fail when flipped and pass when restored, transitions pasted?
- **Behavior:** does each test exercise the public surface and survive a behavior-preserving
  refactor — no internals asserted?
- **One reason:** does each test fail for one reason, with a message that says what behavior broke?
- **Right reason:** does each AC-bound test fail when *its* requirement is violated? High-stakes
  checks strengthened and noted?
- **Determinism:** no ordering, timing, shared-state, network, or randomness dependency that could
  flake in CI?
- **Scope:** no production code edited outside the packet; bugs exposed recorded as findings; no
  review result issued on your own work.
