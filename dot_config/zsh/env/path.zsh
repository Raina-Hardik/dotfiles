# PATH additions
# (env/*.zsh is sourced by env.zsh -> init.zsh -> .zshrc)
# PATH is deduped by `typeset -U PATH` in .zshrc, so the first
# occurrence of a directory wins — prepend to take precedence.

path=("$HOME/.local/bin" $path)

# Go tools installed with `go install`.
# mise defaults GOBIN into its *versioned* toolchain dir
# (~/.local/share/mise/installs/go/<version>/bin), so every go upgrade
# silently orphans everything you installed. Pin it outside mise's tree.
export GOBIN="$HOME/go/bin"
path=("$GOBIN" $path)
