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
- Summary (the ticket title): **at most 8 words**, a plain statement of the problem
  or the work — no Jira keys, the link carries the reference
- Description: root cause → what happens → verification evidence → plan
- Link with `createJiraIssueLink`, link type `Problem/Incident`,
  `inwardIssue` = the new RBT key, `outwardIssue` = the FIRE key → reads
  "RBT causes FIRE" / "FIRE is caused by RBT". Re-read the FIRE ticket
  afterwards and confirm that wording before reporting done.
- `RBT-1138` and `RBT-1137` show the description shape to match; their summaries
  are longer than 8 words, so do not copy those

## RBT tickets move on the DEN Kanban (board 264)

Column names differ from status names — transition by id, never by name:

| Column | Status | Transition id |
| --- | --- | --- |
| Backlog | To Do | 11 |
| Selected for Dev | Selected for Development | 241 |
| In Progress | In Progress | 231 (name `In Progress (2)`) |
| TO REVIEW | In Review | 31 |
| BLOCKED | Blocked | 281 |
| TO TEST | Ready to Test | 51 |
| READY TO DEPLOY | TO_DEPLOY | 201 |
| Done | Done | 211 (name `Done (2)`) |

"TO TEST" is status `Ready to Test`.

- starting work on a ticket → In Progress
- opening a PR for a ticket → In Review. **Not while the PR is a draft** — leave the
  ticket alone, and move it the moment it is undrafted
- PR turned back into a draft, or review requests changes → back to In Progress,
  as soon as you notice it
- "deploy to staging" → Ready to Test, by whichever mechanism the repo uses:
  - LM-github-workflows repos: post `/deployStaging` on the PR — that comment
    merges the branch into `staging` and deploys it
  - Rubin repos (per `LM-wiki/pls/rubin/dev-process.md`): merge the PR into
    `develop`, which deploys staging
- "deploy to production" = merge the PR to `main`, which deploys prod → Done.
  Exception: in Rubin repos prod needs manual intervention, so stop and hand over
  instead of merging to `master`
- never move a ticket to TO_DEPLOY yourself — QA does that once Ready to Test passes
- PR titles and commits carry the ticket: `feat: RBT-1098 add taxonomy aliases`
