#!/usr/bin/env bash
# Installs/updates the RTK extension for the pi coding agent.
# Re-runs whenever this script changes (e.g. rtk renamed a flag).

set -euo pipefail

if ! command -v rtk >/dev/null 2>&1; then
	echo "rtk not installed; skipping pi extension install"
	exit 0
fi

rtk init -g --agent pi --auto-patch
