# Glossary

| Term | Meaning |
| --- | --- |
| **Intent** | What the change must make true. At minimum weight, one inline sentence. |
| **Key** | A moment present on virtually every change: intent, review, or findings. |
| **Scaffold** | Structure pulled in when work earns it: spec, task split, inventory, change plan, checker. |
| **Spec** | Working structured intent: intent and verifiable requirements, plus only the optional sections that carry information. |
| **Requirement / AC** | One observable obligation with a stable ID inside its spec and a verification method. |
| **Task packet** | A scoped slice cut when a source must be decomposed across workers or waves. |
| **Execution notes** | Changed files, verification output, scope drift, and blockers for the current run. |
| **Inventory** | Observation-only map of current modules, interfaces, behavior, tests, constraints, and unknowns. |
| **Change plan** | Safe transformation plan with preservation guarantees, waves, cutover, rollback, and checks. |
| **Audit** | Evidence-backed record of present-state risks; no intended behavior or prescription. |
| **Research** | Evidence for one decision-informing question; no decision. |
| **Inspection method** | A bounded method run over a target. Bulletproof and Demolition stay read-only; Revolver and Triple-check repair sequentially. |
| **Review packet** | Independent reconciliation of implementation and evidence against the spec. |
| **Requirement assessment** | Agent evidence judgment recorded as Supported, Unsupported, Unverified, or Blocked per requirement. |
| **Review decision** | Human selection recorded as accepted, changes-requested, or deferred; waivers name deliberately accepted evidence gaps. |
| **Finding** | A lesson candidate. It is not a standalone artifact type. |
| **Native memory** | A harness-provided durable memory surface; used only when supported. |
| **Evidence** | Directly inspectable output, CI run, or named manual observation tied to a claim. |
| **Evidence receipt** | Untyped sidecar holding one raw command record under a stable anchor. |
| **Run note** | Untyped sidecar for execution or round detail too large for its governing artifact. |
| **Decision gate** | Structured human selection for material or irreversible choices. |
| **Artifact disposition** | Human close choice for a complete transient artifact set: Delete, Leave, or Promote. `Other` is the picker escape hatch, not a disposition. |
| **Checker** | `suspec check`: read-only facts and severity levels over explicit artifact paths. |
| **SOL** | A stricter, per-spec controlled syntax that encodes the same requirement record as plain form. |
| **Revolver** | Purpose-agnostic breadth inspection through sequential target-derived stances. |
| **Triple-check** | Exactly three fresh top-tier passes for narrow depth. |

## Authority

Working artifacts direct live work. After close, code, tests, maintained project records,
and supported native memory carry durable truth.

Related: [artifact formats](artifact-formats.md) · [principles](principles.md)
