# Engineering Skills

[中文 README](README.md)

Engineering Skills is a cross-runtime skill pack for coding agents. It is designed for feature development, bug diagnosis, architecture review, safe git operations, and skill documentation maintenance in real engineering projects.

This project combines two kinds of inspiration:

- Workflow discipline inspired by [obra/superpowers](https://github.com/obra/superpowers): clarify first, plan before execution, write failing tests before implementation, review and verify before completion.
- Engineering depth inspired by [mattpocock/skills](https://github.com/mattpocock/skills): domain language, task layering, behavior tests, feedback loops, root-cause diagnosis, and review discipline.

The goal is not to let an agent replace engineering judgment. The goal is to help it make fewer mistakes at critical moments.

## Acknowledgements

This project is informed by the excellent practices in [obra/superpowers](https://github.com/obra/superpowers) and [mattpocock/skills](https://github.com/mattpocock/skills). The former inspired the workflow discipline and skill gates; the latter inspired engineering task design and diagnosis/review methods.

The skill text and organization in this repository are newly written and adapted for Chinese engineering workflows and multi-platform distribution.

Developed with assistance from OpenAI Codex for design, organization, and validation.

## Core Skills

| Skill | Purpose |
| --- | --- |
| `start` | Entry router. Selects the right skill path before action. |
| `zoom-out` | Understand code context, module relationships, data flow, and impact range. |
| `deepen` | Find architecture improvement opportunities, reduce coupling, and improve module depth and testability. |
| `brainstorm` | Generate and compare candidate approaches when the goal is clear but the direction is not. |
| `clarify` | Clarify requirements, success criteria, boundaries, domain language, and decisions. |
| `grill` | Stress-test ideas, plans, and designs before implementation. |
| `plan` | Convert confirmed requirements into task-layered implementation plans. |
| `execute` | Execute confirmed plans task by task with TDD, verification, review, and diagnosis. |
| `tdd` | Behavior-first TDD: failing test, minimal implementation, refactor. |
| `diagnose` | Diagnose failures with feedback loops, reproduction, hypotheses, evidence, root cause, and regression checks. |
| `review` | Review requirement fit and engineering quality. |
| `finish` | Completion gate before claiming completion, merging, or delivery. |
| `git` | Safe version-control operations: commits, pushes, merges, PRs, remotes, and cleanup. |
| `skill-edit` | Create or modify skills with pressure scenarios and validation. |

## Recommended Mode

Use guided mode by default:

- Users only need to describe the goal, scope, and constraints. They do not need to memorize or manually choose skill chains.
- `start` routes the request to the right skill path and briefly explains the routing decision.
- If a task clearly matches a skill, load that skill first.
- If the match is unclear, provide a short routing suggestion.
- User goals and boundaries are important, but they cannot override validation, safety confirmation, or completion evidence.

This is a routed workflow, not a mandatory long chain. `start` chooses the shortest reliable path for the task.

Common boundaries:

- `zoom-out` understands the system and impact range.
- `clarify` aligns goals, boundaries, and success criteria.
- `brainstorm` compares multiple approaches after the goal is clear.
- `grill` stress-tests a selected idea, plan, or design.
- `deepen` finds architecture improvement and refactoring opportunities.
- `review` checks requirement fit and engineering quality.
- `diagnose` finds the root cause of concrete failures.

All complete paths converge at `finish`: verify that the result is what the user wanted, verify that the code, documentation, or skill artifact is correct, and report evidence and residual risk.

## Installation and Usage

- Installation: [INSTALL.md](INSTALL.md)
- Usage examples: [USAGE.md](USAGE.md)
- Changelog: [CHANGELOG.md](CHANGELOG.md)
- Contributing: [CONTRIBUTING.md](CONTRIBUTING.md)
- Validation: run `scripts/validate.ps1` on Windows or `scripts/validate.sh` on macOS/Linux.

## Quick Start

Windows:

```powershell
git clone https://github.com/Jacklovecode/engineering-skills.git
cd engineering-skills
.\scripts\install.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate.ps1
```

macOS / Linux:

```bash
git clone https://github.com/Jacklovecode/engineering-skills.git
cd engineering-skills
chmod +x scripts/install.sh scripts/validate.sh scripts/simulate-pressure.sh
./scripts/install.sh
./scripts/validate.sh
./scripts/simulate-pressure.sh
```

The install scripts copy the skill pack and platform entry files. They do not run git operations.

## Contributing

Contributions are welcome through issues and pull requests, especially for skill design, Chinese wording, validation scenarios, and multi-platform compatibility.

- Contribution guide: [CONTRIBUTING.md](CONTRIBUTING.md)
- Code of conduct: [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)
- Security policy: [SECURITY.md](SECURITY.md)

Before opening a pull request, run structure validation and pressure-scenario validation. Make sure local reports, caches, backup files, and sensitive information are not committed.

## Language Strategy

- Skill names are short English names for cross-platform compatibility.
- Skill bodies are written in Chinese, especially constraints, gates, and execution requirements.
- Frontmatter metadata and platform manifests stay English-friendly for indexing and platform discovery.
