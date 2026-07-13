# What is Suspec?

Suspec is a skill-delivered method for directing and checking coding agents. Your harness writes code.
Suspec structures intent, evidence, review, and human decisions around it.

It provides:

- an inline path for work too small to need a file;
- specs with verifiable requirements;
- task packets for separately dispatchable slices;
- inventories and change plans for structural work;
- independent reviews reconciled requirement by requirement;
- durable-lesson routing to native memory or project records;
- deterministic checks over recorded structure.

It does not replace plan mode, project instructions, issue trackers, PRs, CI, tests, or human
acceptance.

## Proportional rigor

Use the least structure that changes execution or review:

- State a trivial fix and its verification inline.
- Write a spec when intent needs a working contract.
- Add inventory, change planning, or task splitting only when the work demands them.
- Escalate review with risk.

Intent, review, and findings remain constant. Everything else is optional scaffold.

## Boundaries

Suspec artifacts are transient. Code, tests, decisions, issues, PRs, maintained documentation, and
supported native memory hold durable truth. Suspec neither intercepts native plans nor creates a
repository-local store.

The CLI checks structural facts without a model. It does not prove recorded evidence true or render a
review decision. Independent review judges evidence; humans accept, waive, defer, or request changes.

## Fit

Use Suspec when a change outgrows direct attention, several workers share it, or intent and proof must
be reconstructed later. Skip it when native planning, project instructions, tests, and direct review
already make the work obvious.

Next: [workflow](02-basic-workflow.md).
