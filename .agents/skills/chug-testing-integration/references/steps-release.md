# Steps: Release

Requires a merged PR with a change file on `main` — run `steps-pr-and-merge.md` first if needed.

## Step 1 — Trigger a release

Check the latest release and use the next minor version (e.g. latest `v0.3.0` → use `v0.4.0`):

```bash
gh release list --repo crayment/chug-testing --limit 5

gh workflow run release-changelog.yml \
  --repo crayment/chug-testing \
  --ref main \
  -f version=<next-version>

sleep 5 && gh run list --repo crayment/chug-testing --workflow release-changelog.yml --limit 1
gh run watch <run-id> --repo crayment/chug-testing
```

## Step 2 — Verify CHANGELOG.md and GitHub release

```bash
git -C /Users/crayment/dev/me/chug-testing pull
cat /Users/crayment/dev/me/chug-testing/CHANGELOG.md
ls /Users/crayment/dev/me/chug-testing/changes/ 2>/dev/null || echo "(changes/ gone — all files processed)"
gh release view <version> --repo crayment/chug-testing
```

Expected:
- New `[version]` section at top of CHANGELOG.md with the Simpsons quote change listed
- `changes/` directory is empty or gone
- GitHub release body contains the changelog content, followed by `## What's Changed` and `**Full Changelog**`

Record the workflow run URL and paste the GitHub release body.

## Step 3 — Run a second release with no pending changes

```bash
gh workflow run release-changelog.yml \
  --repo crayment/chug-testing \
  --ref main \
  -f version=<next-version>

sleep 5 && gh run list --repo crayment/chug-testing --workflow release-changelog.yml --limit 1
gh run watch <run-id> --repo crayment/chug-testing

git -C /Users/crayment/dev/me/chug-testing pull
cat /Users/crayment/dev/me/chug-testing/CHANGELOG.md
gh release view <version> --repo crayment/chug-testing
```

Expected:
- New CHANGELOG.md section containing `- No changes`
- GitHub release exists for the version

## Evidence to capture

- First release: workflow run URL, CHANGELOG.md excerpt, GitHub release URL and body
- Second release: workflow run URL, CHANGELOG.md excerpt showing `- No changes`, GitHub release URL
