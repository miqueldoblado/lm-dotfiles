# Manifest contract

The manifest is the coordinator's prompt: data only, no instructions. This file
owns the shape; the shape is the same whichever host wrote it.

## Fields

- `feature`: the feature name, slugified — it drives the run's identity.
- `tracker`: the tracker, explicit and never inferred from the shape of a
  reference.
- `flow`: `A`, `B`, or `cross-repo`. Never omitted.
- `mode`: `gated` or `land`. Never omitted.
- `items`: one line per item, each naming its ticket, file scope, acceptance
  line and out-of-scope line.
- `waves`: the items grouped by wave, in dispatch order.
- `models`: a model line only when the operator overrode the role defaults.
- `notes`: any run note the tickets cannot supply — cross-repo paths, run-alone
  handling, approval gates.

## Item line

Each item line carries:

- `id`: the item's id, stable across the run.
- `ticket`: the ticket the item names.
- `files`: the file scope.
- `acceptance`: one line, what proves the item works.
- `out-of-scope`: one line, what the item is not claiming.
- `blockedBy`: the item ids this item waits on.

## The test for inclusion

Does this line tell the coordinator how to do something its own skill already
specifies? If yes, cut it. Role models, dispatch flags, review loops and ledger
mechanics live in the run skill and are never restated here.
