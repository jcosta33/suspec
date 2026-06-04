---
type: pass-guide
name: write-spec
pass: author
activates_for_task_kind: spec-writing
description: Run the `author` pass — capture intent as a `*.swarm.md` spec: SOL obligation blocks (REQ/CONSTRAINT/INVARIANT/INTERFACE) each binding a proof, every requirement testable, ambiguity in QUESTION blocks, plus a distillation-loss statement. ALWAYS apply when a task names `author` or asks for a spec, requirements, acceptance criteria, or interface contract, or when normalizing a research/audit/PRD/RFC/NFR parent into binding intent. Do not prescribe implementations, put obligation force in prose outside a block, ship a `[blocking]` QUESTION, or drop intent silently. Skip when describing present-state code (audit), reproducing a defect (bug-report), surveying without deciding (research), partitioning a lowered IR (decompose), or writing the code itself (implement).
---

# Pass guide: write-spec (author)

This guide tells you *how* to perform the `author` pass — the first of the nine passes (`author → lint → improve → lower → decompose → implement → verify → review → promote`) and the only one that *writes* a `*.swarm.md` source spec. `author` sits **outside** the seven analysis phases: it is the entry pass before `PARSE`, the boundary at which unstructured intent (chat, a research/audit/PRD/RFC parent) becomes the first compiler-visible artifact. Analysis begins at the next pass; this pass produces the input that pass reads.

This guide is SOFT control: it carries procedure, not meaning. The load-bearing facts — what each block type *means*, what the five modals *mean*, what a proof type *means*, the required section order — are fixed in the SOL language reference and the spec artifact contract, and applied here, never redefined. A correctly authored spec is understandable without this guide; the guide only says how to run the pass to produce one.

Stance: **Architect**. You declare what MUST hold, not how it will be built. The implementer who later reads the spec picks the mechanism; your job is to make the obligation unambiguous, testable, and bounded.

## Purpose

A spec is the contract between whoever specifies and whoever builds. An implementer reading it should be able to build with no follow-up questions, and a verifier should be able to derive a proof from each obligation without re-interviewing the author. This guide is the discipline that gets a spec there. Its epistemic stance is **intent**: it is the one source artifact that asserts what *must* hold — every other parent records what *is*, what *failed*, what *might* be done, or what *was decided*, and acquires obligation force only when authored into a spec here.

## Consumes

- The triggering ask plus any recognized parent: a research write-up (inquiry stance), an audit (observation stance), a PRD (intent, not yet authoritative), an RFC (proposal), NFRs/SLOs (quality attributes), use-cases/examples (scenarios), or an interface source such as an OpenAPI / GraphQL / DB schema (boundary shape). *Why:* the spec is normalized *from* these; you are not inventing intent from nothing, you are lifting each parent's content across the boundary into binding obligations.
- The consuming repo's `AGENTS.md > Commands` for the `cmd*` slots a `VERIFY BY` binding will reference (`cmdTest`/`cmdValidate`/`cmdFormat`/`cmdBenchmark`/`cmdLint`/`cmdTypecheck`). If a slot a binding needs is undefined, **ask the user** — never guess a command. *Why:* the spec is stack-agnostic; the concrete command is a project value.

## Produces

- One `*.swarm.md` source spec. The `.swarm.` infix before the final extension is the sole discriminator marking it compiler-visible; a plain `.md` is a working artifact and is never parsed as SOL, so name the spec `<slug>.swarm.md` (e.g. `auth-refresh.swarm.md`) and leave every parent (audit, research, PRD, RFC, finding, ADR) a plain `.md`. *Why:* the infix is what a future tool keys on to decide "parse this as obligations"; mis-naming a parent `.swarm.*` would smuggle a non-spec into the compiler's view.

The file carries YAML frontmatter (required set: `type: spec`, `id`, `swarm_language: SOL/0.1`, `aps_version`, `spec_version`, `status`) then the required sections in this exact order: `## Intent`, `## Non-goals`, `## Context`, `## Interfaces`, `## Obligations`, `## Constraints`, `## Invariants`, `## Questions`, `## Verification coverage`, `## Downstream tasks`, `## Distillation loss statement`. The copyable skeleton ships at the kernel's spec template (`templates/spec.swarm.md`); copy it and replace every placeholder.

## Preserves

