---
name: Simplify
description: Review recently changed code for cleanup opportunities (reuse, simplicity, efficiency, abstraction level) and apply the fixes. Use after implementing a feature or fixing a bug, before opening a PR. Does not look for correctness bugs.
---

## Purpose

Port of Claude Code's bundled `/simplify` skill. Reviews the current diff (or a
specific target) for cleanup opportunities and applies the fixes directly. This
is a post-implementation cleanup pass, not a correctness review — use a
separate code-review pass for bugs.

## Scope

- Default target: the working diff, i.e. uncommitted changes plus commits made
  during this session that aren't on the base branch yet. Use `git status`,
  `git diff`, and `git log` to establish the diff range.
- If the user passes a target (a file path, directory, PR reference, or branch
  name), review only that target instead of the working diff.
- If the user adds a focus area (e.g. "focus on memory efficiency" or "focus on
  performance"), bias all four passes toward that concern but still run them
  all.

## Workflow

1. Determine the diff to review:
   - `git status --short` and `git diff` (plus `git diff --staged`) for
     uncommitted changes.
   - If there are session commits not yet merged/pushed, include them via
     `git diff <merge-base>...HEAD` or `git log` as appropriate.
   - If a target was given, scope the diff/review to it instead.
2. Read every changed file in full (not just the diff hunks) to get enough
   context to judge abstraction level and reuse opportunities.
3. Run four review passes over the changed code. These can be done
   sequentially in one pass of reasoning, or dispatched as parallel subagents
   for a large diff — pick whichever is faster for the size of the change:
   - **Reuse**: Does this duplicate logic that already exists elsewhere in the
     codebase (a helper, utility, pattern, or component)? Should it call or be
     extracted into a shared helper instead?
   - **Simplification**: Is there redundant logic, unnecessary indirection,
     overly clever code, or dead code that can be removed or flattened?
   - **Efficiency**: Are there redundant operations, unnecessary allocations,
     repeated computation, or obviously suboptimal algorithms introduced by
     this change?
   - **Abstraction level**: Is the change at the right level of abstraction —
     not over-engineered with unneeded flexibility, and not under-abstracted
     in a way that leaks implementation details or duplicates concerns?
4. Collect findings from all four passes. Discard anything that is actually a
   correctness bug (point the user to a code-review pass for those instead of
   silently dropping them) and anything that would change the diff's intended
   behavior.
5. Apply the fixes directly with the edit tool, matching existing code style
   and conventions. Prefer small, targeted edits over broad rewrites.
6. Re-read the edited sections to confirm the fixes are coherent and didn't
   introduce new duplication or break callers.
7. Summarize what was changed and why, grouped by the four categories above.
   Call out any findings you intentionally did not fix (e.g. because they'd
   require a larger refactor) so the user can decide.

## Notes

- This skill edits code. Don't ask for confirmation before each individual
  cleanup edit, but do summarize the full set of changes at the end.
- If the repo has a `CLAUDE.md`, `AGENTS.md`, or similar conventions doc, read
  it first and align suggestions with those standards.
- If nothing in the diff warrants a change, say so plainly instead of
  inventing busywork edits.
