# Ledger

The run's one written record, written as the run goes. This file owns the
shape; the shape is the same whichever host wrote it.

## Fields

- `run`: the run's identity.
- `mode`: `gated` or `land`, written before the first spawn.
- `flow`: `A`, `B`, or `cross-repo`.
- `tracker`: the tracker, explicit.
- `gates`: the plan gate and commit gate, each with `requestedAt` and
  `approvedAt` timestamps.
- `items`: one entry per item, with its lifecycle state, cause, reviews, fixes
  and models.
- `classFixes`: one entry per defect class, with its `brief` and the items it
  reached.
- `models`: what the run asked for, and `served`: what each lane's record names.
- `usage`: one entry per lane, written as the lane settles — see *Lane usage*.

## Lane usage

Every lane's settle writes a `usage` entry, because the retro cannot price a
lane it only has prose about. The host module's `collect` verb names where its
record carries these fields; the coordinator copies them, it does not derive
them.

- `lane`: the lane's name and role.
- `model`: the model the lane actually ran, not the one requested.
- `input`: fresh, uncached input tokens.
- `cacheRead`, `cacheWrite`: tokens read from and written to the prompt cache.
- `output`, `reasoning`: output tokens, and how many of them were reasoning.
- `turns`: assistant turns the lane took.
- `cost`: the lane's total, in USD.

A field the lane's record does not name is **absent, not zero**. Absent usage
reads as unverified in the retro, and a lane missing every field is named in the
report as unpriced rather than assumed cheap.

## Item entry

- `id`, `ticket`, `files`, `acceptance`, `out-of-scope`.
- `state`: `todo`, `running`, `done`, `failed`, `blocked`.
- `cause`: the typed reason when `blocked` or `failed`, with a `code` from the
  closed set and a `detail` line.
- `reviews`: one entry per completed review pass, with its verdict.
- `fixes`: one entry per fix round, with its outcome (code changed, refuted,
  unchanged).
- `risk`: the item's risk, recorded when its first review is dispatched.

## The closed set of causes

`cap_exhausted`, `artifact_unchanged`, `nonconvergent`, `finding_refuted`,
`spec_conflict`, `model_unavailable`, `dispatch_failed`.
