# The `suspec` CLI

[suspec-cli](https://github.com/jcosta33/suspec-cli) is Suspec's read-only deterministic checker.
Facts in, diagnostics out. It runs no model or verification command, writes nothing, discovers no
repository or artifact store, and renders no acceptance decision.

The CLI repository owns commands, options, companions, path handling, output, exits, installation,
and runtime behavior. See its [public contract](https://github.com/jcosta33/suspec-cli#readme).

Canon owns check meaning:

- [machine contract](../../checks/checks.yaml);
- [check catalog](checks.md);
- [artifact formats](artifact-formats.md).

The implementation must match the canon contract. A parser is not a manager.
