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

Role defaults, passed to the host's dispatch as the host module specifies. The
`:medium` suffix is the thinking level — gates run below `max` on purpose
(*why* below).

| Role | Model |
|---|---|
| worker | pi's configured default (no flag) |
| code-review, high-risk | `openrouter/~z-ai/glm-latest:medium` |
| code-review, mechanical | `openrouter/~z-ai/glm-flash-latest:medium` |
| ponytail | `openrouter/~openai/gpt-luna-latest:medium` |

The mechanical reviewer is [core/run.md](../core/run.md#models)'s lighter-model
rule — same z-ai family, so the family rule holds without an exception. It is
worth roughly 12% of a run: three mechanical passes of a nine-pass run cost
$0.53 on `glm-latest` and about $0.09 on `glm-flash`. Default a doubtful item
to high-risk, and never downgrade the fresh-eyes review of a fix delta.

The family rule (core/run.md) requires the three roles to be different
families: worker (deepseek), review (GLM), ponytail (OpenAI). Check every named
model against `pi --list-models` before dispatching; a model that does not work
stops the run.

**Never `~`-alias an Anthropic model.** The tilde alias disables prompt caching
for Anthropic on OpenRouter: measured 0% cache hits on 87 turns of
`~anthropic/claude-sonnet-latest` ($23.63), against 100% on the pinned
`anthropic/claude-sonnet-5.5`. The z-ai, openai and deepseek tilde aliases cache
at 97-100%, so the alias itself is fine there. If a role must run on an
Anthropic model, use the pinned id and accept that it goes stale.

**Gates run at `medium` thinking, not `max`.** A review and a ponytail pass read
a bounded frozen diff; at `max` they spent 70-95% of their output on reasoning
(one ponytail pass: 264K reasoning tokens, $6.80) to produce a report of a few
hundred words. The worker keeps pi's default: authoring is where thinking pays,
and it was 8% of the run's cost.

Ponytail is a cheap lane on purpose: it reads a bounded frozen diff, and a
frontier model there costs more than every other lane combined. Step up to
`~openai/gpt-terra-latest` at `medium` if its notes come back shallow.

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
