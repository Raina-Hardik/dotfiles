# PATH additions
# (env/*.sh is sourced by env.sh -> init.sh -> .bashrc)
# bash has no `typeset -U` dedup like zsh, so guard against re-sourcing
# appending duplicates — prepend only if not already present.

case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) PATH="$HOME/.local/bin:$PATH" ;;
esac

# Go tools installed with `go install`.
# mise defaults GOBIN into its *versioned* toolchain dir
# (~/.local/share/mise/installs/go/<version>/bin), so every go upgrade
# silently orphans everything you installed. Pin it outside mise's tree.
export GOBIN="$HOME/go/bin"
case ":$PATH:" in
    *":$GOBIN:"*) ;;
    *) PATH="$GOBIN:$PATH" ;;
esac

export PATH
