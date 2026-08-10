# Integrations

Integrations carry Suspec across tool boundaries. They do not become product owners. Skills carry the
method; Markdown and explicit paths carry the work.

## CLI

[suspec-cli](https://github.com/jcosta33/suspec-cli) runs read-only deterministic checks over explicit
paths. Its separate `setup` command installs, checks, or removes the user-level agent policy for
explicit harnesses through their native global instruction files. See its [public
contract](https://github.com/jcosta33/suspec-cli#readme) and Suspec's [check
catalog](reference/checks.md).

## MCP

[suspec-mcp](https://github.com/jcosta33/suspec-mcp) exposes the checker to shell-less MCP clients.
Its repository owns the exact [tools, schemas, envelope, and installation
contract](https://github.com/jcosta33/suspec-mcp#readme).

Agents with shell access can call the CLI directly.

MCP exposes checks only. It cannot install policy, manage artifacts, or orchestrate work. Run
`suspec setup` directly.

## Harnesses

Give any worker:

- project instructions;
- the spec and optional task by absolute path;
- the repository or worktree.

The UI and provider are replaceable by design. Suspec ships no custom agents.

## Project systems

Keep existing owners:

- issue trackers hold backlog and source IDs;
- PRs show diffs and discussion;
- project commands and CI run proportionate checks;
- review maps those results to requirements;
- project systems validate pull-request, review, merge, resource, and cleanup transitions;
- harness permissions isolate worker authority, merge credentials, shared resources, and cleanup;
- project records hold durable decisions and lessons.

An autonomous campaign starts only after these native controls prove their owner and enforcement
class. Its stable campaign artifact points to the native ledger that owns mutable progress. Suspec
supplies no delivery runtime.

The checker verifies coverage, evidence presence, references, and command matches for structured
`verify` blocks. Free-form evidence receives advisory human review. Suspec never owns credentials,
model settings, editor UI, tracker state, CI configuration, or merge authority.

Adopter repositories receive no Suspec configuration, directories, or gitignore entries. Their own
agent guides remain project policy.

Previous: [findings and memory](09-saving-findings.md). Start: [what Suspec is](01-what-is-suspec.md).
