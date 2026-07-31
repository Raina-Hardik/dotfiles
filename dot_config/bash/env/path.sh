# PATH additions
# (env/*.sh is sourced by env.sh -> init.sh -> .bashrc)
# bash has no `typeset -U` dedup like zsh, so guard against re-sourcing
# appending duplicates — prepend only if not already present.

case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) PATH="$HOME/.local/bin:$PATH" ;;
esac
export PATH
