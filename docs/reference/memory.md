# Memory

Suspec adds no memory system. The harness you run already has one — a memory directory,
a `CLAUDE.md`-style instruction file, whatever your runner provides — and a lesson written
there is loaded on every future session with no extra machinery. Durable lessons go where
the harness actually reads them.

## The doctrine

A durable lesson becomes a native memory: write it the way your harness records memories (a
memory file, CLAUDE.md, whatever your runner provides), one claim per memory, the evidence
attached, under a searchable title. Suspec adds no parallel findings store — if the lesson
belongs to the team rather than to you, raise it through the project's own channels (an
issue, an ADR, a test).

Level: convention — the save-findings discipline guides this; nothing enforces it.

## What is durable

Most findings are ephemeral: they ride the review packet as candidate findings and end with
it. A lesson earns a memory when it would change how the next task is done — a non-obvious
constraint, a verified behavior that contradicts the docs, a failure mode that will recur.
One file write; nothing more.

## Hygiene

Three rules, all convention:

- **Verified, not assumed.** A memory states what was verified, not what was guessed.
  Agent-authored content is a claim, not a fact, until its evidence is named.
- **Evidence named.** Every memory names what backs it — the command output, the file and
  line, the review row it came from.
- **Correct or delete.** A memory contradicted by newer evidence is corrected or deleted
  the moment the contradiction is seen. A stale memory misleads more than a missing one.

## What Suspec deliberately does not do

- **No parallel memory.** A second memory beside the harness's own is a record nobody
  reads; the harness already indexes, loads, and recalls its own.
- **No machinery.** No index, no triage states, no expiry, no promotion pipeline.
- **No format of its own.** Write memories the way your harness writes them; Suspec's
  contribution is the discipline (one claim, evidence attached, searchable title), not a
  file shape.
- **No team memory.** Memories are per-developer and per-harness; the team never sees them
  unless you raise the lesson through project channels, written by hand like any other
  contribution.

## Related

- [Saving findings](../09-saving-findings.md)
- [Drift](drift.md)
