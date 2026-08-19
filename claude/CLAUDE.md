## Worktree discipline
### Worktree-or-main checkpoint
- Right after a plan is approved (post-`ExitPlanMode`) and before the first edit, ask via `AskUserQuestion` whether to implement on main or in a worktree — never decide this silently.
- Compute a recommended default from the plan's content and mark it "(Recommended)":
  - Needs live verification (dev server, manual browser/CLI testing, iterating against running state) → recommend **main, auto**.
  - Self-contained, verifiable by tests/build/lint alone, especially one of several independent tasks headed for its own PR → recommend **worktree, auto**.
- Offer these four options:
  1. Main, auto-accept edits
  2. Main, manually approve edits
  3. Worktree, auto-accept edits — implement, verify, push, open PR without further confirmation for this task
  4. Worktree, manually approve edits — implement in a worktree, but confirm before push/PR
- Choosing "auto" + "worktree" overrides the general confirm-before-push default for that task.
- For several independent small tasks handed over together, ask the checkpoint once (it applies to all of them), then fan out with parallel `Agent` calls using `isolation: "worktree"` — one worktree/branch/PR per task.
- Skip the checkpoint for trivial single-file/one-line fixes, even if they went through plan mode.

### Once inside a worktree
- Before edits in a worktree, run `pwd` and `git branch --show-current` as one parallel batch to confirm location and branch.
- Verify a worktree is based on the intended base (usually `main`), not a stale feature branch.
- Re-read files from the current worktree before editing — never trust content from a previous worktree.

## Git
- Push with explicit branch: `git push -u origin <branch>`.
- Never invoke `git -C <dir>` — run plain `git <subcommand>` and rely on the working directory. `-C` breaks allow/deny permission patterns.
- Before `git commit`, show `git status` and `git diff --staged --stat` as one parallel batch; confirm the staged set is complete.
- Don't add "Generated with Claude Code" footers or "Co-Authored-By: Claude" trailers to commits or PRs.

## Tool choice
- Edit files with the Edit/Write tools, never by shelling out to `python3`/`sed`/`awk` heredocs that rewrite them. Batching a procedure into one shell call saves a round-trip but costs an approval prompt.
- To revert a temporary edit, use `git checkout -- <file>`. Don't `cp` backups to /tmp; git is already the backup.

## Code comments
- Default to NO comment. Most functions, fields, types, and tables need none — the name and type already carry the intent.
- Add a comment only for a genuine quirk or non-obvious decision: a footgun, a service-enforced invariant no type expresses, an ordering dependency, a surprising FK/null asymmetry. One line beats three.
- Never restate the adjacent name/type, never editorialize design intent the PR/issue already records, never write multi-line preambles on routine code.

## TypeScript
- Node 22.6+ runs `.ts` natively (default in 23.6+, used on Node 24). Run scripts as `node ./script.ts`; don't suggest `tsx`, `ts-node`, or `swc-node`.

## Writing
- Default issue template: **Context** (2–3 sentences), **Proposal** (bullets), **Out of scope** (bullets).
- No speculative future scope in PR descriptions, issues, or design notes ("tomorrow possibly X may also use this"). Scope trade-offs to what runs today; verify infra/domain claims before including them.
- Plain language for PR comments and chat: lead with the point in one short sentence, split dense clauses. Avoid academic vocabulary (tautological, orthogonal, idempotent unless about retry semantics, axiomatic, vacuous).

## Documentation
- READMEs and docs cover what the thing does, how to set it up, and how to use it. Nothing else.
- Cut history, background stories, design philosophy, and rationale for decisions already made. If a reader needs the "why", it belongs in the PR or an ADR, not the README.
- No preamble sections ("Overview", "Motivation", "Background") unless the doc is unusable without them.

## PR test plans
- The `## Test plan` section is a log of what was verified before opening the PR, not a checklist for the reviewer. List checks actually run (tests, scripts, Playwright MCP, manual steps); put anything that couldn't be verified under an **Unverified** subsection with the reason. Omit the section if both are empty — don't speculate.

## PR review responses
- Triage every comment first: IMPLEMENT / DEFER (file in issue tracker) / PUSH BACK, with feasibility check and rationale.
- Wait for approval before code changes. Don't auto-apply reviewer suggestions without verifying they work.
