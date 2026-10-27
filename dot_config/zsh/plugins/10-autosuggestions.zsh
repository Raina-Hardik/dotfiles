# zsh-autosuggestions: inline gray suggestions from history.
# Needs compinit (env/completion.zsh) and the fzf widgets already defined, so it
# loads from plugins.zsh, after env/ and functions/. Must stay before 99-.
[[ -r "$HOME/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
  source "$HOME/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
