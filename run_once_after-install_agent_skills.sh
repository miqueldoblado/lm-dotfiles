#!/usr/bin/env bash
# Restores the global agent skills listed in the chezmoi-managed skill lock.
# Only the lock is tracked, not the skill folders, so a fresh machine re-adds them here.

set -euo pipefail

lock="$HOME/.agents/.skill-lock.json"

command -v skills >/dev/null 2>&1 || { echo "skills CLI not installed; skipping skill restore"; exit 0; }
command -v jq >/dev/null 2>&1 || { echo "jq not installed; skipping skill restore"; exit 0; }
[ -f "$lock" ] || { echo "no skill lock at $lock; skipping skill restore"; exit 0; }

failed=0
# One `skills add` per source, carrying all of that source's tracked skill names.
while IFS=$'\t' read -r source names; do
	read -ra wanted <<<"$names"
	echo "Restoring ${#wanted[@]} skill(s) from $source"
	skills add "$source" -g -y --skill "${wanted[@]}" || failed=1
done < <(jq -r '.skills | to_entries | group_by(.value.sourceUrl)[]
	| "\(.[0].value.sourceUrl)\t\([.[].key] | join(" "))"' "$lock")

if [ "$failed" -ne 0 ]; then
	echo "Some skill sources failed to restore; rerun 'skills add <source> -g --skill <name>' by hand" >&2
	exit 1
fi
