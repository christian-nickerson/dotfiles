-- See https://wiki.hypr.land/Configuring/Basics/Variables/#input
hl.config({
  input = {
    kb_layout = "us",

    follow_mouse = 1,

    -- -1.0 - 1.0, 0 means no modification.
    sensitivity = 0,

    touchpad = {
      natural_scroll = false,
    },
  },
})

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
