# Load all zsh functions in ~/.config/zsh/functions/
FUNCTIONS_DIR="$HOME/.config/zsh/functions"

if [ -d "$FUNCTIONS_DIR" ]; then
    for f in "$FUNCTIONS_DIR"/*.zsh; do
        [ -r "$f" ] && source "$f"
    done
fi

