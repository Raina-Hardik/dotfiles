-- Keep only your personal keybinding overrides here. Add new bindings with
-- o.bind or replace defaults with o.rebind.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding. o.rebind takes the same arguments as o.bind.
-- This example replaces the default file manager with Flea.
-- o.rebind("SUPER + SHIFT + F", "File manager", { launch = "flea" })

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, { panel = "omarchy.emojis" })

-- Migrated from bindings.conf.
local cwd = '"$(omarchy-cmd-terminal-cwd)"'
local term = "uwsm-app -- xdg-terminal-exec --dir=" .. cwd

o.rebind("SUPER + ALT + RETURN", "Tmux", term .. ' bash -c "tmux attach || tmux new -s Work"')
o.rebind("SUPER + SHIFT + RETURN", "GitHub", o.launch_webapp("https://github.com"))
o.rebind("SUPER + SHIFT + F", "File manager", "uwsm-app -- nautilus --new-window")
o.rebind("SUPER + ALT + SHIFT + F", "File manager (cwd)", "uwsm-app -- nautilus --new-window " .. cwd)
o.rebind("SUPER + SHIFT + B", "Browser", "omarchy-launch-browser")
o.rebind("SUPER + SHIFT + ALT + B", "Browser (private)", "omarchy-launch-browser --private")
o.rebind("SUPER + SHIFT + N", "Editor", "omarchy-launch-editor")
o.rebind("SUPER + SHIFT + D", "Docker", "omarchy-launch-tui lazydocker")
o.rebind("SUPER + SHIFT + G", "Yazi", term .. " yazi")
o.rebind("SUPER + SHIFT + O", "Affine", o.launch_webapp_sole("Affine", "https://affine.shorthair-micro.ts.net"))
o.rebind("SUPER + SHIFT + W", "WhatsApp", o.launch_webapp_sole("WhatsApp", "https://web.whatsapp.com/"))
o.rebind("SUPER + SHIFT + SLASH", "Steam", o.launch_sole("^steam$", "steam"))

o.rebind("SUPER + SHIFT + A", "Gemini", o.launch_webapp("https://gemini.google.com/app"))
o.rebind("SUPER + SHIFT + ALT + A", "Claude", o.launch_webapp("https://claude.ai"))
o.rebind("SUPER + SHIFT + C", "Google Meet", o.launch_webapp_sole("Google Meet", "https://meet.google.com/"))
o.rebind("SUPER + SHIFT + E", "Gmail", o.launch_webapp("https://mail.google.com/"))
o.rebind("SUPER + SHIFT + Y", "YouTube", o.launch_webapp("https://youtube.com/"))

o.rebind("SUPER + SHIFT + P", "Immich", o.launch_webapp_sole("Immich", "https://immich.shorthair-micro.ts.net"))
o.rebind("SUPER + SHIFT + X", "Horizon", o.launch_sole("^horizon-electron$", "fchat-horizon"))
o.rebind("SUPER + SHIFT + ALT + X", "Hermes", "omarchy-launch-tui hermes")

-- Restore the pre-Lua launcher layout: Super+Space = Walker apps, Super+Alt+Space = Omarchy menu.
o.rebind("SUPER + SPACE", "Launch apps", "launch-walker")
o.rebind("SUPER + ALT + SPACE", "Omarchy menu", { menu = "root" })
o.rebind("SUPER + CTRL + E", "Emoji picker", "launch-walker -m symbols")

-- Drop the default Google Maps webapp binding; leave Super+Shift+S unbound.
hl.unbind("SUPER + SHIFT + S")

-- Super+Q duplicates Super+W (close window); free it, along with the unused
-- Spotify and cliamp defaults.
hl.unbind("SUPER + Q")
hl.unbind("SUPER + SHIFT + M")
hl.unbind("SUPER + SHIFT + ALT + M")

-- Music lives on its own special workspace, apart from the scratchpad. Super+M
-- shows or hides it, pulling Feishin in if it is elsewhere and launching it
-- there if it is not running. This replaces minimize-to-dock.
local feishin_url = "https://feishin.shorthair-micro.ts.net/"
local feishin_class = "chrome-feishin.shorthair-micro.ts.net__-Default"

local function toggle_music()
  for _, window in ipairs(hl.get_windows()) do
    if window.class == feishin_class then
      if not (window.workspace and window.workspace.name == "special:music") then
        hl.dispatch(hl.dsp.window.move({ workspace = "special:music", follow = false, window = "address:" .. window.address }))
      end
      hl.dispatch(hl.dsp.workspace.toggle_special("music"))
      return
    end
  end
  hl.exec_cmd(o.launch_webapp(feishin_url), { workspace = "special:music" })
end

o.rebind("SUPER + M", "Toggle music", toggle_music)
o.bind("SUPER + ALT + M", "Move window to music", hl.dsp.window.move({ workspace = "special:music", follow = false }))
