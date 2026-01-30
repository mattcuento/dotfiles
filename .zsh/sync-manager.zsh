#!/usr/bin/env zsh
# Sync Manager - Consolidated dotfiles and Claude config sync
# Handles automatic syncing of both dotfiles and Claude configuration
# with robust error handling, circuit breaker pattern, and emergency disable mechanisms

# ============================================================================
# Configuration & Constants
# ============================================================================

# Check interval (4 hours)
SYNC_CHECK_INTERVAL=$((4 * 60 * 60))

# State files
SYNC_STATE_FILE="/tmp/.sync-state-${USER}"
SYNC_FAILURE_FILE="/tmp/.sync-failures-${USER}"

# Circuit breaker configuration
SYNC_MAX_FAILURES=3

# Paths come from environment variables (set in env.zsh)
# - DOTFILES_PATH: Path to dotfiles repository
# - CLAUDE_DIR: Path to Claude config directory
# - CLAUDE_REPO_URL: URL for Claude config repository

# ============================================================================
# Emergency Disable Checks
# ============================================================================

_sync_is_enabled() {
  # Fast-fail checks for emergency disable mechanisms
  # Returns 0 if enabled, 1 if disabled

  # Check environment variable disables
  [[ -n "$SYNC_DISABLED" ]] && return 1
  [[ -n "$DOTFILES_SYNC_DISABLED" ]] && return 1
  [[ -n "$CLAUDE_SYNC_DISABLED" ]] && return 1

  # Check circuit breaker auto-disable
  if [[ -f "$SYNC_FAILURE_FILE" ]]; then
    grep -q "^DISABLED:" "$SYNC_FAILURE_FILE" 2>/dev/null && return 1
  fi

  return 0
}

# ============================================================================
# Circuit Breaker Functions
# ============================================================================

_sync_record_failure() {
  local module=$1
  local error_msg=$2
  local timestamp=$(date +%s)

  # Append failure to file
  echo "${timestamp}:${module}:${error_msg}" >> "$SYNC_FAILURE_FILE"

  # Count recent failures (last hour)
  local one_hour_ago=$((timestamp - 3600))
  local failure_count=0

  if [[ -f "$SYNC_FAILURE_FILE" ]]; then
    while IFS=: read -r fail_time fail_module fail_msg; do
      if [[ "$fail_time" =~ ^[0-9]+$ ]] && [[ $fail_time -ge $one_hour_ago ]]; then
        ((failure_count++))
      fi
    done < "$SYNC_FAILURE_FILE"
  fi

  # Auto-disable if too many failures
  if [[ $failure_count -ge $SYNC_MAX_FAILURES ]]; then
    echo "DISABLED:${timestamp}:Too many failures (${failure_count})" >> "$SYNC_FAILURE_FILE"
    echo "⚠️  Sync Manager: Auto-disabled after ${failure_count} failures"
    echo "   Run 'sync-clear-failures' or 'rm ${SYNC_FAILURE_FILE}' to re-enable"
  fi
}

_sync_clear_failures() {
  # User-callable function to clear failure state
  if [[ -f "$SYNC_FAILURE_FILE" ]]; then
    rm "$SYNC_FAILURE_FILE"
    echo "✓ Sync Manager: Failure state cleared, sync re-enabled"
  else
    echo "ℹ️  Sync Manager: No failures to clear"
  fi
}

# ============================================================================
# State Management
# ============================================================================

_sync_should_check() {
  # Returns 0 if should check, 1 if too soon

  if [[ ! -f "$SYNC_STATE_FILE" ]]; then
    return 0
  fi

  local last_check=$(cat "$SYNC_STATE_FILE" 2>/dev/null || echo 0)
  local current_time=$(date +%s)
  local time_diff=$((current_time - last_check))

  if [[ $time_diff -ge $SYNC_CHECK_INTERVAL ]]; then
    return 0
  else
    return 1
  fi
}

_sync_update_state() {
  # Updates state file with current timestamp or custom value
  local timestamp=${1:-$(date +%s)}
  echo "$timestamp" > "$SYNC_STATE_FILE"
}

# ============================================================================
# Validation Functions
# ============================================================================

_sync_validate_dotfiles() {
  # Returns 0 if dotfiles path is valid and is a git repo

  if [[ -z "$DOTFILES_PATH" ]]; then
    return 1
  fi

  if [[ ! -d "$DOTFILES_PATH/.git" ]]; then
    return 1
  fi

  # Verify it's a valid git repository
  git -C "$DOTFILES_PATH" rev-parse --git-dir >/dev/null 2>&1
}

_sync_validate_claude() {
  # Returns 0 if Claude dir is valid or can be created
  # Returns 1 if Claude dir exists but is not a valid git repo

  if [[ -z "$CLAUDE_DIR" ]]; then
    return 1
  fi

  # If directory doesn't exist, that's OK (we'll clone)
  if [[ ! -d "$CLAUDE_DIR" ]]; then
    return 0
  fi

  # If directory exists but no .git, that's a problem
  if [[ ! -d "$CLAUDE_DIR/.git" ]]; then
    return 1
  fi

  # Verify it's a valid git repository
  git -C "$CLAUDE_DIR" rev-parse --git-dir >/dev/null 2>&1
}

