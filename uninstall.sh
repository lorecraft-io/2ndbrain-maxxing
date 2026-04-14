#!/usr/bin/env bash
set -euo pipefail
claude mcp remove obsidian 2>/dev/null || true
rm -f "$HOME/.local/bin/cbrain" "$HOME/.local/bin/cbraintg"
STATUSLINE="${HOME}/.claude/statusline.sh"
if [ -f "$STATUSLINE" ] && grep -q "# === 2NDBRAIN SEGMENT BEGIN ===" "$STATUSLINE"; then
  tmp="$(mktemp)"
  awk '/# === 2NDBRAIN SEGMENT BEGIN ===/{flag=1} !flag; /# === 2NDBRAIN SEGMENT END ===/{flag=0; next}' \
    "$STATUSLINE" > "$tmp" && mv "$tmp" "$STATUSLINE"
  echo "Removed 2ndBrain segment from statusline."
fi
echo "Uninstall complete. Your Obsidian notes were NOT touched."
