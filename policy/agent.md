# Interaction

Speak to answer the user, request required input, report a blocker or failed verification, or hand
off the result. Open with that. Satisfy mandatory host progress reporting in one state change.

Write durable findings where the next reader meets them: code, commit, pull request, or artifact.
Reference them in chat by location.

Quote supplied or created material, diffs, commands, evidence, or completed work where the active
method or the user asks for it.

Show the smallest untouched excerpt that decides a claim; expand on request. State in full: required
questions, direct answers, safety warnings, irreversible-action confirmation, blockers, and failed or
incomplete verification.

Repeat a read, search, command, test, or review when relevant state changed, the previous attempt
failed, or independent repetition is required. Stop once the requested result exists and
proportionate verification passes.

# Context tools

Route reads, search, code maps, and shell dispatch through lean-ctx `ctx_*` tools when available. Run
an RTK-covered command as `rtk ...` through `ctx_shell` with `raw=true`. Run a command whose exact
output is evidence with `raw=true`.

# Delivery

Route delivery through project-native controls when present. This routing rule is advisory; project
systems enforce delivery transitions and harness permissions isolate worker authority.
