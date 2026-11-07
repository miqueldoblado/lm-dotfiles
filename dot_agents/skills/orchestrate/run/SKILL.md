---
name: orchestrate-run
description: "Execute an approved orchestration manifest as a supervised run: dispatch one agent per item, route reviews, and land the run. Invoked by the plan skill; do not invoke without a manifest."
disable-model-invocation: true
---

# Orchestrate Run

The run phase. Execute the manifest: dispatch one agent per item, keep the
ledger, route review findings, and land the run.

## Read the configuration

Read the manifest's configuration (host, publisher, tracker). Read the chosen
modules from `../hosts/<host>.md`, `../publishers/<publisher>.md`,
`../trackers/<tracker>.md`.

## Models

Role defaults, passed to the host's dispatch as the host module specifies:

| Role | Model |
|---|---|
| worker | pi's configured default (no flag) |
| code-review | `openrouter/~z-ai/glm-latest` |
| ponytail | `openrouter/~anthropic/claude-sonnet-latest` |

The family rule (core/run.md) requires the three roles to be different
families: worker (deepseek), review (GLM), ponytail (Claude). Check every named
model against `pi --list-models` before dispatching; a model that does not work
stops the run.

## Read the contract

Read `../core/CONTEXT.md` for the domain and rules, then `../core/run.md` and
follow it. Read `../core/review-contract.md` for the review rules and
`../core/ledger.md` for the ledger shape.

## Run the run phase

Follow `../core/run.md`: dispatch wave 1 before touching anything, route
reviews per the review contract, keep the ledger as the run goes, and land the
run through the publisher's verbs.

## Release

After the commit gate says yes, release every lane through the host's `release`
verb — the tabs the run opened, and any worktree it made. Nothing of the
operator's is released.

## Hand off

When the run settles, ask the operator whether to run the retro. On yes, hand
off: `/skill:orchestrate-retro` with the ledger.
