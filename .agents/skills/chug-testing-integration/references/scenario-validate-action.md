# Scenario: Validate

Validate that the `crayment/chug` setup action installs the CLI and that `chug validate` enforces a change file in pull requests.

## Goal

Prove that a consumer repository can reference the public setup action and get correct PR validation behavior.

## Precondition

`chug validate` must exist in the published PyPI version of `chug-cli`. Confirm with:

```bash
pip index versions chug-cli
chug validate --help
```

If `validate` is not available in the latest PyPI release, run `scenario-validate-prerelease.md` instead, which installs from the action repo source.

## Steps

1. Resolve `PRODUCT_REPO_DIR` and `CONSUMER_REPO_DIR` using `repository-discovery.md`
2. Work in `CONSUMER_REPO_DIR`
3. Ensure the repo has a workflow that uses:

```yaml
name: Validate Changelog Entry

on:
  pull_request:

permissions:
  contents: read
  pull-requests: read

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - uses: crayment/chug@main
      - run: chug validate
        shell: bash
```

4. Create a branch with a normal code or README change but no `changes/` file
5. Push the branch and open a PR
6. Wait for the workflow run to complete
7. Confirm the workflow fails with the expected validation error
8. Update the same branch by adding a valid `changes/*.yml` file
9. Push again and confirm the workflow passes

## Expected Result

- first PR run fails without a change file
- second PR run passes after adding a change file

## Record

- `PRODUCT_REPO_DIR`
- `CONSUMER_REPO_DIR`
- PR URL
- failing workflow run URL
- passing workflow run URL
- exact error text from the failing run
