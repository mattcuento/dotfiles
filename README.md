# Dotfiles

Personal configuration files using the mirror home directory pattern. This repository mirrors your home directory structure, making setup simple and intuitive.

## Structure

```
dotfiles/
├── .gitignore              # Excludes machine-specific/transient files
├── .gitconfig              # → ~/.gitconfig (git user identity)
├── README.md               # This file
├── .config/                # → ~/.config/
│   ├── gh/                # GitHub CLI configuration
│   │   ├── config.yml     # Global preferences and aliases
│   │   └── hosts.yml      # GitHub username and host config
│   ├── git/
│   │   └── ignore         # Global gitignore patterns
│   ├── iterm2/            # iTerm2 preferences
│   │   └── com.googlecode.iterm2.plist
│   └── nvim/              # Neovim configuration
│       ├── init.lua       # Main config file
│       ├── lazy-lock.json # Plugin lockfile
│       └── lua/
│           ├── vim-options.lua
│           └── plugins/   # Plugin configurations
├── .tmux.conf              # → ~/.tmux.conf
├── .tmux/                  # → ~/.tmux/
│   └── plugins/
│       └── tpm/           # Tmux Plugin Manager (submodule)
├── .zshrc                  # → ~/.zshrc (main zsh config)
└── .zsh/                   # → ~/.zsh/ (modular zsh configs)
    ├── env.zsh            # Environment variables
    ├── path.zsh           # PATH modifications
    ├── aliases.zsh        # Shell aliases
    ├── functions.zsh      # Custom functions
    ├── fzf.zsh            # fzf configuration and key bindings
    └── sensitive.zsh.example  # Template for ~/.zsh_sensitive

Note: Sensitive data goes in ~/.zsh_sensitive (home root, not tracked)
```

**Mapping**: The directory structure mirrors your home directory exactly.

- `dotfiles/.config/git/` → `~/.config/git/`
- `dotfiles/.gitconfig` → `~/.gitconfig`
- `dotfiles/.tmux.conf` → `~/.tmux.conf`
- `dotfiles/.tmux/` → `~/.tmux/`
- `dotfiles/.zshrc` → `~/.zshrc`
- `dotfiles/.zsh/` → `~/.zsh/`

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

# Create all symlinks automatically
stow -t ~ .
```

**What stow does:**

- Creates `~/.config` → `~/Development/dotfiles/.config`
- Handles all nested files and directories automatically

### Option 2: Manual Symlinks

If you prefer manual control or don't want to use stow:

```bash
# Clone repository
git clone <your-repo-url> ~/Development/dotfiles

# Create symlinks
ln -s ~/Development/dotfiles/.config ~/.config

# Or symlink individual files/directories as needed
```

### Verification

```bash
# Check symlinks
ls -la ~ | grep '\->'

# Should show:
# .config -> /Users/you/Development/dotfiles/.config
```

## What's Included

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
- Global gitignore patterns

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

### GitHub CLI Configuration (`.config/gh/`)

**Versioned (Portable):**

- `config.yml` - Global preferences (git protocol, editor, aliases)
- `hosts.yml` - GitHub hostname and username configuration

**What's included:**

- Git protocol preference: `https`
- Prompt settings
- Alias: `co` → `pr checkout`
- GitHub username

**Not versioned (Secure):**

- OAuth tokens are stored in system keychain (not in config files)
- Auth state is machine-specific

**Setup on new machine:**

1. **Create symlink:**

```bash
ln -s ~/Development/dotfiles/.config/gh ~/.config/gh
```

2. **Authenticate:**

```bash
gh auth login
```

Follow the prompts to authenticate. Your preferences from the config will be used, but you'll need to auth separately on each machine.

3. **Verify setup:**

```bash
gh auth status
gh config list
```

**Customization:**

Edit `.config/gh/config.yml` to add your own aliases or change preferences. Changes sync via git to all machines.

### Zsh Configuration (`.zshrc` + `.zsh/`)

**Modular structure for maintainability:**

The Zsh configuration is split into logical modules for easy management:

```
.zshrc                         # Main config, sources all modules
.zsh/
  ├── env.zsh                 # Environment variables (ANDROID_HOME, etc.)
  ├── path.zsh                # PATH modifications
  ├── aliases.zsh             # Command aliases
  ├── functions.zsh           # Custom shell functions
  └── sensitive.zsh.example   # Template for ~/.zsh_sensitive

