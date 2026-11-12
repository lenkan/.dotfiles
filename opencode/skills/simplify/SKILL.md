---
name: Simplify
description: Clean up a diff before it ships. Reverts unnecessary changes, removes needless complexity, reuses existing helpers and test utilities, and matches the conventions of neighbouring files (naming, structure, how tests and mocks are written). Applies the fixes. Use after implementing a change, before committing or opening a PR. Does not look for correctness bugs; use code-review for that.
---

# Simplify

Clean up a finished change: remove what it doesn't need and make it fit the codebase. Do this yourself in this session, without subagents. It's not a bug hunt. Mention any correctness problems you notice, but don't fix them.

Arguments: an optional target (path, commit range, branch or PR number) and/or a focus, such as "tests only".

## Scope

- Default: the diff against the merge-base with the branch this will merge into (usually `origin/main`; on the default branch, its upstream), plus untracked files that belong to the change. Leave unrelated untracked files alone.
- Path target: the same, limited to that path. Range: that range.
- Branch or PR target: this skill edits, so it has to be checked out. Ask before switching (`gh pr checkout <n>`).
- If there's nothing to review, say so and stop.

Know what the change is for. Get that from this conversation, the PR or the commit messages, and ask if it's unclear. Read each changed file in full, plus any `AGENTS.md`, `CLAUDE.md` or `CONTRIBUTING.md` at the root and near the changes.

## Look for

1. **Unneeded changes.** Every hunk should serve the intent. Look for:
   - drive-by refactors, renames, reformatting or import churn
   - debug output, commented-out code, unused imports, variables or parameters
   - speculative options or abstractions, and checks for states that can't happen
   - comments that narrate the code or describe the change
   - dependency or config changes the intent doesn't need
2. **Needless complexity.** Look for:
   - logic that can be stated more directly
   - wrappers, single-use helpers or types that add nothing
   - near-duplicate blocks
   - a fix made in the wrong layer
   - repeated work

   Prefer the change that deletes code.
3. **Reuse.** Search the codebase for things the change re-implements:
   - helpers, utilities, constants and types
   - test support: fixtures, factories, mock helpers, shared setup
   - the standard library and existing dependencies
4. **Conventions.** Open two or three neighbouring files that do the same job: sibling modules for source, sibling tests for tests. Match what they do:
   - naming, file location and layout, error handling
   - in tests: how mocks are set up and reset, fixtures, test names and assertion style

   Follow a pattern only when the neighbours agree. One neighbour is enough if it's the only one of its kind. Convention docs override neighbours.

Only judge what the diff adds or touches. Skip anything a formatter or linter enforces, and taste that has no precedent in the codebase.

## Fix

- Apply cleanups that keep behaviour the same directly. Use the smallest edit and match the surrounding style. To revert an unneeded hunk, restore the base version of those lines.
- Before anything that changes behaviour or might be deliberate, ask once (a multi-select question). That covers an unrelated fix, a speculative feature, or deleting an untracked file.
- Leave refactors that go beyond the diff alone, and mention them.
- Re-read what you changed, including every use of anything you renamed.
- Run the project's fast checks for the touched files: typecheck, lint and tests. Find them in `package.json`, a Makefile, `scripts/`, CI config or `AGENTS.md`.

## Report

Keep it short:
- what you changed and why, by check, with `path:line`
- what you asked about and the answer
- the checks you ran
- any correctness concerns, for `code-review`

If nothing needed changing, say so in one line.
