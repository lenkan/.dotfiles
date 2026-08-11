---
name: triage-prs
description: Triage PRs — show what to work on next across PRs in flight
allowed-tools: Bash(gh pr list *), Bash(gh pr view *)
---

# Triage PRs

Show me what to work on next across PRs in flight.

Read-only. Run each `gh` command bare — no pipes, `&&`, `;`, or shell loops. `gh`'s own `--jq` flag is fine: it's a flag on one command, not a pipe.

1. List both buckets, requesting every field the table needs so no per-PR fetch is required. Issue the two calls in one message as parallel tool uses:
   - Mine: `gh pr list --author @me --state open --json number,title,statusCheckRollup,reviewDecision,reviews,comments,mergeable,mergeStateStatus`
   - Awaiting my review: `gh pr list --search "review-requested:@me state:open" --json number,title,statusCheckRollup,reviewDecision,reviews,comments,mergeable,mergeStateStatus`
2. GitHub computes merge state lazily, so a list query can return `UNKNOWN` for `mergeable`/`mergeStateStatus`. Only for those PRs, re-fetch the one field set: `gh pr view <N> --json mergeable,mergeStateStatus`. Don't re-fetch PRs that already resolved.
3. Output one table: PR | title | bucket | CI | reviews | recommended action.
4. Recommended action is exactly one of: REVIEW NOW, ADDRESS COMMENTS, MERGE, REBASE, WAIT.
5. Wait for me to pick which PR to act on. Don't open files, switch worktrees, or run anything until I say.
