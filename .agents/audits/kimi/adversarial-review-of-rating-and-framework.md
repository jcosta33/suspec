---
type: audit
id: AUDIT-swarm-rating-and-framework-hostile-read
title: Hostile read of the 20-point rating and the Swarm framework
status: draft
owner: kimi
sources:
  - README.md
  - AGENTS.md
  - docs/01-what-is-swarm.md
  - docs/reference/principles.md
  - docs/reference/checks.md
  - docs/adrs/0057-practical-first-repositioning.md
  - docs/adrs/0063-honesty-framework-and-tooling-boundary.md
  - starter-kit/AGENTS.md
  - starter-kit/advanced/audit.md
---

# Audit: Hostile read of the 20-point rating and the Swarm framework

## Scope

- In scope: the 20-point rating of the Swarm harness produced in this session; the public framework surfaces the rating rested on.
- Out of scope: root `.agents/` files (excluded from read); runtime behavior of any agent or CLI; empirical validation with users.

## Observations

1. The README presents a workflow that solves agent-coordination problems, but the "what works today" section lists only templates, specs, task packets, review packets, and examples — no shipped automation. Evidence: `README.md:76-84`.
2. `docs/01-what-is-swarm.md` explicitly states that nothing in the repo runs or enforces anything. Evidence: `docs/01-what-is-swarm.md:83-86`.
3. The honesty framework ADR admits that comparable tools ship validators and that "rules without a checker has a short credibility window." Evidence: `docs/adrs/0063-honesty-framework-and-tooling-boundary.md:14-16`.
4. The starter-kit `AGENTS.md` Commands table is entirely placeholders; an adopting team must fill it before any verification resolves. Evidence: `starter-kit/AGENTS.md:43-49`.
5. The starter-kit `AGENTS.md` declares that an agent must never review its own implementation, but provides no mechanism to enforce or detect a violation. Evidence: `starter-kit/AGENTS.md:67-70`.
6. The README claims provider neutrality while the repo ships `.claude/settings.local.json` and a `.claude/skills` symlink. Evidence: `README.md:105`, `.claude/settings.local.json`, `.claude/skills` symlink.
7. The check catalogue maintains a large set of SOL codes despite citing evidence that automated detection of the underlying prose patterns is imprecise. Evidence: `docs/reference/checks.md:91`.
8. ADR-0057, a central repositioning decision, cites external adopter audits and plans stored under paths inside root `.agents/`, which were excluded from this read. Evidence: `docs/adrs/0057-practical-first-repositioning.md:19-26`.
9. The 20-point rating scored provider neutrality at 5/5 and production readiness at 3/5 despite the observations above. Evidence: the rating table in this session.
10. The rating scored "Clarity of core workflow" at 5/5 even though the simple six-step loop coexists with a nine-pass advanced lifecycle, many artifact types, optional SOL notation, and 71 ADRs. Evidence: `docs/02-basic-workflow.md`, `docs/reference/advanced-lifecycle.md`, `docs/reference/artifact-formats.md`, `docs/adrs/README.md`.
11. The large-PR-review example is a single authored walkthrough, not measured evidence that review-by-exception reduces reviewer load in production. Evidence: `docs/examples/large-pr-review.md`.

## Risks

- Teams copy the starter kit, fill templates, and believe they have adopted Swarm while the hard discipline (defining commands, training reviewers, writing honest specs) is skipped. Fires when: adoption is measured by file presence rather than behavior change.
- Agents generate plausible-looking review packets with stale or fabricated pasted output; human reviewers rubber-stamp them. Fires when: the team treats "pasted output" as automatically trustworthy evidence.
- The framework's credibility erodes because "toolable" checks are advertised while the reference CLI is not shipped. Fires when: adopters discover that nothing actually enforces the rules.
- Provider-neutrality claims conflict with Claude-first scaffolding, causing other-agent users to distrust the "any agent" framing. Fires when: a Codex/Cursor/Aider user inspects the repo.

## Open questions / unverified areas

