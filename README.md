# Dotfiles

Personal configuration files using the mirror home directory pattern. This repository mirrors your home directory structure, making setup simple and intuitive.

## Structure

```
dotfiles/
├── .gitignore              # Excludes machine-specific/transient files
├── .gitconfig              # → ~/.gitconfig (git user identity)
├── README.md               # This file
├── .claude/                # → ~/.claude/
│   ├── CLAUDE.md          # User preferences and guidelines
│   ├── settings.json      # Global settings
│   └── plugins/
│       └── dev-suite/     # Custom development plugin
├── .config/                # → ~/.config/
│   ├── git/
│   │   └── ignore         # Global gitignore patterns
│   └── nvim/              # Neovim configuration
│       ├── init.lua       # Main config file
│       ├── lazy-lock.json # Plugin lockfile
│       └── lua/
│           ├── vim-options.lua
│           └── plugins/   # Plugin configurations
├── .tmux.conf              # → ~/.tmux.conf
└── .tmux/                  # → ~/.tmux/
    └── plugins/
        └── tpm/           # Tmux Plugin Manager (submodule)
```

**Mapping**: The directory structure mirrors your home directory exactly.

- `dotfiles/.claude/` → `~/.claude/`
- `dotfiles/.config/git/` → `~/.config/git/`
- `dotfiles/.gitconfig` → `~/.gitconfig`
- `dotfiles/.tmux.conf` → `~/.tmux.conf`
- `dotfiles/.tmux/` → `~/.tmux/`

## Quick Setup

### Option 1: Using GNU Stow (Recommended)

