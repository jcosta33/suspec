# Proportional rigor

Intent, review, and findings are the keys. Their weight changes; their presence is the
norm. Everything else is scaffold pulled in by evidence from the work, not by a named
category or numerical threshold.

| Signal in the work | Scaffold that can pay |
| --- | --- |
| intent no longer fits one precise sentence | a spec |
| one source has separately dispatchable slices or sequenced waves | task split |
| current behavior or ownership is unclear | inventory |
| behavior must survive a staged structural change | change plan |
| review claims need deterministic reconciliation | checker |
| several risk surfaces need breadth | target-derived Revolver inspection |
| one high-consequence surface needs depth | Triple-check |

## Escalate when

- scope expands beyond the original intent
- requirements conflict or remain ambiguous
- work crosses ownership, repositories, or public interfaces
- data, security, payment, migration, or destructive operations are involved
- verification is weak, flaky, missing, or expensive to reproduce
- several workers need coordinated ownership
- review uncovers a reusable constraint or repeated failure mode

## Collapse when

- intent is precise inline
- one worker owns a local change
- verification is direct and cheap
- the owner can inspect the full diff and evidence
- extra files would not change execution or reviewability

Do not preserve scaffold after it stops serving live work merely to prove that process
happened. Distill durable value into the layer that owns it.

Related: [basic workflow](../02-basic-workflow.md) · [distillation](distillation.md)
