---
name: implement-task
type: agent-guide
description: >-
  Implement a generic or unclassified Suspec task packet: read sources, stay
  inside scope, run every Verify item, and self-review before handoff. Apply
  only when no specialized implementation skill matches. Do not co-activate
  with a specialized implementation skill, edit outside scope, claim a result
  without evidence, or assess your own work.
---

# Implement a task

`DISRESPEC-SPINE: One fact once. No filler, repeated source material, empty sections, or chat restatement; after successful creation return only clickable artifact links, except for blockers, failed creation, incomplete verification, or irreversible-action confirmation.`

The controlling artifact bounds your work: a task packet for a split slice, or the spec itself for
1:1 work. It supplies the requirement IDs, areas not to change, and Verify checklist. The dispatch
prompt gives every controlling artifact by explicit full path. Read it there and record the run
directly in it — never a copy.
Your job is to satisfy exactly that scope and leave behind evidence a
reviewer can check without trusting you. These rules are conventions the
review packet inspects — nothing enforces them at edit time.

## Rules

1. **Read the sources first.** For split work, read the task packet, then its linked spec and change
   plan when one governs. For 1:1 work, read the direct spec and every source it names. Read all of
   them at the explicit paths from the dispatch before touching code. _Why: the controlling artifact
   says what to do; its sources say why and how success will be judged._
2. **Isolate concurrent runs.** When tasks run in parallel, give each one a separate worktree or
   branch so their writes cannot collide. Otherwise follow the repository's normal branch flow.
3. **Stay in scope.** Implement the ACs the controlling artifact lists — no more. If a
   requirement cannot be met as written, or your change seems to need a
   non-goal or Do not change area, stop and say what you need and why —
   never improvise past the boundary or work around it — stop and ask. _Why: an
   improvised interpretation is a decision nobody made, landing where it is most
   expensive to find — in the code; a boundary with an explicit stop-and-ask path remains
   actionable when the work reaches it._
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
6. **Re-run after your last relevant change.** Output pasted before an edit that can affect its
   claim is stale and no longer covers that claim.
7. **Adversarially self-review your diff before handoff.** Re-read it as a
   hostile reviewer: which path did you not exercise (edge, error,
   concurrency)? What changed that the spec did not ask for? Which callers of
   a changed surface did you not look at? Fix what you find and note what you
   fixed. _Why: the cheapest review round is the one you run on yourself._
8. **Record the run directly in the artifact** — for 1:1 work (no task), fill
   the spec's `## Execution` section with the current run, replacing stale run
   notes; for a split task fill the task's `## Run summary` — directly at its
   own path, never a copy. Either
   way: changed files, one line per Verify command citing its pasted output,
   anything that could not be met as written, out-of-scope edits if any,
   blocked questions. For a split task, also put candidate discoveries in the
   task's `## Findings`. The spec carries no `## Findings` section — for 1:1
   work, note durable discoveries in the Execution entry's prose instead, and
   let the review step route them into `## Candidate findings` for a multi-lens review or
   `## Findings or Open decisions` otherwise. Findings ride the task or review packet; only evidence-backed,
   durable lessons move into native memory or the project's normal channels at close.
9. **Never write a review result on your own work.** Self-review yields fixes
   and notes — never a Supported. The review packet is filled by someone who did
   not write the diff. _Why: authors favor their own output; independence is
   the point of the review step._

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
- **Editing a file outside the controlling artifact's Affected areas because it was "right there."** A
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
- [ ] You checked relevant paths the implementation had not exercised
      (edge / error / concurrency) and recorded what you found.
- [ ] Anything you could not meet as written is reported, not silently
      adapted.
- [ ] The summary names changed files, commands with output, and finding
      candidates.
- [ ] You issued no review result on your own work.
