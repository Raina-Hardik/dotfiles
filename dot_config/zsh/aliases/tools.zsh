# Tool shorthands.
# Vendored from omarchy-zsh, minus the ones tied to tools not installed here
# (`c`/opencode, `cy`/codex, `r`/rails).

# Clear scrollback, then Claude with permission prompts off.
alias cx='printf "\033[2J\033[3J\033[H" && claude --permission-mode bypassPermissions'

alias d='docker'
alias t='tmux attach || tmux new -s Work'

# tmux dev layout with Claude in the agent pane.
# `tdl` is defined in functions/tmux.zsh and requires an active tmux session.
alias ix='tdl cx'

# nvim, defaulting to the current directory.
n() {
  if [ "$#" -eq 0 ]; then
    command nvim .
  else
    command nvim "$@"
  fi
}
