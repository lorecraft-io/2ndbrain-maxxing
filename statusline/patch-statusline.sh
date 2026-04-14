#!/usr/bin/env bash
set -euo pipefail
STATUSLINE="${HOME}/.claude/statusline.sh"
BEGIN="# === 2NDBRAIN SEGMENT BEGIN ==="
END="# === 2NDBRAIN SEGMENT END ==="

[ -f "$STATUSLINE" ] || { echo "No statusline at $STATUSLINE — run cli-maxxing first."; exit 1; }
if grep -q "$BEGIN" "$STATUSLINE"; then
  echo "2ndBrain segment already present — skipping."
  exit 0
fi

cat >> "$STATUSLINE" <<'EOF'

# === 2NDBRAIN SEGMENT BEGIN ===
# Emits 🧠 2ndBrain when pwd is inside the Obsidian vault.
_2ndbrain_vault="${HOME}/Desktop/WORK/OBSIDIAN/2ndBrain"
case "$PWD" in
  "$_2ndbrain_vault"*) printf ' 🧠 2ndBrain' ;;
esac
# === 2NDBRAIN SEGMENT END ===
EOF
echo "Patched $STATUSLINE with 2ndBrain segment."
