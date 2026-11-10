# Machine-wide agent instructions

Facts about this machine and my own working conventions. A repository's own
`AGENTS.md` is the authority on that repository: this file adds to it and never
replaces it.

## Dotfiles are managed by chezmoi, not by bare git

`~/.agents/skills`, `~/.pi/agent`, `~/.config/direnv`, `~/.config/herdr` and
others are chezmoi-managed (not everything under `~` is — check, do not assume).
The target tree carries no `.git`, so `git status` there says "not a
repository". That is **not** evidence that a file is unversioned.

- Ask first: `chezmoi managed <path>`
- Then edit the **source** and apply it:
  `chezmoi source-path <path>` finds the editable file, `chezmoi apply <path>`
  lands the change in `~`
- Already edited the target by mistake? `chezmoi diff <path>` shows it,
  `chezmoi add <path>` records it into the source, and a plain `chezmoi apply`
  would otherwise revert it
- The dotfiles repo is `~/.local/share/chezmoi`; commit there
- An unrecorded target edit is drift, and the next `chezmoi apply` discards it

## Fireline follow-ups go to RBT

When I ask for a linked work item, ticket, or follow-up from a FIRE incident,
create it in project `RBT` (Data Platform) — not in FIRE:

- Type `Bug` for a defect, `Task` for planned work; label `Fireline`; priority `Minor`
- Summary: a plain one-line statement of the problem or the work — no Jira keys,
  the link carries the reference
- Description: root cause → what happens → verification evidence → plan
- Link with `createJiraIssueLink`, link type `Problem/Incident`,
  `inwardIssue` = the new RBT key, `outwardIssue` = the FIRE key → reads
  "RBT causes FIRE" / "FIRE is caused by RBT". Re-read the FIRE ticket
  afterwards and confirm that wording before reporting done.
- `RBT-1138` and `RBT-1137` show the shape to match, minus the key-suffixed
  summaries they use