- Root `.agents/` files were not read, so the adopter audits and plans cited by ADR-0057 could not be inspected. Why not: read exclusion in the original request.
- No runtime or CLI exists in the repo, so no command could be run to validate any check. Why not: the framework ships no runtime.
- No user study or production data was available to verify that review-by-exception reduces review burden. Why not: not part of the repo.

## Candidate requirements

- A future spec should require that every "works today" claim in the README maps to a shipped, runnable artifact or is rephrased as a convention.
- A future spec should require that the starter-kit `AGENTS.md` fails validation if required placeholders remain unfilled.
- A future spec should require that any cited evidence used to justify an ADR be readable without entering excluded directories.
- A future spec should require that provider-neutrality claims be backed by equal scaffolding for at least one non-Claude agent, or the claim is narrowed.

---

# Research follow-up: veracity of sources flagged as weak

## Question

How strong is the empirical grounding for the design claims this audit criticized as weakly sourced — specifically the ambiguity-degrades-generation claim and the perceived-vs-measured-productivity claim?

## Findings

### R-001 — HUMANEVALCOMM is peer-reviewed, not caveated

**Claim:** `docs/01-what-is-swarm.md:95` cites [[HUMANEVALCOMM]] to ground the statement that "ambiguity measurably degrades generated code, and models do not reliably flag or resolve it on their own." This audit initially misclassified the source as caveated/non-peer-reviewed.

**Evidence:** Direct fetch of arXiv:2406.00215 (v3, Jan 2025) shows the paper is published in *ACM Transactions on Software Engineering and Methodology* with DOI `10.1145/3715109` and a 2025 publication date. The GitHub repository's BibTeX and the arXiv HTML header both confirm `journal = {ACM Trans. Softw. Eng. Methodol.}`. The repo's `docs/research/sources.md:60-61` classifies it correctly under "Verified — primary research (peer-reviewed, finding confirmed)."

**Confidence:** high.

**Bears on:** Observation 9 and the broader claim that the framework leans on weak evidence. The classification was wrong; the source is strong.

### R-002 — ORCHID is an arXiv preprint with no peer-reviewed venue found

**Claim:** [[ORCHID]] is cited alongside [[HUMANEVALCOMM]] for the same ambiguity claim. The repo classifies it as Caveated.

**Evidence:** Direct fetch of arXiv:2604.21505 (April 2026) confirms it is an arXiv e-print only. ADS and the paper itself list no conference or journal venue. The abstract's claims — 1,304 function-level tasks, ambiguity degrades performance, functionally divergent implementations, models cannot reliably identify/resolve ambiguity — are internally consistent with the repo's summary.

**Confidence:** high that it is a preprint; medium that the findings will hold after peer review and scale to repo-level tasks.

**Bears on:** The repo's caveated classification is correct. The ambiguity claim does not depend on ORCHID because peer-reviewed corroboration exists (R-004).

### R-003 — METR 19% slowdown is from a small-N preprint and is not settled

**Claim:** [[METR]] is cited in `docs/01-what-is-swarm.md:97` for the perception-vs-reality gap: developers believed they were ~20% faster while measuring ~19% slower.

**Evidence:** Direct fetch of arXiv:2507.09089 confirms the RCT design (n=16 experienced OSS developers, 246 tasks, early-2025 AI tools) and the 19% slowdown figure. The repo's `docs/research/sources.md:203-205` already flags that "a 2026 follow-up reportedly did not replicate the slowdown — claim surfaced in the external validation survey, unverified here; do not cite the 19% figure as settled." Secondary discussion of that follow-up reports selection bias (developers refused to work without AI) and inconclusive results [unconfirmed — no direct fetch of the 2026 paper was performed].

**Confidence:** high that the 19% figure is preliminary and contested; medium that the perception-vs-reality gap directionally exists.

**Bears on:** The framework's "generation outpaces validation" thesis should treat METR as illustrative, not dispositive. The repo already does this; the audit's criticism should be narrowed.

### R-004 — Peer-reviewed corroboration for the ambiguity-degrades-generation claim exists independently

**Claim:** Even if ORCHID were discarded, the core design rationale for clear specs and the writing-rules watchlist is supported by peer-reviewed work.

