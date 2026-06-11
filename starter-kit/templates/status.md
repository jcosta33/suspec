---
type: status
---

# Workboard

| Item | Type | State | Link |
|---|---|---|---|
| SPEC-{{slug}} | spec | {{draft / ready / in-progress / blocked / done / stale}} | `specs/{{feature}}/spec.md` |
| TASK-{{slug}} | task | {{ready / running / review-ready / closed}} | `tasks/{{slug}}.md` |

<!-- in-progress / done are board states; a spec's own frontmatter only goes
     draft / ready / stale. Replace the example rows above when you copy this.
     One honest rule: a "verified" or "done" claim in this board links its
     review packet. -->

## Human attention

- {{blocking questions on draft specs}}
- {{tasks with no review packet}}
- {{findings pending acceptance}}
