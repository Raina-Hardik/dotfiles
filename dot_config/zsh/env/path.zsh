# PATH additions
# (env/*.zsh is sourced by env.zsh -> init.zsh -> .zshrc)
# PATH is deduped by `typeset -U PATH` in .zshrc, so the first
# occurrence of a directory wins — prepend to take precedence.

path=("$HOME/.local/bin" $path)