# ============================================================================
# Dotfiles Sync Logic (ported from git-sync.zsh)
# ============================================================================

_dotfiles_has_local_changes() {
  # Returns 0 if uncommitted changes exist
  local git_status=$(git -C "$DOTFILES_PATH" status --porcelain 2>/dev/null)
  [[ -n "$git_status" ]]
}

_dotfiles_has_remote_updates() {
  # Returns 0 if remote has new commits
  git -C "$DOTFILES_PATH" fetch origin --quiet 2>/dev/null || return 1

  local ahead=$(git -C "$DOTFILES_PATH" rev-list HEAD..origin/main --count 2>/dev/null)
  [[ "$ahead" -gt 0 ]]
}

_dotfiles_prompt_commit() {
  local change_count=$(git -C "$DOTFILES_PATH" status --porcelain 2>/dev/null | wc -l | tr -d ' ')

  local choice=$(echo "Commit and push now
Commit only (no push)
Show git status
Show git diff
Remind me later (4h)
Ignore for this session" | fzf \
    --height 40% \
    --reverse \
    --border \
    --header "📝 Dotfiles: ${change_count} uncommitted changes" \
    --prompt "Action: ")

  case "$choice" in
    "Commit and push now")
      echo "\nCommitting changes..."
      git -C "$DOTFILES_PATH" add -A
      git -C "$DOTFILES_PATH" commit

      if [[ $? -eq 0 ]]; then
        echo "\nPushing to remote..."
        git -C "$DOTFILES_PATH" push origin main
        if [[ $? -eq 0 ]]; then
          echo "✓ Changes committed and pushed"
          _sync_update_state
        else
          echo "✗ Push failed"
          _sync_record_failure "dotfiles" "Push failed"
        fi
      else
        echo "✗ Commit cancelled or failed"
      fi
      ;;

    "Commit only (no push)")
      echo "\nCommitting changes..."
      git -C "$DOTFILES_PATH" add -A
      git -C "$DOTFILES_PATH" commit

      if [[ $? -eq 0 ]]; then
        echo "✓ Changes committed"
        _dotfiles_prompt_push
        _sync_update_state
      else
        echo "✗ Commit cancelled or failed"
      fi
      ;;

    "Show git status")
      echo "\nGit status:"
      git -C "$DOTFILES_PATH" status
      echo ""
      _dotfiles_prompt_commit  # Re-prompt after showing status
      ;;

    "Show git diff")
      echo "\nGit diff:"
      git -C "$DOTFILES_PATH" diff
      echo ""
      _dotfiles_prompt_commit  # Re-prompt after showing diff
      ;;

    "Remind me later (4h)")
      _sync_update_state
      echo "⏰ Will remind you in 4 hours"
      ;;

    "Ignore for this session")
      local tomorrow=$(($(date +%s) + 86400))
      _sync_update_state "$tomorrow"
      echo "🔕 Ignoring until next day"
      ;;
  esac
}

_dotfiles_prompt_pull() {
  local commit_count=$(git -C "$DOTFILES_PATH" rev-list HEAD..origin/main --count 2>/dev/null)

  local choice=$(echo "Pull changes now
Show incoming commits
Remind me later (4h)
Ignore for this session" | fzf \
    --height 40% \
    --reverse \
    --border \
    --header "📥 Dotfiles: ${commit_count} new commits available" \
    --prompt "Action: ")

  case "$choice" in
    "Pull changes now")
      echo "\nPulling changes..."
      git -C "$DOTFILES_PATH" pull origin main

      if [[ $? -eq 0 ]]; then
        echo "✓ Changes pulled successfully"
        _sync_update_state
      else
        echo "✗ Pull failed"
        _sync_record_failure "dotfiles" "Pull failed"
      fi
      ;;

    "Show incoming commits")
      echo "\nIncoming commits:"
      git -C "$DOTFILES_PATH" log HEAD..origin/main --oneline --decorate
      echo ""
      _dotfiles_prompt_pull  # Re-prompt after showing commits
      ;;

    "Remind me later (4h)")
      _sync_update_state
      echo "⏰ Will remind you in 4 hours"
      ;;

    "Ignore for this session")
      local tomorrow=$(($(date +%s) + 86400))
      _sync_update_state "$tomorrow"
      echo "🔕 Ignoring until next day"
      ;;
  esac
}

