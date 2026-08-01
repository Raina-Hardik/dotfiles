#!/usr/bin/env bash
#
# Install user tooling via each language's own toolchain.
#
# Deliberately NOT managed by mise. mise owns the *runtimes*
# (go, node, rust, uv, chezmoi); the tools below are installed by
# cargo / uv / go directly so they land in real bindirs rather than
# behind another layer of mise shims:
#
#   cargo install  -> ~/.cargo/bin
#   uv tool install-> ~/.local/bin
#   go install     -> ~/go/bin   (GOBIN, pinned in zsh/bash env/path.*)
#
# chezmoi re-runs this whenever the file's contents change, so adding a
# tool to a list below is enough — the next `chezmoi apply` installs it.
# Already-installed tools are skipped, so it is cheap to re-run.

set -uo pipefail

# ---------------------------------------------------------------------
# Manifest
# ---------------------------------------------------------------------

# crates.io. Names are *crate* names, which sometimes differ from the
# binary they ship (git-delta->delta, television->tv, cargo-update->
# cargo-install-update, cargo-run-bin->cargo-bin).
CARGO_TOOLS=(
    cargo-binstall          # prebuilt-binary installer; bootstraps the rest
    cargo-update            # `cargo install-update -a` to upgrade all
    cargo-run-bin
    git-delta               # git pager, wired up in .config/git/config
    television              # fuzzy picker
    navi                    # interactive cheatsheets
    ouch                    # one-command archive extract/compress
    fclones                 # duplicate finder
    diskonaut               # disk usage TUI
    diskwatch
    mcat                    # cat with media support
    viu                     # terminal image viewer
    spotatui                # music TUI; see CARGO_FEATURES for Navidrome
    topgrade                # upgrade-everything runner
    cloudflare-speed-cli
)

# Crates needing non-default cargo features. Same format as a plain entry
# plus the feature list. `subsonic` is NOT a default feature of spotatui —
# without it you get a Spotify-only build with no Navidrome support.
declare -A CARGO_FEATURES=(
    [spotatui]="all-sources"   # local-files + subsonic + internet-radio + youtube
)

# ESP32 embedded toolchain. Only needed for ~/esp-ctrl work; espup
# additionally registers an `esp` toolchain with rustup after install.
CARGO_TOOLS_ESP=(
    espup
    cargo-espflash
    espmonitor
    ldproxy
)

# PyPI, installed as isolated tools by uv.
UV_TOOLS=(
    ruff
    black
    pre-commit
    git-filter-repo
)

# Go modules. Format: "<binary>|<module path>|<build tags, or empty>"
GO_TOOLS=(
    "hugo|github.com/gohugoio/hugo@latest|withdeploy"
    "eget2|github.com/xplshn/eget2@latest|"   # backs the `eget` alias
)

# npm globals. Format: "<binary>|<package>". Uses mise's node.
NPM_GLOBALS=(
    "playwright-cli|@playwright/cli@latest"
)

# Tools distributed via their own install script. Format: "<binary>|<url>".
# Each installs itself into ~/.local/bin (or a versioned dir symlinked there)
# and self-updates afterwards, so these run once and are then skipped.
# These pipe a remote script into a shell — they are first-party installers
# for tools already trusted here, but that is the tradeoff being made.
#
# NOTE: an installer that git-clones from GitHub/GitLab/Bitbucket over HTTPS
# will fail on a fresh machine once .config/git/config is applied — its
# `insteadOf` rules rewrite those URLs to SSH, so the clone needs a key that
# does not exist yet. Set up SSH keys before adding anything like that here.
VENDOR_INSTALLERS=(
    "claude|https://claude.ai/install.sh"
    "agy|https://antigravity.google/cli/install.sh"
)

# ---------------------------------------------------------------------
# Setup
# ---------------------------------------------------------------------

# Forced, NOT `${GOBIN:-...}`. An inherited GOBIN is untrustworthy here: mise
# points it at its own versioned toolchain dir, and a shell started before that
# was fixed still carries the stale value. Honouring it would install go tools
# into a directory the next go upgrade deletes.
export GOBIN="$HOME/go/bin"
mkdir -p "$GOBIN"

