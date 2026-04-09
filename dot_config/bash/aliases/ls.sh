# Basic listing (ls default)
alias ls='eza --group-directories-first --icons=auto'

# Minimal listing (no dots) but respects .gitignore
alias l='eza --group-directories-first --icons=auto --git-ignore'

# Human-readable sizes
alias lh='eza -lh --group-directories-first --icons=auto'

# List almost all (everything except . and ..)
alias la='eza -la --almost-all --group-directories-first --icons=auto'

# Tree view, 2 levels
alias lt='eza --tree --level=2 --long --icons --git'

# Long listing with permissions first (like 'ls -l')
alias lp='eza -l --group-directories-first --icons=auto --long'

# Sort by file size, largest first, human readable
alias lsh='eza -lhS --group-directories-first --icons=auto'

# Sort by file size, smallest first, human readable
alias lss='eza -lhSr --group-directories-first --icons=auto'

# Clear screen and run basic listing
alias cls='clear && ls'

# Sort by modification time, newest first
alias ltm='eza -lh --sort=modified --icons=auto --group-directories-first'

# Sort by modification time, oldest first
alias ltr='eza -lh --sort=modified --reverse --icons=auto --group-directories-first'
