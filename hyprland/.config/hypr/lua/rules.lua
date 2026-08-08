-- Layer rules for blur effects.
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/#layer-rules
--
-- Namespaces are RE2 regexes and are deliberately left unanchored to match the
-- previous hyprlang config exactly.
local blurredLayers = {
  "logout_dialog",
  "waybar",
  "swaync-control-center",
  "swaync-notification-window",
}

for _, namespace in ipairs(blurredLayers) do
  hl.layer_rule({ match = { namespace = namespace }, blur = true, ignore_alpha = 0.3 })
end

-- Window rules are evaluated top to bottom, so order matters here.
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- Ignore maximize requests from all apps.
hl.window_rule({
  name = "suppress-maximize-events",
  match = { class = ".*" },

  suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland.
hl.window_rule({
  name = "xwayland-drag-fix",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },

  no_focus = true,
})
