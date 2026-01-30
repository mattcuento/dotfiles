---
name: creating-pull-requests
description: Use when ready to create PR after implementation complete, tests passing, and need comprehensive documentation with Why/What/How/Tests/Changelog structure
---

# Creating Pull Requests

## Overview

Create comprehensive, well-documented PRs using `gh pr create` with Why/What/How structure, test summary, and changelog.

## Quick Reference - PR Template

```markdown
## Why (Context & Motivation)
[1-3 sentences: problem solved, business/technical motivation, related issues]

## What (Changes Made)
- New feature: [description]
- Modified: [file/component] - [change]
- Fixed: [issue] - [how]

## How (Implementation)
[2-4 sentences: approach, key decisions, trade-offs, SOLID principles applied]

## Test Summary
**Coverage:** Unit: [X] new/modified | Integration: [Y] | Edge cases: [list]
**Results:** ✓ All tests passing ([X] tests) | ✓ Linting passed
**Tested:** [scenario]: [test name]

## Changelog
**Added:** [features] | **Changed:** [modifications] | **Fixed:** [bugs] | **Removed:** [deprecated]

## Checklist
- [ ] Tests pass | Linting passes | No debug statements | Follows patterns

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

## Implementation Workflow

**1. Gather Context (parallel)**
```bash
git status
git diff
git diff --staged
git log $(git merge-base HEAD main)..HEAD
git diff $(git merge-base HEAD main)...HEAD
```

**2. Run Verification**
- Lint: Use language-specific linter (clippy, eslint, ruff, checkstyle, golangci-lint)
- Tests: Run full test suite
- Fix failures before proceeding

**3. Create PR**
```bash
gh pr create --title "[<70 chars]" --body "$(cat <<'EOF'
[Paste template above with details filled]
EOF
)"
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Creating PR with failing tests | Run tests first, fix failures |
| Vague "What" section | Be specific: file names, component names |
| Missing edge cases in test summary | List actual edge cases tested |
| No trade-offs in "How" | Acknowledge decisions made and alternatives |
| Pushing without confirmation | Ask user before `git push` if not already pushed |

## When NOT to Use

- Draft PRs (use `gh pr create --draft`)
- WIP branches (fix issues first)
- No tests written (write tests first per TDD)
