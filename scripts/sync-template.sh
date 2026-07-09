#!/usr/bin/env bash
# Sync the canonical ArdieWorks agents + CLAUDE.md into the app-template repo,
# so every future app is born with the current agency baked in.
#
# Usage:  ./scripts/sync-template.sh /path/to/app-template-checkout
# Then review the diff in app-template, commit on a branch, and PR as usual.

set -euo pipefail

TEMPLATE="${1:?Usage: sync-template.sh /path/to/app-template-checkout}"
HQ="$(cd "$(dirname "$0")/.." && pwd)"

[ -d "$TEMPLATE/.git" ] || { echo "error: $TEMPLATE is not a git checkout"; exit 1; }

mkdir -p "$TEMPLATE/.claude/agents"
cp "$HQ"/plugins/ardieworks/agents/*.md "$TEMPLATE/.claude/agents/"
cp "$HQ/CLAUDE.md" "$TEMPLATE/CLAUDE.md"

echo "Synced agents + CLAUDE.md from ardieworks -> $TEMPLATE"
echo "Next: cd $TEMPLATE && git checkout -b sync-ardieworks && git diff"
