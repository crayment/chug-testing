---
name: chug-testing-integration
description: Run end-to-end integration tests for Chug against real GitHub repositories. Tests the full product workflow — PR validation, merging, and changelog releases — using crayment/chug-testing as the consumer repo and crayment/chug as the product.
tags:
  - chug
  - github
  - integration-tests
version: 2.0.0
author: Claude
---

# Chug Integration Testing

This skill validates Chug as a product through real GitHub repositories — not unit tests. It exercises the full consumer workflow that any team using Chug would follow.

## What gets tested

- A PR without a change file fails the `chug validate` CI check
- Adding a change file makes that PR pass
- Merging the PR and triggering a release updates `CHANGELOG.md`, deletes the change file, and creates a GitHub release with the changelog content in the release notes
- A second release with no pending changes writes a "No changes" section and a corresponding GitHub release

## The product

`crayment/chug-testing` maintains a `simpsons-quotes.md` file — a growing collection of Simpsons quotes. Each test PR adds a new quote. This gives every test run real, meaningful content to track through validation, changelog, and GitHub release.

## Repositories

- **Product**: `crayment/chug` — the Chug CLI and GitHub Action
- **Consumer**: `crayment/chug-testing` — a real repo that uses Chug like any third-party would

Both repos must be accessible via `gh`. Confirm with `gh auth status` before starting.

Local clone paths:
- Product: `/Users/crayment/dev/me/chug`
- Consumer: `/Users/crayment/dev/me/chug-testing`

## How to run

Load this skill when asked to run Chug integration tests. Then read the step files in order:

1. **[steps-pr-and-merge.md](./references/steps-pr-and-merge.md)** — Add a Simpsons quote to `simpsons-quotes.md`, verify validation fails without a change file, add the change file, verify it passes, merge
2. **[steps-release.md](./references/steps-release.md)** — Trigger a changelog release, verify CHANGELOG.md and the GitHub release body, then run a second release with no pending changes

Run them in order — the merge from step 1 sets up the pending change file that step 2 releases.

## Prerequisites

Before starting, confirm:

```bash
gh auth status          # must be authenticated as crayment
chug --version          # must be installed; if missing: uv tool install chug-cli
```

## Expected noise

Every workflow run will show Node.js 20 deprecation warnings from `actions/checkout`, `actions/setup-python`, and `astral-sh/setup-uv`. These are expected and do not indicate a test failure — ignore them.

## Rules

- Work in `crayment/chug-testing`, not in `crayment/chug`
- Create short-lived branches for test PRs; delete them after the scenario completes
- Do not force-push or rewrite history on either repo
- Capture evidence as you go: branch names, PR URLs, workflow run URLs, commit SHAs
- If a workflow fails unexpectedly, check whether the failure is in Chug itself, the test setup, or a GitHub policy constraint — and report which
