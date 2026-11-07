# Herdr host

The host module for Herdr. Implements the five host verbs. Requires
`HERDR_ENV=1` and `herdr integration status` reporting `pi: current`.

## dispatch

One work unit = one tab + one named pi agent in that tab's root pane. The
coordinator keeps its own pane; workers never share a pane.

```sh
tab=$(herdr tab create --workspace "$HERDR_WORKSPACE_ID" --cwd "$PWD" \
  --label "ITEM <id> · <short title>" --no-focus)
pane=$(printf '%s' "$tab" | jq -r '.result.root_pane.pane_id')
herdr agent start "item-<slug>" --kind pi --pane "$pane"
```

`herdr agent start` returns once pi is ready; its JSON carries
`agent_session.value` (the session transcript), `pane_id` and `argv`. Record
all three in the ledger.

## wait

```sh
herdr agent prompt "item-<slug>" "$(cat prompt.txt)" --wait --timeout 12000
```

Read the exit code and `.error.code`: exit 0 with `agent_status: done`/`blocked`
means settled; exit 1 with `timeout` means submitted and working (wait for
settlement); `agent_prompt_stalled` means not confirmed delivered (inspect,
never blind-resend).

## collect

Read the lane's output from its pi session transcript (`agent_session.value`
from the start reply).

## isolate

```sh
git fetch origin <target>
herdr worktree create --cwd <repo-root> --branch "<feature-slug>/<slug>" \
  --base "origin/<target>" --label "<id> · <short title>" --no-focus
```

The reply carries `.result.workspace.workspace_id`, `.result.root_pane.pane_id`
and `.result.worktree.path` — record all three.

## release

```sh
herdr worktree remove --workspace <item-ws>
```

Never `--force`: a dirty worktree refusing removal is the signal that work is
still in it.