failed=()
note() { printf '\033[1;34m::\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*" >&2; }

# The toolchains themselves come from mise; make sure they exist before
# asking them to install anything.
if command -v mise >/dev/null 2>&1 && [ "${SKIP_MISE_INSTALL:-0}" != 1 ]; then
    note "ensuring mise runtimes are installed"
    mise install || warn "mise install reported errors; continuing"
    eval "$(mise activate bash --shims 2>/dev/null)" || true
    PATH="$HOME/.local/share/mise/shims:$PATH"
fi

# ---------------------------------------------------------------------
# cargo
# ---------------------------------------------------------------------

if command -v cargo >/dev/null 2>&1; then
    installed_crates="$(cargo install --list 2>/dev/null | grep -E '^\S+ v' | cut -d' ' -f1)"

    cargo_install() {
        local crate="$1"
        if grep -qx "$crate" <<<"$installed_crates"; then
            return 0
        fi
        local feats="${CARGO_FEATURES[$crate]:-}"
        note "cargo: installing $crate${feats:+ (features: $feats)}"
        # binstall grabs a prebuilt binary when one exists, which turns a
        # multi-minute compile into a download. Upstream release builds already
        # carry the features below, so binstall is safe for those too.
        if command -v cargo-binstall >/dev/null 2>&1 && [ "$crate" != cargo-binstall ]; then
            cargo binstall --no-confirm --disable-telemetry "$crate" && return 0
            warn "binstall failed for $crate; falling back to cargo install"
        fi
        if [ -n "$feats" ]; then
            cargo install --locked --features "$feats" "$crate" || { failed+=("cargo:$crate"); return 1; }
        else
            cargo install --locked "$crate" || { failed+=("cargo:$crate"); return 1; }
        fi
    }

    for crate in "${CARGO_TOOLS[@]}"; do
        cargo_install "$crate"
        # refresh after binstall bootstraps itself
        [ "$crate" = cargo-binstall ] && \
            installed_crates="$(cargo install --list 2>/dev/null | grep -E '^\S+ v' | cut -d' ' -f1)"
    done

    if [ "${INSTALL_ESP_TOOLS:-0}" = 1 ]; then
        for crate in "${CARGO_TOOLS_ESP[@]}"; do cargo_install "$crate"; done
    else
        note "skipping ESP tools (set INSTALL_ESP_TOOLS=1 to include: ${CARGO_TOOLS_ESP[*]})"
    fi
else
    warn "cargo not found; skipped ${#CARGO_TOOLS[@]} crates"
fi

# ---------------------------------------------------------------------
# uv
# ---------------------------------------------------------------------

if command -v uv >/dev/null 2>&1; then
    installed_uv="$(uv tool list 2>/dev/null | grep -E '^\S+ v' | cut -d' ' -f1)"
    for tool in "${UV_TOOLS[@]}"; do
        if grep -qx "$tool" <<<"$installed_uv"; then
            continue
        fi
        note "uv: installing $tool"
        uv tool install "$tool" || failed+=("uv:$tool")
    done
else
    warn "uv not found; skipped ${#UV_TOOLS[@]} tools"
fi

# ---------------------------------------------------------------------
# go
# ---------------------------------------------------------------------

if command -v go >/dev/null 2>&1; then
    for entry in "${GO_TOOLS[@]}"; do
        IFS='|' read -r bin module tags <<<"$entry"
        if [ -x "$GOBIN/$bin" ]; then
            continue
        fi
        note "go: installing $bin"
        if [ -n "$tags" ]; then
            go install -tags "$tags" "$module" || failed+=("go:$bin")
        else
            go install "$module" || failed+=("go:$bin")
        fi
    done
else
    warn "go not found; skipped ${#GO_TOOLS[@]} tools"
fi

# ---------------------------------------------------------------------
# npm globals
# ---------------------------------------------------------------------

if command -v npm >/dev/null 2>&1; then
    for entry in "${NPM_GLOBALS[@]}"; do
        IFS='|' read -r bin pkg <<<"$entry"
        command -v "$bin" >/dev/null 2>&1 && continue
        note "npm: installing $pkg"
        npm install -g "$pkg" || failed+=("npm:$pkg")
    done
else
    warn "npm not found; skipped ${#NPM_GLOBALS[@]} packages"
fi

# ---------------------------------------------------------------------
# Vendor install scripts
# ---------------------------------------------------------------------

for entry in "${VENDOR_INSTALLERS[@]}"; do
    IFS='|' read -r bin url <<<"$entry"
    command -v "$bin" >/dev/null 2>&1 && continue
    note "installer: fetching $bin from $url"
    if curl -fsSL "$url" | bash; then
        command -v "$bin" >/dev/null 2>&1 \
            || warn "$bin installer ran but '$bin' is still not on PATH"
    else
        failed+=("installer:$bin")
    fi
done

# ---------------------------------------------------------------------

if [ ${#failed[@]} -gt 0 ]; then
    warn "failed to install: ${failed[*]}"
    exit 1
fi

note "all tools present"
