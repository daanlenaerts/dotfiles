-- Personal keybinding overrides.
-- See current bindings and descriptions: omarchy menu keybindings --print
--
-- Bindings that Omarchy 4 now ships as defaults were dropped here:
-- terminal, tmux, browser, file manager, spotify, nvim, lazydocker, signal,
-- 1password, youtube and google messages all match the stock bindings.

local home = os.getenv("HOME")

-- Browser profiles ------------------------------------------------------------
-- omarchy-launch-browser treats any extra flag as a URL and then focuses an
-- already-open Brave window, which switches to that window's workspace before
-- the new one maps. Launch Brave directly so a new window stays on this workspace.

hl.unbind("SUPER + SHIFT + RETURN")
o.bind("SUPER + SHIFT + RETURN", "Browser", { launch = 'brave --new-window --profile-directory="Profile 1"' })

-- Was: toggle window gaps
hl.unbind("SUPER + SHIFT + BACKSPACE")
o.bind("SUPER + SHIFT + BACKSPACE", "Browser", { launch = 'brave --new-window --profile-directory="Profile 3"' })

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

-- Was: toggle single-window square aspect
hl.unbind("SUPER + CTRL + BACKSPACE")
o.bind(
  "SUPER + CTRL + BACKSPACE",
  "Herdr remote",
  "omarchy-launch-terminal herdr --remote omarchy-desktop"
)

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
-- Omasnap replaces Omarchy's screenshot tool. The same key toggles the
-- overlay: first press opens it, second press dismisses it.
-- https://github.com/tobi/omasnap

-- Was: Omarchy screenshot
hl.unbind("PRINT")
hl.unbind("F12")
hl.unbind("ALT + SHIFT + 4")

o.bind("PRINT", "Screenshot", "omasnap")
o.bind("F12", "Screenshot", "omasnap")
o.bind("ALT + SHIFT + 4", "Screenshot", "omasnap")

-- Was: Google Maps, then Omarchy screenshot
hl.unbind("SUPER + SHIFT + S")
o.bind("SUPER + SHIFT + S", "Screenshot", "omasnap")

hl.layer_rule({
  match = { namespace = "^omasnap$" },
  no_anim = true,
  animation = "none",
  no_screen_share = true,
})

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

-- T3 Code lives in its own slideout (special workspace "t3"), tiled. F9 toggles
-- the slideout and F10 docks T3 Code on the current workspace instead.

local function t3_window()
  for _, window in ipairs(hl.get_windows()) do
    if window.class == "t3code" then
      return window
    end
  end
end

local function t3_in_slideout(window)
  return window.workspace and window.workspace.name == "special:t3"
end

-- While T3 Code is the only tiled window in the slideout, a left gap of half
-- the monitor keeps it on the right half. Gaps are pixels, so there is one rule
-- per monitor width. Registered at load and again before showing, in case a
-- monitor was plugged in since.
local t3_gap_rules = {}

local function t3_ensure_gap_rule(monitor)
  if not monitor then
    return
  end
  local width = math.floor(monitor.width / monitor.scale)
  local key = monitor.name .. ":" .. width
  if t3_gap_rules[key] then
    return
  end
  t3_gap_rules[key] = hl.workspace_rule({
    workspace = "n[s:special:t3] w[t1] m[" .. monitor.name .. "]",
    gaps_out = { top = 10, right = 10, bottom = 10, left = math.floor(width / 2) + 10 },
  })
end

for _, monitor in ipairs(hl.get_monitors()) do
  t3_ensure_gap_rule(monitor)
end

local function t3_undock(window)
  local selector = "address:" .. window.address
  hl.dispatch(hl.dsp.window.move({ workspace = "special:t3", follow = false, window = selector }))
  hl.dispatch(hl.dsp.window.float({ action = "disable", window = selector }))
end

-- Launches T3 Code if it isn't running, and pulls it back from a workspace
-- it was docked on.
o.bind("F9", "Toggle T3 Code slideout", function()
  t3_ensure_gap_rule(hl.get_active_monitor())
  local window = t3_window()
  if not window then
    hl.exec_cmd(o.launch("t3code"))
    return
  end
  if not t3_in_slideout(window) then
    t3_undock(window)
  end
  hl.dispatch(hl.dsp.workspace.toggle_special("t3"))
end)

o.bind("F10", "Dock/undock T3 Code", function()
  local window = t3_window()
  if not window then
    return
  end
  if t3_in_slideout(window) then
    local selector = "address:" .. window.address
    local current = hl.get_active_workspace()
    hl.dispatch(hl.dsp.window.move({ workspace = "name:" .. current.name, window = selector }))
    hl.dispatch(hl.dsp.window.float({ action = "disable", window = selector }))
    hl.dispatch(hl.dsp.focus({ window = selector }))
  else
    t3_ensure_gap_rule(window.monitor)
    t3_undock(window)
  end
end)

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

-- T3 Code opens in its slideout; the gap rule above puts it on the right half
o.window("^t3code$", { workspace = "special:t3" })

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

-- SUPER+A / SUPER+D cycle this monitor's slots.
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

-- Cycle windows in the active group instead of switching workspaces. Bound after
-- the plugin, which claims SUPER+TAB for per-monitor workspace cycling.
hl.unbind("SUPER + TAB")
hl.unbind("SUPER + SHIFT + TAB")
o.bind("SUPER + TAB", "Next window in group", hl.dsp.group.next())
o.bind("SUPER + SHIFT + TAB", "Previous window in group", hl.dsp.group.prev())
