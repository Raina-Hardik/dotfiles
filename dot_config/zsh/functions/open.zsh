open-exe () {
    local exe="$1"
    shift
    if [[ "$exe" == *.exe ]]; then
        # Run with Wine/Proton
        SDL_VIDEODRIVER=x11 SDL_AUDIODRIVER=pulse GDK_SCALE=1 wine "$exe" "$@" &
    else
        # Generic Linux binary
        SDL_VIDEODRIVER=x11 SDL_AUDIODRIVER=pulse GDK_SCALE=1 "$exe" "$@" &
    fi
    disown
}

open-renpy () { SDL_VIDEODRIVER=x11 SDL_AUDIODRIVER=pulse GDK_SCALE=1 "$@" & disown }


open() {
    xdg-open "$@" >/dev/null 2>&1 &
    disown
    echo "Opened $*"
}
