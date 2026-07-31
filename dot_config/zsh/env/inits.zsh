# Tool initialisation.
# Vendored from omarchy-zsh's `inits`. mise is deliberately NOT here — .zshrc
# activates it after this file, so that its shims win the PATH ordering.

if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

if command -v fzf &>/dev/null; then
  [[ -f /usr/share/fzf/completion.zsh ]]   && source /usr/share/fzf/completion.zsh
  [[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
fi
