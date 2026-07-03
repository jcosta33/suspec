---
name: implement-task
type: agent-guide
description: >-
  Implement a Suspec task packet: read the sources first, stay inside scope, run
  every Verify item and paste real output, self-review your diff before
  handoff. ALWAYS apply when given a task packet (`type: task`) or asked to
  implement against a spec's requirements. Do not edit outside the task's
  scope, claim a result without pasted output, or write a review result on
  your own work. Skip for writing specs, reviewing another agent's output, and
  splitting work into tasks.
---

# Implement a task

The task packet (`templates/task.md`) bounds your work: a scope of requirement
IDs, areas not to change, and a Verify checklist. Your job is to satisfy
exactly that scope and leave behind evidence a reviewer can check without
trusting you. These rules are conventions the review packet inspects — nothing
enforces them at edit time.

## Rules

1. **Read the sources first.** The task packet, then the linked spec (and
   change plan, if any), before touching code. _Why: the packet says what to
   do; the spec says why, and how success will be judged._
2. **One worktree (or branch) per task.** Keep this task's changes isolated so
   parallel tasks stay write-disjoint and the reviewer sees one clean diff.
3. **Stay in scope.** Implement the ACs the packet lists — no more. If a
   requirement cannot be met as written, or your change seems to need a
   non-goal or Do-not-change area, stop and say what you need and why —
   never improvise past the boundary or work around it. _Why: an improvised
   interpretation is a decision nobody made, landing where it is most
   expensive to find — in the code; and the stop-and-ask hatch is the
   measured-effective half of a scope wall._
4. **No out-of-scope edits.** "While I'm here" fixes belong in your summary as
   finding candidates, not in the diff. If an out-of-scope edit is truly
   unavoidable (a broken import on your path), keep it minimal and list every
   one explicitly in the summary. _Why: an unlisted out-of-scope change is an
   exception trigger at review; a listed one is a judgment call._
5. **Run every Verify item and paste the real output** — the command, its exit
   status, and the summary lines. A claim without output counts as unverified.
   No predictions ("should pass"), no paraphrase ("all green"), no pre-edit
   runs. If a command exists but cannot execute in your environment, produce
   a CI link or delegate the run; otherwise record the item as Blocked —
   never paste predicted output. If a Verify command is missing or undefined
   in `AGENTS.md`, ask which command to run — never guess; if it cannot be
   resolved, the item is Unverified. _Why: confident prose comes out whether or not the claim is true;
   pasted output is what a reviewer can re-check._
6. **Re-run after your last change.** Output pasted before a later edit is
   stale and no longer covers the claim.
7. **Adversarially self-review your diff before handoff.** Re-read it as a
   hostile reviewer: which path did you not exercise (edge, error,
   concurrency)? What changed that the spec did not ask for? Which callers of
   a changed surface did you not look at? Fix what you find and note what you
   fixed. _Why: the cheapest review round is the one you run on yourself._
8. **Record the run** — for 1:1 work (no task) fill the spec's `## Execution`
   section; for a split task fill the task's `## Run summary`. Either way:
   changed files, one line per Verify command citing its pasted output, anything
   that could not be met as written, out-of-scope edits if any, blocked questions
   — and drop durable discoveries in `## Findings`.
9. **Never write a review result on your own work.** Self-review yields fixes
   and notes — never a Pass. The review packet is filled by someone who did
   not write the diff. _Why: authors favor their own output; independence is
   the point of the review step._

**Spec-external mode (single-root).** When the workspace and code live in separate
repos, the task and its pinned spec snapshot sit in the code repo's gitignored `.suspec/`.
Read the snapshot; write only in the code repo (your code + `.suspec/` scratch) — never the
canonical workspace. Your commands and edits resolve against one root, and the review lead
merges your evidence back.

## Refuses

| Temptation                                   | Do instead                                                                              |
| -------------------------------------------- | --------------------------------------------------------------------------------------- |
| "Tests passed" with no output                | Run the command; paste command + exit + summary                                         |
| A drive-by refactor next to your change      | Note it as a finding candidate; leave the code alone                                    |
| The AC seems wrong or unbuildable as written | Stop; report why in the summary — do not reinterpret it                                 |
| Editing the spec to match what you built     | Flag the mismatch in the summary; the spec changes through its own review, not mid-task |
| Marking your own work `pass`                 | Leave the result to the review packet                                                   |
| Reusing output from before your last edit    | Re-run; paste the fresh output                                                          |
| A Verify command missing from `AGENTS.md`    | Ask which command to run — a guessed run is a false signal; unresolvable = Unverified   |

## Gotchas

- **Filling `## Run summary` from memory instead of the pasted Verify output.** You
  recall the suite was green and write "tests pass" — but the reviewer cites that cell,
  not your recollection. A summary line that does not point at real pasted output is
  unverified the moment it is read.
- **Editing a file outside the task's Affected areas because it was "right there."** A
  neighbouring bug or ugly import is on your path and the fix is one line. That unlisted
  change is an exception trigger at review and pollutes a diff that was meant to be
  write-disjoint from parallel tasks.
- **Pasting output captured before your last edit.** You ran Verify, then fixed one more
  thing, then handed off — the pasted run no longer covers the code you shipped. Stale
  evidence reads as fresh and hides the regression your final edit introduced.

## Self-review gate

Before declaring the task done:

- [ ] Every Verify item ran after your final edit, output pasted.
- [ ] The diff contains only in-scope changes — or every exception is listed
      in the summary.
- [ ] You hunted at least one path you had not exercised
      (edge / error / concurrency) and recorded what you found.
- [ ] Anything you could not meet as written is reported, not silently
      adapted.
- [ ] The summary names changed files, commands with output, and finding
      candidates.
- [ ] You issued no review result on your own work.
