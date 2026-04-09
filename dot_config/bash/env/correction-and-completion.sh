# Correction - bash uses nocorrect/shopt for various options
# Enable bash completion if available
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Enable bash completion from homebrew or other sources
if [ -f $(brew --prefix 2>/dev/null)/etc/bash_completion ]; then
    . $(brew --prefix 2>/dev/null)/etc/bash_completion
fi

# Enable cdable_vars for easier cd into CDPATH-like navigation
shopt -s cdable_vars 2>/dev/null

# Enable extglob for extended glob patterns
shopt -s extglob 2>/dev/null

# Enable checkwinsize for proper terminal size handling
shopt -s checkwinsize 2>/dev/null

# Enable globstar for recursive ** patterns
shopt -s globstar 2>/dev/null
