.PHONY: waybar check-hypr

# Recompiles the SCSS to CSS and restarts Waybar
waybar:
	sass waybar/.config/waybar/style.scss waybar/.config/waybar/style.css
	pkill waybar || true
	nohup waybar > /dev/null 2>&1 &

# Validates Hyprland config, deprecations, and daemon health
check-hypr:
	hyprctl --instance 0 configerrors
	hyprctl --instance 0 deprecated-config
	test "$$(pgrep -xc hypridle)" -eq 1
