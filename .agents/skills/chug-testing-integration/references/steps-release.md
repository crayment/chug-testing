# Steps: Release

Trigger a changelog release, verify the output, then run a second release with no pending changes.

Requires a merged PR with a change file on `main` — run `steps-pr-and-merge.md` first if needed.

## Step 1 — Confirm a pending change file exists on main

```bash
git -C /Users/crayment/dev/me/chug-testing checkout main
git -C /Users/crayment/dev/me/chug-testing pull
ls /Users/crayment/dev/me/chug-testing/changes/
```

There should be at least one `.yml` file. If there isn't, run `steps-pr-and-merge.md` first.

## Step 2 — Trigger the release workflow

Pick a version string for this test release, e.g. `0.1.0-test`:

```bash
gh workflow run release-changelog.yml \
  --repo crayment/chug-testing \
  --ref main \
  -f version=0.1.0-test
```

Wait for it to complete:

```bash
gh run watch --repo crayment/chug-testing
```

## Step 3 — Verify the release output

Expected:
- The workflow succeeds
- `CHANGELOG.md` on `main` has a new `[0.1.0-test]` section with the pending changes listed
- The `changes/` directory no longer contains the processed `.yml` file
- A commit was pushed to `main` by `github-actions[bot]`

Check the result:

```bash
git -C /Users/crayment/dev/me/chug-testing pull
cat /Users/crayment/dev/me/chug-testing/CHANGELOG.md
ls /Users/crayment/dev/me/chug-testing/changes/
```

Record the workflow run URL and the commit SHA of the release commit.

## Step 4 — Trigger a second release with no pending changes

```bash
gh workflow run release-changelog.yml \
  --repo crayment/chug-testing \
  --ref main \
  -f version=0.1.1-test
```

Wait for completion:

```bash
gh run watch --repo crayment/chug-testing
```

## Step 5 — Verify the no-changes release

Expected:
- The workflow succeeds
- `CHANGELOG.md` has a new `[0.1.1-test]` section containing `- No changes`
- A commit was pushed to `main`

```bash
git -C /Users/crayment/dev/me/chug-testing pull
cat /Users/crayment/dev/me/chug-testing/CHANGELOG.md
```

Record the workflow run URL and commit SHA.

## Evidence to capture

- First release: workflow run URL, commit SHA, CHANGELOG.md excerpt showing the new section
- Second release: workflow run URL, commit SHA, CHANGELOG.md excerpt showing the "No changes" section
