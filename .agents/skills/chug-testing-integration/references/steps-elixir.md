# Steps: Elixir Task

Test that `mix chug.new` works correctly using the chug task installed from `crayment/chug` main branch source.

The `mix.exs` in `crayment/chug-testing` pulls the chug dep directly from GitHub, not Hex.pm — so this tests whatever is currently on `crayment/chug` main, including unreleased changes.

## Step 1 — Install the dep

```bash
cd /Users/crayment/dev/me/chug-testing
mix deps.get
```

## Step 2 — Run mix chug.new

```bash
mix chug.new --description "Test change from Elixir task" --category chore
```

## Step 3 — Verify the change file was created

```bash
ls changes/
cat changes/*test-change-from-elixir-task*.yml
```

Expected: a timestamped `.yml` file in `changes/` containing `description`, `category`, and `authors` fields.

## Step 4 — Clean up

Delete the test change file so it doesn't linger:

```bash
rm changes/*test-change-from-elixir-task*.yml
```

## Evidence to capture

- Output of `mix chug.new`
- Contents of the generated change file
- Any error output if the task fails
