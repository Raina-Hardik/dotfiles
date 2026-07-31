# Manual steps

Everything chezmoi cannot do. Ordered as you'd actually run it on a fresh
CachyOS install. Nothing here is recoverable from this repo — if it isn't done,
it isn't done.

---

## 0. During installation

- [ ] Install CachyOS with **no DE and no WM**. niri and the shell layer get
      built up afterwards.
- [ ] LUKS on root.
- [ ] Confirm **multilib is enabled** in `/etc/pacman.conf`. CachyOS enables it
      by default; without it `steam`, `lib32-nvidia-utils` and `lib32-vulkan-intel`
      fail to resolve and the whole pacman transaction aborts.

---

## 1. Bootstrap

See `README.md` for the exact command order. The short version, and the order
matters:

```
mise → chezmoi init (clone only) → pacman/yay → chezmoi apply
```

Applying before packages are installed makes the `ouch` and `spotatui` builds
fail — they need `clang` (libclang, for bindgen) and `alsa-lib` respectively.

---

## 2. Groups

```sh
sudo usermod -aG libvirt,docker,uucp,input,wheel "$USER"
```

Log out and back in for these to take effect.

| Group | Why |
|---|---|
| `uucp` | Serial port access. Without it ESP32 flashing fails with a permissions error that reads like broken hardware. |
| `docker` | Rootless docker CLI |
| `libvirt` | virt-manager / qemu |
| `input` | Input device access for compositor tooling |
| `wheel` | sudo |

---

## 3. Session + login

The goal: LUKS → greeter → niri session, with the keyring unlocked once and
never prompting again.

- [ ] Install a greeter. **greetd + tuigreet** is the minimal option and is a
      real PAM login (SDDM works but drags in Qt for a two-second screen).
- [ ] `systemctl enable greetd`
- [ ] Point greetd's session at **`niri-session`** — niri's own systemd-integrated
      launcher. `uwsm` is the compositor-agnostic alternative if wanted.

### Keyring auto-unlock — the step that makes it feel broken if skipped

Add to **`/etc/pam.d/greetd`** (not a display manager's file — there isn't one):

```
auth     optional  pam_gnome_keyring.so
session  optional  pam_gnome_keyring.so auto_start
```

Without these, gnome-keyring starts *locked* and every application prompts
forever.

> **Do not copy `~/.local/share/keyrings/` forward from the old machine.**
> The old `Default_keyring.keyring` is stored as **plaintext INI with an empty
> password** — a side effect of SDDM autologin having no password to derive a
> key from. Let the new system create a fresh, properly encrypted login keyring
> and re-add the secrets by hand. There were 6 of them.

### Screen locker

The keyring stays unlocked for the life of the session, so the locker does not
need to touch it. Only if idle-locking of the keyring itself is enabled
(`lock-on-idle`) does the locker's PAM file need the same two lines.

Prefer **noctalia's built-in lock screen** over hyprlock. hyprlock does work on
niri, but hypridle reports niri missing `hyprland-lock-notify-v1`, and
[niri#2986](https://github.com/niri-wm/niri/issues/2986) can leave the
compositor in an unrecoverable blank state if the locker restarts mid-lock.

---

## 4. systemd units

```sh
sudo systemctl enable --now docker libvirtd tailscaled ufw bluetooth iwd \
                            thermald power-profiles-daemon
```

Adjust to taste — this is what the old box had enabled, not a prescription.

---

## 5. Toolchain follow-ups

- [ ] `tailscale up` (re-auth; the old machine's state does not transfer)
- [ ] `espup install` — only if doing ESP32 work. It registers an `esp`
      toolchain with rustup. Let mise install rust *first*.
- [ ] Re-add the 6 keyring secrets.
- [ ] Regenerate or copy SSH keys, and re-add the public key to GitHub.
      **The dotfiles repo remote is SSH.**

---

## 6. Shell layer

- [ ] `zsh-syntax-highlighting` is installed from pacman and sourced at the very
      end of `.zshrc`. If it moves, highlighting silently stops covering the fzf
      ZLE widgets.
- [ ] Login shell stays **bash**, deliberately — a clean, dependency-free TTY
      fallback. zsh is reached via ghostty spawning it directly, not `chsh`.

---

## 7. Deliberately not carried over

| Thing | Why |
|---|---|
| `~/.local/share/keyrings/` | Plaintext, empty password. See above. |
| Docker volumes (`gaps_*`) | Dev-only on the old machine, disposable. |
| `omarchy-*` packages | Omarchy repo only. The wanted parts are vendored into this repo. |
| `tobi-try` (`try`) | Unused. |
| `codex`, `opencode` shim, `ghui`, `copilot`, `gemini`, `pi`, `leaf` | Dropped. `mcat` covers `leaf`. |
| `uv` / `uvx` in `~/.local/bin` | mise owns uv now; the hand-installed copies are redundant. |

Still hand-installed and **not yet tracked** — decide before wiping:
`agy`, `hermes` (installer: `curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash`),
`playwright-cli`.
