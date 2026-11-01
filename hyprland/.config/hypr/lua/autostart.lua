-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
--
-- hl.exec_cmd() spawns asynchronously through `sh -c`, so `& disown` is not
-- needed and shell syntax (~, quoting, pipes) still works.

hl.on("hyprland.start", function()
  -- Set up the environment first.
  hl.exec_cmd(
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE"
  )

  -- GTK theming (Catppuccin Macchiato Mauve).
  hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'catppuccin-macchiato-mauve-standard'")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme 'BreezeX-RosePine-Linux'")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size 24")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")

  -- Apply Hyprcursor and X11 cursor theme.
  hl.exec_cmd("hyprctl setcursor rose-pine-hyprcursor 24")
  hl.exec_cmd("echo 'Xcursor.theme: BreezeX-RosePine-Linux\\nXcursor.size: 24' | xrdb -merge")

  -- Start daemons idempotently (hypridle is managed by systemd hypridle.service on NixOS;
  -- only spawn manually if the systemd service is not active and no instance is running).
  hl.exec_cmd("pidof hyprpaper || hyprpaper")
  hl.exec_cmd("systemctl --user is-active --quiet hypridle.service || pidof hypridle || hypridle")
  hl.exec_cmd("pidof swaync || swaync")
  hl.exec_cmd("~/.config/waybar/launch.sh")
  hl.exec_cmd('mailspring -b --password-store="gnome-libsecret"')
  hl.exec_cmd("openrgb -p off.orp")
end)
