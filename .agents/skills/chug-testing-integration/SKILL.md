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
- Merging the PR and triggering a release updates `CHANGELOG.md` and deletes the change file
- A second release with no pending changes writes a "No changes" section
- `mix chug.new` (Elixir task) creates a valid change file using the chug source from `crayment/chug` main

## Repositories

- **Product**: `crayment/chug` — the Chug CLI and GitHub Action
- **Consumer**: `crayment/chug-testing` — a real repo that uses Chug like any third-party would

Both repos must be accessible via `gh`. Confirm with `gh auth status` before starting.

Local clone paths:
- Product: `/Users/crayment/dev/me/chug`
- Consumer: `/Users/crayment/dev/me/chug-testing`

## How to run

Load this skill when asked to run Chug integration tests. Then read the step files in order:

1. **[steps-pr-and-merge.md](./references/steps-pr-and-merge.md)** — Create a PR, verify validation fails, add a change file, verify it passes, merge
2. **[steps-release.md](./references/steps-release.md)** — Trigger a changelog release, verify the output, then run a second release with no pending changes
3. **[steps-elixir.md](./references/steps-elixir.md)** — Trigger the Elixir task test, verify `mix chug.new` creates a valid change file using chug source from `crayment/chug` main

Run steps 1 and 2 in order — the merge from step 1 sets up the pending change file that step 2 releases. Step 3 is independent and can be run on its own when testing Elixir task changes.

## Rules

- Work in `crayment/chug-testing`, not in `crayment/chug`
- Create short-lived branches for test PRs; delete them after the scenario completes
- Do not force-push or rewrite history on either repo
- Capture evidence as you go: branch names, PR URLs, workflow run URLs, commit SHAs
- If a workflow fails unexpectedly, check whether the failure is in Chug itself, the test setup, or a GitHub policy constraint — and report which
