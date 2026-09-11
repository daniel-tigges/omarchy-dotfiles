-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

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

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- Navigation (Arrow keys)
o.bind("CTRL + ALT + right", "Switch to workspace right", hl.dsp.focus({ workspace = "+1" }) )
o.bind("CTRL + ALT + left", "Switch to workspace left", hl.dsp.focus({ workspace = "-1" }) )
o.bind("CTRL + ALT + SHIFT + right", "Move window to workspace right", hl.dsp.window.move({ workspace = "+1" }) )
o.bind("CTRL + ALT + SHIFT + left", "Move window to workspace left", hl.dsp.window.move({ workspace = "-1" }) )

-- Navigation (Vim keys: h/l)
o.bind("CTRL + ALT + l", "Switch to workspace right", hl.dsp.focus({ workspace = "+1" }) )
o.bind("CTRL + ALT + h", "Switch to workspace left", hl.dsp.focus({ workspace = "-1" }) )
o.bind("CTRL + ALT + SHIFT + l", "Move window to workspace right", hl.dsp.window.move({ workspace = "+1" }) )
o.bind("CTRL + ALT + SHIFT + h", "Move window to workspace left", hl.dsp.window.move({ workspace = "-1" }) )

-- vim like motions
hl.unbind("SUPER + l")
o.bind("SUPER + h", "Focus window left", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + j", "Focus window down", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + k", "Focus window up", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + l", "Focus window right", hl.dsp.focus({ direction = "r" }))