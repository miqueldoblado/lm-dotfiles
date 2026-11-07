# Review contract

One review rule, read by the `run` adapter. This file owns what a review is,
when it ends, and what a fix round costs.

## A finding is a defect

A **finding** is a defect in behaviour, in a named acceptance criterion, or a
failure of a gate this run must pass (lint, typecheck, tests). A **nit** is
everything else — a preference, a style choice the gate accepts, an observation
with no gate behind it.

A finding is **evidenced and classified**, and both are on the report line:

```
<file>:<line> · <class> · <what breaks> · "<the line(s) that prove it>"
```

- The location and the quotation are the evidence. A claim with no quotation
  from the code it is about is a nit.
- `<class>` is a short kebab-case name for the defect class. The brief lists
  every class already recorded in the run's `classFixes`, and a finding of one
  of those classes reuses the recorded spelling.
- Two findings with the same file, line and normalized title are one finding.

**Four things are not findings**, whatever they are called, and none of them
opens a fix round or counts against the cap — each is a nit:

- a defect in code this item's diff does not touch, which the base already carried
- something the run's own gate already catches
- something the surrounding code already guards
- a preference with no gate behind it

**Intent comes from the manifest, and it is the plan's.** The item's
`acceptance` and `out-of-scope` lines are quoted into the review brief from the
approved manifest. The `out-of-scope` line bounds what a reviewer may require.

**The worker's account is a lead, not a verdict.** Every worker states its
hardest decision, the alternatives it rejected, and what it is least confident
about; the review brief quotes those lines.

## CLEAN ends the loop

`VERDICT CLEAN` closes the item's review even when it carries non-blocking
nits. Only `VERDICT FINDINGS` opens a fix round.

Every review and ponytail report ends with `VERDICT CLEAN` or
`VERDICT FINDINGS` as its first line.

## The review lane does the pass itself

The review runs in the review lane, from its own context. It spawns no
subagents.

Depth scales to the item's risk. A **high-risk** item — real state, logic, or
contract surface — gets the full adversarial prompt: every acceptance criterion
verified in code, edge cases probed, test fixtures judged. A **mechanical**
item — deletions, renames, rendering-only, docs, config — gets a short pass
over the frozen diff. The call is recorded as the item's `risk`.

## Cap: 2 findings rounds per item

A **findings round** is a pass that returns `VERDICT FINDINGS`. A 3rd findings
round is never spawned: the item is `blocked` with `cause.code:
cap_exhausted`, its findings are surfaced to the operator, and the rest of the
frontier keeps moving.

**A re-review is scoped to the delta.** Its brief names what changed and only
the earlier conclusions that change could have invalidated.

**A re-review is gated on the artifact having moved.** Each pass reads its own
frozen diff, and the next pass is spawned only when the new freeze differs from
every freeze this item has read. Identical bytes are not a new round: the item
is `blocked` with `cause.code: artifact_unchanged`.

**A freeze that repeats an earlier pass's is oscillation, not a new round.**
The item is `blocked` with `cause.code: nonconvergent`.

## A findings round ends in code, a refutation, or a stop

A fix round is dispatched with the findings, and it has three outcomes:

- **The code changed.** The re-review waits on the new freeze.
- **`REFUTED:`** — the worker names the finding and quotes the code that
  disproves it. No re-review is spawned. The item is `blocked` with
  `cause.code: finding_refuted`.
- **Neither** — `artifact_unchanged`.

A refutation is a disagreement about the code, handed to the operator with the
finding it answers. It is not a settlement.

## One class fix, one diagnosis

A finding whose `<class>` matches a recorded `classFixes` entry has already
been diagnosed in this run. The coordinator reuses the entry's `brief`
verbatim, appends the item to the entry's `items`, and runs one repair round
for the class. Each affected item still gets its own re-review of the repair's
delta.

## Ponytail fixes

A ponytail finding's fix is re-checked by the next ponytail pass. It skips the
fresh-eyes review only when its diff adds no executable behaviour. A fix that
adds or changes behaviour gets a fresh-eyes review of the fix delta before the
item settles.

## A finding that contradicts the spec

When a review or ponytail finding conflicts with the approved manifest or the
tracker spec, that is not a fix round. Quote the finding and the spec clause it
contradicts, record it as a follow-up, and block the item with `cause.code:
spec_conflict`. The check is made when the finding arrives, before the next fix
round is spawned.
