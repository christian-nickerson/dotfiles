-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

hl.monitor({ output = "HDMI-A-2", mode = "highres", position = "0x0", scale = 1 })

-- Fallback for every other output.
hl.monitor({ output = "", mode = "3840x1200@60", position = "auto", scale = 1 })
