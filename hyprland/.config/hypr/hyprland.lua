-- Hyprland configuration entrypoint.
--
-- Docs:  https://wiki.hypr.land/Configuring/
-- Stubs: /run/current-system/sw/share/hypr/stubs/hl.meta.lua
--
-- Hyprland loads each require() into its own Lua scope, so an error in one
-- module does not prevent the remaining modules from loading. Keep the actual
-- configuration in lua/ and leave this file as a manifest.

require("lua.env")
require("lua.monitors")
require("lua.autostart")
require("lua.look")
require("lua.input")
require("lua.binds")
require("lua.rules")
