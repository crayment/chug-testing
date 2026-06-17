---
name: chug-testing-integration
description: Run end-to-end integration tests for Chug against real GitHub repositories. Tests the full product workflow — PR validation, merging, changelog releases, and the Elixir mix task — using crayment/chug-testing as the consumer repo and crayment/chug as the product.
tags:
  - chug
  - github
  - integration-tests
version: 4.0.0
author: Claude
---

# Chug Integration Testing

Load this skill when asked to run "chug-testing tests" or any variation. Unless a specific step is requested, run all three steps and report findings.

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

Run all three unless told otherwise. Steps 1 and 2 must run in order. Step 3 is independent.

1. **[steps-pr-and-merge.md](./references/steps-pr-and-merge.md)** — Add a Simpsons quote, verify validation fails without a change file, add the change file, verify it passes, merge
2. **[steps-release.md](./references/steps-release.md)** — Trigger a release, verify CHANGELOG.md and GitHub release, run a no-changes release
3. **[steps-elixir.md](./references/steps-elixir.md)** — Run `mix chug.new` using chug source from `crayment/chug` main and verify it creates a valid change file

## Reporting

After completing all steps, report:
- Pass/fail for each step with evidence (PR URLs, workflow run URLs, release URLs, commit SHAs)
- Any unexpected failures with your diagnosis: is the issue in Chug, the test setup, or GitHub policy?
- Overall verdict: ready to release or not

## Rules

- Work in `crayment/chug-testing`, not in `crayment/chug`
- Create short-lived branches for test PRs; delete them when done
- Capture evidence as you go
- If a step fails unexpectedly, stop and report rather than pushing through
