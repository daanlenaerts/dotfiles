-- Personal input overrides. Only settings that differ from the Omarchy 4
-- defaults are listed; the defaults already cover compose:caps, repeat_rate 40,
-- numlock on, touchpad clickfinger + scroll_factor 0.4, and the faster terminal
-- touchpad scrolling that used to live here.
-- See https://wiki.hypr.land/Configuring/Basics/Variables/#input
hl.config({
  input = {
    -- Slower than Omarchy's 250ms default.
    repeat_delay = 600,

    touchpad = {
      -- Use natural (inverse) scrolling.
      natural_scroll = true,
    },
  },
})

-- Three-finger horizontal swipe changes workspaces.
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