**Evidence:** The repo itself cites [[CLARIFYGPT]] (FSE 2024, Pass@1 improvement via requirement clarification), [[SPECFIX]] (ASE 2025, repairing requirement text improves Pass@1), and [[HUMANEVALCOMM]] (TOSEM 2025, ambiguity/incompleteness drops Pass@1 35–52%). It also cites [[SMELLS]] (JSS 2017, lexical requirements-smell detection is feasible but imprecise) to justify keeping prose checks advisory.

**Confidence:** high.

**Bears on:** The framework's spec-clarity emphasis is well-grounded. The audit should not lump this rationale in with genuinely unsettled claims.

### R-005 — The repo's source-discipline correctly constrains caveated sources

**Claim:** The framework uses caveated/preliminary sources only for illustration, never for `MUST`-level rules.

**Evidence:** `docs/research/sources.md:1-6` states the discipline: Verified entries ground empirical claims, Caveated entries "MUST NOT carry a `MUST`-level claim," and Rejected entries must not be cited. `docs/research/sources.md:113-114` repeats that caveated sources are "usable to illustrate a direction, never to ground a `MUST`." METR and ORCHID appear only as supporting citations for design rationale, not as enforcement claims.

**Confidence:** high.

**Bears on:** The framework's honesty framework extends to its bibliography. The audit's concern about weak evidence should focus on whether the *narrative* overstates the evidence, not on whether the sources are misclassified.

## Open questions

- **Q-001:** Has ORchid been accepted at a peer-reviewed venue since the April 2026 arXiv upload? Answering this would let the repo upgrade or maintain its caveated classification.
- **Q-002:** What is the formal result of METR's 2026 follow-up, and has it been published? Answering this would let the repo update the METR entry from "reportedly did not replicate" to a settled status.
- **Q-003:** Is there any peer-reviewed or first-party evidence that a review-by-exception workflow reduces reviewer burden or catches more defects than conventional PR review? Answering this would strengthen or weaken the framework's central wedge.

## Advisory recommendation

The audit's claim that the framework rests on weak evidence should be narrowed:

- **Keep the criticism** for areas with no empirical grounding: review-by-exception benefits, provider-neutrality in practice, and the gap between templates and operational workflow.
- **Soften the criticism** for the ambiguity-degrades-generation rationale: it is supported by multiple peer-reviewed sources (CLARIFYGPT, SPECFIX, HUMANEVALCOMM) and correctly caveated where it relies on preprints (ORCHID).
- **Soften the criticism** for the METR citation: the repo already flags the 19% figure as unsettled and uses it only as preliminary illustration.

The largest remaining design impact is that Swarm's central value proposition — "invest in validation because generation outpaces validation" — is a sound design bet with partial empirical support, but the specific 19% slowdown figure should not appear in any adopter-facing pitch without the same caveat that appears in `docs/research/sources.md`.

---

# Market-gap research follow-up: gaps Swarm fills or can fill

## Question

What unique market gaps does the current AI-coding-tool landscape leave open, and how well does Swarm's design map onto them?

## Method

Surveyor persona: scan 2025–2026 empirical reports, regulatory signals, and first-party industry analyses for unmet needs that a markdown-only, spec-first, human-in-control workflow can address. Compare each gap to Swarm's existing conventions and artifacts. Map Swarm's coverage as **filled** (already addressed by shipped conventions), **partially filled** (addressed by convention but missing template/checklist guidance), or **fillable** (aligned with framework philosophy and can be addressed with modest additions).

## Findings

### G-001 — Human-in-control governance gap

**Gap:** Agentic AI is moving into production faster than governance. Gartner projects 40% of enterprise applications will embed task-specific AI agents by end of 2026, up from under 5% in 2025 [[GARTNER-AGENTS]]. Stanford's 2026 AI Index found security and risk is now the primary barrier to scaling agentic AI, cited by 62% of organizations [[AI-INDEX-2026]]. A 2026 Cloud Security Alliance survey found 65% of enterprises with deployed agents had experienced a confirmed security incident, 63% cannot enforce purpose limitations, and 60% cannot terminate a misbehaving agent once running [[CSA-AI-CYBER-2026]]. NIST has formally acknowledged that existing cybersecurity frameworks do not translate cleanly to autonomous agents and launched a multi-year AI Agent Standards Initiative with first deliverables not expected before late 2026 [[NIST-CAISI-RFI]] [[NIST-AI-AGENT-STANDARDS]].

