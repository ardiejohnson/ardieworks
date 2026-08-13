#!/usr/bin/env bash
# Sync the canonical ArdieWorks agency into the app-template repo, so every
# future app is born with the current agents, skills, conventions, CI check,
# permissions allowlist, and HomeButton baked in.
#
# Usage:  ./scripts/sync-template.sh /path/to/app-template-checkout
# Then review the diff in app-template, commit on a branch, and PR as usual.
# (The sync-template GitHub Action runs this automatically on pushes to main
# when the TEMPLATE_SYNC_TOKEN secret is configured — see the workflow file.)

set -euo pipefail

TEMPLATE="${1:?Usage: sync-template.sh /path/to/app-template-checkout}"
HQ="$(cd "$(dirname "$0")/.." && pwd)"

[ -d "$TEMPLATE/.git" ] || { echo "error: $TEMPLATE is not a git checkout"; exit 1; }

# Agents + conventions
mkdir -p "$TEMPLATE/.claude/agents"
cp "$HQ"/plugins/ardieworks/agents/*.md "$TEMPLATE/.claude/agents/"
cp "$HQ/CLAUDE.md" "$TEMPLATE/CLAUDE.md"

# Skills (previously missed — web sessions in app repos need these too)
mkdir -p "$TEMPLATE/.claude/skills"
for skill in "$HQ"/plugins/ardieworks/skills/*/; do
  name="$(basename "$skill")"
  mkdir -p "$TEMPLATE/.claude/skills/$name"
  cp "$skill"SKILL.md "$TEMPLATE/.claude/skills/$name/SKILL.md"
done

# Permissions allowlist (fewer prompts in template-born repos)
cp "$HQ/template/.claude/settings.json" "$TEMPLATE/.claude/settings.json"

# CI check — makes "checks are green" enforceable on every PR
mkdir -p "$TEMPLATE/.github/workflows"
cp "$HQ/template/.github/workflows/ci.yml" "$TEMPLATE/.github/workflows/ci.yml"

# The portfolio-standard back-to-home pill, as real files
mkdir -p "$TEMPLATE/src"
cp "$HQ/template/src/HomeButton.tsx" "$TEMPLATE/src/HomeButton.tsx"
cp "$HQ/template/home-button.html" "$TEMPLATE/home-button.html"

echo "Synced agents + skills + CLAUDE.md + settings + CI + HomeButton -> $TEMPLATE"
echo "Next: cd $TEMPLATE && git checkout -b sync-ardieworks && git diff"
