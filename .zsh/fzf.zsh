# ============================================
# fzf Configuration
# ============================================
# Fuzzy finder for command-line
# https://github.com/junegunn/fzf

# ============================================
# Shell Integration
# ============================================
# Key bindings and completion
eval "$(fzf --zsh)"

# ============================================
# Default Options
# ============================================
export FZF_DEFAULT_OPTS="
  --height 40%
  --layout=reverse
  --border
  --inline-info
  --color=fg:#d0d0d0,bg:#1c1c1c,hl:#5f87af
  --color=fg+:#d0d0d0,bg+:#262626,hl+:#5fd7ff
  --color=info:#afaf87,prompt:#d7005f,pointer:#af5fff
  --color=marker:#87ff00,spinner:#af5fff,header:#87afaf
  --bind ctrl-/:toggle-preview
  --bind ctrl-u:preview-half-page-up
  --bind ctrl-d:preview-half-page-down
"

# ============================================
# Command Options
# ============================================

# Default command (used when no specific command is set)
# Uses fd if available (faster), falls back to find
if command -v fd &> /dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
else
  export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/\.git/*"'
fi

# Ctrl+T - File search with preview
export FZF_CTRL_T_OPTS="
  --preview 'bat --style=numbers --color=always --line-range :500 {} 2> /dev/null || cat {} 2> /dev/null || tree -C {} 2> /dev/null'
  --preview-window right:60%:wrap
"

if command -v fd &> /dev/null; then
  export FZF_CTRL_T_COMMAND='fd --type f --hidden --follow --exclude .git'
fi

# Alt+C - Directory search with tree preview
export FZF_ALT_C_OPTS="
  --preview 'tree -C {} | head -200'
  --preview-window right:60%:wrap
"

if command -v fd &> /dev/null; then
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

# ============================================
# Custom Functions
# ============================================

# fzf-git-branch - Checkout git branch using fzf
fzf-git-branch() {
  local branch
  branch=$(git branch -a | grep -v HEAD | sed 's/^[* ]*//' | sed 's#remotes/origin/##' | sort -u | fzf --height 40% --reverse --preview 'git log --oneline --color=always {}' --preview-window right:60%)
  if [[ -n "$branch" ]]; then
    git checkout "$branch"
  fi
}

# fzf-git-commit-show - Show git commit using fzf
fzf-git-commit-show() {
  git log --oneline --color=always | fzf --ansi --preview 'git show --color=always {1}' --preview-window right:60%:wrap
}

# fzf-kill - Kill process using fzf
fzf-kill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf --multi --header='Select process to kill' | awk '{print $2}')
  if [[ -n "$pid" ]]; then
    echo "$pid" | xargs kill -${1:-9}
  fi
}

# ============================================
# Aliases
# ============================================
alias fgb='fzf-git-branch'
alias fgc='fzf-git-commit-show'
alias fkill='fzf-kill'
