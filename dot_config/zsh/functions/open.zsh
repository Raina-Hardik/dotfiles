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


open-yuri() {
    # Launches a Japanese YU-RIS engine game through Bottles.
    # Usage:
    #   open-yuri /path/to/GAME.exe     # launch a specific exe directly
    #   open-yuri /path/to/GameDir      # resolve GameDir/Data/*.exe (minus settings)
    #   open-yuri                       # same, using the current directory
    local BOTTLE_NAME="yu-ris"
    bottles_cli() { flatpak run --command=bottles-cli com.usebottles.bottles "$@"; }
    local target="${1:-.}"
    local exe_path

    if [[ -f "$target" && "$target" == *.exe ]]; then
        # Direct exe path given.
        exe_path="$(cd "$(dirname "$target")" && pwd)/$(basename "$target")"
    elif [[ -d "$target" ]]; then
        # Directory given: resolve the game exe in <dir>/Data/.
        local game_dir data_dir
        game_dir="$(cd "$target" && pwd)"
        data_dir="$game_dir/Data"

        if [[ ! -d "$data_dir" ]]; then
            echo "open-yuri: no Data/ directory in $game_dir" >&2
            return 1
        fi

        local candidates=()
        while IFS= read -r line; do
            candidates+=("$line")
        done < <(
            find "$data_dir" -maxdepth 1 -type f -iname '*.exe' \
                ! -name 'エンジン設定.exe' -printf '%p\n'
        )

        if [[ "${#candidates[@]}" -eq 0 ]]; then
            echo "open-yuri: no game exe found in $data_dir" >&2
            return 1
        elif [[ "${#candidates[@]}" -gt 1 ]]; then
            echo "open-yuri: multiple candidate exes in $data_dir:" >&2
            printf '  %s\n' "${candidates[@]}" >&2
            echo "open-yuri: cannot auto-resolve which one is the game." >&2
            return 1
        fi
        exe_path="${candidates[1]}"
    else
        echo "open-yuri: '$target' is not a .exe file or a directory" >&2
        return 1
    fi

    echo "Resolved game exe: $exe_path"

    # Warn if the ja_JP locale isn't generated on the host — YU-RIS renders
    # Shift-JIS text and needs Wine's LANG=ja_JP.UTF-8 codepage emulation,
    # otherwise in-game text shows as mojibake/garbage boxes.
    if ! locale -a 2>/dev/null | grep -qi '^ja_JP\.utf8$'; then
        cat >&2 <<'EOF'
Warning: ja_JP.UTF-8 locale is not generated on this system.
In-game Japanese text will likely render as garbled boxes without it.
One-time fix (needs sudo):
  sudo sed -i 's/^#ja_JP.UTF-8/ja_JP.UTF-8/' /etc/locale.gen
  sudo locale-gen
EOF
    fi

    # Create the shared bottle on first run.
    if ! bottles_cli list bottles 2>/dev/null | grep -q "^- ${BOTTLE_NAME}\$"; then
        echo "Creating bottle '$BOTTLE_NAME' (this only happens once)..."
        bottles_cli new --bottle-name "$BOTTLE_NAME" --environment gaming --arch win32
    fi

    echo "Launching game..."
    flatpak run --env=LANG=ja_JP.UTF-8 --command=bottles-cli com.usebottles.bottles \
        run -b "$BOTTLE_NAME" -e "$exe_path"
}

open() {
    xdg-open "$@" >/dev/null 2>&1 &
    disown
    echo "Opened $*"
}
