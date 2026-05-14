# AGENTS.md

This repository is ACE, an agent-portable workflow harness for planning,
building, testing, and recording AI-assisted work across Codex, Claude Code,
and similar execution environments.

Use this file as the shared project instruction source for AI agents working in
this repository.

## Project Intent

- Keep ACE portable across agent runtimes. Do not hard-code behavior that only
  works in one assistant unless the feature is explicitly runtime-specific.
- Preserve the artifact flow described in `README.md`: analysis, design,
  development, test, research, model, plan, judgement, and wiki outputs should
  remain reusable across projects.
- Treat ACE as a harness, not a prompt collection. Changes should strengthen
  repeatable workflows, validation, and handoff quality.

## Working Principles

- Think before coding. If requirements, acceptance criteria, data flow, or
  runtime behavior are unclear, ask for clarification or write down explicit
  assumptions before implementing.
- Prefer simple, surgical changes. Keep edits scoped to the requested behavior
  and avoid unrelated refactors.
- Preserve compatibility with existing project structure and command names.
- Keep generated project scaffolds predictable and easy to inspect.
- Record important decisions in project docs or wiki outputs when the task is
  part of a larger workflow.

## Repository Conventions

- Use `rg`/`rg --files` for code and file discovery.
- Use ASCII for new files unless the surrounding file already uses non-ASCII or
  the content requires Korean text.
- Do not modify user-created or unrelated untracked files.
- Do not rewrite git history or discard local changes unless explicitly asked.
- Keep documentation aligned with `README.md`, `README.mac.md`, and
  `README.windows.md`.

## Validation

Run the project test command after behavior or skill changes when feasible:

```bash
npm test
```

This currently checks the CLI help path and validates skills:

```bash
node ace --help
node ace validate-skills
```

If tests are skipped, state why and mention the residual risk.

## Codex Notes

- Codex global settings live outside the repository in `~/.codex/config.toml`.
  Do not assume those settings are committed or shared with collaborators.
- Project-shared Codex guidance belongs in this file.
- If a task asks to support both Codex and Claude Code, keep instructions and
  generated artifacts agent-neutral where possible.

## Claude Code Notes

- Claude Code may also use `CLAUDE.md` in some projects. In this repository,
  prefer keeping the canonical shared guidance in `AGENTS.md` unless the user
  explicitly asks to add a separate `CLAUDE.md`.
- If `CLAUDE.md` is added later, keep it short or have it point back to this
  file to avoid instruction drift.
