## Agent skills

### Issue tracker

Issues and specs live as local markdown files under `.scratch/<feature-slug>/`. See `docs/agents/issue-tracker.md`.

### Triage labels

The five canonical triage roles, recorded on each issue file's `Status:` line. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: `GLOSSARY.md` and `docs/adr/` at the repo root. See `docs/agents/domain.md`.

## Chezmoi-managed files

Everything under a `dot_` prefix maps into `$HOME`, so the installed copy is a
target and this repo is the source. Edit the source here and let `chezmoi apply`
write it out. An edit made to the installed path alone is drift the next apply
discards — `~/.agents/skills/orchestrate/` in particular is read by a running
agent, which is how an edit lands in the wrong copy. Check with
`chezmoi status <target>` before trusting either side.
