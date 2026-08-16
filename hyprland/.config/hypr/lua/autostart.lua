-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
--
-- hl.exec_cmd() spawns asynchronously through `sh -c`, so `& disown` is not
-- needed and shell syntax (~, quoting, pipes) still works.

hl.on("hyprland.start", function()
  -- Set up the environment first.
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

  -- GTK theming (Catppuccin Macchiato Mauve).
  hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'catppuccin-macchiato-mauve-standard'")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme 'BreezeX-RosePine-Linux'")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size 24")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")

  -- Apply Hyprcursor and X11 cursor theme.
  hl.exec_cmd("hyprctl setcursor rose-pine-hyprcursor 24")
  hl.exec_cmd("echo 'Xcursor.theme: BreezeX-RosePine-Linux\\nXcursor.size: 24' | xrdb -merge")

  -- Then start everything else.
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("swaync")
  hl.exec_cmd("~/.config/waybar/launch.sh")
  hl.exec_cmd('mailspring -b --password-store="gnome-libsecret"')
  hl.exec_cmd("openrgb -p off.orp")
end)
