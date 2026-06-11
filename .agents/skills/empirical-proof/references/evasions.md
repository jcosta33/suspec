# Common evasions and the response

The full catalogue of evasions the evidence rule needs to defeat. The body of `SKILL.md` keeps the
most frequent ones inline; the complete list (including those, for completeness) lives here so the
agent can pull it up when one surfaces in conversation.

The response is always the same shape: **run the check and paste the verbatim output.** These are
review-checklist conventions — nothing in this repo enforces them.

| Evasion | Response |
| --- | --- |
| "The output is too long to paste." | Paste the resolved command, the exit condition, and the summary lines — not the whole log. The summary is what backs the result; the noise above it does not. |
| "I already ran it earlier in the session." | Re-run after every change. A proof pasted before a later edit is stale and no longer backs the claim. |
| "It's obvious from the diff that the test passes." | A diff runs nothing. "Obvious from the diff" is a prediction, not a recorded run. Run the check; paste the output. |
| "The CI will catch it." | The discipline is this session's gate, not CI's. A CI link is acceptable evidence only when you opened it and read the result. |
| "It would slow down the session." | The session's value is correctness, not speed. A Pass with no pasted evidence records as Unverified, so the "fast" path produced nothing the review accepts. |
| "I'm reviewing in good faith — pasting is performative." | Trust is the vulnerability this rule removes, not a virtue. In review, run the checks yourself; the worker's paste is a past moment, not the present result. |
| "The command failed for environmental reasons unrelated to my changes." | That is Blocked, not Pass — truth is unknown, not true. Surface the environment issue as a blocker, fix it, re-run; never silently mark complete. |
| "Schema validated, so the output is correct." | Shape is not truth. Well-formed output says nothing about whether the value is correct; such a claim is Unverified. |
| "The judge model said it passes." | A model-judged result counts only with the judge identity recorded and a judge independent of whoever produced the work. A bare "the judge approved" is Unverified. |
| "I bundled all the checks into one 'all green' line." | One paste per claim. A bundled paste hides which check ran and which never did — a claim with no run of its own is Unverified. |
| "There's no command in the Commands table for this, so I used a reasonable one." | Do not guess a command. Name the missing entry and ask; a guessed command proves nothing about the real project, and the claim stays Blocked until the real one runs. |
| "One test passes, so the risky requirement is proven." | For risky surfaces, one example is a weak oracle. Record what the check actually exercised relative to the requirement — not merely that a command exited zero — and say where the coverage stops. |
| "It worked when I checked it in production." | A production observation is the weakest, laggiest signal, and it still must be pasted as recorded evidence — not asserted from memory. |

## How to use this table

When you (or the user) catch the reasoning drifting toward one of these, look up the row, paste
the response, and run the check. The point is not to win the argument — it is to make the cost of
*skipping* the verification (a visible exchange of evasion + response) higher than the cost of
just running the command and pasting its output.
