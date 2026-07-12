# Repository skill mirrors

`.agents/skills/` contains local mirrors used while maintaining this documentation and
checks repository. It is not the shipped catalog and owns no methodology rule.

| Mirror | Source |
| --- | --- |
| `implement-task` | `suspec-skills/skills/implement-task` |
| `empirical-proof` | `suspec-skills/skills/empirical-proof` |

Edit the canonical skill in
[suspec-skills](https://github.com/jcosta33/suspec-skills), then update its mirror here in
the same change. The files and bundled references must remain byte-identical.

Human-facing formats live in [artifact formats](../docs/reference/artifact-formats.md);
the machine contract lives in [`checks.yaml`](../checks/checks.yaml). The CLI does not
scaffold or install repository files.
