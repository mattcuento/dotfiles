# Dotfiles

Personal configuration files using the **mirror home directory pattern**: this
repo mirrors `~` so setup is a matter of symlinking `.config/` (and a couple of
root-level files) into place.

## The stack

| Area       | Tool                     | Config location                    |
| ---------- | ------------------------ | ---------------------------------- |
| Shell      | **fish** (+ tide, fzf.fish) | `.config/fish/`                 |
| Multiplexer| **zellij**               | `.config/zellij/config.kdl`        |
| VCS        | **git** + **jujutsu (jj)** | `.gitconfig`, `.config/jj/config.toml` |
| Editor     | **Neovim** (LazyVim)     | `.config/nvim/`                    |
| Terminal   | **Ghostty**              | `.config/ghostty/config`           |
| GitHub CLI | **gh**                   | `.config/gh/`                      |

> Migrated from a zsh + tmux + iTerm2 + hand-rolled Neovim setup. The old
> configs live in git history on `main` if you ever need them.

## Structure

```
dotfiles/
├── .gitconfig                  # → ~/.gitconfig (identity + GPG signing)
├── .gitignore                  # Excludes machine-specific/transient files
├── README.md
└── .config/                    # → ~/.config/
    ├── fish/                   # fish shell (lockfile-only, see below)
    │   ├── config.fish
    │   ├── fish_plugins        # fisher plugin manifest
    │   └── conf.d/
    │       └── tide.fish       # tide prompt config, tracked as code
    ├── zellij/
    │   └── config.kdl
    ├── jj/
    │   └── config.toml
    ├── ghostty/
    │   └── config
    ├── nvim/                   # LazyVim
    │   ├── init.lua
    │   ├── lazy-lock.json      # plugin lockfile
    │   └── lua/{config,plugins}/
    └── gh/
        ├── config.yml
        └── hosts.yml
```

## Quick setup on a new machine

```bash
# 1. Clone
git clone <repo-url> ~/.dotfiles
cd ~/.dotfiles

# 2. Symlink into home (GNU Stow, recommended)
brew install stow
stow -t ~ .

# ...or manually, per tool:
#   ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
#   ln -s ~/.dotfiles/.config/fish ~/.config/fish   (etc.)
```

Then install the tools and their plugins (below).

## Per-tool notes

### Fish (`.config/fish/`)

Tracked **lockfile-only**: `config.fish`, `fish_plugins`, and
`conf.d/tide.fish`. Everything else under `functions/`, `conf.d/`,
`completions/`, and `themes/` is installed by
[fisher](https://github.com/jorgebucaran/fisher) and is gitignored
(re-downloadable).

**Tide prompt config** is *not* stored via fish's `fish_variables` blob (opaque
and non-portable). Tide has no config file of its own — it only keeps state in
universal variables — so the settings are exported as `set -U` commands into
`conf.d/tide.fish`, which fish auto-sources on startup. To capture new tweaks
after running `tide configure`, regenerate it:

```fish
for v in (set --names --universal | sort)
    string match -qr '^tide_' -- $v; and echo "set -U $v "(string escape -- $$v)
end > ~/.config/fish/conf.d/tide.fish
```

Note: because these are applied on every shell start, ad-hoc `tide configure`
changes are overwritten on the next shell unless you regenerate the file.

```bash
brew install fish fzf zoxide eza bat ripgrep

# Install fisher, then all plugins from fish_plugins:
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
fisher update
```

Plugins pulled in via `fish_plugins`: `fisher`, `patrickf1/fzf.fish`,
`ilancosman/tide@v6` (prompt), `catppuccin/fish` (theme), `jhillyerd/plugin-git`,
`kapsmudit/plugin-jj`.

`config.fish` sets up zoxide, option-key word navigation (tuned to avoid
colliding with zellij), and abbreviations (`vim→nvim`, `ls→eza`, `cat→bat`,
`cd→z`, `grep→rg`, plus `cargo nextest` and `kubectl` shortcuts).

### Zellij (`.config/zellij/config.kdl`)

```bash
brew install zellij
```

`*.bak` backups that zellij writes next to the config are gitignored.

### jj + git (`.config/jj/config.toml`, `.gitconfig`)

```bash
brew install jj
```

`jj/config.toml` holds identity, GPG commit signing, and a `wa` alias for
workspace-add. Per-repo state under `.config/jj/repos/` is gitignored.
`.gitconfig` configures identity and GPG signing (`signingkey` is a public key
ID, safe to commit).

### Neovim (`.config/nvim/`) — LazyVim

```bash
brew install neovim
nvim   # LazyVim bootstraps and installs plugins on first launch
```

Standard [LazyVim](https://www.lazyvim.org/) layout: `lua/config/` for core
settings, `lua/plugins/` for plugin specs (gruvbox, mini, multicursor,
obsidian, ...). `lazy-lock.json` pins versions; plugin data lives in
`~/.local/share/nvim/` (outside this repo).

**LazyVim extras enabled** (in `lazyvim.json`):

| Category | Extra                | What it adds                          |
| -------- | -------------------- | ------------------------------------- |
| AI       | `ai.claudecode`      | Claude Code integration               |
| Editor   | `editor.dial`        | Smart increment/decrement (`<C-a>/<C-x>`) |
| Editor   | `editor.fzf`         | fzf-lua as the fuzzy finder           |
| Editor   | `editor.inc-rename`  | Incremental LSP rename with live preview |
| Editor   | `editor.snacks_picker` | snacks.nvim picker                  |
| Lang     | `lang.go`            | Go (gopls, formatting, DAP)           |
| Lang     | `lang.java`          | Java (jdtls)                          |
| Lang     | `lang.json`          | JSON schemas + LSP                    |
| Lang     | `lang.markdown`      | Markdown tooling                      |
| Lang     | `lang.python`        | Python (pyright/ruff, DAP)            |
| Lang     | `lang.rust`          | Rust (rust-analyzer, crates)          |
| Lang     | `lang.sql`           | SQL LSP + formatting                  |
| Lang     | `lang.toml`          | TOML LSP                              |
| Lang     | `lang.typescript`    | TypeScript/JavaScript                 |
| Lang     | `lang.yaml`          | YAML schemas + LSP                    |
| Test     | `test.core`          | neotest test runner                   |
| Util     | `util.dot`           | Dotfiles editing helpers              |
| Util     | `util.octo`          | GitHub issues/PRs via octo.nvim       |

Manage these with `:LazyExtras` inside Neovim.

### Ghostty (`.config/ghostty/config`)

```bash
brew install --cask ghostty
```

Fira Code Mono, size 12, `copy-on-select`, `macos-option-as-alt`. Extra themes
are listed as commented-out lines to switch between.

## Syncing

Configs are symlinked, so `git pull` makes changes live immediately. To capture
local changes, edit the files in this repo (or in `~/.config/...` if symlinked)
and commit:

```bash
cd ~/.dotfiles
git add -A && git commit -m "Update <tool> config" && git push
```

## What's intentionally not tracked

- Fisher-installed fish files (reinstall with `fisher update`)
- Neovim plugin data (`~/.local/share/nvim/`)
- jj per-repo state (`.config/jj/repos/`)
- Zellij `*.bak` backups
- Secrets / auth tokens (gh stores its token in the system keychain)
