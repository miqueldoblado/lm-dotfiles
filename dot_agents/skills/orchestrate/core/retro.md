# The retro phase

The retrospective contract shared by the `retro` adapter. Two questions decide
whether the retro was worth the tokens: did it explain every number it printed,
and did it end in an edit someone can make.

## Report

The report has five sections:

- **Execution plan** — the flow, the items in dispatch order with their
  blocked-by edges, and the wave structure the run actually followed. Note
  every place it diverged from the plan it approved.
- **What to fix** — one line per finding: what happened, the evidence, and the
  smallest change that prevents it next time.
- **Changes to the main skill** — ranked proposals, each naming the section it
  edits; at most three, and `no skill change is argued` when the rules
  explained the run. Skills live in a chezmoi-managed tree: apply a proposal by
  editing its source (`chezmoi source-path <target>`) and landing that, never
  by editing the target alone, which is drift the next `chezmoi apply` discards.
- **Time per phase** — from the ledger's timestamps.
- **Cost per model** — from the ledger's `usage` entries, with the checks below.

The report is done when every finding is explained or marked **unexplained**,
and every proposal names the section it would change plus the evidence that
motivates it and the check that decides it landed.

## Cost checks

A cost section that only totals money is a bill, not a retro. These checks turn
the ledger's `usage` entries into findings: each one compares a lane against the
shape a healthy lane has, and any lane that fails a check is written up with its
numbers and marked **explained** or **unexplained**.

| Check | Healthy | What a failure means |
|---|---|---|
| Cache hit rate, per model: `cacheRead / (input + cacheRead)` | above 50% once a lane passes ~5 turns | The model or alias does not cache, or the prompt is rebuilt every turn. The whole context is repaid at input price on every turn. |
| Fresh input volume, per lane | near the size of what it reads | A lane whose fresh input dwarfs its diff is re-reading context that should have been cached. Name the lane and the model. |
| Reasoning share: `reasoning / output` | under 50% for a gate lane | The thinking level is buying tokens instead of a verdict. Name the level it ran at. |
| Requested vs served: `models` against `served` | equal | A mismatch is a routing or dispatch error, and every cost figure attributed to the requested model is wrong. |
| Role cost share | worker lanes carry the work, gates a minority | Run cost concentrated in the gate roles is a defect in the run's shape, not in the model. |
| Pass count per item | within the caps here and in [review-contract.md](review-contract.md) | A pass count above its cap is a contract defect, whatever it cost. |
| Model availability | every model named at plan time resolved | Count the causes: `model_unavailable` means a model was named that the catalog did not have. |

**A check that fires is evidence, and the report says which.** The same failure
in two runs is a recurrence: report it against the earlier record rather than as
a new finding.

## What earns a proposal

Default to **none**. A candidate becomes a proposal only when all five hold:

1. **A defect of the rules, not of the run.** The run broke a written rule —
   that is a *What to fix* finding. The rules are silent or contradict each
   other — that is a candidate.
2. **Not already answered in the corpus.** Search the corpus records for the
   class before proposing.
3. **It names its check, and its saving.** One line each.
4. **A change that only prints another number pays for itself.**
5. **Ranked, and at most three.**
