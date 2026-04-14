# 2ndbrain-maxxing

Opinionated Obsidian vault bootstrap for Claude Code. Ships the vault tree,
wires in the Obsidian MCP server, and installs two launchers (`cbrain` +
`cbraintg`) plus a statusline segment so Claude Code knows when it is
working inside your second brain.

This repo is the vault layer of the `cli-maxxing` stack. It assumes
`cli-maxxing` is already installed.

## Prerequisite

> **Prereq: cli-maxxing** — install [`cli-maxxing`](https://github.com/lorecraft-io/cli-maxxing) first.

You must install `cli-maxxing`
**first**. `2ndbrain-maxxing` is a thin extension — it does not install
Claude Code, the base alias set, the statusline, or the Telegram channel on
its own.

The install script hard-fails if:

- `claude` is not on `PATH`
- `~/.claude/skills` does not exist

If you see either error, run `cli-maxxing` through step-1 (at minimum) and,
if you want `cbraintg`, step-8 as well.

## Install

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/lorecraft-io/2ndbrain-maxxing/main/install.sh)
```

Or, from a local clone:

```bash
git clone https://github.com/lorecraft-io/2ndbrain-maxxing.git
cd 2ndbrain-maxxing
bash install.sh
```

When it finishes, run `cbrain` to open Claude Code inside the vault.

## Update

To pull the latest version and re-run all idempotent steps:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/lorecraft-io/2ndbrain-maxxing/main/update.sh)
```

## What gets installed

The install script runs four vault-bootstrap steps, then two wiring scripts:

| Script | Purpose |
|---|---|
| `step-7/step-7a-setup-vault.sh` | Creates the `2ndBrain/` tree (00-Inbox, 01-Fleeting, …, 08-Tasks) with templates, CLAUDE.md, and starter MOCs |
| `step-7/step-7b-import-claude.sh` | Imports your Claude projects into `07-Projects/` so Claude Code has context |
| `step-7/step-7c-import-notes.sh` | Imports any existing Markdown notes into the appropriate vault folder |
| `step-7/step-7d-wire-vault.sh` | Registers the Obsidian MCP server against the vault path |
| `aliases/install-aliases.sh` | Writes `~/.local/bin/cbrain` and `~/.local/bin/cbraintg` launchers |
| `statusline/patch-statusline.sh` | Appends a sentinel-wrapped `🧠 2ndBrain` segment to `~/.claude/statusline.sh` |

### Launchers

- **`cbrain`** — `cd` into the vault and launch Claude Code with
  `--dangerously-skip-permissions`. Honors `VAULT_PATH`; otherwise searches
  a fixed allowlist under `~/Desktop/` and `~/Documents/`.
- **`cbraintg`** — same as `cbrain` plus the Telegram channel
  (`plugin:telegram@claude-plugins-official`). Requires `cli-maxxing` step-8
  to have set up `~/.claude/channels/telegram/.env`.

### Statusline

The patch is idempotent and sentinel-wrapped:

```
# === 2NDBRAIN SEGMENT BEGIN ===
...
# === 2NDBRAIN SEGMENT END ===
```

Running it twice is a no-op. If `~/.claude/statusline.sh` does not exist,
the patcher hard-fails with a pointer to `cli-maxxing` rather than writing
a new statusline from scratch.

## Custom vault location

To install the vault somewhere other than `~/Desktop/WORK/OBSIDIAN/2ndBrain`:

```bash
VAULT_PATH="$HOME/path/to/vault" bash install.sh
```

The launchers also honor `VAULT_PATH` at runtime:

```bash
VAULT_PATH="$HOME/path/to/vault" cbrain
```

## Uninstall

```bash
bash uninstall.sh
```

This:

- Removes the Obsidian MCP registration (`claude mcp remove obsidian`)
- Deletes the `cbrain` and `cbraintg` launcher scripts
- Strips the sentinel-wrapped `🧠 2ndBrain` segment from your statusline
  (everything else in the statusline is untouched)

**Your vault is NOT touched.** If you want to delete the vault directory,
do it yourself.

## Relationship to `cli-maxxing`

`cli-maxxing` owns:

- Claude Code install + base aliases (`cskip`, `cc`, `ccr`, `ccc`, `ctg`)
- Statusline base file
- Productivity MCPs (Notion, Granola, n8n, Morgen, Motion, etc.)
- Telegram channel (step-8)

`2ndbrain-maxxing` owns:

- Vault tree bootstrap (step-7a through 7d)
- `cbrain` + `cbraintg` launchers
- `🧠 2ndBrain` statusline segment
- Obsidian MCP registration

Existing users on older `cli-maxxing` installs (before the split) already
have these files on disk. The installer and the statusline patcher are
both idempotent, so re-running them on top of an existing install is safe
— they detect "already present" and skip.

## The Trilogy

This is one of three repos in the cli-maxxing stack:

| Repo | What it does |
|------|-------------|
| [`cli-maxxing`](https://github.com/lorecraft-io/cli-maxxing) | Foundation — Claude Code, shell aliases, Ruflo, dev tools, productivity MCPs |
| [`creativity-maxxing`](https://github.com/lorecraft-io/creativity-maxxing) | Design skills + video/audio pipeline |
| **`2ndbrain-maxxing`** | **This repo** — Obsidian PKM vault setup, cbrain/cbraintg commands |

Install `cli-maxxing` first. `2ndbrain-maxxing` and `creativity-maxxing` can be installed in either order after that.

---

## License

MIT. See `LICENSE`.