_dotfiles_prompt_push() {
  local choice=$(echo "Push to remote now
Push later (manual)" | fzf \
    --height 40% \
    --reverse \
    --border \
    --header "📤 Dotfiles: Push committed changes?" \
    --prompt "Action: ")

  case "$choice" in
    "Push to remote now")
      echo "\nPushing to remote..."
      git -C "$DOTFILES_PATH" push origin main

      if [[ $? -eq 0 ]]; then
        echo "✓ Changes pushed successfully"
      else
        echo "✗ Push failed"
        _sync_record_failure "dotfiles" "Push failed"
      fi
      ;;

    "Push later (manual)")
      echo "📝 Remember to push manually later"
      ;;
  esac
}

_dotfiles_check_sync() {
  # Main dotfiles sync orchestrator

  # Validate dotfiles path
  _sync_validate_dotfiles || return 1

  # Check for local changes first
  if _dotfiles_has_local_changes; then
    _dotfiles_prompt_commit
    return 0
  fi

  # Check for remote updates
  if _dotfiles_has_remote_updates; then
    _dotfiles_prompt_pull
    return 0
  fi

  # No changes detected
  return 0
}

# ============================================================================
# Claude Sync Logic
# ============================================================================

_claude_clone_if_missing() {
  # Clone Claude config repo if directory doesn't exist

  if [[ -d "$CLAUDE_DIR" ]]; then
    return 0  # Already exists
  fi

  if [[ -z "$CLAUDE_REPO_URL" ]]; then
    _sync_record_failure "claude" "CLAUDE_REPO_URL not set"
    return 1
  fi

  echo "📦 Cloning Claude config from ${CLAUDE_REPO_URL}..."

  if git clone "$CLAUDE_REPO_URL" "$CLAUDE_DIR" 2>/dev/null; then
    echo "✓ Claude config cloned successfully"
    return 0
  else
    echo "✗ Failed to clone Claude config"
    _sync_record_failure "claude" "Clone failed"
    return 1
  fi
}

_claude_pull_updates() {
  # Pull latest changes from Claude config repo

  if [[ ! -d "$CLAUDE_DIR/.git" ]]; then
    return 1
  fi

  # Fetch to check for updates
  git -C "$CLAUDE_DIR" fetch origin --quiet 2>/dev/null || return 1

  local ahead=$(git -C "$CLAUDE_DIR" rev-list HEAD..origin/main --count 2>/dev/null)

  if [[ "$ahead" -gt 0 ]]; then
    echo "📥 Claude config: ${ahead} new commits available"

    local choice=$(echo "Pull changes now
Show incoming commits
Skip for now" | fzf \
      --height 40% \
      --reverse \
      --border \
      --header "📥 Claude config: ${ahead} new commits available" \
      --prompt "Action: ")

    case "$choice" in
      "Pull changes now")
        echo "\nPulling changes..."
        if git -C "$CLAUDE_DIR" pull origin main; then
          echo "✓ Claude config updated"
        else
          echo "✗ Pull failed"
          _sync_record_failure "claude" "Pull failed"
        fi
        ;;

      "Show incoming commits")
        echo "\nIncoming commits:"
        git -C "$CLAUDE_DIR" log HEAD..origin/main --oneline --decorate
        echo ""
        # Re-prompt
        _claude_pull_updates
        ;;

      "Skip for now")
        echo "⏩ Skipping pull"
        ;;
    esac
  fi

  return 0
}

_claude_check_changes() {
  # Run the check-claude-changes.sh script
  # Use subshell for isolation since script uses cd

  if [[ ! -f "$CLAUDE_DIR/scripts/check-claude-changes.sh" ]]; then
    return 0  # Script doesn't exist, skip
  fi

  # Run in subshell to isolate cd commands
  (
    cd "$CLAUDE_DIR" 2>/dev/null || exit 1
    source ./scripts/check-claude-changes.sh
  )
}

_claude_check_sync() {
  # Main Claude sync orchestrator

  # Validate Claude path
  _sync_validate_claude || return 1

  # Clone if missing
  _claude_clone_if_missing || return 1

  # Pull updates
  _claude_pull_updates || return 1

  # Check for local changes (via script)
  _claude_check_changes || return 1

  return 0
}

# ============================================================================
# Main Orchestrator
# ============================================================================

_sync_check_all() {
  # Main entry point called by precmd hook

  # Fast-fail: Check if sync is enabled
  _sync_is_enabled || return 0

  # Fast-fail: Check if interval has elapsed
  _sync_should_check || return 0

  # Track if any sync ran
  local any_sync_ran=false

  # Check dotfiles sync
  if _sync_validate_dotfiles; then
    if _dotfiles_check_sync; then
      any_sync_ran=true
    else
      _sync_record_failure "dotfiles" "Check sync failed"
    fi
  fi

  # Check Claude sync
  if _sync_validate_claude; then
    if _claude_check_sync; then
      any_sync_ran=true
    else
      _sync_record_failure "claude" "Check sync failed"
    fi
  fi

  # Update state if any sync completed successfully
  if [[ "$any_sync_ran" == "true" ]]; then
    _sync_update_state
  fi

  return 0
}

# ============================================================================
# Hook Registration
# ============================================================================

autoload -U add-zsh-hook
add-zsh-hook precmd _sync_check_all
