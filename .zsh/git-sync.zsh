#!/usr/bin/env zsh
# Git Sync Module for Dotfiles
# Automatically prompts to sync dotfiles repository on shell startup

# ============================================================================
# Configuration
# ============================================================================

DOTFILES_PATH="${HOME}/Development/dotfiles"
GIT_SYNC_CHECK_INTERVAL=$((4 * 60 * 60))  # 4 hours in seconds
GIT_SYNC_STATE_FILE="/tmp/.dotfiles-git-sync-state-${USER}"

# ============================================================================
# State Management
# ============================================================================

_dotfiles_should_check_sync() {
  # Returns 0 (true) if should check, 1 (false) if too soon

  if [[ ! -f "$GIT_SYNC_STATE_FILE" ]]; then
    return 0
  fi

  local last_check=$(cat "$GIT_SYNC_STATE_FILE" 2>/dev/null || echo 0)
  local current_time=$(date +%s)
  local time_diff=$((current_time - last_check))

  if [[ $time_diff -ge $GIT_SYNC_CHECK_INTERVAL ]]; then
    return 0
  else
    return 1
  fi
}

_dotfiles_update_state() {
  # Updates state file with current timestamp or custom value
  local timestamp=${1:-$(date +%s)}
  echo "$timestamp" > "$GIT_SYNC_STATE_FILE"
}

# ============================================================================
# Git Status Checks
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

# ============================================================================
# User Prompts
# ============================================================================

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
          _dotfiles_update_state
        else
          echo "✗ Push failed"
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
        _dotfiles_update_state
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
      _dotfiles_update_state
      echo "⏰ Will remind you in 4 hours"
      ;;

    "Ignore for this session")
      local tomorrow=$(($(date +%s) + 86400))
      _dotfiles_update_state "$tomorrow"
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
        _dotfiles_update_state
      else
        echo "✗ Pull failed"
      fi
      ;;

    "Show incoming commits")
      echo "\nIncoming commits:"
      git -C "$DOTFILES_PATH" log HEAD..origin/main --oneline --decorate
      echo ""
      _dotfiles_prompt_pull  # Re-prompt after showing commits
      ;;

    "Remind me later (4h)")
      _dotfiles_update_state
      echo "⏰ Will remind you in 4 hours"
      ;;

    "Ignore for this session")
      local tomorrow=$(($(date +%s) + 86400))
      _dotfiles_update_state "$tomorrow"
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
      fi
      ;;

    "Push later (manual)")
      echo "📝 Remember to push manually later"
      ;;
  esac
}

# ============================================================================
# Main Orchestrator
# ============================================================================

_dotfiles_check_sync() {
  # Verify dotfiles directory exists
  [[ ! -d "$DOTFILES_PATH/.git" ]] && return 0

  # Check if should run (state check)
  _dotfiles_should_check_sync || return 0

  # Check for local changes
  if _dotfiles_has_local_changes; then
    _dotfiles_prompt_commit
    return 0
  fi

  # Check for remote updates
  if _dotfiles_has_remote_updates; then
    _dotfiles_prompt_pull
    return 0
  fi

  # No changes detected, update state silently
  _dotfiles_update_state
}

# ============================================================================
# Hook Registration
# ============================================================================

autoload -U add-zsh-hook
add-zsh-hook precmd _dotfiles_check_sync
