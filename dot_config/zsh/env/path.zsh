# PATH additions
# (env/*.zsh is sourced by env.zsh -> init.zsh -> .zshrc)
# PATH is deduped by `typeset -U PATH` in .zshrc, so the first
# occurrence of a directory wins — prepend to take precedence.

path=("$HOME/.local/bin" $path)

# Go tools installed with `go install` land in ~/go/bin.
# NOTE: GOBIN itself is exported in .zshrc *after* `mise activate`, because
# mise unsets GOBIN when go_set_gobin=false and would clobber a value set here.
path=("$HOME/go/bin" $path)