`author` is bound by the distillation-loss discipline: nothing load-bearing from a parent may be dropped silently. Architectural constraints, interface/payload shapes, and acceptance criteria are *never* droppable; narrative, explored-but-rejected alternatives, and survey prose MAY be dropped — but only with an accounting in the closing statement. Each parent's epistemic stance is also preserved across the boundary: an observation, an inquiry, or a proposal becomes binding *intent* only here, in SOL obligation blocks — it does not arrive pre-promoted.

## Rejects

Refuse to finalize the spec, and surface the problem, when any of these hold. Each is a real lint defect the downstream pipeline raises — author so they never fire:

- A behavioral requirement stated only in prose, outside a block. Obligation force lives only inside `REQ`/`CONSTRAINT`/`INVARIANT` blocks; prose frames and explains but is never a contract. Hedged behavioral prose that should be a decision is the hedged-ambiguity defect `SOL-P008`.
- A binding obligation with no `VERIFY BY` — the missing-proof defect `SOL-V001`. An `INTERFACE` bound to anything other than a `contract:` proof is the interface-without-contract defect `SOL-V006`; a proof type outside the closed nine is `SOL-V009`.
- A `[blocking]` `QUESTION` left open. A blocking question prevents lowering of every obligation it `AFFECTS`; one that reaches the next pass is an orchestration error — an unresolved decision being compiled into tasks.
- The required sections missing or out of order — the document-level defect `SOL-S012`.
- An implementation prescribed where a requirement belongs (see rule 2), or a parent's stance violated — e.g. authoring an audit's observation directly as a `REQ` of its own without lifting it into intent here.

## Core rules

### 1. Every obligation is testable; bind a proof to each

A requirement a verifier cannot test is a wish, not an obligation. If you cannot describe the proof in your head — the command, the assertion, the observable — the obligation is too vague. Every binding block (`REQ`, `CONSTRAINT`, `INVARIANT`, `INTERFACE`) MUST carry a `VERIFY BY <type>:<adapter>:<artifact>` drawn from the closed nine proof types (`static`, `test`, `contract`, `property`, `model`, `perf`, `security`, `manual`, `monitor`); the `<adapter>` is a `cmd*` slot resolved through the consuming repo's `AGENTS.md > Commands`. *Why:* the unbound obligation (`SOL-V001`) is the exact gap that lets work be marked "done" with nothing to judge it against.

- Testable: `THE client MUST redirect an expired session to /login with a fresh S256 code_challenge (≥ 32 bytes verifier entropy)` → `VERIFY BY test:cmdTest:auth-refresh-expired`.
- Not testable: `THE login flow MUST be secure` — no proof can be derived; reword to the concrete observable that "secure" means here.

### 2. State the requirement, not the mechanism

The implementer picks the implementation; the spec fixes the obligation. Write the observable behavior or the bound, not the data structure or the library. *Why:* a spec that names the mechanism over-constrains the solution space and silently turns into implementation the verifier cannot independently check.

- Requirement: `Lookup MUST be O(1) per key` (an `INVARIANT`, `VERIFY BY perf:cmdBenchmark:lookup-latency`).
- Mechanism leak: "use a `Map<string, X>`". If a specific mechanism *is* load-bearing (compatibility with an existing API, a wire format), state it as a `CONSTRAINT` with a `BECAUSE` that names the requirement driving it, not as a bare instruction.

### 3. Write each block in its canonical SOL shape under its own section

The seven block types each have a fixed grammar and a dedicated section; restating it here so you author it right the first time:

- `REQ` (Obligations) — `WHEN <trigger>` / `THE <actor> MUST <observable response>`. Conditions use the EARS keywords in order (`WHERE → WHILE → WHEN → IF`); `THEN` is optional sugar after `IF` only. `AND THE …` chains a second consequence (each lowers to a separate obligation). A condition with no actor clause is `SOL-S001`; an actor clause with no modal is `SOL-S003`.
- `CONSTRAINT` (Constraints) — `THE <actor-or-surface> MUST NOT <forbidden action>`; bounds *how* obligations may be met. Carry a `static`, `contract`, or `manual:` proof. There is no `POLICY` block and no surface authority clause.
- `INVARIANT` (Invariants) — `<property> MUST|MUST NOT <hold>`; an always-held property, never a one-time triggered behavior (that is a `REQ`). Do not write `ALWAYS`/`NEVER` (redundant). Prefer a `property`, `model`, or `static` proof — binding an invariant only to a unit `test` is the weak-proof warning `SOL-V003`.
- `INTERFACE` (Interfaces) — `<signature> RETURNS <type>` with contiguous `ACCEPTS:`/`ERRORS:` bullet continuation lines (a blank line would close the body). MUST bind a `contract:` proof (else `SOL-V006`).
- `QUESTION` (Questions) — header carries `[blocking]` or `[non-blocking]` before the colon, body names what it `AFFECTS`. See rule 5.
- `TRACE` and `VERDICT` are *not* authored here — they are downstream review artifacts. A spec carries the first five only.

