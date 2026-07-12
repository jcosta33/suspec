---
name: empirical-proof
type: agent-guide
description: Back command-verifiable claims with current raw output recorded once. ALWAYS apply when writing code, running validation or benchmarks, or making verifiable behavior claims. Keep short output once; move dominating output to an adjacent evidence receipt with stable anchors, command, working directory, state identifier, exit status, and untouched raw output. Never paraphrase proof, duplicate one run for each claim, or trust rerunnable upstream output. Skip only work with no verifiable claim.
---

# Empirical proof

`DISRESPEC-SPINE: One fact once. No filler, repeated source material, empty sections, or chat restatement; after successful creation return only clickable artifact links, except for blockers, failed creation, incomplete verification, or irreversible-action confirmation.`

## Artifact placement

Place the file under `~/.agents/artifacts/<workspace>/`, resolving `~` to the absolute
home path and deriving `<workspace>` from the repository or working-directory basename. Keep it
out of the repository and carry its absolute path forward. If the workspace name or target path
conflicts with unrelated work, stop for a structured human choice; never overwrite. If the root is
unwritable, offer grant access and retry, another agent-neutral user directory, or cancel. Never
fall back to vendor storage, the repository, or a temporary directory.

## Method

1. Resolve the project's actual commands from contributor instructions.
2. Pin the working directory and state identifier.
3. Run each required command after the final relevant edit. Record its exit status.
4. Keep short raw output once. If it would dominate the governing artifact, write one adjacent
   `evidence-<slug>.md` receipt with a stable `E-NNN` anchor, command, working directory, state
   identifier, exit status, and untouched raw output.
5. Put only the decisive verbatim excerpt and receipt link in the governing artifact.
6. Map every supported claim to its evidence anchor. One run may support several claims.
7. Cite exact durable evidence for CI, manual observation, or source inspection. Mark missing
   evidence `Unverified`; never fabricate command-shaped proof.

Without an artifact, chat may show the compact command, exit status, and decisive raw excerpt.
Do not rerun unchanged commands merely to duplicate evidence.
