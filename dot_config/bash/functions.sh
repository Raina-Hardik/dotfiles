# Load all bash functions in ~/.config/bash/functions/
FUNCTIONS_DIR="$HOME/.config/bash/functions"

if [ -d "$FUNCTIONS_DIR" ]; then
    for f in "$FUNCTIONS_DIR"/*.sh; do
        [ -r "$f" ] && source "$f"
    done
fi
