# Local checks

Suspec's checker validates generic artifact facts. Project-specific verification stays in
the repository that owns the code.

## Resolve commands

Read the repository's `AGENTS.md`, contributor guide, and package manifest. Use the exact
commands they define for build, tests, lint, type checking, formatting, architecture,
security, and benchmarks.

A spec's `Verify with:` line can name a literal command or a project command slot. A slot
is useful only when the repository maps it to a real command; an unresolved slot leaves the
claim unverified.

## Evidence

Run the command after the final relevant edit and paste its real output or link the exact
CI job. A script can report exit status and facts. It cannot decide that a requirement is
Supported, Unverified, or Blocked; the reviewer makes that judgment against the requirement.

## Layering

- repository tools verify code behavior and quality
- `suspec check` verifies artifact structure and evidence binding
- independent review judges whether the evidence demonstrates intent
- a human owns merge policy

Do not rebuild repository linters inside Suspec. Reference their outputs and keep their
configuration with the code.

Related: [checks](checks.md) · [CLI](cli.md)
