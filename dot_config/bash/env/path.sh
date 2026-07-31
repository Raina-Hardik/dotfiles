# PATH additions
# (env/*.sh is sourced by env.sh -> init.sh -> .bashrc)
# bash has no `typeset -U` dedup like zsh, so guard against re-sourcing
# appending duplicates — prepend only if not already present.

case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) PATH="$HOME/.local/bin:$PATH" ;;
esac

# Go tools installed with `go install` land in ~/go/bin.
# NOTE: GOBIN itself is exported in .bashrc *after* `mise activate`, because
# mise unsets GOBIN when go_set_gobin=false and would clobber a value set here.
case ":$PATH:" in
    *":$HOME/go/bin:"*) ;;
    *) PATH="$HOME/go/bin:$PATH" ;;
esac

export PATH
