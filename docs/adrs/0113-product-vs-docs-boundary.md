---
type: adr
id: adr-0113
status: accepted
created: 2026-06-27
updated: 2026-06-30
---

# ADR-0113 — Citations live in docs, not in products (the product-vs-docs boundary)

## Context

The Phase 3 family sweep (workflow `wf9rvvwys`, the AUDIT-family pass) confirmed the
re-architecture this program shipped was right in **file structure** — 8→6 agents, 7→11 skills,
suspec-mcp at 0.2.0, the catalog/kit split of [ADR-0112](./0112-two-tier-skills.md) — but the
**doc / reference layer drifted**, and every recurring issue mapped to a missing automated gate.

The concrete drift the sweep found: the **citation / product-pollution** and **count-drift**
classes had **recurred** in suspec-mcp and the kit. This program had already run a manual
strip-and-rule pass, but that pass covered only the **catalog and the agents** — so ADR-####
/ AUDIT-#### citations and repo / GitHub / DOI URLs leaked back into MCP tool strings and kit
files. Humans caught the recurrence in the sweep; no gate did. A citation embedded in a
product string is not just untidy: when a skill or agent is installed standalone, a
cross-folder link like `(./docs/...)` or an ADR reference resolves to nothing — the
self-containment break [ADR-0112](./0112-two-tier-skills.md) §1 already names as a coupling
smell, now observed leaking into shipped strings rather than skill bodies.

The boundary this program kept enforcing **by hand** was never written down as a decision. This
ADR writes it down.

## Decision

**Product-facing bodies carry zero sourcing; top-level product READMEs carry only install/discovery
links. Sourcing lives under `docs/`.**

1. **The product body/template surface — zero citations, zero source URLs.** These files MUST carry no
   `ADR-####` / `AUDIT-####` citation and no repo / GitHub / DOI URL:
   - agent definition **bodies** (suspec-agents),
   - generated runner projections such as Codex `.toml` files,
   - **`SKILL.md` bodies** (the catalog and the kit),
   - starter-kit standing instructions, templates, hooks, and bundled skill guides,
   - MCP tool **`title` / `description` / `inputSchema` `.describe()` strings** (suspec-mcp),
   - any other shipped prose or emitted product string.

2. **Top-level product READMEs may link for installation/discovery, not provenance.** A family README
   may link to the framework repo, sibling repos, release pages, install docs, and local `docs/` pages
   because that is how a user finds and installs the product. It MUST NOT carry `ADR-####` /
   `AUDIT-####` / DOI provenance citations or explain a behavior by pointing at an internal decision
   record. The README states the product fact; the docs cite why.

3. **The docs surface cites freely.** Everything under `docs/` — and the science / sources pages
   — sources normally; citing the evidence is *their job*. The boundary is between **what ships
   as product behavior** and **what documents it**.

4. **Two reasons it is a boundary, not a style choice:**
   (a) **Self-containment** — a cross-folder citation link 404s the moment the skill or agent is
   installed standalone, away from the `docs/` it pointed at;
   (b) **Separation of concerns** — sourcing is a documentation concern, not product behavior; a
   tool description's job is to tell an agent what the tool does, not to footnote why.

5. **Code comments are out of scope.** A comment is maintainer rationale, not a shipped product
   string; it may carry an ADR reference. The rule governs strings the *product emits or
   displays*, not the source that explains them to a maintainer.

_Level: method gate plus review._ The policy is **in force today**: this program stripped
suspec-skills, suspec-agents, suspec-mcp, the starter kit, the CLI README, and bench README product
surfaces, then codified the body/README split in `scripts/lint-product-citations.sh`.

The **enforcement path** is the family regex-lint scanning designated product paths for `ADR-####` /
`AUDIT-####` tokens and source URLs. It scans product body/template files with the strict rule and
top-level product READMEs with the narrower provenance-citation rule. Code comments and emitted
strings buried inside code still require human review because a grep-only code pass would be noisy;
do not claim those are mechanically enforced.

## Consequences

- **Cost — code-emitted product strings still need review.** The shipped lint covers the low-noise
  file surfaces. Tool strings or diagnostics embedded in code remain a human-review obligation until a
  parser-aware check can distinguish emitted prose from comments and fixtures.
- **A reader of a tool description or a `SKILL.md` loses the inline "why."** The sourcing is one
  hop away under `docs/` instead of in front of them. This is the deliberate trade: the product
  string stays installable and self-contained, and the evidence stays where it can be maintained.
- **A top-level README may still help users find the product.** Repo/install links are product
  navigation, not provenance. ADR/AUDIT/DOI citations remain documentation-only.
- **The boundary is mechanical and auditable.** "Does this file ship as product, or document it?"
  decides every case, and the low-noise violation classes are regex-checkable.
- **Comments are explicitly spared**, so maintainer rationale near code is not collateral damage;
  the rule does not push ADR references out of the codebase, only out of emitted strings.

## Affected obligations / constraints

- **Refines:** [ADR-0111](./0111-kit-skill-scope.md) and [ADR-0112](./0112-two-tier-skills.md)
  (the catalog/kit split and the universality / self-containment work — this names the product
  surfaces a citation must stay off of, and the standalone-install 404 it prevents).
  **Grounded by:** the honesty model [ADR-0063](./0063-honesty-framework-and-tooling-boundary.md)
  (the rule is a convention now; its CI lint is toolable, not shipped) and the AUDIT-family Phase 3
  sweep (`wf9rvvwys`).
- **Does NOT change:** the artifact formats, the catalog/kit boundary itself, the core loop, or
  the checks contract. Accepted ADRs 0111/0112/0063 are refined here by reference, never edited
  (Nygard immutability).
