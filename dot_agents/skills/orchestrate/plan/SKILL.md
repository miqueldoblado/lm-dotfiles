---
name: orchestrate-plan
description: "Plan an orchestration run and take one approval before anything is dispatched, then hand off to the run skill. Use when the user gives a `.scratch/` feature directory or an issue to run. Pass --land to skip the commit yes and open drafts."
argument-hint: "@.scratch/<feature>/ | <issue> [--land]"
disable-model-invocation: true
---

# Orchestrate Plan

One loop, three skills: **plan → run → retro**. This skill is the plan phase:
it decides the run's shape, items, waves and models; takes one approval; writes
the manifest; and hands off to the run skill.

## Discover the modules

List the module folders relative to this skill's directory:

- `../hosts/` — the available hosts.
- `../publishers/` — the available publishers.
- `../trackers/` — the available trackers.

Each file is one module; its filename without `.md` is its name.

## Ask the configuration

Propose the defaults and offer the options:

- **host**: `herdr` (default) · the other files in `../hosts/`.
- **publisher**: `github` (default) · the other files in `../publishers/`.
- **tracker**: detected — read `docs/agents/issue-tracker.md` in the current
  working directory and map it to a module (`github` → `github-issues`, `local
  markdown` → `scratch`). If the file is missing, fall back to `scratch` and
  note the repo isn't set up.

The operator accepts the defaults or overrides one axis. Write the chosen
configuration into the manifest.

## Check the host's preflight

Read the chosen host module (`../hosts/<host>.md`) and check its requirements
before planning. A plan approved for a host that cannot dispatch is a plan that
cannot run.

## Read the contract

Read `../core/CONTEXT.md` for the domain and rules, then `../core/plan.md` and
follow it.

## Run the plan phase

Follow `../core/plan.md`: read the spec and tickets through the tracker
module's `read` verb, plan the run, take one approval, and write the manifest
per `../core/manifest-contract.md`.

## Hand off

When the approval is given and the manifest is written, hand off to the run
skill: `/skill:orchestrate-run` with the manifest.
