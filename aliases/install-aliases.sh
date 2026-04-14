#!/usr/bin/env bash
# install-aliases.sh — Install cbrain + cbraintg launchers to ~/.local/bin
# Extracted from cli-maxxing/step-1/step-1-install.sh (CBRAIN_EOF + CBRAINTG_EOF
# heredocs, plus their health checks). VAULT_PATH detection is preserved
# inside each launcher.
#
# Prereq: cli-maxxing must be installed first. This script does NOT install
# ~/.local/bin into PATH — cli-maxxing's step-1 already handles that.
# Prereq for cbraintg specifically: cli-maxxing step-8 (Telegram) must be
# configured so that ~/.claude/channels/telegram/.env holds a bot token.

set -euo pipefail

# -----------------------------------------------------------------------------
# Minimal status helpers (no color, no interactive prompts)
# -----------------------------------------------------------------------------
info()     { echo "  [info] $*"; }
success()  { echo "  [ ok ] $*"; }
soft_fail() { echo "  [fail] $*" >&2; }

mkdir -p "$HOME/.local/bin"

# -----------------------------------------------------------------------------
# Install cbrain command (2ndBrain + skip-permissions)
# Source: cli-maxxing/step-1/step-1-install.sh lines 268–299
# -----------------------------------------------------------------------------
info "Installing cbrain command to ~/.local/bin..."
cat > "$HOME/.local/bin/cbrain" << 'CBRAIN_EOF'
#!/usr/bin/env bash
# cbrain — Launch Claude Code in 2ndBrain Obsidian vault with full permissions
# Check VAULT_PATH env var first, then fall back to candidate list
if [ -n "${VAULT_PATH:-}" ] && [ -d "$VAULT_PATH" ]; then
  VAULT="$VAULT_PATH"
else
  for candidate in \
      "$HOME/Desktop/WORK/OBSIDIAN/2ndBrain" \
      "$HOME/Desktop/2ndBrain" \
      "$HOME/Desktop/Second-Brain" \
      "$HOME/Desktop/Vault" \
      "$HOME/Documents/2ndBrain" \
      "$HOME/Documents/Second-Brain"; do
    if [ -d "$candidate" ]; then
      VAULT="$candidate"
      break
    fi
  done
fi

if [ -z "${VAULT:-}" ]; then
  echo "Error: Could not find your 2ndBrain vault."
  echo "Run Step 7 first, or set VAULT_PATH: VAULT_PATH=~/path/to/vault cbrain"
  exit 1
fi
cd "$VAULT" && exec claude --dangerously-skip-permissions "$@"
CBRAIN_EOF
chmod +x "$HOME/.local/bin/cbrain"
success "cbrain command installed to ~/.local/bin/cbrain"

# -----------------------------------------------------------------------------
# Install cbraintg command (cbrain + Telegram channel)
# Source: cli-maxxing/step-1/step-1-install.sh lines 327–374
# -----------------------------------------------------------------------------
info "Installing cbraintg command to ~/.local/bin..."
cat > "$HOME/.local/bin/cbraintg" << 'CBRAINTG_EOF'
#!/usr/bin/env bash
# cbraintg — Launch Claude Code in 2ndBrain vault with full permissions + Telegram
# Checks for a valid bot token before launching to avoid an infinite warning loop

TOKEN_FILE="$HOME/.claude/channels/telegram/.env"

if [ ! -f "$TOKEN_FILE" ] || ! grep -qE 'TELEGRAM_BOT_TOKEN=.+' "$TOKEN_FILE" 2>/dev/null; then
  echo ""
  echo "Telegram bot token not configured."
  echo "Run Step 8 to set it up:"
  echo ""
  echo "  bash <(curl -fsSL https://raw.githubusercontent.com/lorecraft-io/cli-maxxing/main/step-8/step-8-install.sh)"
  echo ""
  echo "Or use 'cbrain' to launch without Telegram."
  echo ""
  exit 1
fi

# Check VAULT_PATH env var first, then fall back to candidate list
if [ -n "${VAULT_PATH:-}" ] && [ -d "$VAULT_PATH" ]; then
  VAULT="$VAULT_PATH"
else
  for candidate in \
      "$HOME/Desktop/WORK/OBSIDIAN/2ndBrain" \
      "$HOME/Desktop/2ndBrain" \
      "$HOME/Desktop/Second-Brain" \
      "$HOME/Desktop/Vault" \
      "$HOME/Documents/2ndBrain" \
      "$HOME/Documents/Second-Brain"; do
    if [ -d "$candidate" ]; then
      VAULT="$candidate"
      break
    fi
  done
fi

if [ -z "${VAULT:-}" ]; then
  echo "Error: Could not find your 2ndBrain vault."
  echo "Run Step 7 first, or set VAULT_PATH: VAULT_PATH=~/path/to/vault cbraintg"
  exit 1
fi
cd "$VAULT" && exec claude --dangerously-skip-permissions --channels plugin:telegram@claude-plugins-official "$@"
CBRAINTG_EOF
chmod +x "$HOME/.local/bin/cbraintg"
success "cbraintg command installed to ~/.local/bin/cbraintg"

# -----------------------------------------------------------------------------
# Health checks
# Source: cli-maxxing/step-1/step-1-install.sh lines 448–454 (cbrain) +
#         lines 466–471 (cbraintg)
# -----------------------------------------------------------------------------

# cbrain command
if [ -x "$HOME/.local/bin/cbrain" ]; then
    success "TEST: cbrain command — installed at ~/.local/bin/cbrain"
else
    soft_fail "TEST: cbrain command — not found or not executable"
fi

# cbraintg command
if [ -x "$HOME/.local/bin/cbraintg" ]; then
    success "TEST: cbraintg command — installed at ~/.local/bin/cbraintg"
else
    soft_fail "TEST: cbraintg command — not found or not executable"
fi
