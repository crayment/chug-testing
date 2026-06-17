# Steps: Elixir Task

Test that `mix chug.new` works using chug pulled directly from `crayment/chug` main — not Hex.pm. This exercises unreleased changes.

## Step 1 — Update and install the dep

Use `deps.update` (not `deps.get`) to force re-fetching the latest main, ignoring the locked SHA:

```bash
cd "$CONSUMER_DIR"
mix deps.update chug && mix deps.get
```

## Step 2 — Run mix chug.new

```bash
mix chug.new --description "Test change from Elixir task" --category chore
```

## Step 3 — Verify the change file

```bash
ls "$CONSUMER_DIR/changes/"
cat "$CONSUMER_DIR/changes/"*test-change-from-elixir-task*.yml
```

Expected: a timestamped `.yml` file containing `description`, `category`, and `authors` fields.

## Step 4 — Clean up

```bash
rm "$CONSUMER_DIR/changes/"*test-change-from-elixir-task*.yml
```

## Evidence to capture

- Output of `mix chug.new`
- Contents of the generated change file
- Any error output if the task fails
