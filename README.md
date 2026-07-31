# dotfiles

Personal configuration, managed with [chezmoi](https://chezmoi.io).

**Target system:** CachyOS (Arch-based) + [niri](https://github.com/YaLTeR/niri),
installed TTY-first with no desktop environment, then riced by hand.

**Scope:** this repo owns *configuration*. It does not decide which distro,
compositor, or shell to use — those are choices made once at install time. The
package manifests in `packages/` are data, not logic: lists you edit, fed to a
package manager you invoke.

---

## Bootstrap on a fresh machine

Order matters. Several Rust tools need system libraries present *before* they
compile, so packages must land before `chezmoi apply` runs the tool installer.

```sh
# 1. mise — the only bootstrap dependency. Brings chezmoi, go, rust, uv, node.
curl https://mise.run | sh
export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"
mise use -g chezmoi@latest

# 2. Clone the source WITHOUT applying yet.
chezmoi init https://github.com/Raina-Hardik/dotfiles.git

# 3. System packages first — install-tools.sh depends on some of them.
cd ~/.local/share/chezmoi
sudo pacman -S --needed - < packages/pacman-native.lst
yay   -S --needed - < packages/pacman-aur.lst
flatpak install -y $(cat packages/flatpak.lst)

# 4. Now apply. This writes the dotfiles and runs the tool installer.
chezmoi apply
```

> **Do not** run `chezmoi init --apply` in one shot on a bare machine. It would
> execute `install-tools.sh` before pacman has installed `clang` and `alsa-lib`,
> and the `ouch` and `spotatui` builds would fail. Verified in a clean Arch
> container.

`multilib` must be enabled for `steam` and the `lib32-*` packages. CachyOS
enables it by default; stock Arch does not.

---

## Layout

| Path | Purpose |
|---|---|
| `dot_zshrc`, `dot_bashrc`, `dot_bash_profile` | Shell entry points |
| `dot_config/zsh/`, `dot_config/bash/` | Modular shell config, kept at parity |
| `dot_config/…` | nvim, git, ghostty, tmux, btop, mise, starship, walker, lazygit |
| `packages/*.lst` | Package manifests. Excluded from `$HOME` via `.chezmoiignore` |
| `.chezmoiscripts/run_onchange_after_install-tools.sh` | Installs cargo/uv/go tools |

### Shell config

`.zshrc` sources `~/.config/zsh/init.zsh`, which sources every top-level
`*.zsh`, each of which loops over its matching directory:

```
init.zsh ──> aliases.zsh ──> aliases/*.zsh
        ──> env.zsh     ──> env/*.zsh
        ──> functions.zsh ──> functions/*.zsh
```

`~/.config/bash/` mirrors this exactly with `.sh` extensions. **Changes to one
side should be made to both.** The two trees have drifted apart before.

---

## Manual steps chezmoi cannot do

Nothing below is recoverable from this repo. Do them by hand after `apply`.

**Group membership** — none of this is in any dotfile:

```sh
sudo usermod -aG libvirt,docker,uucp,input,wheel "$USER"
```

`uucp` is serial-port access. Without it, ESP32 flashing fails with a
permissions error that looks like broken hardware.

**Keyring auto-unlock.** `gnome-keyring` provides the Secret Service API that
git, `gh`, and browsers use. Because there is no display manager, the PAM hooks
go in `/etc/pam.d/login`, not a DM's file:

```
auth     optional  pam_gnome_keyring.so
session  optional  pam_gnome_keyring.so auto_start
```

Without these the daemon starts *locked* and every app prompts forever. This is
the step that makes keyring setup feel broken.

**Other:** `sudo tailscale up`; enable needed systemd units (`docker`,
`libvirtd`, `tailscaled`, `ufw`, `bluetooth`, `iwd`, `thermald`,
`power-profiles-daemon`); re-run `espup install` if doing ESP32 work.

---

## Decisions

Recorded so they don't get re-litigated.

| Decision | Rationale |
|---|---|
| **bash stays the login shell** | A clean, dependency-free TTY fallback is worth a lot on a heavily riced system. zsh is reached via ghostty, which spawns it directly — not via `chsh`. |
| **mise owns runtimes; toolchains own tools** | mise installs go/node/rust/uv/chezmoi. Tools install via `cargo`/`uv tool`/`go install` so they land in real bindirs instead of behind another layer of shims. |
| **`GOBIN` pinned to `~/go/bin`** | mise defaults `GOBIN` into its *versioned* toolchain dir, so every go upgrade silently orphans `go install` binaries. Set via `go_set_gobin = false` plus an explicit export in `env/path.*`. |
| **Python via uv, not mise** | uv handles per-project versions. Bare `python` resolves to the system interpreter. |
| **rust in mise, rustup left alone on the old box** | The old machine has an `esp` toolchain plus pinned nightlies registered with rustup; letting mise take over would orphan them. On a fresh install mise owns rust from the start. |
| **No `core.excludesFile`** | It *replaces* `~/.config/git/ignore` rather than adding to it, and hardcoded an absolute `/home/hardik` path. Global ignores now live at the XDG default path git finds on its own. |
| **`spotatui` built with `all-sources`** | The `subsonic` feature is not a cargo default. Without it you get a Spotify-only binary with no Navidrome support. |
| **`packages/` excluded from `$HOME`** | Manifests belong in the repo, not the home directory. |

### Known-dead config, pending cleanup

Aliases inherited from omarchy that reference tools not installed here:
`ic`, `ix`, `icx` (need `tdl`), and `eget` (needs `eget2`, which is not in the
AUR or crates.io — source unknown).

---

## Notes

- `omarchy-zsh` provides ~655 lines of shell config at `/usr/share/omarchy-zsh/`
  that this repo does *not* own. On a non-omarchy system those files simply do
  not exist and the `[[ -f ]]` guards silently skip them — no error, just a
  quietly worse shell. Vendor what is wanted before hopping.
- `chezmoi apply --dry-run -v` renders scripts as diffs. That is display only;
  scripts are never written into `$HOME`.