*Why:* a block whose prefix mismatches its type is `SOL-S005`; duplicate ids within one spec are `SOL-S004`. The header is one flush-left line `TYPE PREFIX-NNN:` with a mandatory trailing colon, and a blank line *inside* a body terminates it — author bodies as contiguous lines.

### 4. Use only the five modals, and uppercase only

The obligation's force is carried by exactly five uppercase modals — `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, `MAY`. Lowercase `must`/`should`/`may` is plain prose and binds nothing. `CAN`/`WILL` in a binding clause is the non-modal defect `SOL-P003`; `SHALL`/`SHALL NOT` is the deprecated alias `SOL-P058`. A `SHOULD`/`SHOULD NOT` REQUIRES a same-block `BECAUSE` or `EXCEPT` (else `SOL-S006`). *Why:* the modal is the single token a downstream verdict judges strength against; an informal modal leaves the obligation's force undefined.

### 5. Lift every behavioral ambiguity into a `[blocking]` QUESTION — and resolve it before you finish

A `[blocking]` QUESTION is one whose answer would change the spec's content. Capture it as a `QUESTION Q-NNN [blocking]:` block naming what it `AFFECTS` — never as hedged prose (that is `SOL-P008`). The spec is not finishable while a blocking question is open: either route it to a parent that resolves it (a research, an ADR, an audit) and resume, or, if a reasonable default answers it, **make the decision**, record it in `## Context` (or as a resolved note), and downgrade the question to `[non-blocking]`. *Why:* a blocking question that reaches lowering is an unresolved decision being compiled into tasks — an orchestration error, not a deferrable nicety. Non-blocking questions MAY remain open if they touch no assigned obligation.

### 6. Survey existing patterns before introducing a new one

Before specifying a new interface or behavior, check what the consuming project already has. Record what you consulted in `## Context` (cite the project path you read), and if you reuse an existing pattern, say which; if you introduce a new one, say why the existing patterns do not fit. *Why:* a spec authored without a survey re-specifies behavior that already exists, and the duplication is invisible until implementation collides with it.

### 7. Forced visible output: close the distillation-loss statement and the blocking-question list

The deliverable *is* the proof for this pass, so the gate is a written, inspectable one. Before you hand off, the spec MUST carry a complete `## Distillation loss statement` with three subsections — `### Preserved` (intent carried forward), `### Dropped` (detail intentionally not carried, and why downstream does not need it), `### Still uncertain` (open uncertainty) — and you MUST paste, into the task file, the blocking-question status verbatim:

```
## [blocking] QUESTION status
- (none — spec is finishable)
— or —
- Q-003 — blocking because <reason>; resolution path: <research / ADR / decision recorded>
```

*Why:* the silent failure mode of this pass is a late step claimed but skipped — "I accounted for the loss" with no statement, or "no open questions" with an unresolved blocker still in the file. Forcing the written marker converts that invisible claim into something the next reader can check. If the list shows any blocking question, the spec is not finishable: route it, resolve it, re-paste the list.

## What does not belong

- Present-state observations of existing code → an audit (observation stance), not a spec.
- A defect's reproduction and root cause → a bug-report, which promotes into a fix task, not into a spec.
- An options survey that commits to nothing → a research write-up; it promotes *into* a spec via this pass, but is not itself the spec.
- Implementation step-by-step, the data structure, the chosen library → the implementer's concern; the spec states the requirement that constrains the choice.
- Unmeasurable acceptance language ("intuitive", "performant", "fast") in any obligation → reword to the concrete observable, or it is an untestable wish.

## Anti-patterns

