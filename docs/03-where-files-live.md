# Where files live

Place the file next to your own native artifacts — the same place you keep your plans,
notes, and memories for this work, in a folder named after the repo you are working on
(or wherever fits your harness best). You choose the exact spot; keep it out of the repo
unless the project's own governance says otherwise, and carry the file's full path
forward — every later step names artifacts by explicit path.

That paragraph is the whole placement rule. The rest of this page is why it is shaped
that way.

## Why no location is prescribed

Your harness already solves placement: it lands its own plans, notes, and memories in
its own conventions, without any external rule. Suspec describes the intent — beside
your native artifacts, out of the adopter's repo — and the agent chooses the spot
(level: convention). A prescribed path would make Suspec responsible for a directory's
hygiene, and a directory someone owns grows management machinery: cleanup, migration,
reconciliation. No owned location, no machinery. Artifacts are transient working files;
when the work is done, what mattered has already left them or the user explicitly promotes
the whole artifact into a project-native durable channel.

## Paths flow explicitly

Nothing discovers, resolves, or infers locations, with one narrow exception (level: convention):

- A skill that writes an artifact states where it put it, and carries that path forward.
- A dispatch prompt names the spec — and the task, when one exists — by full path.
- The checker reads exactly the files it is handed for a spec (`suspec check <path>`) or
  a review packet (`suspec check <review-path> --spec <spec-path>`, adding
  `--task <task-path>` when the spec was split into one) (level: enforced — suspec-cli).
- The one exception, artifact-relative resolution, never a tree walk: checking a spec
  resolves its source links and inline citations against whatever relative path its own
  frontmatter names, from the spec's own directory — however many levels that path
  itself climbs — and checking a change plan resolves its `SPEC-id#AC-NNN` refs by
  scanning the plan's own directory for sibling `*/spec.md` files, one level beside the
  plan and no further (level: enforced — suspec-cli).

The trade is deliberate: no tool can list your specs or resume your work in flight,
because no tool knows where they are. You do — and the artifacts are plain markdown,
greppable with whatever you already use.

## Nothing in the adopter repo

Your repo takes the code, the tests, and whatever your project's own governance already
commits — ADRs, agent guides. No Suspec directory, no config file, no gitignore entry,
no seeded scaffold (level: convention). If a project's governance chooses to commit
specs or reviews, that is the project's call, not Suspec's default.

## Where durable value goes

The files are disposable *because* the durable residue leaves them for the layers that
already own it:

| You produced        | It lives, while the work is live, as | Durable value lands in                     |
| ------------------- | ------------------------------------ | ------------------------------------------- |
| a captured ticket   | an intake file                       | nothing — the recorded URL re-fetches it    |
| intended behavior   | a spec                               | an ADR, when it carries a decision          |
| verification        | pasted output in the spec or task    | the PR and its discussion                   |
| a review            | a review packet                      | the exceptions you act on                   |
| a lesson            | the packet's findings section        | a native harness memory, an issue, a test   |
| a split slice       | a task packet                        | nothing — the spec stays the contract       |
| a change plan       | a change plan                        | the PRs that land it                        |

See [saving findings](09-saving-findings.md) for the memory route. Whole-document promotion
uses `promote-artifact`: discover the project's durable destinations, select one, sanitize,
move, repair references, and validate. It creates no Suspec location or registry and never
pushes implicitly.

## Drift rule

Code can prove a working spec wrong. It does not silently update intent. During live work,
when code and intent diverge, re-run the verification and then update the active spec or
fix the code. After close, code and the project's durable records are authoritative.

## Related

- Next: [Writing specs](04-writing-specs.md)
- Previous: [The basic workflow](02-basic-workflow.md)
