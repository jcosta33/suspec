# Local checks

Project repositories own code verification. Suspec checks generic artifact facts.

Resolve exact build, test, lint, type, format, architecture, security, and benchmark commands from the
repository's instructions and manifests. A `Verify with:` slot without a real project mapping remains
unverified.

Run commands after the final relevant edit. Preserve raw output or the exact CI job. Tools report exit
status and facts; independent review decides whether evidence supports a requirement.

| Layer                          | Owner                       |
| ------------------------------ | --------------------------- |
| code behavior and quality      | repository tools            |
| artifact structure and binding | `suspec check`              |
| evidence judgment              | independent reviewer        |
| merge policy                   | human or project governance |

Do not rebuild project linters inside Suspec.

Related: [checks](checks.md) · [CLI](cli.md)