**Market implication:** Enterprises need control patterns that work *today*, before standards and platforms mature. The gap is not more model capability; it is structured human oversight that keeps agents inside boundaries without destroying velocity.

**Swarm mapping:** **Filled.** Swarm's entire workflow is a human-in-the-loop pattern: specs are human-authored, task packets are approved, agents do not review their own output, and review packets escalate exceptions to humans. The basic six-step loop (`docs/02-basic-workflow.md`) and the advanced lifecycle (`docs/reference/advanced-lifecycle.md`) encode layered oversight (human-in-the-loop for exceptions, human-on-the-loop via status/review, human-out-of-the-loop only after a convention has been proven). This directly addresses the governance gap at the **convention** and **checklist** level.

**Positioning note:** Swarm should present itself as a near-term governance pattern, not an alternative to future platforms. Its honesty about being convention/checklist-first is a strength in a market where vendors imply enforcement they cannot deliver.

---

### G-002 — Audit trail and provenance gap

**Gap:** Regulated industries increasingly require documented provenance for AI-generated code. A 2025 compliance survey of 400 organizations in regulated industries found 73% now require AI-generation audit trails for production code, up from 18% in 2024 [[VIBECODER-AUDIT]]. Requirements arise from HIPAA, PCI DSS, FedRAMP, SOC 2 Type II, ISO 27001, EU AI Act Article 12 traceability, and the EU Cyber Resilience Act [[AQUILAX-VIBE]] [[FORGEPROOF-2026]]. The four audit-trail components commonly cited are prompt history, generation provenance, review documentation, and version-control linkage [[VIBECODER-AUDIT]]. Current IDE agents keep prompt and model history inside proprietary sandboxes; most teams cannot reconstruct what was asked, which model answered, and whether a human reviewed it.

**Market implication:** Audit-ready AI-generated code is becoming a market-access requirement, not a niche compliance checkbox. Tools that make provenance cheap and human-readable will have a durable advantage over black-box agents.

**Swarm mapping:** **Partially filled.** Swarm already produces most of the needed artifacts:
- Prompt history: implicit in task packets and agent logs.
- Generation provenance: can be recorded in task packets (model/version) and commit metadata.
- Review documentation: the review packet is explicitly designed to capture reviewer, result, and evidence.
- Version-control linkage: git commits with references to specs/plans/tasks.

What is missing is a single template or convention that teams can point auditors to: a "provenance bundle" template that ties these four components together per change. Swarm's **honesty framework** (ADR-0063) is also a differentiator here: it makes explicit which rules are convention, checklist, toolable, or enforced, which is exactly the kind of transparency auditors and risk officers need.

**Recommendation:** Add a `provenance-bundle.md` template or checklist to the starter kit showing how to assemble the four components for a given change. Cite the regulatory drivers in a reference doc but avoid implying legal compliance without legal review.

---

### G-003 — Lightweight, no-platform governance demand

**Gap:** Enterprises are spending heavily on AI but getting locked into platforms. Migration costs for AI agent platforms typically reach twice the initial investment, and 57% of IT leaders spent over $1 million on platform migrations in the past year [[INNOBU-LOCKIN]]. 78% of enterprises already use two or more LLM families, but 46% struggle to integrate agent platforms into existing systems [[INNOBU-LOCKIN]]. At the same time, low-code/no-code AI platforms are proliferating, projected to reach $25 billion by 2030 [[YAITEC-NOCODE]], while many teams report that governance tools add friction rather than clarity.

**Market implication:** There is demand for governance that is portable, multi-model, and does not require a new platform. Teams want to keep using Cursor, Claude Code, Codex, Aider, or their own setup while adding a lightweight process layer.

