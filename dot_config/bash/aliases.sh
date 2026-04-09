# Load all bash aliases in ~/.config/bash/aliases/
ALIASES_DIR="$HOME/.config/bash/aliases/"

if [ -d "$ALIASES_DIR" ]; then
    for f in "$ALIASES_DIR"/*.sh; do
        [ -r "$f" ] && source "$f"
    done
fi
