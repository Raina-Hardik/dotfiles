# zsh-syntax-highlighting MUST be sourced last so it wraps every ZLE widget
# defined above it (notably the fzf widgets in functions/fzf-widgets.zsh and
# the autosuggestions widgets). Keep the 99- prefix so it sorts after every
# other plugin, and never define widgets after init.zsh in .zshrc.
[[ -r "$HOME/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
  source "$HOME/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
