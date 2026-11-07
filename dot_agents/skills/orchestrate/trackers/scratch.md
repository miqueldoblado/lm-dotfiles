# Scratch tracker

The tracker module for local markdown. Implements the two tracker verbs.

## read

- The spec is `.scratch/<feature>/spec.md`.
- The tickets are `.scratch/<feature>/issues/NN-<slug>.md`, numbered from `01`.
- The graph is each ticket's `Blocked by: NN, NN` line.

## write-back

Mark a ticket done: set `Status: resolved` and append the outcome under an
`## Answer` heading. Append comments under a `## Comments` heading.
