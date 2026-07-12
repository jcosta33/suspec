# Writing-rules fixture set

_Maintainer reference; not needed to use Suspec._

[`labeled.yaml`](./labeled.yaml) contains short requirement-prose spans paired with an
expected result: `clean` or the specific `SOL-P` code a writing-rules detector should
report. Nothing here runs. The set makes heuristic detector behavior inspectable without
pretending that prose judgment is deterministic.

## Why it exists

Structural checks have closed conditions: a requirement either contains a verification
line or it does not. Writing rules judge ambiguity, vague quality words, bundling, and
missing baselines. Such detectors can miss real defects or flag clear prose; published
requirements-smell results show that this tradeoff is material
[[SMELLS]](../../../docs/research/sources.md#SMELLS).

The fixtures provide stable examples for measuring that behavior. Near-miss pairs keep
the distinction tight: one span contains a named problem and its partner supplies the
observable criterion or structural repair.

## Record shape

Each item records:

- `id`: stable fixture identity
- `text`: prose under judgment
- `context`: whether the span is binding or commentary
- `label` and `expect`: expected code, or `clean` and `none`
- `severity`: expected level for that context
- `reason`: the local evidence for the label

The reason is part of the review surface. A disputed label is corrected through ordinary
fixture review; no inter-annotator agreement or deployed-detector accuracy is claimed by
this repository.

## Evaluate a detector

1. Run each item's `text` with its `context` through the detector.
2. Compare emitted codes with `expect`.
3. Report per-item mismatches plus precision and recall for the evaluated version.
4. Keep the raw results and detector version with the evaluation.

A code emitted on a `clean` item is a false positive. Silence or a different code on a
problem item is a miss. Choose an acceptance threshold before the evaluation based on the
detector's use: an advisory review hint and a blocking gate have different false-positive
costs.

The fixture labels pin expected outcomes. Rule mechanics remain authoritative in
[the checks reference](../../../docs/reference/checks.md).
