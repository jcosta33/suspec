# Glossary

| Term | Meaning |
| --- | --- |
| acceptance criterion | One verifiable requirement, usually `AC-NNN`. |
| ADR | Decision record. Kept and superseded, not rewritten. |
| agent run summary | Worker record in the spec `## Execution` entry or task packet: changed files, results, output links, blocked questions. |
| AGENTS.md | Always-loaded agent context and command table. |
| audit | Present-state report. Observes, does not prescribe. |
| bug report | Diagnosis of one defect. |
| change plan | Structural change plan with waves and preservation guarantees. |
| checks | The deterministic facts `suspec check` reports over an artifact — the honesty floor plus per-kind lint. |
| Close | Final act of a change: merge or block, save durable lessons as native memories. |
| companion | An artifact a review packet reconciles against, passed by explicit flag (`--spec`, `--task`). |
| distinct-lens review | Multiple reviewers with different focuses. |
| drift | Requirement and implementation diverged after earlier evidence. |
| Dropped from sources | Spec section for source asks intentionally left out. |
| durable record | Kept for project life: code, tests, ADRs, issues — plus your native memories. |
| evidence | Pasted output, CI link, or named manual observation. |
| evidence path | Files and checks exercised by the last valid evidence. |
| Execution | Append-only run record on the spec; one dated entry per change-cycle, prose or a structured change-record (ADR-0110). |
| finding | One lesson surfaced by the work; a durable one becomes a native memory at Close. |
| honesty floor | The checks a lazy or dishonest reviewer cannot fake: coverage-complete, command-matches, pass-needs-evidence, ref-resolves. |
| honesty level | convention, checklist, toolable, enforced. |
| intake | Verbatim source snapshot. |
| inventory | Present-state map before brownfield work. |
| key | One of intent, review, findings — present on virtually every change, at whatever weight the change earns. |
| loop | Intent, spec, implement, review, check, findings — the full shape of one change. |
| native memory | The harness's own durable memory surface (a memory file, CLAUDE.md, whatever the runner provides); where durable findings land. |
| non-goal | Explicit out-of-scope behavior. |
| open question | Unresolved spec question. Blocking questions keep specs draft. |
| preservation guarantee | Behavior a change plan must preserve. |
| requirement | Binding behavior plus verification. |
| research | Source-backed inquiry. No decision. |
| review by exception | Read coverage, failures, and exceptions before the diff. |
| review packet | Per-review record: coverage, evidence, human attention. |
| review result | Pass, Fail, Unverified, or Blocked. |
| review stance | Optional reading posture, such as adversarial reviewer or auditor. |
| rigor ladder | The named rungs of proportional rigor; pick the lowest that leaves enough proof. |
| risk-weighted review | More review for higher-risk change shape, diffusion, churn, or impact. |
| Run | Worker implements and records evidence. |
| save a finding | Close-step act: write a durable lesson as a native memory. |
| scaffold | What Suspec erects around the keys when the work earns it: the spec, task split, inventory, change plan, the deterministic checker. |
| scout | Read-only delegated helper. |
| skill family | The globally installed guides that carry the methodology. |
| SOL | Optional structured requirement notation selected by `format: sol`. |
| source authority | Rule for which artifact governs when intent conflicts. |
| spec | Intended behavior and verification. |
| split work | Turn spec or change plan into task packets. |
| step | One stage of the loop: intent, spec, implement, review, check, findings. |
| structured requirements | Plain `AC-NNN` requirements or SOL blocks over the same record. |
| task packet | Bounded split work order for an agent or person. |
| transitory output | Short-lived output such as run logs and check output. |
| verification method | Type of evidence: test, static, contract, manual, etc. |
| `Verify with:` | Spec line naming how to check a requirement. |
| watchlist | Vague terms that need same-line criteria. |
| wave | One verified stage of a change plan. |
| worker | Implementer that owns a spec or task slice and returns a run summary. |
| worktree | Separate checkout for one task. |
| writing rules | Requirement hygiene rules. |

## Internal terms

| Internal | Public term |
| --- | --- |
| APS | writing rules |
| obligation | requirement |
| pass (lowercase — a loop step) | step |
| profile | review stance |
| proof | evidence |
| trace | agent run summary |
| verdict | review result |

## Related

- [Cheatsheet](cheatsheet.md)
- [Artifact formats](artifact-formats.md)
- [Checks](checks.md)
