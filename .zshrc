# ============================================
# Zsh Configuration
# ============================================
# Modular configuration split into logical sections.
# See ~/.zsh/ for individual module files.

# ============================================
# Initialize ASDF
# ============================================
. /opt/homebrew/opt/asdf/libexec/asdf.sh

# ============================================
# Oh My Zsh Configuration
# ============================================
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Plugins (must be defined before sourcing oh-my-zsh.sh)
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# ============================================
# Load Configuration Modules
# ============================================

# Environment variables (non-sensitive)
[[ -f ~/.zsh/env.zsh ]] && source ~/.zsh/env.zsh

# PATH modifications
[[ -f ~/.zsh/path.zsh ]] && source ~/.zsh/path.zsh

# Aliases
[[ -f ~/.zsh/aliases.zsh ]] && source ~/.zsh/aliases.zsh

# Functions
[[ -f ~/.zsh/functions.zsh ]] && source ~/.zsh/functions.zsh

# fzf configuration
[[ -f ~/.zsh/fzf.zsh ]] && source ~/.zsh/fzf.zsh

# Git sync for dotfiles
[[ -f ~/.zsh/git-sync.zsh ]] && source ~/.zsh/git-sync.zsh

# Claude config sync
[[ -f ~/.zsh/claude-sync.zsh ]] && source ~/.zsh/claude-sync.zsh

# Sensitive data (tokens, secrets) - stored in HOME, not in repo
# Create ~/.zsh_sensitive with your tokens (see .zsh/sensitive.zsh.example)
[[ -f ~/.zsh_sensitive ]] && source ~/.zsh_sensitive

# ============================================
# Optional: Additional Plugin Loaders
# ============================================
# Uncomment if using these plugins
# source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source $(brew --prefix)/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# ============================================
# Optional: Auto-start tmux
# ============================================
# Uncomment to automatically start tmux on shell launch
# if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#   exec tmux new-session -A -s home
# fi
