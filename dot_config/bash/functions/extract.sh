extract() {
    # Check if a file was provided
    [ -f "$1" ] || { echo "Not a file"; return 1; }

    # Get the base filename and prepare a directory name
    filename=$(basename "$1")
    dirname="${filename%.*}"

    # Handle double extensions like .tar.gz, .tar.bz2, .tar.xz, .tgz, .tbz2
    case "$filename" in
        *.tar.gz|*.tgz)  dirname="${filename%.tar.gz}"; dirname="${dirname%.tgz}" ;;
        *.tar.bz2|*.tbz2) dirname="${filename%.tar.bz2}"; dirname="${dirname%.tbz2}" ;;
        *.tar.xz)        dirname="${filename%.tar.xz}" ;;
        *.tar.lz)        dirname="${filename%.tar.lz}" ;;
        *.tar.lzma)      dirname="${filename%.tar.lzma}" ;;
        *.tar.Z)         dirname="${filename%.tar.Z}" ;;
        *.tar)           dirname="${filename%.tar}" ;;
    esac

    # Create directory if it doesn't exist
    mkdir -p "$dirname"

    # Extract files into the directory
    case "$1" in
        *.tar.bz2|*.tbz2) tar xjf "$1" -C "$dirname" ;;
        *.tar.gz|*.tgz)   tar xzf "$1" -C "$dirname" ;;
        *.tar.xz)         tar xJf "$1" -C "$dirname" ;;
        *.tar.lz)         tar --lzip -xf "$1" -C "$dirname" ;;
        *.tar.lzma)       tar --lzma -xf "$1" -C "$dirname" ;;
        *.tar.Z)          uncompress -c "$1" | tar xf - -C "$dirname" ;;
        *.tar)            tar xf "$1" -C "$dirname" ;;
        *.bz2)            bunzip2 -c "$1" > "$dirname/${filename%.bz2}" ;;
        *.gz)             gunzip -c "$1" > "$dirname/${filename%.gz}" ;;
        *.xz)             unxz -c "$1" > "$dirname/${filename%.xz}" ;;
        *.zip)            unzip -o "$1" -d "$dirname" ;;
        *.7z)             7z x -y "$1" -o"$dirname" ;;
        *.rar)            unrar x -o+ "$1" "$dirname" ;;
        *.lz)             lzip -d -c "$1" > "$dirname/${filename%.lz}" ;;
        *.cpio)           cpio -idmv < "$1" ;;
        *.ar)             ar x "$1" ;;
        *.iso)            7z x -y "$1" -o"$dirname" ;;
        *.cab)            cabextract -d "$dirname" "$1" ;;
        *)                echo "Don't know how to extract '$1'" ; return 2 ;;
    esac

    echo "Extracted '$1' into '$dirname'"
}

