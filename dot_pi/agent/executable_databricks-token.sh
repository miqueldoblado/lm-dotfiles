#!/usr/bin/env bash
# Print the Authorization header value (Bearer <token>) for a DATABRICKS profile.
# Reads the PAT out of ~/.databrickscfg (or $DATABRICKS_CONFIG_FILE).
# Usage: databricks-token.sh <profile>
set -euo pipefail

profile="${1:?usage: databricks-token.sh <profile>}"
cfg="${DATABRICKS_CONFIG_FILE:-$HOME/.databrickscfg}"

[[ -r "$cfg" ]] || { echo "cannot read $cfg" >&2; exit 1; }

token="$(
  awk -v s="$profile" '
    /^\[/ { f = ($0 == "[" s "]") }
    f && $0 ~ /^[ \t]*token[ \t]*=/ {
      sub(/^[ \t]*token[ \t]*=[ \t]*/, ""); sub(/[ \t\r]+$/, ""); print; exit
    }' "$cfg"
)"

[[ -n "$token" ]] || { echo "no token for profile '$profile' in $cfg" >&2; exit 1; }

printf 'Bearer %s' "$token"
