-- Programs referenced from binds and autostart.

return {
  terminal = "ghostty",
  fileManager = "nemo",
  menu = "rofi -show drun -theme ~/.config/rofi/styles/launcher.rasi",
  wlogout = "~/.config/wlogout/scripts/wlogout.sh",
  swaync = "swaync-client -t -sw",
}
