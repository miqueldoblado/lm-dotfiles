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

## Publishing a Databricks notebook to a workspace

Databricks notebooks are versioned in a repo (`projects/<project>/notebooks/`) and normally reach
the workspace through its bundle, which mirrors the project into
`/Shared/databricks-bundle/pls/<bundle>/files/...`. Publish one by hand only when it is not deployed
yet — once the branch is deployed the deploy does it. Profiles are `staging` and `prod`; the host is
`databricks auth env --profile <stage> | grep DATABRICKS_HOST`.

1. Import it as a source notebook — the workspace name carries **no** `.py`:
   ```sh
   databricks workspace import \
     "/Shared/databricks-bundle/pls/<bundle>/files/notebooks/<name>" \
     --file notebooks/<name>.py --format SOURCE --language PYTHON \
     --profile <stage> --overwrite
   ```
2. Read back the `object_id` and build the permalink — `https://<host>/#notebook/<object_id>`:
   ```sh
   databricks api get "/api/2.0/workspace/get-status?path=/Shared/databricks-bundle/pls/<bundle>/files/notebooks/<name>" \
     --profile <stage>
   ```
3. Share it with the owning group (`LM-PLS` in the databricks repos, `LM-DIG` for DIG-owned work).
   `PUT` replaces the **direct** permissions only; the folder's inherited grants stay:
   ```sh
   databricks api put "/api/2.0/permissions/notebooks/<object_id>" --profile <stage> \
     --json '{"access_control_list":[{"group_name":"LM-PLS","permission_level":"CAN_MANAGE"}]}'
   ```
4. Verify it landed as a notebook and not a raw file: export it (`/api/2.0/workspace/export?format=SOURCE`)
   and check the first line is `# Databricks notebook source`.
5. Do every stage, then put each link on the ticket in one comment — say what it changes, how to run
   it, and whether it has been run. Never claim it ran when it did not.

A bundle-path link is not durable until the file is on the branch being deployed: a deploy from a
revision without it removes it from that folder. Say so when handing the link over.

Notebook file conventions: `# Databricks notebook source` first, then
`# flake8: noqa: E402,F821  -- notebook: <why>`, then `# MAGIC %md` prose; a `STAGE = "staging"`
config cell where the notebook is stage-specific; idempotent; and it **raises** when the effect did
not land instead of printing only. Format it before committing — the commit hook rejects unformatted
files.
