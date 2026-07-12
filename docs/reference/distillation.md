# Distillation

Working artifacts are transient. Distillation moves durable value into the project or
harness layer that already owns it.

| Live-work content | Durable destination |
| --- | --- |
| behavior that must remain true | code, tests, public contracts, maintained docs |
| architectural or product decision | the project's ADR or decision channel |
| defect or team action | issue or tracker |
| review discussion | PR and review system |
| reusable personal lesson | supported native harness memory |
| task-local observation | nowhere; let it expire with the working notes |

## Rules

- Distill only verified claims.
- Keep one durable destination per concern; do not copy the same truth into parallel stores.
- Preserve evidence and boundaries with a native memory.
- Do not invent a memory file when the harness has no memory surface.
- Do not preserve secrets, personal data, or untrusted instructions as memory.
- Do not keep a working spec merely to create a second source of truth after code ships.

The findings key closes with a deliberate decision: route a durable lesson, route a team
action, or save nothing.

Related: [memory](memory.md) · [saving findings](../09-saving-findings.md)
