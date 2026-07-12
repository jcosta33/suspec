# Glossary

| Term | Meaning |
| --- | --- |
| **Intent** | What the change must make true. At minimum weight, one inline sentence. |
| **Key** | A moment present on virtually every change: intent, review, or findings. |
| **Scaffold** | Structure pulled in when work earns it: spec, task split, inventory, change plan, checker. |
| **Spec** | Working structured intent: requirements, non-goals, questions, affected areas, verification. |
| **Requirement / AC** | One observable obligation with a stable ID inside its spec and a verification method. |
| **Task packet** | A scoped slice cut when a source must be decomposed across workers or waves. |
| **Execution notes** | Changed files, verification output, scope drift, and blockers for the current run. |
| **Inventory** | Observation-only map of current modules, interfaces, behavior, tests, constraints, and unknowns. |
| **Change plan** | Safe transformation plan with preservation guarantees, waves, cutover, rollback, and checks. |
| **Review packet** | Independent reconciliation of implementation and evidence against the spec. |
| **Review result** | Human judgment recorded as Pass, Fail, Unverified, or Blocked per requirement. |
| **Finding** | A lesson candidate. It is not a standalone artifact type. |
| **Native memory** | A harness-provided durable memory surface; used only when supported. |
| **Evidence** | Directly inspectable output, CI run, or named manual observation tied to a claim. |
| **Human attention** | Exceptions and decisions a person must inspect. |
| **Checker** | `suspec check`: read-only facts and severity levels over explicit artifact paths. |
| **SOL** | A stricter, per-spec controlled syntax that encodes the same requirement record as plain form. |
| **Revolver Review** | Sequential target-derived review stances, with fixes between rounds on the revised state. |

## Authority

Working artifacts direct live work. After close, code, tests, maintained project records,
and supported native memory carry durable truth.

Related: [artifact formats](artifact-formats.md) · [principles](principles.md)
