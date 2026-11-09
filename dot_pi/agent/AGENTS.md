# Machine-wide agent instructions

Facts about this machine only. A repository's own `AGENTS.md` is the authority
on that repository: this file adds to it and never replaces it.

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