~/.zsh_sensitive               # Your actual secrets (NOT in repo, not symlinked)
```

**Versioned (Portable):**

- `.zshrc` - Main configuration file
- `.zsh/env.zsh` - Environment variables (Android, Java, etc.)
- `.zsh/path.zsh` - PATH modifications
- `.zsh/aliases.zsh` - Shell aliases (git shortcuts, vim → nvim)
- `.zsh/functions.zsh` - Custom functions (blog post helpers)

**Not versioned (Sensitive):**

- `~/.zsh_sensitive` - Machine-specific secrets (OAuth tokens, API keys)
  - **Location**: `~/.zsh_sensitive` (in HOME root, NOT in `.zsh/` directory)
  - **Not symlinked**: Created directly in home directory, never tracked by git
- `.zsh_history` - Command history
- `.zsh_sessions/` - Session state

**What's included:**

- **Oh My Zsh** integration with robbyrussell theme
- **ASDF** version manager initialization
- **Git aliases**: `gs` (status), `gc` (commit), `gp` (push), etc.
- **Android/Java** development environment setup
- **Blog functions**: `post` and `blist` for cuento-blog management
- **Modular loading**: Each module can be enabled/disabled independently

**Setup on new machine:**

1. **Create symlinks:**

```bash
ln -s ~/Development/dotfiles/.zshrc ~/.zshrc
ln -s ~/Development/dotfiles/.zsh ~/.zsh
```

2. **Create sensitive file (in HOME, not in repo):**

```bash
# Copy template to HOME directory (NOT in .zsh/)
cp ~/.zsh/sensitive.zsh.example ~/.zsh_sensitive

# Edit and add your actual tokens
vim ~/.zsh_sensitive
```

3. **Add your tokens:**

```bash
# Inside ~/.zsh_sensitive (in home root, not versioned)
export CLAUDE_CODE_OAUTH_TOKEN="your-actual-token-here"
export API_KEY="your-key-here"
# etc.
```

**Important**: `~/.zsh_sensitive` is created in your HOME directory root, NOT inside the `.zsh/` directory. This keeps it outside the repo and prevents accidental commits.

4. **Reload shell:**

```bash
source ~/.zshrc
# Or use the alias: src
```

**Verify setup:**

```bash
echo $CLAUDE_CODE_OAUTH_TOKEN  # Should show your token
gs  # Should run git status
vim # Should open neovim
```

**Adding new configuration:**

- **Aliases**: Edit `.zsh/aliases.zsh`
- **Functions**: Edit `.zsh/functions.zsh`
- **Environment vars**: Edit `.zsh/env.zsh`
- **PATH changes**: Edit `.zsh/path.zsh`
- **Secrets**: Edit `~/.zsh_sensitive` (in home root, not versioned)

**Dependencies:**

- **Oh My Zsh**: Install from [ohmyz.sh](https://ohmyz.sh/)
- **zsh-syntax-highlighting**: Install via Oh My Zsh or homebrew
- **ASDF**: Version manager for multiple languages

### iTerm2 Configuration (`.config/iterm2/`)

**What's included:**

iTerm2 preferences including color schemes, fonts, key bindings, profiles, and window settings.

**Versioned (Portable):**

- `com.googlecode.iterm2.plist` - Complete iTerm2 preferences

**Setup on new machine:**

1. **Clone dotfiles** (if not already done)

2. **Configure iTerm2 to load from dotfiles:**

```bash
# Tell iTerm2 where to find preferences
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "~/Development/dotfiles/.config/iterm2"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
```

3. **Restart iTerm2:**

Close and reopen iTerm2 for settings to take effect.

4. **Verify settings loaded:**

Open iTerm2 → Preferences → General → Preferences
Should show: "Load preferences from a custom folder or URL"
Path: `~/Development/dotfiles/.config/iterm2`

**Making changes:**

Any preference changes in iTerm2 will automatically save to the dotfiles folder. Commit and push to sync across machines:

```bash
cd ~/Development/dotfiles
git add .config/iterm2/
git commit -m "Update iTerm2 preferences"
git push
```

**Note:** Changes require iTerm2 to be restarted to take effect on other machines after pulling updates.

### fzf Configuration (`.zsh/fzf.zsh`)

**What's included:**

Command-line fuzzy finder with shell integration, custom key bindings, and helper functions.

**Versioned (Portable):**

- `.zsh/fzf.zsh` - Complete fzf configuration including:
  - Shell integration (key bindings and completions)
  - Custom color scheme and layout
  - File/directory preview with syntax highlighting
  - Git integration functions
  - Process management helpers

**Setup on new machine:**

1. **Install fzf and dependencies:**

```bash
brew install fzf bat fd tree
```

2. **Reload shell:**

```bash
source ~/.zshrc
# or open a new terminal
```

**Key bindings:**

- **Ctrl+R**: Search command history with preview
- **Ctrl+T**: Search files with syntax-highlighted preview
- **Alt+C**: Search directories with tree preview
- **Ctrl+/**: Toggle preview window
- **Ctrl+U/D**: Scroll preview half-page up/down

**Custom functions:**

- `fgb` (fzf-git-branch): Checkout git branch with commit preview
- `fgc` (fzf-git-commit-show): Browse and view git commits
- `fkill` (fzf-kill): Kill processes interactively

**Dependencies:**

- **fzf**: Core fuzzy finder
- **bat**: Syntax-highlighted file previews (optional but recommended)
- **fd**: Fast file searching (optional, fallback to `find`)
- **tree**: Directory tree previews (optional, fallback to basic listing)

**Usage examples:**

```bash
# Search files and open in editor
vim $(fzf)

