#!/usr/bin/env zsh
# Claude Config Sync Module
# Automatically syncs Claude configuration from github.com/mattcuento/claudefiles

# ============================================================================
# Configuration
# ============================================================================

# Claude directory - can be overridden with CLAUDE_DIR environment variable
# Falls back to standard location if not set
CLAUDE_DIR="${CLAUDE_DIR:-${HOME}/.claude}"
CLAUDE_REPO_URL="https://github.com/mattcuento/claudefiles.git"
CLAUDE_SYNC_CHECK_INTERVAL=$((4 * 60 * 60))  # 4 hours in seconds
CLAUDE_SYNC_STATE_FILE="/tmp/.claude-git-sync-state-${USER}"

# ============================================================================
# State Management
# ============================================================================

_claude_should_check_sync() {
  # Returns 0 (true) if should check, 1 (false) if too soon

  if [[ ! -f "$CLAUDE_SYNC_STATE_FILE" ]]; then
    return 0
  fi

  local last_check=$(cat "$CLAUDE_SYNC_STATE_FILE" 2>/dev/null || echo 0)
  local current_time=$(date +%s)
  local time_diff=$((current_time - last_check))

  if [[ $time_diff -ge $CLAUDE_SYNC_CHECK_INTERVAL ]]; then
    return 0
  else
    return 1
  fi
}

_claude_update_state() {
  # Updates state file with current timestamp or custom value
  local timestamp=${1:-$(date +%s)}
  echo "$timestamp" > "$CLAUDE_SYNC_STATE_FILE"
}

# ============================================================================
# Repository Management
# ============================================================================

_claude_clone_if_missing() {
  # Clone repo if .claude doesn't exist
  if [[ ! -d "$CLAUDE_DIR" ]]; then
    echo "📦 Cloning Claude configuration from github.com/mattcuento/claudefiles..."
    git clone "$CLAUDE_REPO_URL" "$CLAUDE_DIR"

    if [[ $? -eq 0 ]]; then
      echo "✓ Claude config cloned successfully"
      _claude_update_state
      return 0
    else
      echo "✗ Failed to clone Claude config"
      return 1
    fi
  fi

  # Exists but not a git repo
  if [[ ! -d "$CLAUDE_DIR/.git" ]]; then
    echo "⚠️  .claude exists but is not a git repository"
    return 1
  fi

  return 0
}

_claude_pull_updates() {
  # Pull updates from remote if behind
  cd "$CLAUDE_DIR" || return 1

  # Fetch silently
  git fetch origin --quiet 2>/dev/null || return 1

  # Check if behind remote
  local behind=$(git rev-list HEAD..origin/main --count 2>/dev/null)

  if [[ "$behind" -gt 0 ]]; then
    echo "📥 Pulling ${behind} new commits for Claude config..."
    git pull origin main --quiet

    if [[ $? -eq 0 ]]; then
      echo "✓ Claude config updated"
      _claude_update_state
    else
      echo "✗ Pull failed - may have merge conflicts"
    fi
  fi

  cd - >/dev/null 2>&1
}

# ============================================================================
# Main Orchestrator
# ============================================================================

_claude_check_sync() {
  # Clone if missing
  _claude_clone_if_missing || return 0

  # Check if should run (interval check)
  _claude_should_check_sync || return 0

  # Pull updates
  _claude_pull_updates

  # Source the commit checker script
  if [[ -f "$CLAUDE_DIR/scripts/check-claude-changes.sh" ]]; then
    source "$CLAUDE_DIR/scripts/check-claude-changes.sh"
  fi

  # Update state
  _claude_update_state
}

# ============================================================================
# Hook Registration
# ============================================================================

autoload -U add-zsh-hook
add-zsh-hook precmd _claude_check_sync
