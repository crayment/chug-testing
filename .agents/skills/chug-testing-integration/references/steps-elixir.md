# Steps: Elixir Task

Test that `mix chug.new` works correctly using the chug task installed from `crayment/chug` main branch source.

This installs directly from GitHub (not Hex.pm) so it tests unreleased changes. Run this before cutting a new chug release that includes Elixir task changes.

## Step 1 — Trigger the test workflow

```bash
gh workflow run test-elixir-task.yml \
  --repo crayment/chug-testing \
  --ref main
```

## Step 2 — Wait for completion

```bash
gh run watch --repo crayment/chug-testing
```

## Step 3 — Verify the result

Expected:
- The workflow succeeds
- `mix deps.get` installs the chug task from `crayment/chug` main
- `mix chug.new` runs and creates a timestamped `.yml` file in `changes/`
- The workflow logs show the contents of the created file
- The file contains `description`, `category`, and `authors` fields

If the workflow fails:
- A `mix: command not found` error means the Elixir setup step failed
- A `no such command 'chug.new'` error means the dep wasn't installed correctly — check the `mix.exs` GitHub dep reference
- A missing `changes/` file means `mix chug.new` ran but failed silently — check the task output

## Evidence to capture

- Workflow run URL
- The contents of the generated change file (shown in workflow logs)
- Any failure output if the run does not succeed
