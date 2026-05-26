# Steps: PR and Merge

Test that `chug validate` enforces a change file on pull requests, then merge a valid PR.

## Setup

Work in the local consumer repo. Make sure `main` is up to date:

```bash
git -C /Users/crayment/dev/me/chug-testing checkout main
git -C /Users/crayment/dev/me/chug-testing pull
```

## Step 1 — Open a PR without a change file

Create a branch with a small change but no `changes/` file:

```bash
cd /Users/crayment/dev/me/chug-testing
git checkout -b test/validate-no-change-file
echo "" >> README.md
git add README.md
git commit -m "Test: trigger validate without a change file"
git push -u origin test/validate-no-change-file
gh pr create --title "Test: no change file (should fail validation)" --body "Intentionally missing a change file."
```

## Step 2 — Confirm validation fails

Wait for the `Validate Changelog Entry` workflow to run on the PR. Confirm it fails:

```bash
gh pr checks --watch
```

Expected: the `validate` check fails with the error annotation:
```
A changelog entry file in changes/ is required for this pull request.
```

Record the failing workflow run URL.

## Step 3 — Add a change file and confirm validation passes

```bash
chug new --description "Test change for integration scenario" --category chore
git add changes/
git commit -m "Add change file"
git push
```

Wait for the validate check to re-run:

```bash
gh pr checks --watch
```

Expected: the `validate` check passes.

Record the passing workflow run URL.

## Step 4 — Merge the PR

```bash
gh pr merge --squash --delete-branch
```

Record the merge commit SHA.

## Evidence to capture

- Branch name
- PR URL
- Failing workflow run URL and exact error text
- Passing workflow run URL
- Merge commit SHA
