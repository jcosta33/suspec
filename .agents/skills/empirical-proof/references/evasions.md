# Common evasions and the response

This catalogue extends the common evasions kept inline in `SKILL.md`. Pull it up when one of these
arguments surfaces in conversation.

| Evasion                                                                      | Response                                                                                         |
| ---------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| "The output is too long to paste."                                           | Paste the smallest verbatim slice that proves the claim: runner summary plus recorded exit status. |
| "I already ran it earlier in the session."                                   | Re-run when a later change can affect that result.                                               |
| "It's obvious from the diff that the test passes."                           | Diff doesn't run tests. Run the tests; paste the output.                                         |
| "The CI will catch it."                                                      | Cite a completed CI run or run the check locally; future CI is not evidence.                      |
| "It would slow down the session."                                            | Do not trade an unverified completion claim for speed.                                           |
| "I'm reviewing in good faith — pasting is performative."                     | Evidence makes the claim independently checkable; intent does not.                               |
| "The test command failed for environmental reasons unrelated to my changes." | Surface the environment gap and leave the affected claim unverified.                             |

## How to use this table

When one of these evasions appears, apply the response and run the verification. If the check
cannot run, record the evidence gap instead of making the completion claim.
