# zsh options, keybindings and history.
# Vendored from omarchy-zsh (2026-08-01); the omarchy-dispatcher
# tab-completion block (orig. lines 69-138) was dropped.

# Use emacs key bindings
bindkey -e

# Meta/UTF-8 settings
setopt COMBINING_CHARS

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=32768
SAVEHIST=32768
setopt APPEND_HISTORY           # Append to history file
setopt SHARE_HISTORY            # Share history across sessions
setopt HIST_IGNORE_DUPS         # Ignore duplicate commands
setopt HIST_IGNORE_ALL_DUPS     # Remove older duplicate from history
setopt HIST_IGNORE_SPACE        # Ignore commands starting with space
setopt HIST_REDUCE_BLANKS       # Remove unnecessary blanks
setopt HIST_VERIFY              # Don't execute immediately upon history expansion

# Completion configuration
setopt COMPLETE_IN_WORD         # Complete from both ends of word
setopt ALWAYS_TO_END            # Move cursor to end after completion
unsetopt MENU_COMPLETE          # Don't jump into menu selection on first tab
unsetopt BASH_AUTO_LIST         # Let AUTO_LIST below list immediately when ambiguous
setopt AUTO_LIST                # List choices when completion is ambiguous
setopt LIST_AMBIGUOUS           # Insert any shared prefix before listing choices
setopt AUTO_MENU                # Enter menu selection on repeated tab after listing


# Shift-Tab cycles the completion menu backwards. The main-keymap binding
# kicks in on the first press; the menuselect binding handles subsequent
# presses once the highlighted menu is active.
bindkey '^[[Z' reverse-menu-complete
bindkey -M menuselect '^[[Z' reverse-menu-complete

# Extended globbing
setopt EXTENDED_GLOB

# Don't beep on errors
unsetopt BEEP

# Allow comments in interactive shells
setopt INTERACTIVE_COMMENTS

# Color man pages with bat
export MANROFFOPT="-c"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Ensure mise works (disable command hashing)
setopt NO_HASH_CMDS
setopt NO_HASH_DIRS

