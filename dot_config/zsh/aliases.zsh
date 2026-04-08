# Load all zsh functions in ~/.config/zsh/aliases/
ALIASES_DIR="$HOME/.config/zsh/aliases/"

if [ -d "$ALIASES_DIR" ]; then
    for f in "$ALIASES_DIR"/*.zsh; do
        [ -r "$f" ] && source "$f"
    done
fi


