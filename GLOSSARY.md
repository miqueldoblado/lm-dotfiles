# Supervised runs

The language for executing an already-written spec: plan it, run it under a host, and record what happened. Writing the spec is outside this workflow.

## Language

**Spec**:
The written description of a piece of work that already exists before a run is planned.
_Avoid_: Plan, manifest, ticket

**Ticket**:
One unit of requested work that belongs to a spec, already written before planning starts.
_Avoid_: Item, task, issue

**Plan**:
The phase that reads a spec and its tickets and produces a manifest and a mode.
_Avoid_: Run, spec

**Manifest**:
The approved plan as data: the work to dispatch, what proves it, and the mode.
_Avoid_: Plan, spec, config

**Mode**:
How many human yeses a run requires. `gated` asks before planning is accepted and again before landing. `land` asks only before planning, then publishes and stops.
_Avoid_: Autonomy, permission mode

**Flow shape**:
How a run's work is arranged. `A` one shared worktree and one change; `B` one worktree and change per item; `cross-repo` items whose code lands in more than one repository.
_Avoid_: Layout, topology

**Run**:
One execution of an approved manifest: the coordinator, the work it dispatches, and the ledger that records them.
_Avoid_: Job, session, orchestration

**Coordinator**:
The lane that dispatches the run's work and keeps the ledger. It never implements the work itself.
_Avoid_: Manager, orchestrator, host

**Lane**:
One dispatched agent the ledger names.
_Avoid_: Thread, agent, session

**Role**:
What a lane is for — `worker`, `code-review`, `ponytail`, `fix`, or `coordinator`.
_Avoid_: Agent type, lane kind

**Ledger**:
The run's one written record, in one shape whichever host wrote it, written as the run goes.
_Avoid_: Log, state file

**Item**:
One unit of work a run dispatches, with a file scope, an acceptance line and an out-of-scope line.
_Avoid_: Ticket, task, unit

**Acceptance line**:
The one line naming what proves an item works, quoted verbatim into the worker prompt, the review brief and the published change.
_Avoid_: Definition of done, criteria

**Out-of-scope line**:
The one line naming what an item is not claiming and its reviewer must not require.
_Avoid_: Non-goals, exclusions

**Wave**:
The set of items whose blockers are settled, dispatched and settled together.
_Avoid_: Batch, stage

**Item lifecycle**:
The states an item moves through — `todo`, `running`, `done`, `failed`, `blocked`.
_Avoid_: Status machine, workflow

**Cause**:
The typed reason an item is `blocked` or `failed`, drawn from a closed set.
_Avoid_: Error, failure reason

**Gate**:
A point the run stops at for a human yes — the plan gate and the commit gate.
_Avoid_: Checkpoint, approval step

**Review**:
An independent pass over work by a lane that did not write it.
_Avoid_: Check, audit

**Verdict**:
What a review ends with — `CLEAN` or `FINDINGS`.
_Avoid_: Result, outcome, score

**Finding**:
A defect in behaviour or a named acceptance criterion, evidenced by a location and a quotation from the code.
_Avoid_: Issue, bug report, comment

**Nit**:
Everything a review reports that is not a finding — a preference with no gate behind it.
_Avoid_: Minor finding, suggestion

**Findings round**:
A review pass that ends in findings; it opens a fix round and counts against the item's cap.
_Avoid_: Iteration, attempt

**Refutation**:
A fix round's answer that names a finding and quotes the code disproving it, instead of changing code.
_Avoid_: Rejection, dismissal

**Class fix**:
One diagnosis of a defect class, recorded once and shared by every item the class reached.
_Avoid_: Batch fix, grouped fix

**Ponytail pass**:
The run's second independent gate, reading the change for what can be deleted or simplified rather than for defects.
_Avoid_: Cleanup pass, lint

**Host**:
The external system where lanes run. One module names it and only it.
_Avoid_: Adapter, runtime, environment

**Publisher**:
The external system where a run's change lands. One module names it and only it.
_Avoid_: Sink, destination, deploy

**Tracker**:
The external system where a spec and its tickets live. Local files are not a tracker.
_Avoid_: Board, backlog

**Adapter**:
The binding a human invokes: it names which host, publisher and tracker a run uses, and holds no commands of its own.
_Avoid_: Plugin, tool, runtime, module
