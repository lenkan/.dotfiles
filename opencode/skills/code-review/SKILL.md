---
name: Code Review
description: Find correctness bugs in a diff. Covers logic errors, broken edge cases, callers and contracts the change breaks, regressions of earlier fixes, and tests that don't really test the change. Reports findings ranked by severity and edits only with --fix. Use when asked to review changes, before committing, or before opening or merging a PR. For cleanup, complexity and style, use simplify instead.
---

# Code Review

Find correctness bugs in a change and report them. One read-only `reviewer` subagent does the review, so it comes to the code fresh. You set the scope, check its findings and report. Cleanup and style belong to `simplify`.

Arguments: an optional `--fix`, then an optional target (path, commit range, branch or PR number) and/or a focus.

## 1. Scope

Build a diff command the reviewer can run as written. Resolve refs to SHAs, because it can't use `$(...)`, pipes or `gh`.

- Default: `git diff <merge-base>`, plus untracked files that belong to the change. The merge-base is with the branch this will merge into: usually `origin/main`, or the upstream when you're on the default branch.
- Path target: the same, with `-- <path>`. Range: that range. Branch: `git diff <merge-base> <branch>`.
- PR target: `gh pr view <n> --json headRefOid,baseRefName,title,body`, then `git fetch origin <baseRefName> pull/<n>/head`, then `git diff <merge-base> <headRefOid>`.
- If the code isn't the working tree (a branch, range or PR that isn't checked out), its SHA is the revision the reviewer reads files from.
- If there's nothing to review, say so and stop.

Write the intent in one to three sentences of your own, from this conversation, the PR or the commit messages. Don't paste PR text into the prompt.

## 2. Review

To keep it cheap, the reviewer runs on Sonnet at medium thinking from the current provider:

1. Call the models tool (Code Mode: `tools.opencode.models`). The first provider in `models({ limit: 1 })` is the current one.
2. Take the first model from `models({ query: "sonnet", provider })` and pass `<id>#medium` as `model`.
3. If there's no Sonnet, leave `model` out.

Launch one `reviewer` and give it:
- the diff command
- the untracked files
- the revision to read files from, if any
- the intent
- the user's focus

## 3. Check and report

Open the code each finding cites. Drop findings that don't hold up, that are style, or that are pre-existing problems the diff doesn't touch. If the working tree is under review, run the project's fast checks; a failure in touched code is a finding.

Report at most ten findings, most severe first, in the reviewer's format. If none survive, say "No correctness issues found." End with one line on what was checked and what wasn't.

Without `--fix`, don't edit anything. With `--fix`, the working tree must be the code under review. Fix the findings with minimal edits, re-read the callers, run the checks again, and say what you fixed.
