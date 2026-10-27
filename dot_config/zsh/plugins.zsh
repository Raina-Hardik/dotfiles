# Load all zsh plugin loaders in ~/.config/zsh/plugins/
# Plugin source is fetched by chezmoi (.chezmoiexternal.toml), not vendored in
# git. Files load in name order: number-prefix a loader to control ordering.
PLUGINS_DIR="$HOME/.config/zsh/plugins"

if [ -d "$PLUGINS_DIR" ]; then
    for f in "$PLUGINS_DIR"/*.zsh; do
        [ -r "$f" ] && source "$f"
    done
fi
