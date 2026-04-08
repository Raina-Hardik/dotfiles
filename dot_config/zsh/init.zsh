# ~/.config/zsh/init.zsh
CONFIG_DIR="$HOME/.config/zsh"

# Source all top-level .zsh files except init.zsh
for f in "$CONFIG_DIR"/*.zsh; do
    [[ -r "$f" && "$(basename "$f")" != "init.zsh" ]] && source "$f"
done

