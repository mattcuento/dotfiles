# Environment Variables
# Non-sensitive environment configuration

# Android Development
export ANDROID_HOME=~/Library/Android/sdk

# Apache Ant
export ANT_HOME=~/Development/apache-ant-1.10.15

# Java Home (updated dynamically via ASDF)
asdf_update_java_home() {
  # shellcheck disable=SC2046
  JAVA_HOME=$(realpath $(dirname $(readlink -f $(asdf which java)))/../)
  export JAVA_HOME
}
autoload -U add-zsh-hook
add-zsh-hook precmd asdf_update_java_home

# Sync Manager Configuration
export DOTFILES_PATH="${HOME}/.dotfiles"
export CLAUDE_DIR="${HOME}/.claude"
export CLAUDE_REPO_URL="https://github.com/mattcuento/claudefiles.git"
