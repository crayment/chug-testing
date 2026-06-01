# Steps: PR and Merge

## Setup

Resolve `CONSUMER_DIR` as described in SKILL.md, then make sure `main` is up to date:

```bash
git -C "$CONSUMER_DIR" checkout main
git -C "$CONSUMER_DIR" pull
```

`simpsons-quotes.md` exists on `main`. If it doesn't, create it.

## Step 1 — Open a PR without a change file

```bash
cd "$CONSUMER_DIR"
git checkout -b test/add-simpsons-quote
```

Append a quote in this format:
```
"Quote text here." — Character Name
```

```bash
git add simpsons-quotes.md
git commit -m "Add Simpsons quote"
git push -u origin test/add-simpsons-quote
gh pr create --title "Add Simpsons quote" --body "A new quote for the collection." --repo crayment/chug-testing
```

## Step 2 — Confirm validation fails

```bash
gh pr checks --watch --repo crayment/chug-testing
```

Expected error:
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
gh pr checks --watch --repo crayment/chug-testing
```

Expected: the `validate` check passes. Record the passing workflow run URL.

## Step 4 — Merge the PR

```bash
gh pr merge --squash --delete-branch --repo crayment/chug-testing
git -C "$CONSUMER_DIR" pull && git -C "$CONSUMER_DIR" log --oneline -1
```

Record the merge commit SHA.

## Evidence to capture

- Branch name, PR URL
- Failing workflow run URL and exact error text
- Passing workflow run URL
- Merge commit SHA, quote added
