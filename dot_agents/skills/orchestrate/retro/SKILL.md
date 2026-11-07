---
name: orchestrate-retro
description: "Turn a finished orchestration run's ledger into numbers and proposed skill edits. Invoked by the run skill; do not invoke without a finished ledger."
disable-model-invocation: true
---

# Orchestrate Retro

The retro phase. Turn a finished run's record into numbers and proposed edits.

## Read the configuration

Read the ledger's configuration (host, publisher, tracker). Read the chosen
modules from `../hosts/<host>.md`, `../publishers/<publisher>.md`,
`../trackers/<tracker>.md`.

## Read the contract

Read `../core/CONTEXT.md` for the domain and rules, then `../core/retro.md` and
follow it.

## Run the retro phase

Follow `../core/retro.md`: produce the five-section report, explain every
number, and end in an edit someone can make.