[GNU Stow](https://www.gnu.org/software/stow/) automatically creates symlinks based on directory structure.

```bash
# Install stow (if needed)
brew install stow  # macOS
# or: apt install stow  # Linux

# Clone and setup
git clone <your-repo-url> ~/Development/dotfiles
cd ~/Development/dotfiles

# Backup existing configs (optional but recommended)
mv ~/.claude ~/.claude.backup

# Create all symlinks automatically
stow -t ~ .
```

**What stow does:**

- Creates `~/.claude` → `~/Development/dotfiles/.claude`
- Creates `~/.config` → `~/Development/dotfiles/.config`
- Handles all nested files and directories automatically

### Option 2: Manual Symlinks

If you prefer manual control or don't want to use stow:

```bash
# Clone repository
git clone <your-repo-url> ~/Development/dotfiles

# Backup existing configs (optional)
mv ~/.claude ~/.claude.backup

# Create symlinks
ln -s ~/Development/dotfiles/.claude ~/.claude
ln -s ~/Development/dotfiles/.config ~/.config

# Or symlink individual files/directories as needed
```

### Verification

```bash
# Check symlinks
ls -la ~ | grep '\->'

# Should show:
# .claude -> /Users/you/Development/dotfiles/.claude
# .config -> /Users/you/Development/dotfiles/.config

# Test Claude
claude --version
```

## What's Included

### Claude Configuration (`.claude/`)

**Versioned (Portable):**

- `CLAUDE.md` - Personal preferences and development guidelines
- `settings.json` - Global settings (permissions, plugins, model)
- `plugins/dev-suite/` - Custom local plugin with 5 specialized agents

**Ignored (Machine-Specific):**

- `settings.local.json` - Machine-specific overrides
- `history.jsonl` - Command history
- `projects/` - Project data with absolute paths
- `cache/`, `downloads/`, `todos/` - Transient data
- Plugin marketplace cache

See `.gitignore` for the complete exclusion list.

### Claude Dev-Suite Plugin

Custom plugin with 5 specialized development agents:

1. **system-architect** (Blue, Sonnet) - System architecture and SOLID principles
2. **feature-planner** (Cyan, Sonnet) - Implementation plans with TDD approach
3. **implementation-dev** (Green, Haiku) - TDD implementation with minimal code
4. **qa-tester** (Yellow, Haiku) - Comprehensive testing and validation
5. **code-reviewer** (Red, Sonnet) - Quality review and SOLID compliance

**Usage:**

```bash
/dev-suite:dev-workflow    # Complete development lifecycle
/dev-suite:design-review   # Architecture and design review
```

See `.claude/plugins/dev-suite/README.md` for complete documentation.

### Tmux Configuration (`.tmux.conf` + `.tmux/`)

**Versioned (Portable):**

- Main configuration file (`.tmux.conf`)
- TPM (Tmux Plugin Manager) - included as git submodule
- Custom prefix key: `Ctrl-Space` (instead of default `Ctrl-b`)
- Vi-style pane navigation (`h/j/k/l`)
- Mouse support enabled
- Catppuccin Mocha theme with status modules
- Plugin declarations

**Auto-Downloaded (Not Versioned):**

- Plugins managed by TPM (catppuccin, tmux-sensible, vim-tmux-navigator)
- Installed to `~/.tmux/plugins/` on first use

#### First-Time Setup on New Machine

**1. Clone with submodules:**

```bash
git clone --recurse-submodules <repo-url> ~/Development/dotfiles
# TPM is automatically included!
```

**2. Create symlinks:**

```bash
cd ~/Development/dotfiles
stow -t ~ .

# Or manually:
ln -s ~/Development/dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/Development/dotfiles/.tmux ~/.tmux
```

**3. Start tmux:**

```bash
tmux
```

**4. Install plugins:**
Press `Ctrl-Space + I` (that's capital I) inside tmux. TPM will automatically download:

- Catppuccin theme (v2.1.3)
- tmux-sensible (sensible defaults)
- vim-tmux-navigator (seamless vim/tmux navigation)

**5. Verify setup:**

- Status bar should show Catppuccin Mocha theme
- Try `Ctrl-Space + h/j/k/l` to navigate between panes
- Mouse clicks should work for pane selection

#### Key Bindings

**Important:** This config uses `Ctrl-Space` as the prefix key (not the default `Ctrl-b`).

| Keybinding             | Action                                    |
| ---------------------- | ----------------------------------------- |
| `Ctrl-Space`           | Prefix key (all commands start with this) |
| `Ctrl-Space + r`       | Reload tmux configuration                 |
| `Ctrl-Space + h/j/k/l` | Navigate panes (left/down/up/right)       |
| `Ctrl-Space + c`       | Create new window                         |
| `Ctrl-Space + I`       | Install/update plugins (capital I)        |

#### Troubleshooting

**TPM not found:**

```bash
# Check if submodules were initialized
ls ~/.tmux/plugins/tpm/

# If missing, initialize submodules:
cd ~/Development/dotfiles
git submodule update --init --recursive
```

**Plugins not installing:**

```bash
# Ensure TPM is present, then inside tmux:
# Press: Ctrl-Space + I (capital I)

# If that doesn't work, source the config manually:
tmux source ~/.tmux.conf
# Then press: Ctrl-Space + I
```

**Theme not loading:**

```bash
# Kill tmux server and restart
tmux kill-server
tmux

# Press: Ctrl-Space + I (to reinstall plugins)
```

**Wrong prefix key:**
If you're pressing `Ctrl-b` and nothing happens, remember this config uses `Ctrl-Space`.

### Git Configuration (`.gitconfig` + `.config/git/`)

**Versioned (Portable):**

- `.gitconfig` - User identity (name and email)
- `.config/git/ignore` - Global gitignore patterns

**What's included:**

- User name and email configuration
- Global gitignore for `.claude/settings.local.json`

**Setup on new machine:**
The symlinks created by stow or manual linking will automatically configure git with your identity and global ignores.

**Verify setup:**

```bash
git config --global user.name
git config --global user.email
```

**Note:** If you need machine-specific git config, you can create `~/.gitconfig.local` and include it in your main `.gitconfig`:

```ini
[include]
    path = ~/.gitconfig.local
```

### Neovim Configuration (`.config/nvim/`)

**Versioned (Portable):**

- `init.lua` - Main configuration with lazy.nvim bootstrap
- `lua/vim-options.lua` - Core vim settings (tabs, navigation, line numbers)
- `lua/plugins/*.lua` - Plugin configurations
- `lazy-lock.json` - Plugin version lockfile
- `.luarc.json` - Lua language server configuration

**Plugin Manager:**

- **lazy.nvim** - Modern plugin manager with lazy loading
- Automatically bootstraps itself on first run (no manual installation needed)
- Plugins are declared in `lua/plugins/*.lua` files

**Included Plugins:**

- **catppuccin** - Catppuccin color scheme
- **nvim-lspconfig** - LSP configurations
- **nvim-cmp** - Autocompletion
- **telescope** - Fuzzy finder
- **treesitter** - Syntax highlighting and parsing
- **neo-tree** - File explorer
- **copilot** - GitHub Copilot integration (via vim-plug/pack)
- **lualine** - Status line
- **none-ls** - Formatting and linting
- **nvim-java** - Java language support
- **vim-test** - Test runner integration

**Auto-Downloaded (Not Versioned):**

- Plugin data stored in `~/.local/share/nvim/lazy/`
- Native vim packages in `.config/nvim/pack/` (like Copilot)
- Both are gitignored and auto-installed on first run

**Setup on new machine:**

1. **Create symlink:**

```bash
ln -s ~/Development/dotfiles/.config/nvim ~/.config/nvim
```

2. **Open Neovim:**

```bash
nvim
```

3. **Plugins auto-install:**
   Lazy.nvim will automatically bootstrap and install all plugins on first run. Just wait for the installation to complete.

4. **Verify setup:**

- Catppuccin colorscheme should be active
- LSP should work for your languages
- `:Lazy` command opens the plugin manager UI

**Key Bindings:**

- `<Space>` - Leader key
- `<Ctrl-h/j/k/l>` - Navigate between vim panes
- `<Space>ff` - Telescope find files
- `<Space>fg` - Telescope live grep
- `<Leader>gf` - Format current file with LSP/null-ls

**Optional Dependencies:**

These tools enhance the Neovim experience but aren't required:

- **stylua** - Lua code formatter (for none-ls)

  ```bash
  # macOS
  brew install stylua

  # Or via cargo
  cargo install stylua
  ```

- **Language servers** - Install LSPs for your languages (handled by nvim-lspconfig)
- **GitHub Copilot** - Requires GitHub Copilot subscription and separate setup

**Note:** Neovim will show warnings if optional tools are missing but will function normally otherwise.

## Adding New Configs

### Adding Tool Configs

The mirror pattern makes adding configs simple:

**For XDG-compliant tools** (nvim, alacritty, etc.):

```bash
cd ~/Development/dotfiles
mkdir -p .config/nvim
# Add your nvim config files
git add .config/nvim
git commit -m "Add nvim configuration"
```

**For traditional dotfiles** (tmux, bash, etc.):

```bash
cd ~/Development/dotfiles
cp ~/.tmux.conf .tmux.conf
git add .tmux.conf
git commit -m "Add tmux configuration"
```

**The pattern**: Mirror the actual location in your home directory.

### Examples

| Tool                | Home Location          | Dotfiles Location    |
| ------------------- | ---------------------- | -------------------- |
| Claude              | `~/.claude/`           | `.claude/`           |
| Git                 | `~/.gitconfig`         | `.gitconfig`         |
| Git (global ignore) | `~/.config/git/`       | `.config/git/`       |
| Neovim              | `~/.config/nvim/`      | `.config/nvim/`      |
| tmux                | `~/.tmux.conf`         | `.tmux.conf`         |
| Alacritty           | `~/.config/alacritty/` | `.config/alacritty/` |
| Zsh                 | `~/.zshrc`             | `.zshrc`             |

## Syncing Across Machines

### Setup on New Machine

```bash
# 1. Clone repository with submodules
git clone --recurse-submodules <your-repo-url> ~/Development/dotfiles
# This includes TPM (Tmux Plugin Manager) automatically!

# 2. Install dependencies (if needed)
# - Claude CLI
# - GNU Stow (optional)
# - Other tools (nvim, tmux, etc.)

# 3. Create symlinks
cd ~/Development/dotfiles
stow -t ~ .

# Or manually:
ln -s ~/Development/dotfiles/.claude ~/.claude
ln -s ~/Development/dotfiles/.config ~/.config
ln -s ~/Development/dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/Development/dotfiles/.tmux ~/.tmux

# 4. Install tmux plugins (if using tmux)
tmux
# Press: Ctrl-Space + I (to install plugins)

# 5. First run
# Claude will create machine-specific files automatically
# - settings.local.json
# - Plugin cache (marketplace plugins downloaded)
# - Session data, logs, etc.
```

### Pulling Updates

Changes sync instantly since configs are symlinked:

```bash
cd ~/Development/dotfiles
git pull
git submodule update --remote --merge  # Update submodules (TPM)
# Changes are immediately available in ~/.claude, ~/.config, etc.
```

## Updating Configuration

### Making Changes

```bash
cd ~/Development/dotfiles

# Edit files directly (changes reflect immediately)
vim .claude/CLAUDE.md
vim .claude/settings.json

# Stage and commit
git add .claude/CLAUDE.md
git commit -m "Update Claude preferences"
git push
```

### Machine-Specific Overrides

Create `~/.claude/settings.local.json` for machine-specific settings:

```json
{
  "permissions": {
    "allow": ["Bash(custom-tool:*)"]
  }
}
```

This file is ignored by git and won't conflict with the repository.

## Git Workflow

### Basic Operations

```bash
cd ~/Development/dotfiles

# Check status
git status

# Stage changes
git add .claude/CLAUDE.md

# Commit
git commit -m "Update coding preferences"

# Push to remote
git push

# Pull updates
git pull
```

### Initial Remote Setup

```bash
cd ~/Development/dotfiles

# Add remote
git remote add origin <your-remote-url>

# Push
git push -u origin main
```

## GNU Stow Tips

### Advanced Stow Usage

```bash
# Stow specific directory only
stow -t ~ -d ~/Development/dotfiles .claude

# Unstow (remove symlinks)
stow -D -t ~ .

# Restow (useful after adding new files)
stow -R -t ~ .

# Dry run (see what would happen)
stow -n -v -t ~ .
```

### Stow Advantages

✓ Automatic symlinking of entire directory trees
✓ Easy to add/remove configs
✓ Handles nested directories perfectly
✓ Clean uninstall with `stow -D`
✓ No custom scripts needed

## Troubleshooting

### Symlinks Not Working

**Check if symlink exists:**

```bash
ls -la ~/.claude
# Should show: .claude -> /Users/you/Development/dotfiles/.claude
```

**Fix broken symlink:**

```bash
rm ~/.claude
ln -s ~/Development/dotfiles/.claude ~/.claude
```

### Stow Conflicts

**Error: "existing target is not owned by stow"**

```bash
# Backup existing file
mv ~/.claude ~/.claude.backup

# Retry stow
stow -t ~ .
```

### Claude Plugin Not Loading

**Check plugin enabled:**

```bash
cat ~/.claude/settings.json | jq .enabledPlugins
```

**Restart Claude:**

```bash
# Exit and restart claude
```

### Git Shows Ignored Files

**Problem**: Files appear in `git status` that should be ignored.

**Solution**: Ensure `.gitignore` is committed and patterns are correct:

```bash
git check-ignore -v <file-path>
# Shows which gitignore rule matches (or doesn't)
```

## Benefits of This Approach

✓ **Self-Documenting**: Directory structure shows exactly where files go
✓ **Simple Setup**: One `stow` command or a few symlinks
✓ **Cross-Machine Sync**: Keep configs consistent everywhere
✓ **Version Control**: Track changes, roll back mistakes
✓ **Safe**: Machine-specific files automatically excluded
✓ **Extensible**: Easy to add new tool configs
✓ **Standard Pattern**: Widely used in dotfiles community

## Security Notes

- Command history and session data are excluded from version control
- Machine-specific settings stay local via `.gitignore`
- Consider using a **private repository** for sensitive configs
- API keys should never be in these files (Claude doesn't store them here anyway)

## Repository Info

- **Location**: `~/Development/dotfiles`
- **Symlink Strategy**: Mirror home directory structure
- **Primary Configs**: Claude CLI (`.claude/`)
- **Ready For**: nvim, tmux, zsh, and more (`.config/`, root-level dotfiles)
- **Version**: 1.0.0

## Next Steps

1. **Add Git Remote** (if you haven't):

   ```bash
   cd ~/Development/dotfiles
   git remote add origin <your-remote-url>
   git push -u origin main
   ```

2. **Add More Configs**:
   - Copy your nvim config to `.config/nvim/`
   - Copy your tmux config to `.tmux.conf`
   - Commit and push

3. **Setup Other Machines**:
   - Clone and stow on your other computers
   - Same configs everywhere, instantly

4. **Explore Dev-Suite**:
   - Read `.claude/plugins/dev-suite/README.md`
   - Try `/dev-suite:dev-workflow`

---

**Repository**: `~/Development/dotfiles`
**Pattern**: Mirror home directory structure
**Symlink Method**: GNU Stow or manual `ln -s`
