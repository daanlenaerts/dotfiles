-- Shipping this file makes Omarchy use it instead of generating one from
-- default/themed/hyprland.lua.tpl, so the look'n'feel below travels with the
-- theme the way it did in the pre-4.0 hyprland.conf.

local active_border_color = "rgb(eca944)"
local inactive_border_color = "rgb(f8f9fa)"

hl.config({
  general = {
    border_size = 3,

    col = {
      active_border = active_border_color,
      inactive_border = inactive_border_color,
    },
  },

  group = {
    col = {
      border_active = active_border_color,
      border_inactive = inactive_border_color,
    },
  },

  decoration = {
    rounding = 4,

    blur = {
      passes = 5,
    },
  },
})
