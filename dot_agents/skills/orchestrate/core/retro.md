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
  explained the run.
- **Time per phase** — from the ledger's timestamps.
- **Cost per model** — from the ledger's model records.

The report is done when every finding is explained or marked **unexplained**,
and every proposal names the section it would change plus the evidence that
motivates it and the check that decides it landed.

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
