# Load all env setups in env
ENV_DIR="$HOME/.config/bash/env/"

if [ -d "$ENV_DIR" ]; then
    for f in "$ENV_DIR"/*.sh; do
        [ -r "$f" ] && source "$f"
    done
fi
