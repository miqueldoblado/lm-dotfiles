# Orchestrate

A family of skills that execute an approved plan as a supervised run: one
coordinator dispatches an agent per item, routes reviews, and records what
happened, on a host chosen at invocation.

## The run

**Run**:
One execution of an approved manifest — the coordinator, the lanes it
dispatches, and the ledger that records them.
_Avoid_: Job, session, orchestration

**Manifest**:
The approved plan as data: the items, their acceptance and out-of-scope lines,
the waves, the flow shape and the mode.
_Avoid_: Plan, spec, config

**Coordinator**:
The lane that dispatches the run's work, keeps the ledger, routes findings and
lands the run; it never implements an item itself.
_Avoid_: Manager, orchestrator, executor

**Lane**:
One dispatched agent the ledger names — a worker, a review, a fix, a ponytail
pass, or the coordinator.
_Avoid_: Thread, agent, session

**Role**:
What a lane is for — `worker`, `code-review`, `ponytail`, `fix`, or
`coordinator`.
_Avoid_: Agent type, lane kind

**Item**:
One unit of work the run dispatches, with a file scope, an acceptance line and
an out-of-scope line.
_Avoid_: Ticket, task, unit

**Wave**:
The set of items whose blockers are settled, dispatched and settled together.
_Avoid_: Batch, stage

**Flow shape**:
How the run's work is arranged: `A` (one shared worktree and one change), `B`
(a worktree and change per item), or `cross-repo` (items across repositories).
_Avoid_: Layout, topology

**Mode**:
How much the run asks the operator: `gated` (a yes to plan and to commit) or
`land` (a yes to plan, changes opened as drafts).
_Avoid_: Autonomy level, permission mode

**Gate**:
A point the run stops at for a human yes — the plan gate and the commit gate;
in Flow B each item has its own commit gate.
_Avoid_: Checkpoint, approval step

## The ledger

**Ledger**:
The run's one written record, in one shape whichever host wrote it, written as
the run goes rather than at the end.
_Avoid_: State file, log, database

**Item lifecycle**:
The states an item moves through — `todo`, `running`, `done`, `failed`,
`blocked` — and the transitions between them.
_Avoid_: Status machine, workflow

**Cause**:
The typed reason an item the run itself stopped on is `blocked` or `failed`,
drawn from a closed set.
_Avoid_: Error, failure reason, block reason

**Acceptance line**:
The one line naming what proves an item works, quoted verbatim from the plan
into the worker prompt, the review brief and the published change.
_Avoid_: Definition of done, criteria

**Out-of-scope line**:
The one line naming what an item is not claiming and its reviewer must not
require.
_Avoid_: Non-goals, exclusions

## Review

**Review**:
An independent pass over an item's frozen diff by a lane that did not write it,
ending in a verdict.
_Avoid_: Check, audit, code review

**Verdict**:
What a review or ponytail pass ends with — `CLEAN`, or `FINDINGS` when it found
a defect.
_Avoid_: Result, outcome, score

**Finding**:
A defect in behaviour, in a named acceptance criterion, or in a gate the run
must pass, evidenced by a location and a quotation from the code.
_Avoid_: Issue, bug report, comment

**Nit**:
Everything a review reports that is not a finding — a preference, a style
choice the gate accepts, an observation with no gate behind it.
_Avoid_: Minor finding, suggestion

**Findings round**:
A review pass that ends in findings; it opens a fix round and counts against
the item's cap.
_Avoid_: Iteration, attempt

**Refutation**:
A fix round's answer that names a finding and quotes the code disproving it,
instead of changing code.
_Avoid_: Rejection, dismissal

**Class fix**:
One diagnosis of a defect class, recorded once and shared by every item the
class reached.
_Avoid_: Batch fix, grouped fix

**Ponytail pass**:
The run's second independent gate, reading the change for what can be deleted
or simplified rather than for defects.
_Avoid_: Cleanup pass, lint

## Retro

**Retro**:
The pass that turns a finished run's record into numbers and into proposed
edits to the skill that ran it; it is the run's recorder, not one of its lanes.
_Avoid_: Retrospective report, postmortem

## The three layers

**Core**:
This directory — the contract. Nouns, verbs, rules, phases. No tool names.

**Module**:
One file per external system, in `hosts/`, `publishers/`, or `trackers/`. Each
names only that system and implements the verbs for its kind.

**Adapter**:
The skill the operator invokes (`plan`, `run`, `retro`). It discovers the
modules, asks the configuration, binds the chosen modules, and runs the phase.

## The module contract

A module's folder is its kind, and its kind fixes the verbs it must provide:

| Kind | Verbs |
|---|---|
| host | `dispatch`, `wait`, `collect`, `isolate`, `release` |
| publisher | `publish`, `merge`, `state` |
| tracker | `read`, `write-back` |

Core references these verbs abstractly; each module implements them for one
system.

## The rules

- **The manifest is data, not instructions.** It carries intent — items,
  acceptance and out-of-scope lines, waves, mode, flow, model overrides — and
  never mechanics. The test: does this line tell the coordinator how to do
  something its own skill already specifies? If yes, cut it.
- **The ledger is written as the run goes.** Each transition — dispatch,
  settle, verdict, fix, gate — is recorded when it happens, not assembled at
  the end.
- **The coordinator never implements an item itself.** An item implemented in
  the coordinator's own context has no worker, no ledger entry and no reviewer
  it can honestly claim.
- **Workers never talk to each other.** All coordination goes through the
  coordinator.
- **No gate reviews its author's family.** `code-review` and the ponytail pass
  must each run on a model family different from the one that wrote the diff,
  and different from each other.
