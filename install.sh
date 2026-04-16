#!/usr/bin/env bash
set -euo pipefail

# Idempotency guard — skip if already installed
[ -x "$HOME/.local/bin/cbrain" ] && { echo "2ndbrain-maxxing already installed. Run uninstall.sh to reinstall."; exit 0; }

# Prereq check
command -v claude >/dev/null || { echo "Claude Code not found — run cli-maxxing first: https://github.com/lorecraft-io/cli-maxxing"; exit 1; }
[ -d "$HOME/.claude/skills" ] || { echo "\$HOME/.claude/skills missing — run cli-maxxing first"; exit 1; }

# Resolve repo root — works from local clone AND bash <(curl ...)
HERE="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
if [ ! -f "$HERE/step-7/step-7a-setup-vault.sh" ]; then
    _TMPDIR="$(mktemp -d)"
    trap 'rm -rf "$_TMPDIR"' EXIT
    git clone --quiet --depth 1 https://github.com/lorecraft-io/2ndbrain-maxxing.git "$_TMPDIR"
    HERE="$_TMPDIR"
fi

bash "$HERE/step-7/step-7a-setup-vault.sh"
bash "$HERE/step-7/step-7b-import-claude.sh"
bash "$HERE/step-7/step-7c-import-notes.sh"
bash "$HERE/step-7/step-7d-wire-vault.sh"
bash "$HERE/aliases/install-aliases.sh"
bash "$HERE/statusline/patch-statusline.sh"
echo "2ndbrain-maxxing install complete. Run 'cbrain' to open the vault."