**Swarm mapping:** **Filled.** Swarm is markdown-only, ships no runtime, and keeps workflow state in git. Its SKILL.md format is an emerging open standard across multiple agents [[SOLOBUSINESSHUB-SKILLS]] [[SERENITIESAI-SKILLS]], and its conventions can be adopted regardless of which agent generates the code. The starter kit explicitly tells teams to define their own commands (`starter-kit/AGENTS.md`), which acknowledges that Swarm does not replace their toolchain.

**Positioning note:** Swarm should market itself as "bring your own agent," not as a competitor to Copilot/Cursor/Claude Code. The unique value is a governance layer that survives tool churn.

---

### G-004 — Brownfield comprehension and change-level specification gap

**Gap:** Most AI coding tools excel at greenfield tasks and struggle with legacy code. Studies find that while GenAI enables faster progress on brownfield tasks, developers' comprehension of the legacy system does not improve and may degrade; AI-generated explanations are often too localized to build system-level understanding [[QIAO-BROWNFIELD]] [[EMERGENTMIND-BROWNFIELD]]. NashTech's own research found productivity gains for greenfield development but "less benefits in brownfield or legacy modernisation projects" [[NASHTECH-LEGACY]]. The dominant modernization tools (OpenRewrite, rule-based migrations) remain confined to large enterprises with Java codebases and dedicated platform teams [[ONA-MIGRATIONS]]. Augment Code's brownfield SDD guide recommends "change-level specs" scoped to a single modification as the practical answer to comprehensive specs being impossible at enterprise scale [[AUGMENT-SDD-BROWNFIELD]].

**Market implication:** Brownfield AI adoption is the harder and more valuable problem. Teams need a way to constrain AI-assisted changes so generated code respects invisible legacy invariants.

**Swarm mapping:** **Partially filled.** Swarm's spec-driven approach naturally maps to change-level specs: a spec can define current behavior, target behavior, invariants, and scope boundaries before any code is generated. The `spec.md` template and writing rules already support this. However, the framework does not explicitly call out brownfield/legacy as a use case, and the large-PR-review example (`docs/examples/large-pr-review.md`) is greenfield-leaning.

**Recommendation:** Add a brownfield change-level spec example and a short guidance note to `docs/examples/` or `starter-kit/templates/` showing how to use Swarm for incremental refactoring of existing code. This would fill a gap that most agent vendors ignore.

---

### G-005 — Trust, transparency, and the AI code-quality paradox

**Gap:** Adoption of AI coding tools is outpacing trust. Stack Overflow's 2025 survey found 84% of developers use AI tools daily but only 29% trust AI-generated code accuracy, down from 40% the previous year [[PRACTICALLOGIX-PARADOX]]. A February 2026 analysis of 470 open-source pull requests found AI-generated PRs averaged 1.7x as many issues as human-written PRs, with more correctness, maintainability, and security issues; the only category where AI was better was spelling in comments [[CODERABBIT]] [[PRACTICALLOGIX-PARADOX]]. Developers report contradictory AI feedback, false positives, and a "false sense of security" effect where AI-assisted developers rate insecure solutions as secure more often than controls [[CATALDI-AI-REVIEW]] [[RJNTI-AI-QUALITY]]. A qualitative study of AI-driven code review found trust, reliability, and lack of context understanding were the dominant themes [[CATALDI-AI-REVIEW]].

**Market implication:** Trust is becoming a scarce and valuable commodity. Tools that make verification transparent, human-escalated, and evidence-based will be preferred over tools that optimize only for output volume.

**Swarm mapping:** **Filled, with differentiation.** Swarm's honesty framework (ADR-0063) is a genuine structural advantage: every rule is labeled with a level (convention · checklist · toolable · enforced), so teams know exactly what is automated and what is not. The structured review packet requires evidence pasted into the artifact, which makes review transparent and auditable. The "do not review your own output" rule and the separation of generation and review roles directly counter the over-reliance and false-sense-of-security effects documented in the literature.

