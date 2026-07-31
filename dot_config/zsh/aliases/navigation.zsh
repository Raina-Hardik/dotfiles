# Directory navigation.
# Vendored from omarchy-zsh.

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# `cd` routed through zoxide, but only as a fallback: a real directory still
# goes through `builtin cd` with normal semantics. Only a non-directory
# argument triggers a fuzzy jump, which then prints where it landed.
if command -v zoxide &> /dev/null; then
  alias cd="zd"
  zd() {
    if (( $# == 0 )); then
      builtin cd ~ || return
    elif [[ -d $1 ]]; then
      builtin cd "$1" || return
    else
      if ! z "$@"; then
        echo "Error: Directory not found"
        return 1
      fi

      printf "\U000F17A9 "
      pwd
    fi
  }
fi
