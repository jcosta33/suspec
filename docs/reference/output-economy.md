# Output economy

Evidence should be complete without making the reader excavate it.

## Keep

- the claim being verified
- the exact command or observation
- the decisive output and exit state
- file paths and requirement IDs needed to inspect it
- failures, blockers, and scope drift

## Remove

- repeated request summaries
- confidence language standing in for evidence
- full logs when a stable summary and linked raw run suffice
- decorative status prose
- inventories and counts that do not change a decision

Compression never changes code symbols, commands, paths, error text, security warnings, or
the order of irreversible steps.

For long command output, preserve the complete run in its native system and paste the
smallest verbatim section that proves the claim, including the runner summary and exit
condition. A reviewer can request more when the omitted context matters.

Related: [evidence](checks.md) · [principles](principles.md)