**Positioning note:** Swarm should lead with trust architecture, not productivity. Its pitch is not "generate more code" but "generate code you can stand behind." This aligns with the market's shift from measuring output to measuring outcomes (incidents per PR, change failure rate, time-to-revert) [[PRACTICALLOGIX-PARADOX]].

---

### G-006 — Agent-skill supply-chain and fragmentation risk

**Gap:** Agent skills have exploded as a pattern (modular SKILL.md folders), but the ecosystem is already showing fragmentation and security risks. One report claims 100,000+ skill installs across ecosystems but also warns of vendor lock-in, proprietary orchestration formats, and unportable memory stores [[SOLOBUSINESSHUB-SKILLS]] [[AGENTMELT-LOCKIN]]. Security researchers identified 341 malicious skills on community hubs by February 2026, with risks ranging from data exfiltration to credential theft and prompt injection [[SERENITIESAI-SKILLS]]. Teams are advised to treat third-party skills like npm packages: audit before installing, restrict permissions, pin versions, and maintain an approved-skills list.

**Market implication:** The skill ecosystem needs governance conventions as much as the code ecosystem needs dependency scanning. There is an unmet need for a lightweight, auditable way to manage which skills an agent may load and why.

**Swarm mapping:** **Partially filled.** Swarm's own `.agents/skills/` and starter-kit skill symlinks are small, curated, and version-controlled. However, the framework does not provide a skill-risk checklist or an "approved skills" convention. The starter kit could easily add a `skills-inventory.md` or a short checklist covering source, permissions, version pinning, and review cadence.

**Recommendation:** Add a skill-governance checklist to the starter kit, drawing directly on the third-party-skill security guidance. This would position Swarm as a governance layer for the skill ecosystem, not just the code ecosystem.

---

## Synthesis: where Swarm has durable differentiation

| Gap | Swarm coverage | Durable advantage? |
|---|---|---|
| Human-in-control governance | Filled | Yes — process-first, before platforms enforce it |
| Audit trail / provenance | Partially filled | Yes, if a provenance-bundle template is added |
| No-platform / portable governance | Filled | Yes — markdown + git, BYO agent |
| Brownfield comprehension | Partially filled | Yes, if change-level brownfield specs are added |
| Trust / transparency / honesty | Filled | Yes — honesty framework is structurally differentiated |
| Skill supply-chain governance | Partially filled | Possible, if skill-risk checklist is added |

## Strategic positioning adjustments suggested by the gap analysis

1. **Lead with governance, not generation.** The market has plenty of generation tools. Swarm's wedge is governance, provenance, and trust. Its tagline should emphasize "invest in validation" rather than "ship faster."

2. **Target regulated and risk-sensitive teams explicitly.** The audit-trail gap is a market-access issue for healthcare, finance, defense, and critical infrastructure. Swarm's conventions are closer to compliance-ready than most black-box agents, though it must avoid claiming legal compliance without review.

3. **Embrace BYOA (bring your own agent).** Swarm should not compete with Cursor, Claude Code, Codex, or Aider. It should position itself as the governance layer that works across all of them.

4. **Fill the two nearest gaps quickly:**
   - A `provenance-bundle.md` template/checklist for audit-ready changes.
   - A brownfield change-level spec example and guidance note.

5. **Add skill governance.** A lightweight skill-risk checklist would extend Swarm's governance layer to the fastest-growing but least-governed part of the agent stack.

6. **Keep the honesty framework central.** In a market where 84% use AI but only 29% trust it, a framework that labels every rule by enforceability is a trust signal. Do not bury ADR-0063; surface it in the README and starter kit.

## Open questions

- **Q-005:** Are there existing Swarm adopters in regulated industries who can validate whether the proposed provenance-bundle template would satisfy an auditor? This would move the audit-trail gap from "partially filled" to "filled."
- **Q-006:** Has any team used Swarm's change-level spec pattern for brownfield refactoring at scale? Quantitative evidence (fewer regressions, faster merges) would strengthen the brownfield positioning.
- **Q-007:** What is the minimum viable skill-risk checklist — does it need to cover model-tool permissions, script execution, prompt-injection review, or all three?
