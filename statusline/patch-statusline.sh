#!/usr/bin/env bash
set -euo pipefail
STATUSLINE="${HOME}/.claude/statusline.sh"
BEGIN="# === 2NDBRAIN SEGMENT BEGIN ==="
# shellcheck disable=SC2034  # referenced inside the python heredoc below
END="# === 2NDBRAIN SEGMENT END ==="

[ -f "$STATUSLINE" ] || { echo "No statusline at $STATUSLINE — run cli-maxxing first."; exit 1; }
if grep -q "$BEGIN" "$STATUSLINE"; then
  echo "2ndBrain segment already present — skipping."
  exit 0
fi

# Insert the segment before the final output line so PARTS and CWD are in scope.
python3 - "$STATUSLINE" <<'PYEOF'
import sys, re
path = sys.argv[1]
content = open(path).read()
segment = (
    "\n# === 2NDBRAIN SEGMENT BEGIN ===\n"
    "# Emits \U0001f9e0 2ndBrain when Claude Code workspace is inside the Obsidian vault.\n"
    '_2ndbrain_vault="${VAULT_PATH:-${HOME}/Desktop/WORK/OBSIDIAN/2ndBrain}"\n'
    'case "${CWD:-}" in\n'
    '  "$_2ndbrain_vault"*) PARTS+=" \U0001f9e0 2ndBrain" ;;\n'
    "esac\n"
    "# === 2NDBRAIN SEGMENT END ===\n"
)
# Insert just before the final output echo line
marker = 'echo "${PARTS}'
idx = content.rfind(marker)
if idx < 0:
    print("ERROR: Could not find PARTS output line in statusline.sh", file=sys.stderr)
    sys.exit(1)
line_start = content.rfind('\n', 0, idx) + 1
patched = content[:line_start] + segment + content[line_start:]
open(path, 'w').write(patched)
PYEOF
echo "Patched $STATUSLINE with 2ndBrain segment."
