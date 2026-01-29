# Dotfiles

Personal configuration files using the mirror home directory pattern. This repository mirrors your home directory structure, making setup simple and intuitive.

## Structure

```
dotfiles/
├── .gitignore              # Excludes machine-specific/transient files
├── README.md               # This file
├── .claude/                # → ~/.claude/
│   ├── CLAUDE.md          # User preferences and guidelines
│   ├── settings.json      # Global settings
│   └── plugins/
│       └── dev-suite/     # Custom development plugin
└── .config/                # → ~/.config/ (ready for nvim, etc.)
```

**Mapping**: The directory structure mirrors your home directory exactly.
- `dotfiles/.claude/` → `~/.claude/`
- `dotfiles/.config/nvim/` → `~/.config/nvim/` (when added)
- `dotfiles/.tmux.conf` → `~/.tmux.conf` (when added)

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

| Tool | Home Location | Dotfiles Location |
|------|---------------|-------------------|
| Claude | `~/.claude/` | `.claude/` |
| Neovim | `~/.config/nvim/` | `.config/nvim/` |
| tmux | `~/.tmux.conf` | `.tmux.conf` |
| Alacritty | `~/.config/alacritty/` | `.config/alacritty/` |
| Zsh | `~/.zshrc` | `.zshrc` |

## Syncing Across Machines

### Setup on New Machine

```bash
# 1. Clone repository
git clone <your-repo-url> ~/Development/dotfiles

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

# 4. First run
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
    "allow": [
      "Bash(custom-tool:*)"
    ]
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
