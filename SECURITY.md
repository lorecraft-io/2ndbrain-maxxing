# Security Policy — 2ndbrain-maxxing

This repo bootstraps an Obsidian vault and wires it to Claude Code. Its
credential and filesystem surface is narrow but worth being explicit about.

## Scope

`2ndbrain-maxxing` only touches:

- `~/.local/bin/cbrain`, `~/.local/bin/cbraintg` — launcher scripts.
- `~/.claude/statusline.sh` — appends a sentinel-wrapped `🧠 2ndBrain`
  segment that reads `$PWD` and prints a label when inside the vault.
- `~/.claude/` — registers the Obsidian MCP server via `claude mcp add`.
- Your Obsidian vault directory — created under `~/Desktop/WORK/OBSIDIAN/2ndBrain`
  by default (or a `VAULT_PATH` override).

Everything else on disk is untouched. `uninstall.sh` never deletes the vault.

## Credential surface

### Obsidian MCP

`step-7d-wire-vault.sh` registers an Obsidian MCP server against your vault
path. No API key is required — the server reads and writes local files under
the vault directory you point it at. The main risk is **path confusion**: if
`VAULT_PATH` is set to a directory you do not actually want Claude editing,
the MCP will happily edit it.

Mitigation:

- The launcher auto-detects a candidate vault from a fixed allowlist under
  `~/Desktop/` and `~/Documents/`. It will not traverse arbitrary paths.
- `VAULT_PATH` is an explicit opt-in — set it only when you want a
  non-default location.
- The vault directory itself should not contain `.env`, private keys, or
  production credentials. Keep secrets out of the vault.

### Telegram (cbraintg only)

`cbraintg` depends on `cli-maxxing` step-8 having configured a Telegram bot
token at `~/.claude/channels/telegram/.env`. If that file is missing or the
token is blank, `cbraintg` hard-fails with a pointer to step-8 rather than
launching. This repo never writes the token itself.

Do not commit `~/.claude/channels/telegram/.env` or its contents. The
Telegram channel gates inbound access via `/telegram:access` — follow the
channel's own allowlist rules.

### Vault files

The vault is a normal directory of Markdown. Treat it like any other
directory that could contain personal information:

- Do not commit the vault to a public repo.
- Do not paste production secrets into notes.
- Use `.gitignore` inside the vault to exclude `.env` and `credentials.json`
  even from local git history.

## Reporting a vulnerability

Open a private security advisory on the GitHub repository, or email the
maintainer listed in the repo's `README.md`. Please do not open a public
issue for anything that would expose a user's vault contents, Telegram
token, or Claude Code session.

## Related

- `cli-maxxing/SECURITY.md` — covers Claude Code install, shell hooks,
  statusline base, and the full MCP stack.
