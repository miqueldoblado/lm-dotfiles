# The run phase

The execution contract shared by the `run` adapter. This file owns the domain
the run follows; the adapter owns the mechanics — how it dispatches, waits,
collects, releases and gets a worktree — via the host module, and how it
publishes via the publisher module.

## The coordinator's job

Execute an approved plan: dispatch one agent per item, keep the ledger, route
review findings, and land the run. The coordinator does not plan, and it never
implements an item itself.

The manifest is the approved plan. Start from it immediately: never re-derive
the graph and never re-ask what was already approved. With no manifest, do not
derive one: say the plan is missing and point the operator at the plan skill.

Dispatch before touching anything. The first turn writes the ledger and
dispatches wave 1 before any item's file is opened to change it.

## Flow shapes

The manifest's `flow:` names the run's shape.

- **`A`** — one shared worktree, one change. Workers run in the same worktree,
  leave their changes uncommitted, and never commit or push; the coordinator
  accumulates the combined diff and makes exactly one commit and one change at
  the end.
- **`B`** — one worktree, branch and change per item. Items with no `blockedBy`
  start together; an item with blockers stays `todo` until those changes land,
  then its worktree is created from the updated target.
- **`cross-repo`** — the items span more than one repository: no shared worktree
  and no single change. Each item gets its own worktree and its own per-repo
  gate.

**Waves.** A wave is the set of items whose blockers are settled, and it
dispatches and settles in parallel. In shape `A` every worker shares one
worktree, so an item's worker may only run concurrently with workers whose
files it does not touch. Shape `B` has no file-overlap gating — every unblocked
item moves.

Workers never talk to each other; all coordination goes through the coordinator.

### Item scope

An item's file scope is the manifest's, and the worktree is where it is
checked. Before an item's first review, the files its lane actually changed are
compared with the item's manifest `files`: a path outside that scope is a
finding of its own, resolved before the review is spawned.

## Models

Three roles: **worker**, **code-review**, **ponytail**. The adapter names the
role's default model and the flag that passes it; this file owns the policy.

**No gate reviews its author's family.** `code-review` and the ponytail pass
are the run's two independent gates: each must run on a model family different
from the one that wrote the diff, and different from each other.

A per-run override is the manifest's model line. Ponytail keeps its own role
default; only a ponytail **fix** runs on the worker model, because a fix is
authoring, not review.

**A model that does not work stops the run.** Stop, tell the operator which
model failed and how, and ask which to use instead.

## Review loops

What a review is, when it ends, and what a fix round costs is
[review-contract.md](review-contract.md). A worker's `DONE` is a claim, not
proof.

- Every code-changing item gets a separate fresh-eyes review agent; a worker or
  the coordinator reviewing its own work does not count.
- Findings loop back to the same worker while its lane is live; if the lane is
  gone, start a fresh fix lane in the item's worktree.
- A ponytail fix runs as a fresh worker on the worker model.

## The ledger

The ledger is written as the run goes. The shape is [ledger.md](ledger.md).
Write `mode` on the ledger before the first spawn.

## Gates

Two human yes points: the plan gate (in the plan phase) and the commit gate
(here). In `gated` mode, the commit gate asks before the change is published.
In `land` mode, the commit gate is skipped and the change is opened as a draft.

In Flow B each item has its own commit gate.

**An amendment returns to the plan gate.** If the operator changes what an item
must do after the plan gate, the manifest is stale. Write the change into the
plan's own home first, through the tracker's `write-back` verb — the local
markdown spec and tickets, or the tracker's issue when that is where the plan
lives — then quote the changed acceptance line back to the operator for a yes,
and only then dispatch. Work already dispatched under the old acceptance is
re-read against the new one; it is never assumed to still fit.

**A question is not a go.** When the operator's message is a question, answer
it and wait: do not dispatch or commit the change it implies until the operator
answers with a direction.

## Publish

Publish through the publisher's verbs: `publish` opens the change as a draft,
`merge` merges it, `state` reads its state. The publisher module names the
exact commands.

`land` opens the change as a draft and stops. `gated` asks before publishing
and merges after the yes.

## Release

Undo each lane's dispatch once the run has landed, through the host's `release`
verb: lanes are workers, reviews and ponytail passes, and a settled lane has no
reason to keep a pane or a worktree alive. Release only what the run created;
the coordinator's own pane and the operator's tabs are not yours.

Never release before the commit gate says yes — a run that stops at the gate may
need its worker again to answer the operator. Record each release as it happens,
the same way the dispatch was recorded.

## Ticket write-back

When the run settles, mark the tickets through the tracker's `write-back` verb.
The tracker module names the exact commands.
