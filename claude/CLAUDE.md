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

## TypeScript
- Node 22.6+ runs `.ts` natively (default in 23.6+, used on Node 24). Run scripts as `node ./script.ts`; don't suggest `tsx`, `ts-node`, or `swc-node`.

## Writing
- Length is set by what the reader needs in order to act, not by the work behind it. Default short; a wide diff, or a decision the reader actually has to weigh, earns more room.
- Cut the investigation path, rejected alternatives, and follow-up backlog unless the reader's decision turns on them. In code, comment the footgun, never the name or the type.
- No standard PR/issue template — write the sections that carry something. A test plan lists checks actually run, not the transcript, and says plainly what went unverified.
- Verify infra/domain claims before including them. Plain language: lead with the point, split dense clauses.
- READMEs: what it does, setup, usage. The "why" belongs in the PR or an ADR.

## PR review responses
- Triage every comment first: IMPLEMENT / DEFER (file in issue tracker) / PUSH BACK, with feasibility check and rationale.
- Wait for approval before code changes. Don't auto-apply reviewer suggestions without verifying they work.
