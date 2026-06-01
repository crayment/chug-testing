# Steps: PR and Merge

Test that `chug validate` enforces a change file on pull requests, then merge a valid PR that adds a Simpsons quote.

The "product" in this repo is `simpsons-quotes.md` — a growing collection of Simpsons quotes. Each PR adds a quote and a matching change file. This gives every test run real content to track through the changelog and GitHub release.

## State assumptions

- `simpsons-quotes.md` already exists on `main` with some starter quotes. If it doesn't, create it.
- There may be pre-existing change files in `changes/` on `main` from prior runs. That's fine — they'll all be consumed together in the next release. Your quote will be included alongside them.

## Setup

Work in the local consumer repo. Make sure `main` is up to date:

```bash
git -C /Users/crayment/dev/me/chug-testing checkout main
git -C /Users/crayment/dev/me/chug-testing pull
```

## Step 1 — Open a PR without a change file

Create a branch and add a Simpsons quote to `simpsons-quotes.md`, but no change file:

```bash
cd /Users/crayment/dev/me/chug-testing
git checkout -b test/add-simpsons-quote
```

Append a new Simpsons quote to `simpsons-quotes.md`. Pick any quote — make it a good one. Format:

```
"Quote text here." — Character Name
```

Then commit and push without a change file:

```bash
git add simpsons-quotes.md
git commit -m "Add Simpsons quote"
git push -u origin test/add-simpsons-quote
gh pr create --title "Add Simpsons quote" --body "A new quote for the collection."
```

## Step 2 — Confirm validation fails

Wait for the `Validate Changelog Entry` workflow to run on the PR. This command will block until checks complete:

```bash
gh pr checks --watch
```

Expected: the `validate` check fails with:
```
A changelog entry file in changes/ is required for this pull request.
```

Record the failing workflow run URL.

## Step 3 — Add a change file and confirm validation passes

```bash
chug new --description "Add Simpsons quote: <the quote you added>" --category feature
git add changes/
git commit -m "Add change file"
git push
```

Run the check watcher again (a second invocation — it watches the latest checks on the PR):

```bash
gh pr checks --watch
```

Expected: the `validate` check passes.

Record the passing workflow run URL.

## Step 4 — Merge the PR

```bash
gh pr merge --squash --delete-branch
git -C /Users/crayment/dev/me/chug-testing pull
git -C /Users/crayment/dev/me/chug-testing log --oneline -1
```

Record the merge commit SHA from the log output.

## Evidence to capture

- Branch name
- PR URL
- Failing workflow run URL and exact error text
- Passing workflow run URL
- Merge commit SHA
- The Simpsons quote you added
