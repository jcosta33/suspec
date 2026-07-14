# Adoption

## Install skills

Install globally for your harness (Codex shown):

```bash
npx skills add jcosta33/suspec-skills -g -a codex
```

This is the complete install. Suspec does not annex the repository: its commands, architecture, and
policy stay in native instructions.

Re-running `npx skills add` updates present entries but does not remove names absent from the source.
After a catalog removal, delete only obsolete Suspec entries with
`npx skills remove -g -a <agent> <names...>`, then reinstall. Preserve unrelated skills.

## Add the optional CLI

The CLI is unpublished. Install it from source with Node.js 22.6 or newer:

```bash
git clone https://github.com/jcosta33/suspec-cli
cd suspec-cli
corepack enable
pnpm install --frozen-lockfile
pnpm link --global
```

The repository pins pnpm 10 through Corepack.

Run:

```bash
suspec check <path>
```

It reads explicit absolute or current-working-directory-relative paths and adds no repository
configuration. Exact behavior: [CLI reference](reference/cli.md).

## First structured run

1. Use `sus-spec` to write intent and requirements with stable IDs and `Verify with:` lines.
2. Carry its absolute path from `~/.agents/artifacts/<workspace>/`.
3. Implement from that path and preserve real verification output.
4. Have a non-implementer review the result; use `sus-review` when risk earns a formal packet.
5. Optionally run `suspec check` against the artifacts involved.
6. Route durable findings to native memory or project records.
7. After the final consumer finishes, choose Delete, Leave, or Promote for the complete transient
   artifact set.

A trivial fix skips this workflow. Do not bill obvious work for ceremony. State intent and
verification inline. See the [bug-fix example](examples/bug-fix.md) and
[tutorial](tutorial/README.md).

No fresh reviewer means no independent review. Direct self-review may find defects; it cannot close
work whose risk requires independence.

## Without the CLI

Write the documented [artifact shapes](reference/artifact-formats.md), run each verification, preserve
real output, and review every requirement. Treat empty evidence as `Unverified`. The CLI automates
structural checks only.

## Teams

The canonical machine contract is `checks/checks.yaml`; the CLI ships its matching implementation.
Teams decide which reported levels block CI and may add project-owned checks. Editing a local contract
copy does not reconfigure the CLI.

Suspec commits nothing by default. Your project remains your project: it owns code, tests, decisions,
guides, PRs, and any explicitly promoted artifact.
