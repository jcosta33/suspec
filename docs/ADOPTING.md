# Adoption

## Install skills

Install globally for your harness (Codex shown):

```bash
npx skills add jcosta33/suspec-skills -g -a codex
```

This is a complete install. Repository commands, architecture, and policy remain in that repository's
native instructions.

Re-running `npx skills add` updates present entries but does not remove names absent from the source.
After a catalog removal, delete only obsolete Suspec entries with
`npx skills remove -g -a <agent> <names...>`, then reinstall. Preserve unrelated skills.

## Add the optional CLI

The CLI is unpublished. Build it from source with Node.js 22.6 or newer:

```bash
git clone https://github.com/jcosta33/suspec-cli
cd suspec-cli
pnpm install --frozen-lockfile
pnpm build
pnpm link --global
```

Run:

```bash
suspec check <path>
```

It reads explicit absolute or current-working-directory-relative paths and adds no repository
configuration. Exact behavior: [CLI reference](reference/cli.md).

## First run

1. Use `sus-spec` to write intent and requirements with stable IDs and `Verify with:` lines.
2. Carry its absolute path from `~/.agents/artifacts/<workspace>/`.
3. Implement from that path and preserve real verification output.
4. Run `sus-review` independently against the spec.
5. Optionally run `suspec check <review-path> --spec <spec-path>`.
6. Route durable findings to native memory or project records.
7. After the final consumer finishes, choose Delete, Leave, or Promote for the complete transient
   artifact set.

A trivial fix skips the files: state intent and verification inline. See the
[bug-fix example](examples/bug-fix.md) and [tutorial](tutorial/README.md).

## Without the CLI

Write the documented [artifact shapes](reference/artifact-formats.md), run each verification, preserve
real output, and review every requirement. Treat empty evidence as `Unverified`. The CLI automates
structural checks only.

## Teams

The canonical machine contract is `checks/checks.yaml`; the CLI ships its matching implementation.
Teams decide which reported levels block CI and may add project-owned checks. Editing a local contract
copy does not reconfigure the CLI.

Suspec commits nothing by default. Projects own code, tests, decisions, guides, PRs, and any explicitly
promoted artifact.
