---
name: address-review
description: Address PR review comments — triage findings, implement accepted ones, verify, commit
---

# Address PR Review

For the current PR:
1. Source the findings:
   - If a review already produced findings in this conversation (e.g. `/code-review`), use that list. Skip the fetch.
   - Otherwise, `gh pr view --comments` and use the posted review comments.
2. Triage each finding and get confirmation, per the PR review response rules in CLAUDE.md.
3. Implement accepted items, then run lint, typecheck, and tests as parallel Bash calls in one message.
4. Commit with a message referencing the review.
