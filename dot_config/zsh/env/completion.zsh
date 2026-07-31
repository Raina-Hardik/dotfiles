# Completion system: compinit, menu selection, colors, matchers.
# Vendored from omarchy-zsh (2026-08-01).

# /usr/share/zsh/site-functions/, which is on the default fpath.
autoload -Uz compinit
compinit -i

# zsh/complist provides the menuselect keymap and the highlighted
# interactive completion menu (enabled below via `menu select`).
zmodload zsh/complist

# Directory navigation
setopt AUTO_CD                  # cd by typing directory name
setopt CHASE_LINKS              # Mark symlinked directories

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=* l:|=*'

# Interactive menu with the current selection highlighted.
zstyle ':completion:*' menu select

# Populate LS_COLORS so completion listings (and ls) get colors. Coreutils
# `ls` falls back to built-in defaults, but the list-colors zstyle below
# needs LS_COLORS to be exported.
if [[ -z $LS_COLORS ]] && (( $+commands[dircolors] )); then
  eval "$(dircolors -b)"
fi

# Colored completion listings
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Use the column-grid completion layout (filenames only). Defensively delete
# any prior `file-list` style so re-sourcing on top of an older system copy
# of zoptions (e.g. via dev-link) doesn't leave the verbose ls -l listing.
zstyle -d ':completion:*' file-list

# Show all completions at once (no paging)
zstyle ':completion:*' list-prompt ''
zstyle ':completion:*' select-prompt ''

# Don't complete hidden files unless explicitly starting with dot
zstyle ':completion:*' match-hidden-files off

