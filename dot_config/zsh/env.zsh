# Load all env setups in env
ENV_DIR="$HOME/.config/zsh/env/"

if [ -d "$ENV_DIR" ]; then
    for f in "$ENV_DIR"/*.zsh; do
        [ -r "$f" ] && source "$f"
    done
fi
