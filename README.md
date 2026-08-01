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
| Terminal   | **Ghostty**              | `.config/ghostty/`                 |
| GitHub CLI | **gh**                   | `.config/gh/`                      |
| AI skills  | **Claude + Codex**       | `.claude/skills/`, `.codex/skills/` |
| Launcher   | **Raycast**              | Encrypted settings export (not tracked) |

> Migrated from a zsh + tmux + iTerm2 + hand-rolled Neovim setup. Legacy
> configs are intentionally omitted from the current root snapshot.

## Structure

```
dotfiles/
├── .gitconfig                  # → ~/.gitconfig (identity + GPG signing)
├── .gitignore                  # Excludes machine-specific/transient files
├── README.md
├── .claude/skills/             # portable Claude skills
├── .codex/skills/              # portable Codex skills (not managed .system skills)
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
    ├── k9s/
    │   ├── config.yaml
    │   └── skins/
    ├── ghostty/
    │   ├── config
    │   └── shaders/
    │       └── shader.glsl      # custom terminal shader
    ├── nvim/                   # LazyVim
    │   ├── init.lua
    │   ├── lazy-lock.json      # plugin lockfile
    │   └── lua/{config,plugins}/
    ├── gh/
    │   └── config.yml
    └── gh-dash/
        └── config.yml
```

## Fresh machine setup

Start with Apple's command-line tools and Homebrew:

```bash
# 1. macOS build tools and Homebrew
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Core tools required by these dotfiles
brew install fish zellij jj jjui neovim gh \
             fzf zoxide eza bat ripgrep fd jq fx \
             gnupg pinentry-mac stylua tuicr cormacrelf/tap/dark-notify \
             bottom shfmt shellcheck yq dust direnv
brew install --cask ghostty raycast bitwarden font-fira-code-nerd-font codex

# 3. Install Pi
curl -fsSL https://pi.dev/install.sh | sh

# Restart the shell so Pi's install directory is on PATH, then install packages.
pi install npm:pi-claude-bridge

# 4. Make fish the login shell
echo (which fish) | sudo tee -a /etc/shells
chsh -s (which fish)

# 5. Clone, initialize jj, and link each managed tool
git clone https://github.com/mattcuento/dotfiles.git ~/.dotfiles
cd ~/.dotfiles && jj git init --colocate
mkdir -p ~/.config ~/.config/gh
mkdir -p ~/.claude/skills ~/.codex/skills
ln -s ~/.dotfiles/.config/fish ~/.config/fish
ln -s ~/.dotfiles/.config/ghostty ~/.config/ghostty
ln -s ~/.dotfiles/.config/jj ~/.config/jj
ln -s ~/.dotfiles/.config/k9s ~/.config/k9s
ln -s ~/.dotfiles/.config/nvim ~/.config/nvim
ln -s ~/.dotfiles/.config/zellij ~/.config/zellij
ln -s ~/.dotfiles/.config/gh/config.yml ~/.config/gh/config.yml
ln -s ~/.dotfiles/.config/gh-dash ~/.config/gh-dash
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.claude/skills/gh-stack ~/.claude/skills/gh-stack
ln -s ~/.dotfiles/.claude/skills/jj ~/.claude/skills/jj
ln -s ~/.dotfiles/.codex/skills/gh-stack ~/.codex/skills/gh-stack
ln -s ~/.dotfiles/.codex/skills/jj ~/.codex/skills/jj
ln -s ~/.dotfiles/.codex/skills/tuicr ~/.codex/skills/tuicr

# 6. Install fish plugins (fisher reads fish_plugins)
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
fisher update

# 7. First nvim launch installs LazyVim plugins; authenticate gh and install extensions
nvim +qa
gh auth login
gh extension install dlvhdr/gh-dash

# 8. Import the latest encrypted .rayconfig backup in Raycast
# Raycast → Settings → Advanced → Import
```

### Language toolchains

Rust is managed with `rustup`, which is the upstream-recommended installer,
rather than Homebrew's versioned `rust` formula:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup default stable
rustup component add rustfmt clippy rust-analyzer rust-src
brew install cargo-nextest
```

Install the other toolchains needed for current projects:

```bash
brew install go uv pnpm openjdk@21
```

Node is currently managed outside Homebrew with `nvm`; install the current LTS
release through `nvm` before running `pnpm`. Avoid installing a second Node
version manager unless intentionally migrating away from `nvm`.

Use one Java distribution. This setup standardizes on Homebrew's `openjdk@21`;
do not also install Temurin unless a project specifically requires it.

### Optional workstation packages

These are installed on the current Mac but are workload-specific rather than
required by the dotfiles:

```bash
# Containers, Kubernetes, and cloud tooling
brew install docker kubernetes-cli helm kubie derailed/k9s/k9s awscli
brew install --cask gcloud-cli

