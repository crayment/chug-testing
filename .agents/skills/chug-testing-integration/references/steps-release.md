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

Pick the next version. Check the latest tag to avoid collisions:

```bash
gh release list --repo crayment/chug-testing --limit 5
```

Then trigger the release:

```bash
gh workflow run release-changelog.yml \
  --repo crayment/chug-testing \
  --ref main \
  -f version=<next-version>
```

Wait for it to complete:

```bash
gh run watch --repo crayment/chug-testing
```

## Step 3 — Verify CHANGELOG.md

```bash
git -C /Users/crayment/dev/me/chug-testing pull
cat /Users/crayment/dev/me/chug-testing/CHANGELOG.md
```

Expected:
- A new `[version]` section at the top with the Simpsons quote change listed
- The `changes/` directory no longer contains the processed `.yml` file

## Step 4 — Verify the GitHub release

```bash
gh release view <version> --repo crayment/chug-testing
```

Expected:
- A GitHub release exists for the version
- The release body starts with `## Release Notes` followed by the changelog content
- A `## What's Changed` section follows with PR links
- A `## New Contributors` section if applicable

Record the release URL and paste the release body.

## Step 5 — Trigger a second release with no pending changes

```bash
gh workflow run release-changelog.yml \
  --repo crayment/chug-testing \
  --ref main \
  -f version=<next-version-2>
```

Wait for completion:

```bash
gh run watch --repo crayment/chug-testing
```

## Step 6 — Verify the no-changes release

```bash
git -C /Users/crayment/dev/me/chug-testing pull
cat /Users/crayment/dev/me/chug-testing/CHANGELOG.md
gh release view <version-2> --repo crayment/chug-testing
```

Expected:
- `CHANGELOG.md` has a new section containing `- No changes`
- The GitHub release exists with an empty `## Release Notes` section

## Evidence to capture

- First release: workflow run URL, commit SHA, CHANGELOG.md excerpt, GitHub release URL and body
- Second release: workflow run URL, commit SHA, CHANGELOG.md excerpt showing `- No changes`, GitHub release URL