# Search and checkout git branch
fgb

# Browse git commit history
fgc

# Kill a process interactively
fkill
```

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

| Tool                | Home Location               | Dotfiles Location       |
| ------------------- | --------------------------- | ----------------------- |
| Git                 | `~/.gitconfig`              | `.gitconfig`            |
| Git (global ignore) | `~/.config/git/`            | `.config/git/`          |
| Neovim              | `~/.config/nvim/`           | `.config/nvim/`         |
| iTerm2              | `~/.config/iterm2/`         | `.config/iterm2/`       |
| tmux                | `~/.tmux.conf` + `~/.tmux/` | `.tmux.conf` + `.tmux/` |
| Zsh                 | `~/.zshrc` + `~/.zsh/`      | `.zshrc` + `.zsh/`      |
| Alacritty           | `~/.config/alacritty/`      | `.config/alacritty/`    |

## Syncing Across Machines

### Setup on New Machine

```bash
# 1. Clone repository with submodules
git clone --recurse-submodules <your-repo-url> ~/Development/dotfiles
# This includes TPM (Tmux Plugin Manager) automatically!

# 2. Install dependencies (if needed)
# - GNU Stow (optional)
# - Other tools (nvim, tmux, etc.)

# 3. Create symlinks
cd ~/Development/dotfiles
stow -t ~ .

# Or manually:
ln -s ~/Development/dotfiles/.config ~/.config
ln -s ~/Development/dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/Development/dotfiles/.tmux ~/.tmux

# 4. Install tmux plugins (if using tmux)
tmux
# Press: Ctrl-Space + I (to install plugins)
```

### Pulling Updates

Changes sync instantly since configs are symlinked:

```bash
cd ~/Development/dotfiles
git pull
git submodule update --remote --merge  # Update submodules (TPM)
# Changes are immediately available in ~/.config, etc.
```

## Updating Configuration

### Making Changes

```bash
cd ~/Development/dotfiles

# Edit files directly (changes reflect immediately)
vim .gitconfig
vim .config/nvim/init.lua

# Stage and commit
git add .gitconfig
git commit -m "Update git configuration"
git push
```

## Git Workflow

### Basic Operations

```bash
cd ~/Development/dotfiles

# Check status
git status

# Stage changes
git add .gitconfig

# Commit
git commit -m "Update git configuration"

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
stow -t ~ -d ~/Development/dotfiles .config

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
ls -la ~/.config
# Should show: .config -> /Users/you/Development/dotfiles/.config
```

**Fix broken symlink:**

```bash
rm ~/.config
ln -s ~/Development/dotfiles/.config ~/.config
```

### Stow Conflicts

**Error: "existing target is not owned by stow"**

```bash
# Backup existing file
mv ~/.config ~/.config.backup

# Retry stow
stow -t ~ .
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
- **Primary Configs**: Git, Neovim, Tmux, Zsh
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

---

**Repository**: `~/Development/dotfiles`
**Pattern**: Mirror home directory structure
**Symlink Method**: GNU Stow or manual `ln -s`
