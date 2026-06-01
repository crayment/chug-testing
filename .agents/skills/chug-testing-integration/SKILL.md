---
name: chug-testing-integration
description: Run end-to-end integration tests for Chug against real GitHub repositories. Tests the full product workflow — PR validation, merging, and changelog releases — using crayment/chug-testing as the consumer repo and crayment/chug as the product.
tags:
  - chug
  - github
  - integration-tests
version: 3.0.0
author: Claude
---

# Chug Integration Testing

## Repositories

- **Product**: `crayment/chug` — the Chug CLI and GitHub Action
- **Consumer**: `crayment/chug-testing` — a real consumer repo; test PRs add quotes to `simpsons-quotes.md`

## Prerequisites

```bash
gh auth status          # must be authenticated as crayment
chug --version          # if missing: uv tool install chug-cli
```

Resolve the local clone of `crayment/chug-testing` before starting. Check likely locations (e.g. `~/dev`, parent of your current directory) by verifying the git remote:

```bash
git -C <candidate-path> remote get-url origin
# should match: git@github.com:crayment/chug-testing.git
```

Set `CONSUMER_DIR` to the confirmed path and use it throughout the step files.

## Expected noise

Every workflow run shows Node.js 20 deprecation warnings — expected, ignore them.

## Steps

1. **[steps-pr-and-merge.md](./references/steps-pr-and-merge.md)** — Add a Simpsons quote, verify validation fails, add change file, verify it passes, merge
2. **[steps-release.md](./references/steps-release.md)** — Trigger a release, verify CHANGELOG.md and GitHub release, run a no-changes release

## Rules

- Work in `crayment/chug-testing`, not in `crayment/chug`
- Create short-lived branches for test PRs; delete them when done
- Capture evidence as you go: branch names, PR URLs, workflow run URLs, commit SHAs
- If a workflow fails unexpectedly, determine whether the failure is in Chug, the test setup, or a GitHub policy constraint — and report which
