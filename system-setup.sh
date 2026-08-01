#!/usr/bin/env bash
#
# Root-level system setup. Everything here needs privileges and lives outside
# a user's home, so chezmoi deliberately does not own it — chezmoi manages
# configuration, not the machine.
#
# Idempotent: safe to re-run. Each step checks before acting.
#
#   sudo ./system-setup.sh
#
# Run AFTER packages are installed and `chezmoi apply` has completed.

set -uo pipefail

[ "$(id -u)" -eq 0 ] || { echo "Run me with sudo." >&2; exit 1; }

TARGET_USER="${SUDO_USER:-$(logname 2>/dev/null || echo "")}"
[ -n "$TARGET_USER" ] || { echo "Cannot determine the invoking user." >&2; exit 1; }

note() { printf '\033[1;34m::\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*" >&2; }
skip() { printf '\033[1;30m--\033[0m %s\n' "$*"; }

note "configuring for user: $TARGET_USER"

# ---------------------------------------------------------------------
# Groups
# ---------------------------------------------------------------------
# uucp is serial access — without it ESP32 flashing fails with a permissions
# error that reads like broken hardware.

for g in wheel input uucp docker libvirt; do
    getent group "$g" >/dev/null 2>&1 || { skip "group $g does not exist, skipping"; continue; }
    if id -nG "$TARGET_USER" | tr ' ' '\n' | grep -qx "$g"; then
        skip "already in group $g"
    else
        note "adding $TARGET_USER to $g"
        usermod -aG "$g" "$TARGET_USER"
    fi
done

# ---------------------------------------------------------------------
# Firewall
# ---------------------------------------------------------------------
# CachyOS ships ufw enabled with deny-incoming. Inbound TCP is DROPPED, not
# rejected, so a box that pings fine will hang on SSH until this rule exists.

if command -v ufw >/dev/null 2>&1; then
    if ufw status 2>/dev/null | grep -q '22/tcp'; then
        skip "ufw already allows 22/tcp"
    else
        note "allowing SSH through ufw"
        ufw allow 22/tcp >/dev/null
    fi
else
    skip "ufw not installed"
fi

# ---------------------------------------------------------------------
# Keyring auto-unlock
# ---------------------------------------------------------------------
# This is the step that makes gnome-keyring feel broken when missed: without
# it the daemon starts LOCKED and every application prompts forever.
#
# The hooks belong in greetd's PAM stack, since there is no display manager.

PAM_FILE=/etc/pam.d/greetd
if [ -f "$PAM_FILE" ]; then
    if grep -q pam_gnome_keyring "$PAM_FILE"; then
        skip "pam_gnome_keyring already wired into $PAM_FILE"
    else
        note "adding pam_gnome_keyring hooks to $PAM_FILE"
        cp "$PAM_FILE" "$PAM_FILE.bak.$(date +%s)"
        printf 'auth       optional    pam_gnome_keyring.so\n'            >> "$PAM_FILE"
        printf 'session    optional    pam_gnome_keyring.so auto_start\n' >> "$PAM_FILE"
    fi
else
    warn "$PAM_FILE not found — is greetd installed? skipping keyring setup"
fi

# ---------------------------------------------------------------------
# greetd -> niri session
# ---------------------------------------------------------------------

if command -v greetd >/dev/null 2>&1; then
    install -d /etc/greetd
    if [ -f /etc/greetd/config.toml ] && grep -q 'niri-session' /etc/greetd/config.toml; then
        skip "greetd already configured for niri"
    else
        note "writing /etc/greetd/config.toml"
        [ -f /etc/greetd/config.toml ] && cp /etc/greetd/config.toml "/etc/greetd/config.toml.bak.$(date +%s)"
        cat > /etc/greetd/config.toml <<EOF
[terminal]
vt = 1

# tuigreet renders in the TTY — no Qt, no GTK, and it is a real PAM login,
# which is what lets pam_gnome_keyring unlock the keyring with your password.
[default_session]
command = "tuigreet --time --remember --cmd niri-session"
user = "greeter"
EOF
    fi

    note "enabling greetd"
    systemctl enable greetd >/dev/null 2>&1
    systemctl set-default graphical.target >/dev/null 2>&1
else
    warn "greetd not installed — skipping session setup"
fi

# ---------------------------------------------------------------------
# Services
# ---------------------------------------------------------------------

# Detect by asking systemctl for the one unit and capturing the result. Do NOT
# pipe `systemctl list-unit-files` into `grep -q`: grep exits at the first match
# and systemctl takes the signal, which under `set -o pipefail` makes the whole
# condition fail. That produced *nondeterministic* false negatives — services
# silently skipped as "not installed" on one run and enabled on the next.

for svc in sshd docker libvirtd tailscaled bluetooth thermald power-profiles-daemon; do
    unit=$(systemctl list-unit-files --no-legend "$svc.service" 2>/dev/null)
    if [ -n "$unit" ]; then
        if systemctl is-enabled "$svc" >/dev/null 2>&1; then
            skip "$svc already enabled"
        else
            note "enabling $svc"
            systemctl enable "$svc" >/dev/null 2>&1 || warn "could not enable $svc"
        fi
    else
        skip "$svc not installed"
    fi
done

echo
note "done. Log out / reboot to land on the greetd + niri session."
note "group changes need a fresh login to take effect."
