# ~/.config/bash/functions/cr.sh
cr() {
    clear
    # Use the last command from history
    if [ -n "$BASH_COMMAND" ]; then
        # Run the last command entered
        fc -s
    fi
}

