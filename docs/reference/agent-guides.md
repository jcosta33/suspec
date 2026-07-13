# Native subagents

Suspec skills are complete procedures. Use a fresh harness-native subagent only when isolation,
independence, or a clean context improves the work. Suspec ships no custom worker definitions,
projections, hooks, or role package.

## Dispatch contract

A dispatch prompt names:

- every input artifact by absolute path
- the repository or worktree
- the bounded skill or question
- read/write permissions
- required commands
- the expected return shape

Workers receive explicit inputs. A review receives its spec and optional task paths. Implementation
receives its spec and, when split, its task path. A universal method receives one fixed target.

## Independence

The implementer does not assess its own completed work. Use a fresh session, native subagent, or
human reviewer. Worker output is an index of claims; the reviewer inspects code and reruns evidence.

For breadth, `revolver` derives every stance from the target. For depth, `triple-check` runs exactly
three fresh passes without exposing peer reports. `bulletproof` actively checks claims.
`demolition` is explicit-only advocacy and remains quarantined from evidence.

## Human authority

Agents report findings, evidence, and requirement assessments. Humans own intent, material
tradeoffs, waivers, irreversible actions, and final acceptance. Checker output never becomes a
decision.

Related: [review stances](review-stances.md) · [reviewing output](../08-reviewing-output.md)
