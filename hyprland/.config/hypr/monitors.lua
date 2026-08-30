-- Monitor layout is owned by hyprmoncfg: it writes ~/.config/hypr/hyprmoncfg-monitors.lua
-- and hyprland.lua dofile()s that last, so nothing here defines or overrides monitors.
--
-- What this file does own is one personal tweak: when a workspace on the
-- LEFT-most monitor holds a single tiled window, reserve space on its left so
-- the window sits near the middle of the desk instead of spanning 4K of width.
--
-- The left monitor is resolved from the live layout on every monitor change,
-- so switching hyprmoncfg profiles (thuis / corda / laptop-only) needs no edit
-- here -- whichever screen ends up left-most gets the rule.

-- Only wide screens get the treatment; a laptop panel keeps its full width.
local MIN_WIDTH = 3000
local GAPS = { top = 10, right = 10, bottom = 10, left = 1500 }

-- description -> HL.WorkspaceRule. Hyprland drops runtime rules on reload and
-- re-executes this file, so the table never outlives the rules it tracks.
local rules = {}

local function rule_for(description)
  if not rules[description] then
    rules[description] = hl.workspace_rule({
      workspace = "w[t1]m[desc:" .. description .. "]",
      gaps_out = GAPS,
    })
  end

  return rules[description]
end

local function leftmost_wide_monitor()
  local monitors = hl.get_monitors()

  -- With a single screen there is no "left" monitor to reserve room on.
  if #monitors < 2 then
    return nil
  end

  local leftmost
  for _, monitor in ipairs(monitors) do
    if not leftmost or monitor.x < leftmost.x then
      leftmost = monitor
    end
  end

  if leftmost and leftmost.width >= MIN_WIDTH then
    return leftmost.description
  end
end

local function apply()
  local target = leftmost_wide_monitor()

  for description, rule in pairs(rules) do
    rule:set_enabled(description == target)
  end

  if target then
    rule_for(target):set_enabled(true)
  end
end

-- Config parse runs before hyprmoncfg's generated file, so the layout is still
-- the previous one here; the monitor events below correct it once it lands.
apply()

hl.on("hyprland.start", apply)
hl.on("monitor.added", apply)
hl.on("monitor.removed", apply)
hl.on("monitor.layout_changed", apply)
