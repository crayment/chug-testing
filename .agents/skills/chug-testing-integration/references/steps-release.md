# Steps: Release

Trigger a changelog release, verify the output including the GitHub release, then run a second release with no pending changes.

Requires a merged PR with a change file on `main` — run `steps-pr-and-merge.md` first if needed.

## Step 1 — Confirm a pending change file exists on main

```bash
git -C /Users/crayment/dev/me/chug-testing checkout main
git -C /Users/crayment/dev/me/chug-testing pull
ls /Users/crayment/dev/me/chug-testing/changes/
```

There should be at least one `.yml` file. If there isn't, run `steps-pr-and-merge.md` first.

## Step 2 — Pick a version and trigger the release workflow

Use semver with a `v` prefix. Check the latest release and use the next minor version — e.g. if latest is `v0.3.0`, use `v0.4.0`:

```bash
gh release list --repo crayment/chug-testing --limit 5
```

Then trigger the release and grab the run ID:

```bash
gh workflow run release-changelog.yml \
  --repo crayment/chug-testing \
  --ref main \
  -f version=<next-version>

sleep 5 && gh run list --repo crayment/chug-testing --workflow release-changelog.yml --limit 1
```

Wait for it to complete using the run ID from above:

```bash
gh run watch <run-id> --repo crayment/chug-testing
```

Note: workflow runs will show Node.js 20 deprecation warnings — these are expected and can be ignored.

## Step 3 — Verify CHANGELOG.md

```bash
git -C /Users/crayment/dev/me/chug-testing pull
cat /Users/crayment/dev/me/chug-testing/CHANGELOG.md
ls /Users/crayment/dev/me/chug-testing/changes/ 2>/dev/null || echo "(changes/ directory is gone — all files were processed)"
```

Expected:
- A new `[version]` section at the top with the Simpsons quote change listed
- The `changes/` directory no longer contains the processed `.yml` file (the directory itself may disappear entirely — that's expected)
- A commit was pushed to `main` by `github-actions[bot]`

## Step 4 — Verify the GitHub release

```bash
gh release view <version> --repo crayment/chug-testing
```

Expected:
- A GitHub release exists for the version
- The release body contains the changelog content (categories, bullet points with PR links and author attribution)
- A `## What's Changed` section follows with PR links
- A `**Full Changelog**` link at the bottom

Record the release URL and paste the release body.

## Step 5 — Trigger a second release with no pending changes

Pick the next version (e.g. if first was `v0.1.0`, use `v0.2.0`):

```bash
gh workflow run release-changelog.yml \
  --repo crayment/chug-testing \
  --ref main \
  -f version=<next-version>

sleep 5 && gh run list --repo crayment/chug-testing --workflow release-changelog.yml --limit 1
gh run watch <run-id> --repo crayment/chug-testing
```

## Step 6 — Verify the no-changes release

```bash
git -C /Users/crayment/dev/me/chug-testing pull
cat /Users/crayment/dev/me/chug-testing/CHANGELOG.md
gh release view <version-2> --repo crayment/chug-testing
```

Expected:
- `CHANGELOG.md` has a new section containing `- No changes`
- A GitHub release exists for the version

## Evidence to capture

- First release: workflow run URL, commit SHA, CHANGELOG.md excerpt, GitHub release URL and body
- Second release: workflow run URL, commit SHA, CHANGELOG.md excerpt showing `- No changes`, GitHub release URL
