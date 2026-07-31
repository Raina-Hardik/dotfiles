# Tool initialisation.
# Vendored from omarchy-zsh's `inits`. mise is deliberately NOT here — .bashrc
# activates it after this file, so that its shims win the PATH ordering.

if command -v starship &>/dev/null; then
  # Clear stale readline state before rendering the prompt. Without this,
  # an abnormal exit (SIGQUIT and friends) leaves artifacts in the next prompt.
  __sanitize_prompt() { printf '\r\033[K'; }
  PROMPT_COMMAND="__sanitize_prompt${PROMPT_COMMAND:+;$PROMPT_COMMAND}"

  eval "$(starship init bash)"
fi

if command -v zoxide &>/dev/null; then
  eval "$(zoxide init bash)"
fi

if command -v fzf &>/dev/null; then
  [[ -f /usr/share/fzf/completion.bash ]]   && source /usr/share/fzf/completion.bash
  [[ -f /usr/share/fzf/key-bindings.bash ]] && source /usr/share/fzf/key-bindings.bash
fi
