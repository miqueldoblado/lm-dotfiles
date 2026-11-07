# GitHub issues tracker

The tracker module for a plan that lives in GitHub Issues. Implements the two
tracker verbs. Requires `gh auth status` to pass.

## read

- The spec is the issue the plan was written on: `gh issue view <n> --json
  number,title,body,labels,comments`. Its body is the spec; its sub-issues are
  the tickets when the repo uses them.
- The tickets are the open issues labelled `ready-for-agent` that name the spec:
  `gh issue list --label ready-for-agent --state open --json
  number,title,body,labels --limit 200`.
- The graph is each ticket's `Blocked by:` line, quoting the issue numbers it
  waits on (`#12, #14`). GitHub has no native blocking edge, so that line is the
  edge — never infer one from the order issues were opened or from a task list.

## write-back

- **Mark a ticket done**: `gh issue comment <n> --body-file answer.md` with the
  outcome, then `gh issue close <n> --reason completed`.
- **Amend the plan**: `gh issue edit <spec> --body-file body.md` so the change
  lands in the spec's own body — the body is what the next run reads — then
  `gh issue comment <spec> --body-file amendment.md` naming what changed and
  why, so the trail survives the edit.
- **Comment**: `gh issue comment <n> --body-file note.md`.
