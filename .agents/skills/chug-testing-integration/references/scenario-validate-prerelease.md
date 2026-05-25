# Scenario: Validate (pre-release)

Validate that `chug validate` works via the setup action's `source: repo` mode, before a new PyPI release is cut.

## Goal

Prove that `chug validate` enforces a change file in PRs using the action repo source rather than PyPI. Use this scenario when `chug validate` is not yet available in the published PyPI package.

## Steps

1. Resolve `PRODUCT_REPO_DIR` and `CONSUMER_REPO_DIR` using `repository-discovery.md`
2. Work in `CONSUMER_REPO_DIR`
3. Ensure the repo has the `validate-changelog-prerelease.yml` workflow on the branch you're testing
4. Create a test branch off the branch that has the prerelease workflow (e.g. `setup-action`), targeting that branch as the PR base:

```bash
git checkout setup-action
git checkout -b test/validate-prerelease-missing-change-file
# make a small change with no changes/ file
echo "test" >> README.md
git add README.md
git commit -m "Test: trigger validate without a change file"
git push -u origin test/validate-prerelease-missing-change-file
gh pr create --base setup-action --title "Test: validate prerelease (should fail)" --body "No change file — expecting validation failure"
```

5. Manually trigger `validate-changelog-prerelease.yml` against the test branch:

```bash
gh workflow run validate-changelog-prerelease.yml --ref test/validate-prerelease-missing-change-file
```

6. Wait for the run and confirm it fails with the expected error annotation
7. Add a `changes/*.yml` file to the branch, push, and re-trigger the workflow:

```bash
chug new --description "Test change for prerelease validate scenario" --category chore
git add changes/
git commit -m "Add change file"
git push
gh workflow run validate-changelog-prerelease.yml --ref test/validate-prerelease-missing-change-file
```

8. Confirm the second run passes

## Expected Result

- first run fails: `::error::A changelog entry file in changes/ is required for this pull request.`
- second run passes with exit 0

## Record

- `PRODUCT_REPO_DIR`
- `CONSUMER_REPO_DIR`
- failing workflow run URL
- passing workflow run URL
- exact error text from the failing run

## Cleanup

Close or merge the test PR and delete the branch when done.
