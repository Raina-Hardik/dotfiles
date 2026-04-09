# Correction
# shopt -s nocorrect              # Bash doesn't have spell-check like zsh
# shopt -s nocorrect_all          # (equivalent to CORRECT_ALL)

# Misc
shopt -s interactive_comments    # Allow comments in interactive shell

# Completion
shopt -s complete_in_word        # Complete from both ends of a word (if available)

# Navigation
shopt -s autocd 2>/dev/null      # Type directory name to cd
shopt -s cdspell 2>/dev/null     # Correct small errors in cd
shopt -s extglob 2>/dev/null     # Enable extended pattern matching
shopt -s globstar 2>/dev/null    # Enable recursive ** patterns
