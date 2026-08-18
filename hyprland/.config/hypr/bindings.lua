-- Personal keybinding overrides.
-- See current bindings and descriptions: omarchy menu keybindings --print
--
-- Bindings that Omarchy 4 now ships as defaults were dropped here:
-- terminal, tmux, browser, file manager, spotify, nvim, lazydocker, signal,
-- 1password, youtube and google messages all match the stock bindings.

local home = os.getenv("HOME")

-- Browser profiles ------------------------------------------------------------

hl.unbind("SUPER + SHIFT + RETURN")
o.bind("SUPER + SHIFT + RETURN", "Browser", 'omarchy-launch-browser --profile-directory="Profile 1"')

-- Was: toggle window gaps
hl.unbind("SUPER + SHIFT + BACKSPACE")
o.bind("SUPER + SHIFT + BACKSPACE", "Browser", 'omarchy-launch-browser --profile-directory="Profile 3"')

-- Applications ----------------------------------------------------------------

-- Was: ChatGPT as a web app. The native desktop app is installed instead.
hl.unbind("SUPER + SHIFT + A")
o.bind("SUPER + SHIFT + A", "ChatGPT", { launch = "chatgpt", focus = "^chatgpt$" })

-- Was: Obsidian without the GPU workaround
hl.unbind("SUPER + SHIFT + O")
o.bind("SUPER + SHIFT + O", "Obsidian", { launch = "obsidian -disable-gpu", focus = "^obsidian$" })

-- Was: Calendar (hey.com web app)
hl.unbind("SUPER + SHIFT + C")
o.bind("SUPER + SHIFT + C", "Cursor", { launch = "cursor" })

-- Was: Email (hey.com web app)
hl.unbind("SUPER + SHIFT + E")
o.bind("SUPER + SHIFT + E", "Email", { launch = "thunderbird" })

o.bind("SUPER + SHIFT + T", "Activity", { tui = "btop" })
o.bind("SUPER + SHIFT + L", "Toggl Track", { tui = home .. "/git/toggl-cli/toggl-cli" })

-- Web apps --------------------------------------------------------------------

o.bind("SUPER + SHIFT + Q", "Claude", 'omarchy-launch-webapp "https://claude.ai" --profile-directory="Profile 1"')

-- Was: Omawrite
hl.unbind("SUPER + SHIFT + W")
o.bind("SUPER + SHIFT + W", "WhatsApp", 'omarchy-launch-webapp "https://web.whatsapp.com/" --profile-directory="Profile 1"')

o.bind(
  "SUPER + SHIFT + CTRL + L",
  "Toggl Track",
  'omarchy-launch-webapp "https://track.toggl.com" --profile-directory="Profile 1"'
)

-- Screenshots -----------------------------------------------------------------

-- Was: Google Maps
hl.unbind("SUPER + SHIFT + S")
o.bind("SUPER + SHIFT + S", "Capture screenshot", "omarchy-capture-screenshot")

-- Workspaces ------------------------------------------------------------------

-- Was: move grouped window focus left/right
hl.unbind("SUPER + CTRL + LEFT")
hl.unbind("SUPER + CTRL + RIGHT")
o.bind("SUPER + CTRL + LEFT", "Previous workspace", hl.dsp.focus({ workspace = "r-1" }))
o.bind("SUPER + CTRL + RIGHT", "Next workspace", hl.dsp.focus({ workspace = "r+1" }))

o.bind("SUPER + CTRL + SHIFT + LEFT", "Move to previous workspace", hl.dsp.window.move({ workspace = "r-1" }))
o.bind("SUPER + CTRL + SHIFT + RIGHT", "Move to next workspace", hl.dsp.window.move({ workspace = "r+1" }))

-- Special workspaces ----------------------------------------------------------

o.bind("SUPER + Z", "Toggle special workspace X", hl.dsp.workspace.toggle_special("x"))
o.bind("SUPER + SHIFT + Z", "Move to special workspace X", hl.dsp.window.move({ workspace = "special:x" }))

o.bind("F3", "Toggle terminal workspace", hl.dsp.workspace.toggle_special("terminal"))
o.bind("F4", "Toggle browser workspace", hl.dsp.workspace.toggle_special("browser"))
o.bind("SUPER + E", "Toggle email workspace", hl.dsp.workspace.toggle_special("email"))

-- Displays ---------------------------------------------------------------------

-- Was: toggle laptop display mirroring, which makes the external display mirror
-- the laptop. A 3:2 panel on a 16:9 TV pillarboxes the TV. This mirrors the
-- other way, so the TV runs its native mode and the laptop takes the bars.
-- Absolute path: Hyprland's exec has no ~/scripts on PATH (that is .bashrc).
hl.unbind("SUPER + CTRL + ALT + Delete")
o.bind("SUPER + CTRL + ALT + Delete", "Toggle mirroring from external display", "$HOME/scripts/hypr-mirror-external toggle")

-- Mouse -----------------------------------------------------------------------

-- Was: scroll active workspace forward/backward. SUPER + scroll walks through
-- windows instead, which is more natural in the scrolling layout.
hl.unbind("SUPER + mouse_down")
hl.unbind("SUPER + mouse_up")
o.bind("SUPER + mouse_down", "Focus next window", hl.dsp.focus({ direction = "r" }))
o.bind("SUPER + mouse_up", "Focus previous window", hl.dsp.focus({ direction = "l" }))

-- Window rules ----------------------------------------------------------------

-- Toggl Track web app
o.window("brave-track\\.toggl\\.com.*", {
  float = true,
  center = true,
  size = { "(monitor_w*0.5)", "(monitor_h*0.7)" },
})

-- Toggl CLI
o.window("org\\.omarchy\\.toggl-cli.*", {
  float = true,
  center = true,
  size = { "(monitor_w*0.3)", "(monitor_h*0.5)" },
})

-- Evince, bigger than the standard Omarchy float
o.window("org.gnome.Evince", {
  tag = "-floating-window",
  float = true,
  center = true,
  size = { "(monitor_w*0.5)", "(monitor_h*0.8)" },
})

---------------------------------------------------------------------------------
-- https://github.com/mmsbrggr/omarchy-per-monitor-workspaces/tree/main

-- Per-monitor workspaces: SUPER+N acts on the focused monitor.
-- Added by the Per-monitor Workspaces bar widget. pcall so that removing
-- the plugin costs these bindings rather than everything below this line.
pcall(dofile, os.getenv("HOME") .. "/.config/omarchy/plugins/mmsbrggr.per-monitor-workspaces/hypr/init.lua")

-- SUPER+A / SUPER+D cycle this monitor's slots, matching SUPER+TAB.
-- Bound after the plugin so they use its cycle rather than Hyprland's
-- global r-1/r+1, which would jump to another screen.
local pmw = _G.per_monitor_workspaces
if pmw then
  o.bind("SUPER + A", "Previous workspace", pmw.cycle(-1))
  o.bind("SUPER + D", "Next workspace", pmw.cycle(1))
else
  o.bind("SUPER + A", "Previous workspace", hl.dsp.focus({ workspace = "r-1" }))
  o.bind("SUPER + D", "Next workspace", hl.dsp.focus({ workspace = "r+1" }))
end
---------------------------------------------------------------------------------