- ❌ Stating a behavioral requirement in surrounding prose ("the client should clear the session on expiry") instead of a block → prose carries no obligation force; the requirement is invisible to lowering and verification. Put it in a `REQ` with a `VERIFY BY`.
- ❌ Authoring a `REQ`/`CONSTRAINT`/`INVARIANT` with no `VERIFY BY` because "it's obvious how to test it" → that is `SOL-V001`; an unbound obligation lets work be marked done with nothing to judge it. Bind the proof at author time.
- ❌ Binding an `INTERFACE` to a `test:` proof → an interface boundary requires a `contract:` proof that its shape matches reality (`SOL-V006`); a unit test does not check the boundary contract.
- ❌ Binding an `INVARIANT` only to a unit `test` → a unit test checks one state, not all states (`SOL-V003`); prefer `property`/`model`/`static`.
- ❌ Specifying the mechanism (`use a Map`, `store in Redis`) instead of the requirement → over-constrains the solution and turns the spec into unchecked implementation. State the bound (`O(1) per key`) and let the implementer choose.
- ❌ Leaving an unresolved decision as hedged prose ("we'll probably redirect to /login") → that is `SOL-P008`; lift it into a `[blocking]` QUESTION and resolve or decide before finishing.
- ❌ Shipping the spec with a `[blocking]` QUESTION still open → it blocks lowering of everything it `AFFECTS` and is an orchestration error if it reaches the next pass. Resolve, decide, or route it first.
- ❌ Naming a parent `audit.swarm.md` / `research.swarm.md` → the `.swarm.` infix marks the one compiler-visible spec; a parent is plain `.md`. Mis-naming smuggles a non-spec into the compiler's view.
- ❌ Dropping an architectural constraint, a payload shape, or an acceptance criterion into the loss statement's `### Dropped` → those are never droppable; only narrative, rejected alternatives, and survey prose may be dropped, and only with an accounting.
- ❌ Writing the sections in a convenient order, or omitting `## Verification coverage` / `## Downstream tasks` → required sections out of order or missing is the document-level defect `SOL-S012`.
- ❌ Hardcoding a concrete test/validate command into a `VERIFY BY` adapter → resolve `cmd*` slots through the consuming repo's `AGENTS.md > Commands`; if a slot is undefined, ask the user.

## Self-review delta

Before handing off, confirm — and paste real evidence into the task file where a step produces it; an assertion without the artifact is not a proof:

- [ ] **Every obligation testable.** Pick the most ambiguous-feeling `REQ`/`CONSTRAINT`/`INVARIANT` — could a verifier derive its proof from the block alone? Each binding block carries a `VERIFY BY` from the nine proof types (no `SOL-V001`); each `INTERFACE` binds a `contract:` proof (no `SOL-V006`).
- [ ] **No prose obligation.** No behavioral requirement lives outside a block; every modal that binds is uppercase and one of the five (no `SOL-P003`/`SOL-P058`); each `SHOULD` carries a `BECAUSE`/`EXCEPT` (no `SOL-S006`).
- [ ] **Blocking-question list pasted.** The `## [blocking] QUESTION status` block is in the task file and shows `(none — spec is finishable)`, or every open one names its resolution path. Paste the list verbatim — a claim of "none open" without the list is not a proof.
- [ ] **Distillation-loss statement complete.** All three subsections present; nothing droppable (architectural constraint, payload shape, acceptance criterion) landed in `### Dropped`; each parent's stance was preserved, not pre-promoted.
- [ ] **Sections in order.** Required sections present in the contract order, frontmatter required set populated (no `SOL-S012`); ids unique and prefix-matched per type (no `SOL-S004`/`SOL-S005`).
- [ ] **Survey done.** Existing patterns consulted and recorded in `## Context`; reuse-vs-new is justified.
- [ ] **Commands resolved or asked.** Every `VERIFY BY` adapter resolves a defined `AGENTS.md > Commands` `cmd*` slot; any undefined slot was raised to the user, not guessed.
- [ ] **Implementer test.** "What requirement did I assume the implementer would infer?" Inference is the failure mode the spec exists to prevent — if the answer is non-empty, write the obligation.

## Bundled resources

- `references/task-template.md` — the spec-authoring task file: objective, linked parents, the survey, a progress checklist, design decisions with named alternatives, a blocking-question tracker, and a self-review whose gate is the pasted blocking-question list and the completed distillation-loss statement. The deliverable (the `*.swarm.md` spec) is authored into its final home; the task file is the gitignored working memory and is discarded once the spec lands.
