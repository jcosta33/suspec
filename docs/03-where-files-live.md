# Where files live

Place the file under `~/.agents/artifacts/<workspace>/`, resolving `~` to the
absolute home path and deriving `<workspace>` from the repository or working-directory
basename. Keep it out of the repository and carry its absolute path forward.

That paragraph is the whole placement rule. The rest of this page is why it is shaped
that way.

## Why the location is agent-neutral

Ordinary Suspec artifacts are plain Markdown, not harness state. A vendor-owned directory
does not give them supported loading, indexing, resumption, or UI behavior. The neutral
root lets another local agent consume the same file without a copy or symlink while
keeping every working file outside the adopter's repository (level: convention).

Plan Mode, vendor-native plans, native memory, source code, build output, and
harness-managed state stay where their owners put them. Suspec does not intercept them.

The root is a passive convention, not a managed store. Suspec creates no registry,
resolver, config, lifecycle state, cleanup command, or background process. Cleanup stays
manual and external to Suspec.

## Workspace and conflicts

Derive `<workspace>` from the repository basename. Outside a repository, use the
working-directory basename. Keep artifact-specific layouts and filenames defined by the
writer that creates them.

Never overwrite unrelated work. If a workspace name is ambiguous or a target path
already belongs to unrelated work, stop and present structured choices for a distinct
human-readable name. Do not hash the path or create an identity registry.

If the root is unwritable, present these choices: grant access and retry; choose another
agent-neutral user directory; cancel. Never fall back to vendor storage, the repository,
or an OS temporary directory.

## Paths flow explicitly

Nothing discovers, resolves, or infers artifact relationships, with one narrow exception
(level: convention):

- A skill that writes an artifact resolves `~`, states the absolute path, and carries
  that path forward.
- A dispatch prompt names the spec — and the task, when one exists — by absolute path.
- The checker reads exactly the files it is handed for a spec (`suspec check <path>`) or
  a review packet (`suspec check <review-path> --spec <spec-path>`, adding
  `--task <task-path>` when the spec was split into one) (level: enforced — suspec-cli).
- The one exception, artifact-relative resolution, never a tree walk: checking a spec
  resolves its source links and inline citations against whatever relative path its own
  frontmatter names, from the spec's own directory — however many levels that path
  itself climbs — and checking a change plan resolves its `SPEC-id#AC-NNN` refs by
  scanning the plan's own directory for sibling `*/spec.md` files, one level beside the
  plan and no further (level: enforced — suspec-cli).

The known root improves human discovery, but no Suspec tool lists or resumes work. Every
consumer still receives an explicit absolute path.

## Nothing in the adopter repo

Your repo takes the code, the tests, and whatever your project's own governance already
commits — ADRs, agent guides. No repository-local Suspec directory, config file,
gitignore entry, or seeded scaffold is added (level: convention). A whole artifact
enters the repository only through explicit promotion into a project-owned durable
channel.

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

See [saving findings](09-saving-findings.md) for the memory route. Whole-document
promotion uses `promote-artifact`: discover the project's durable destinations, select
one, sanitize, move, repair references, and validate. Promotion is durable-only; it does
not relocate files between transient roots, create a registry, or push implicitly.

## Drift rule

Code can prove a working spec wrong. It does not silently update intent. During live work,
when code and intent diverge, re-run the verification and then update the active spec or
fix the code. After close, code and the project's durable records are authoritative.

## Related

- Next: [Writing specs](04-writing-specs.md)
- Previous: [The basic workflow](02-basic-workflow.md)
