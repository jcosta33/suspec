# The `suspec` CLI

[suspec-cli](https://github.com/jcosta33/suspec-cli) owns two isolated surfaces.

- `suspec check` is a read-only deterministic checker. Facts in, diagnostics out. It runs no model or
  verification command, writes nothing, discovers no repository or artifact store, and renders no
  acceptance decision.
- `suspec setup` previews, installs, checks, or removes the canonical user-level economy policy for
  explicit Codex, Claude Code, or OpenCode targets. It owns only its payload and marked harness blocks.
  Drift or ambiguous configuration blocks mutation.

The CLI repository owns commands, options, companions, path handling, output, exits, installation,
and runtime behavior. See its [public contract](https://github.com/jcosta33/suspec-cli#readme).

Canon owns check meaning:

- [machine contract](../../checks/checks.yaml);
- [check catalog](checks.md);
- [artifact formats](artifact-formats.md).

The checker must match the checks contract. Setup must embed [the economy policy](output-economy.md)
byte for byte. A parser is not a manager.
