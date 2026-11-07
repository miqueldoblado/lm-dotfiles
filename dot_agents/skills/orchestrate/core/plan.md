# The plan phase

The planning contract shared by the `plan` adapter. This file owns what a plan
must decide and what an approval must carry; the adapter owns the input shapes,
the configuration ask, and the artifact format.

## Read the spec and tickets

Read the spec and its tickets through the tracker's `read` verb. The tracker
module names the exact commands; this file owns the shape of what is read.

- The spec is the written description of the work.
- The tickets are the units of requested work, one per file.
- The graph comes from each ticket's `Blocked by:` line — that line is the
  graph, not an inference.

## Plan the run

1. Read the spec and every ticket.
2. Build the graph from each ticket's `Blocked by:` line.
3. Assign each item a file scope from what it will build. Disjoint scopes plus
   settled blockers form a parallel wave; overlapping scopes serialize.
4. **Reduce the item count first.** Every item costs a full worker plus a
   fresh-eyes review cycle, so one item per ticket is the wrong starting point.
   Items with identical file scopes merge into one item unless the work needs
   independent verifiability or independent rollback. Name that exception in
   the approval message.
5. **Capture each item's intent — from this session, not from the ticket.** One
   line of acceptance: what proves the item works. One line of out-of-scope:
   what the item is not claiming. Both come from the discussion that produced
   this approval.
6. Flag the special handling: run-alone resets, items ending in a push or
   merge, approval gates, and any acceptance criterion reaching into another
   repository.

## One approval

Read `mode` from the argument: `--land`, or neither (`gated`). Both flags is a
stop.

Present in the approval message: the flow, the mode, the reduction made
(tickets in, items out), the waves, the per-item notes, and the model
assignments.

`gated` and `land` do not continue until the operator's yes. Nothing is
dispatched before the manifest exists.

## The manifest

The coordinator's prompt is a manifest: data only, no instructions. The field
list is [manifest-contract.md](manifest-contract.md). What goes in it:

- the feature name and the run's identity
- the tracker, explicit and never inferred
- the flow — `A`, `B`, or `cross-repo`
- the `mode` line, never omitted
- the items, each with its acceptance and out-of-scope lines one line each
- the waves, and any run note the tickets cannot supply
- a model line only when the operator overrode the role defaults

The test for inclusion is procedural: does this line tell the coordinator how
to do something its own skill already specifies? If yes, cut it.