# Other GUI/developer applications present on the current Mac
brew install --cask google-chrome claude-code@latest
```

That's it — `git`, `jj`, `zellij`, and `ghostty` are configured the moment
their symlinks exist. Each `~/.config/<tool>` becomes a symlink into this repo;
`.gitignore` keeps the plugin/runtime files those tools write back (fisher
plugins, `jj/repos/`, nvim data) out of version control.

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

Plugins pulled in via `fish_plugins`: `fisher`, `patrickf1/fzf.fish`,
`ilancosman/tide@v6` (prompt), `catppuccin/fish` (theme), `jhillyerd/plugin-git`,
`kapsmudit/plugin-jj`.

`config.fish` sets up zoxide, option-key word navigation (tuned to avoid
colliding with zellij), and abbreviations (`vim→nvim`, `ls→eza`, `cat→bat`,
`cd→z`, `grep→rg`, plus `cargo nextest` and `kubectl` shortcuts).

### Zellij (`.config/zellij/config.kdl`)

`*.bak` backups that zellij writes next to the config are gitignored.

### jj + git (`.config/jj/config.toml`, `.gitconfig`)

`jj/config.toml` holds identity, GPG commit signing, and a `wa` alias for
workspace-add. Per-repo state under `.config/jj/repos/` is gitignored.
`.gitconfig` configures identity and GPG signing (`signingkey` is a public key
ID, safe to commit).

### Neovim (`.config/nvim/`) — LazyVim

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

### Ghostty (`.config/ghostty/`)

Fira Code Mono, size 12, `copy-on-select`, `macos-option-as-alt`. Extra themes
are listed as commented-out lines to switch between. Custom shaders live in
`.config/ghostty/shaders/` and are included automatically by the directory
symlink; the active shader is selected with `custom-shader` in `config`.

### K9s (`.config/k9s/`)

Fish sets `K9S_CONFIG_DIR=~/.config/k9s`, overriding K9s's macOS default under
`~/Library/Application Support`. The global config and skins are tracked;
runtime files generated alongside them are ignored.

### Raycast

Raycast state is intentionally not symlinked or committed. Its local config
contains access tokens, and installed Store extensions are generated runtime
data. Before migrating devices, use **Export Settings & Data** in Raycast
Settings → Advanced and save the encrypted `.rayconfig` backup somewhere
secure. On the new device, install Raycast and import that backup; it restores
installed Store extensions, hotkeys, aliases, preferences, and other selected
Raycast data.

### Claude and Codex skills

User-authored skills are tracked under `.claude/skills/` and `.codex/skills/`
and linked individually during setup. Codex's `.system` skills and all other
Claude/Codex application state are intentionally excluded because they are
managed by the applications and may contain credentials or session data.

### Pi

Pi stores global state under `~/.pi/agent/`. Package declarations are recorded
in `settings.json`, while downloaded npm packages live under
`~/.pi/agent/npm/`. Use `pi list` to see packages registered in settings and
inspect `~/.pi/agent/npm/package.json` to see their resolved npm dependencies.

Do not track `~/.pi`: it also contains `auth.json`, session history, model
caches, and generated package data. The fresh-machine setup above is the
portable package manifest; add another `pi install <source>` line there whenever
you adopt a new global Pi package. Use `pi install -l <source>` only when a
package belongs to one project, since that writes the declaration to the
project's `.pi/settings.json` instead.

## Updating & installing

Because everything is symlinked, edits are live immediately — edit the files in
this repo (or in `~/.config/...`, same thing) and commit.

```bash
# Fetch and start a new working change on the latest main
cd ~/.dotfiles
jj git fetch
jj new main@origin

# Save local changes back
jj commit -m "Update <tool> config"
jj bookmark set main -r @-
jj git push -b main

# Update fish plugins (after editing fish_plugins)
fisher update

# Update Neovim plugins, then commit the refreshed lockfile
nvim +"Lazy sync" +qa
jj commit -m "nvim: bump plugins"
jj bookmark set main -r @-
jj git push -b main

# Re-capture tide prompt settings after `tide configure`
for v in (set --names --universal | sort)
    string match -qr '^tide_' -- $v; and echo "set -U $v "(string escape -- $$v)
end > ~/.config/fish/conf.d/tide.fish
```

## What's intentionally not tracked

- Fisher-installed fish files (reinstall with `fisher update`)
- Neovim plugin data (`~/.local/share/nvim/`)
- jj per-repo state (`.config/jj/repos/`)
- Zellij `*.bak` backups
- Raycast runtime data and access tokens (migrate with encrypted export/import)
- Secrets / auth tokens (gh stores its token in the system keychain)
