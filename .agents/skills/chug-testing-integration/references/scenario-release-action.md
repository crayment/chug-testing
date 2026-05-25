# Scenario: Release

Validate that the `crayment/chug` setup action installs the CLI and that `chug release` works from a consumer repo.

## Goal

Prove that the public setup action can:

- install the `chug` CLI
- run `chug release --version`
- commit and push the resulting changelog changes via shell steps

## Steps

1. Resolve `PRODUCT_REPO_DIR` and `CONSUMER_REPO_DIR` using `repository-discovery.md`
2. Work in `CONSUMER_REPO_DIR`
3. Ensure the repo has a workflow that uses:

```yaml
name: Update Changelog

on:
  workflow_dispatch:
    inputs:
      version:
        description: Version string for the changelog release section.
        required: true

permissions:
  contents: write
  pull-requests: read

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - uses: crayment/chug@main
      - name: Run chug release
        shell: bash
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: chug release --version "${{ inputs.version }}"
      - name: Commit and push changelog
        shell: bash
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
          git add CHANGELOG.md
          git add -A changes/ || true
          if git diff --cached --quiet; then
            echo "No changelog changes to commit."
            exit 0
          fi
          git commit -m "Update changelog for ${{ inputs.version }}"
          git push
```

4. Ensure there is at least one pending `changes/*.yml` file on `main`
5. Trigger the workflow with `gh workflow run`
6. Wait for completion with `gh run watch`
7. Inspect logs and resulting commit state
8. Repeat with no pending changes to validate the no-change path

## Expected Result

- the workflow succeeds
- `chug release` writes or updates `CHANGELOG.md`
- the commit and push step creates a commit when changelog changes exist
- the no-change run completes cleanly and creates a commit — `chug release` always writes a version section to CHANGELOG.md (even when there are no pending change files), so CHANGELOG.md will be modified and the commit step will commit and push

## Record

- `PRODUCT_REPO_DIR`
- `CONSUMER_REPO_DIR`
- workflow run URL
- commit SHA if one was created
- any permissions or branch policy constraints encountered
