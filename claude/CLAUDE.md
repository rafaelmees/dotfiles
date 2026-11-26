# Personal instructions (all projects)

## Code style

- Comments: default to **none**. Prefer clear names and small functions over
  explanation. Add a comment only when the *why* is genuinely non-obvious and
  can't be conveyed by the code itself (e.g. a workaround, a non-intuitive
  constraint, a subtle ordering requirement). When you do, keep it to one short
  line explaining *why*, never *what*. Never restate what the code already says,
  and never annotate self-explanatory code (a well-named field, type, or
  variable needs no comment).
- Naming: code, identifiers, apps, modules and env vars in plain, common
  English. Avoid ambiguous names and words that read as another language even
  if they are technically English. Flag a bad name instead of reusing it.
- One formatter and one style per codebase (or across sibling repositories).
  Format only the source files the linter covers; never point a formatter at
  templates or generated files.

## Communication

- Português para a conversa; código, identificadores e mensagens de commit em inglês.
- Be concise. Skip preamble and filler; lead with the answer.

## Working agreements

- **Git**: never create branches, pull or push. Commit only when asked in the
  current turn, or inside an agreed batch whose workflow says to commit each
  task. Otherwise leave changes uncommitted and list the changed files.
- **Agree before building**: scope and decisions are settled with me first.
  If a decision comes up mid-work, note it, continue with independent work and
  bring all questions together at the end instead of stopping for each one.
- **Done means verified**: run the project's full verification (lint, types,
  tests) and, when possible, check the change in the running app before calling
  it done. Report faithfully what was verified and what was not.
- **Review your own diff** before finishing: look for bugs, dead code and
  duplication, and fix what you find.
- **Environment pitfalls** (commands that break a running dev server,
  migrations that must also be applied locally, services that send real
  e-mails or messages) belong in the project's CLAUDE.md/AGENTS.md. Read them
  before acting and add new ones when discovered.
- **Test data**: never create test records that reach real people (real
  e-mails, phones). Clean up whatever was created to test manually.
- If a project has a `ROADMAP.md`, its workflow section is the process to follow.

## Quality gates

Agents write most of the code and line-by-line review does not scale, so code
quality is enforced by tools, not by intention. When a project has these gates,
every change must pass them; when starting a project, propose setting them up.

| Gate | Rule |
|---|---|
| Static analysis | Cyclomatic complexity ≤ 10, cognitive complexity ≤ 15, ≤ 4 parameters, nesting depth ≤ 3, functions ≤ 50 lines, files ≤ 400 lines |
| Changed-code coverage | 100% of changed lines **and** branches covered by unit tests (diff vs. coverage report); integration/e2e tests don't count |
| Mutation testing | ≥ 80% mutation score per changed file |
| Architecture | Layer and module-boundary rules, no dependency cycles |
| Dead code | Zero unused files, exports or dependencies; delete instead of ignoring |
| Duplication | No clone may touch a changed line; total duplication stays under a ceiling |
| Types and tests | Type check and the whole test suite pass |

**Legacy is frozen, new code is clean.** Existing violations live in baselines
(lint suppressions, known architecture violations, duplication ceiling, coverage
thresholds). New code must meet every gate; touching legacy code means bringing
the touched lines up to the gates.

**Baselines only shrink.** After fixing legacy violations, prune the baseline
with the project's command. Never:
- add inline escapes (`eslint-disable`, `noqa`, `# type: ignore`, coverage or
  mutation ignore comments, and their equivalents);
- edit baselines by hand, add coverage/dead-code exclusions, or loosen any
  limit or threshold.

A gate failure is fixed by refactoring or by better tests: split functions,
extract shared code, strengthen assertions until mutants die. Config files may
declare real entry points or framework conventions, never hide problems.

**Where gates run**: the same checks in three places.
1. The agent's Stop hook, on changed files only, failing with an actionable
   message (what to do and what is forbidden).
2. A versioned git pre-commit hook (e.g. `.githooks/`, enabled by the project
   setup via `core.hooksPath`), on staged changes.
3. One `verify` command that runs everything, including the slow gates
   (mutation, e2e). Run it before every commit.

CI runs the same `verify` when the project has CI. Mass-reformat commits go to
`.git-blame-ignore-revs`.

## Engineering principles

- **Capabilities in code, combinations in data**: what the system can do
  (permissions, feature flags, statuses) is declared in code by the module that
  owns it; how it is combined (roles, plans, per-customer settings) is data.
- **Nothing that does nothing**: don't create a permission, option or setting
  that protects or changes nothing. Add it when it has a real effect.
- **Disabled means gone**: a feature turned off disappears from navigation,
  screens and permissions, and its API answers with an explicit error.
- **Named errors**: domain errors carry a stable code (`ModuleDisabled`,
  `LastAdminProtected`) besides the HTTP status, so clients and tests rely on
  the code, not the message.
- **Derive, then record**: values that depend on other state are computed, not
  stored; the actual value is recorded when the event happens, for history.
- **Specs before code**: non-trivial work starts from a written spec with the
  decisions made; principles first, then details.
- **UI** (when the project has one): use the design system's components, tokens
  and props instead of custom CSS; design mocks guide structure, not code.
  Spacing on an 8-point grid. Fewer screens, menu items, buttons and filters;
  prefer direct actions over selects and dropdowns; a summary card only when it
  informs something and leads to an action; a screen may exist without a menu
  item when it is reached from context.

@RTK.md
