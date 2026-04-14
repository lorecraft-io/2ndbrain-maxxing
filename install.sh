#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"

# Idempotency guard — skip if already installed
[ -x "$HOME/.local/bin/cbrain" ] && { echo "2ndbrain-maxxing already installed. Run uninstall.sh to reinstall."; exit 0; }

# Prereq check
command -v claude >/dev/null || { echo "Claude Code not found — run cli-maxxing first: https://github.com/lorecraft-io/cli-maxxing"; exit 1; }
[ -d "$HOME/.claude/skills" ] || { echo "~/.claude/skills missing — run cli-maxxing first"; exit 1; }

bash "$HERE/step-7/step-7a-setup-vault.sh"
bash "$HERE/step-7/step-7b-import-claude.sh"
bash "$HERE/step-7/step-7c-import-notes.sh"
bash "$HERE/step-7/step-7d-wire-vault.sh"
bash "$HERE/aliases/install-aliases.sh"
bash "$HERE/statusline/patch-statusline.sh"
echo "2ndbrain-maxxing install complete. Run 'cbrain' to open the vault."
