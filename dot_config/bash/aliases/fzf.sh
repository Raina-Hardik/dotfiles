# Fuzzy find. https://junegunn.github.io/fzf/
# Vendored from omarchy-zsh.
# See also functions/fzf-widgets.sh for the Ctrl+Alt+{F,L,V} ZLE widgets.

alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
alias eff='$EDITOR "$(ff)"'

# Pick a recently-modified file and scp it somewhere.
sff() {
  if [ $# -eq 0 ]; then
    echo "Usage: sff <destination> (e.g. sff host:/tmp/)"
    return 1
  fi
  local file
  file=$(find . -type f -printf '%T@\t%p\n' | sort -rn | cut -f2- | ff) \
    && [ -n "$file" ] && scp "$file" "$1"
}
