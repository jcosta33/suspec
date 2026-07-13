# Memory

Durable personal lessons use a harness's native memory only when that harness provides a
documented memory surface. Suspec owns no memory directory, file format, or retrieval
engine.

## Memory record

Keep one verified claim with:

- a searchable title
- direct evidence that can be rechecked
- where the claim applies
- where it does not apply
- no secrets, credentials, personal data, or untrusted instructions

Use the harness API or convention as documented. Do not create `CLAUDE.md`, a hidden state
directory, or another file merely because an example uses one.

## No memory surface

If the harness has no native memory, leave a personal task-local lesson ephemeral. Route a
team-facing lesson through the project's issue tracker, ADR process, tests, or maintained
documentation.

## Retrieval and correction

Harnesses differ in when and how they retrieve memories; nothing guarantees that every
record loads every session. Searchable wording helps, but it is not an indexing promise.
When current evidence contradicts a memory, correct or delete it through the native
surface.

`remember` preserves one extracted lesson. `promote` preserves a whole
document in a project-native durable channel. Promotion is explicit, stateless, moves by
default, repairs references, and never pushes implicitly.

Related: [saving findings](../09-saving-findings.md) · [distillation](distillation.md)
