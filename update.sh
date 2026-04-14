#!/usr/bin/env bash
set -euo pipefail
# 2ndbrain-maxxing — Update
# Clones the latest version and re-runs all idempotent steps.

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  2ndbrain-maxxing — Update${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

_TMPDIR="$(mktemp -d)"
trap 'rm -rf "$_TMPDIR"' EXIT
git clone --quiet --depth 1 https://github.com/lorecraft-io/2ndbrain-maxxing.git "$_TMPDIR"

bash "$_TMPDIR/step-7/step-7a-setup-vault.sh"
bash "$_TMPDIR/step-7/step-7b-import-claude.sh"
bash "$_TMPDIR/step-7/step-7c-import-notes.sh"
bash "$_TMPDIR/step-7/step-7d-wire-vault.sh"
bash "$_TMPDIR/aliases/install-aliases.sh"
bash "$_TMPDIR/statusline/patch-statusline.sh"

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  2ndbrain-maxxing update complete.${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
