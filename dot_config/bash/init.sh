# ~/.config/bash/init.sh
CONFIG_DIR="$HOME/.config/bash"

# Source all top-level .sh files except init.sh
for f in "$CONFIG_DIR"/*.sh; do
    [[ -r "$f" && "$(basename "$f")" != "init.sh" ]] && source "$f"
done
