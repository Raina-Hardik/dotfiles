# Shell-agnostic options. zsh counterpart: the same block in env/options.zsh.
# (zsh-only setopt/bindkey settings are deliberately not mirrored here.)

# Color man pages with bat
export MANROFFOPT="-c"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
